
# Install Grafana 11.1.0

This project performs the installation and configuration of the Grafana 11.1.0 on the folowing distributions using Shell Script.

- Debian 12
- Fedora 40

## Documentation

This project is divided in two parts. First run the InstallGrafanaDatabase.sh script on the database instance and then run the InstallGrafanaServer.sh script on the frontend instance.

Note: For security reason, it's recommended to protect the variables-db and variables-server files using the command below:

$ chmod 600 variables-db variables-server


Step 1

Run InstallGrafanaDatabase.sh. This script:

- Install MariaDB, enable and start the service;
- Configure mysql_secure_installation;
- Create the Grafana database and the local and remote database users;
- Configure the bind address to allow remote connections on Debian 12;
- Open the firewall on Fedora 40;

Warn: Before running this script it's necessary to set the root and grafana user passwords and the IP address for remote access in the variables-db file. You will be reminded of this when you run it.

Step 2

Run InstallGrafanaServer.sh. This script:

- Install Grafana package;
- Edit parameters in the /etc/grafana/grafana.ini file;
- Enable and start the services.

Warn: 
Before running this script it's necessary to set the variables in the variables-server file. You will be reminded of this when you run it.

## Author

- [Github](https://github.com/marcoantonio11)

- [LinkedIn](https://www.linkedin.com/in/marcosilvarj)
## Feedback

If you have any feedback, please let me know at marcoa.silva84@gmail.com.


## Licença

[MIT](https://choosealicense.com/licenses/mit/)

