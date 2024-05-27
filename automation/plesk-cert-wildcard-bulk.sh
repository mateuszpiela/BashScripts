#!/bin/bash
REG_EMAIL=yourletsencrypt@email.com
SLEEP=10
# for domains
for d in `plesk db -Ne "select name from domains where parentDomainId=0 and webspace_id=0 and htype='vrt_hst'"`
do
    echo "Domain: $d is now in the queue for wildcard certificate"
    plesk ext sslit --certificate -issue -domain "$d"  -registrationEmail "$REG_EMAIL" -secure-domain -secure-mail -wildcard
    echo "Sleeping for $SLEEP seconds before continue ssl issuing!"
    sleep $SLEEP
    echo "Continuing the certificate issue procedure"
    plesk ext sslit --certificate -issue -domain "$d" -registrationEmail "$REG_EMAIL" -secure-domain -secure-mail -wildcard -continue
    echo "Configuring OCSP and HSTS for 6 months"
    plesk ext sslit --ocsp-stapling -enable -domain "$d"
    plesk ext sslit --hsts -enable -domain "$d" -max-age "6months" -include-subdomains -apply-to-webmail
done
