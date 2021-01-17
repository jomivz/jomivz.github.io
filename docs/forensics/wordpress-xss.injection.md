---
layout: default
title: wordpress XSS injection
parent: Forensics
grand_parent: Cheatsheets
has_children: true
---

# Analysing XSS injection in MYD

Copying the MYD files on csirt-sans-sift
 
 - Create a new folder in /var/lib/mysql/database-name and give to database-name the name you want: 
```
sudo mkdir /var/lib/mysql/springfield
```
 - Upload the files in the created new folder with WinSCP
 - Change the linux owner permissions for those files to mysql:mysql: 
```
sudo chown mysql:mysql  -r /var/lib/mysql/springfield/
```

 # Starting MySQL server

    Run the command 
```
sudo mysql start -u root -p  
```

Launch mysql client as per below :
```
mysql > use acme;
mysql > exit
```

# Querying imported MYD files

Based on timestamps of the XSS attack on the ACME website via WordPress, we had to check if the MySQL backups were sain.

We parsed for the iframe injection in the table hbrhui used by the fancybox vulnerable plugin (Sucuri Article).
```
mysql > SELECT option_value FROM wp_hbrhui_options WHERE CHAR_LENGTH(option_value) > 50 INTO OUTFILE '/tmp/dump_20_option_name.txt';
```

Greping for URL of redirection, we proof the backup is compromised.
![XSS in MYD](/docs/forensics/wordpress-xss-injection.png)

# Stopping MySQL server

Run the command: 
```
sudo mysql stop
```
