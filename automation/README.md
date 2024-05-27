# Automation
This directory contains various automations written in bash
<br>
## da_ssl_save_post.sh
This script automatically uploads ssl certificate and reloads web servers on remote servers or run shell scripts on that server and hooks on directadmin action hook for post saving the ssl certificate.

For more information about directadmin hook you can refer to software documentation available at [DirectAdmin Documentation](https://docs.directadmin.com/developer/hooks/ssl_letsencrypt.html#ssl-save-pre-post-sh)

## plesk-cert-wildcard-bulk.sh
I was sleepy but i needed to issue bulk ssl certificates after migrating domain from 1st machine to 2nd machine using plesk cli on 2nd machine<br>
The db part was copied from plesk-ip.sh script for bulk changing ipv4 + ipv6 in domains created by ChristophRo on plesk forum
[See source for the plesk bulk changing ip in subscriptions](https://talk.plesk.com/threads/add-ipv6-to-all-subscriptions-at-once.347967/)
