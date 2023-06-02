---
layout: post
title: SYS Wordpress XSS injection
category: Forensics
parent: Forensics
grand_parent: Cheatsheets
modified_date: 2021-02-06
permalink: /for/wp-xss
---

<!-- vscode-markdown-toc -->
* [Analysing XSS injection in MYD](#AnalysingXSSinjectioninMYD)
* [Starting MySQL server](#StartingMySQLserver)
* [Querying imported MYD files](#QueryingimportedMYDfiles)
* [Stopping MySQL server](#StoppingMySQLserver)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='AnalysingXSSinjectioninMYD'></a>Analysing XSS injection in MYD

Copying the MYD files on csirt-sans-sift
 
 - Create a new folder in /var/lib/mysql/database-name and give to database-name the name you want: 
```
sudo mkdir /var/lib/mysql/springfield
```
 - Upload the files in the created new folder with WinSCP
 - Change the linux owner permissions for those files to ```mysql:mysql```: 
```
sudo chown mysql:mysql  -r /var/lib/mysql/springfield/
```

## <a name='StartingMySQLserver'></a>Starting MySQL server

    Run the command 
```
sudo mysql start -u root -p  
```

Launch mysql client as per below :
```sh
mysql > use acme;
mysql > exit
```

## <a name='QueryingimportedMYDfiles'></a>Querying imported MYD files

Based on timestamps of the XSS attack on the ACME website via WordPress, we had to check if the MySQL backups were sain.

We parsed for the iframe injection in the table hbrhui used by the fancybox vulnerable plugin (Sucuri Article).
```
mysql > SELECT option_value FROM wp_hbrhui_options WHERE CHAR_LENGTH(option_value) > 50 INTO OUTFILE '/tmp/dump_20_option_name.txt';
```

Greping for URL of redirection, we proof the backup is compromised.
![XSS in MYD](/assets/images/wordpress-xss-injection.png)

## <a name='StoppingMySQLserver'></a>Stopping MySQL server

Run the command: 
```
sudo mysql stop
```
