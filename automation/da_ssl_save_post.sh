#!/bin/bash

#List of servers to upload SSL
servers=""
#List of servers to reload the nginx unit using docker cmds
nginx_docker_servers=""
nginx_docker_container="nginx-nginx-1"
#List of servers using standalone nginx (systemctl reload nginx)
nginx_servers=""

#List of servers using custom shell script (owned,executable,writable by root)
shell_scripts_servers=""
#Upload user setup
ssh_key=""
ssh_user=""

#Remote dir for uploading the ssl certs
remote_dir="/etc/ssl_dir"

#Local directadmin directory for prefix cmds
directadmin_dir="/usr/local/directadmin"


ejabberd_restart=false

# From: https://www.baeldung.com/linux/check-variable-exists-in-list
exists_in_list () {
    LIST=$1
    DELIMITER=$2
    VALUE=$3
    echo $LIST | tr "$DELIMITER" '\n' | grep -F -q -x "$VALUE"
}


if [[ "$domain" == *"test.eu" || "$domain" == *"testx.eu" ]]; then
        ejabberd_restart=true
        for server in $servers
        do
                echo "Current server for updating the ssl is $server"
                found_in_list=false

                #Copy from DA user the certificates to remote server (.cert.combined for all chain certs contained in one file (Example ROOT+SubRoot+Domain Cert), .cert for domain certificate, .key for domain certificate private key)
                scp -i $ssh_key -o LogLevel=error $directadmin_dir/data/users/$username/domains/$domain.cert.combined $ssh_user@$server:$remote_dir/$domain.cert.combined
                scp -i $ssh_key -o LogLevel=error $directadmin_dir/data/users/$username/domains/$domain.cert $ssh_user@$server:$remote_dir/$domain.cert
                scp -i $ssh_key -o LogLevel=error $directadmin_dir/data/users/$username/domains/$domain.key  $ssh_user@$server:$remote_dir/$domain.key
                
                if exists_in_list "$nginx_docker_servers" " " $server; then
                        ssh -i $ssh_key -o LogLevel=error $ssh_user@$server "sudo /usr/bin/docker exec $nginx_docker_container nginx -s reload"
                        found_in_list=true
                fi

                if exists_in_list "$nginx_servers" " " $server; then
                        ssh -i $ssh_key -o LogLevel=error $ssh_user@$server "sudo /usr/bin/systemctl reload nginx"
                        found_in_list=true
                fi

                if exists_in_list "$shell_scripts_servers" " " $server; then
                        ssh -i $ssh_key -o LogLevel=error $ssh_user@$server "sudo $remote_dir/reload_services.sh"
                        found_in_list=true
                fi

                if [[ $found_in_list == false ]]; then
                        ssh -i $ssh_key -o LogLevel=error $ssh_user@$server "sudo reboot"
                fi
        done
fi

if $ejabberd_restart; then
        #Restart locally XMPP server
        sudo systemctl restart ejabberd
fi
