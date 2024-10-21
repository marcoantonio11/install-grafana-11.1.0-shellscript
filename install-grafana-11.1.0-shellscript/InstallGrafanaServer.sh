#!/bin/bash

#----------------------------------------------------------------#
# Script name: Install Grafana server                            #
# Description: Install and configure the Grafana server frontend #
# Author: Marco Antonio da Silva                                 #
# E-mail: marcoa.silva84@gmail.com                               #
# LinkedIn: https://www.linkedin.com/marcosilvarj                #
# Github: https://github.com/marcoantonio11                      #
# Use: ./InstallGrafanaServer.sh                                 #
#----------------------------------------------------------------#

## Variables
# [database]
DB_TYPE=$(grep 'db-type' ./variables-server | cut -d: -f2)
DB_HOST=$(grep 'db-host' ./variables-server | cut -d: -f2)
DB_NAME=$(grep 'db-name' ./variables-server | cut -d: -f2)
DB_USER=$(grep 'db-user' ./variables-server | cut -d: -f2)
DB_PASSWORD=$(grep 'db-password' ./variables-server | cut -d: -f2)

# [users]
ALLOW_SIGN_UP=$(grep 'allow-sign-up' ./variables-server | cut -d: -f2)
ALLOW_ORG_CREATE=$(grep 'allow-org-create' ./variables-server | cut -d: -f2)

# Check if the parameters were set
while true; do
   echo '########################################################################'
   echo '## Before using this script:                                          ##'
   echo '## - Set the paramaters in the "variables-server" file.               ##'
   echo '##                                                                    ##'
   echo '## Did you set the parameters?                                        ##'
   echo '## (1) Yes, I set the  parameters. Continue the script.               ##'
   echo '## (2) No, I did not set the parameters. Exit the script.             ##'
   echo '########################################################################'
   read -p "Chosen option: " ANSWER

   case $ANSWER in
      1)
          echo -e 'Ok, the script will continue...\n'
          sleep 3
   break
          ;;
      2)
          echo 'Ok, the script is closing...'
          sleep 2
          exit 1
          ;;
      *)
          echo -e 'Invalid option! Try again.\n'
          sleep 1
          ;;
   esac
done

# Identify the distribution
echo 'Identifying the distribution...'
sleep 2
hostnamectl > /tmp/distro.txt
DISTRO=$(sed -nr 's/.*Operating System: ([A-Z]{1}[a-z]{1,}) ([A-Z]{1,3}?[a-z]{1,}? ?\/?[A-Z]{1}?[a-z]{1,}? ?[0-9]{1,2}\.?[0-9]{1,2}?).*/\1 \2/p' /tmp/distro.txt)

if [ "$DISTRO" = 'Debian GNU/Linux 12' ]; then
   echo "Your distribution is $DISTRO"
   echo -e 'Continuing...\n'
   sleep 3

   # Install Grafana 11.0.1 on Debian 12
   echo 'Installing the prerequisite packages and Grafana...'
   apt update && apt install -y adduser libfontconfig1 musl wget
   wget https://dl.grafana.com/enterprise/release/grafana-enterprise_11.1.0_amd64.deb
   dpkg -i grafana-enterprise_11.1.0_amd64.deb
   echo ' '

elif [ "$DISTRO" = 'Fedora Linux 40' ]
   echo "Your distribution is $DISTRO"
   echo -e 'Continuing...\n'
   sleep 3 

   # Install Grafana 11.0.1 on Fedora 40
   echo 'Installing Grafana...'
   sudo yum install -y https://dl.grafana.com/enterprise/release/grafana-enterprise-11.1.0-1.x86_64.rpm

else
   echo "Your distribution is $DISTRO"
   echo -e 'This distribution is not supported by this script.\n'
   echo 'The distributions supported are:'
   echo '- Debian 12'
   echo -e '- Fedora 40\n'
   echo -e 'Aborting...\n'
   sleep 1
   exit 1
fi

# Enable and start grafana-server
echo 'Enabling and start grafana-server...'
systemctl daemon-reload
systemctl enable grafana-server
systemctl start grafana-server
echo ' '

# Edit grafana.ini
echo -e 'Editing grafana.ini...\n'

# [database]
sed -ri "s/;(type =) sqlite3/\1 $DB_TYPE/" /etc/grafana/grafana.ini
sed -ri "s/;(host =) 127.0.0.1(:3306)/\1 $DB_HOST\2/" /etc/grafana/grafana.ini
sed -ri "s/;(name =) grafana/\1 $DB_NAME/" /etc/grafana/grafana.ini
sed -ri "s/;(user =) root/\1 $DB_USER/" /etc/grafana/grafana.ini
sed -i "/^\[database\]/!b;n;n;n;n;n;n;n;n;n;n;c password = $DB_PASSWORD" /etc/grafana/grafana.ini

# [users]
sed -ri "s/;(allow_sign_up =) true/\1 $ALLOW_SIGN_UP/" /etc/grafana/grafana.ini
sed -ri "s/;(allow_org_create =) true/\1 $ALLOW_ORG_CREATE/" /etc/grafana/grafana.ini

# Restart grafana-server
echo 'Restarting grafana-server...'
systemctl restart grafana-server
echo ' '

echo -e 'End of script!\n'

