---
layout: post
title: TA0008 Lateral Movement - Docker
parent: Pentesting
category: Pentesting
grand_parent: Cheatsheets
modified_date: 2023-02-14
permalink: /:categories/:title/
---
<!-- vscode-markdown-toc -->
* [MUST TO READ](#MUSTTOREAD)
* [Scan with Grype + ExploitDB](#ScanwithGrypeExploitDB)
* [Administration](#Administration)
* [Unsecure Azure Registry](#UnsecureAzureRegistry)
* [Breaking out of Docker via kernel modules loading](#BreakingoutofDockerviakernelmodulesloading)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='MUSTTOREAD'></a>MUST TO READ

- [PayloadAllTheThings](https://swisskyrepo.github.io/PayloadsAllTheThingsWeb/Methodology%20and%20Resources/Container%20-%20Docker%20Pentest/#summary)
- [](https://infosecwriteups.com/attacking-and-securing-docker-containers-cc8c80f05b5b)
- 

## <a name='ScanwithGrypeExploitDB'></a>Scan with Grype + ExploitDB

```
grype <image> -o template -t ~/path/to/csv.tmpl
cut -f3 -d"," grivy_output.csv > /tmp/mycve.txt
while read cve; do toto=`echo $cve | tr -d \"`; grep -i $toto /usr/share/exploitdb/files_exploits.csv; done < /tmp/mycve.txt
```

Here's what the csv.tmpl file might look like:
```
"Package","Version Installed","Vulnerability ID","Severity"
{{- range .Matches}}
"{{.Artifact.Name}}","{{.Artifact.Version}}","{{.Vulnerability.ID}}","{{.Vulnerability.Severity}}"
{{- end}}
```

## <a name='Administration'></a>Administration
```
docker system info
ls -alps /var/lib/docker
docker inspect | jq 
```

```
alias jaqy='java -Dfile.encoding=UTF-8 -Xmx256m -jar ~/jaqy-1.2.0.jar'
jaqy

.protocol teradata com.teradata.jdbc.TeraDriver
.classpath teradata lib/terajdbc4.jar
.open -u dbc -p dbc teradata://127.0.0.1

.protocol postgresql org.postgresql.driver
.classpath postgresql lib/postgresql-42.5.3.jar
.open -u dbc -p dbc postgresql://127.0.0.1
```

## <a name='UnsecureAzureRegistry'></a>Unsecure Azure Registry

```
curl -s -k --user "USER:PASS" https://registry.azurecr.io/v2/_catalog | jq '.repositories'
curl -s -k --user "USER:PASS" https://registry.azurecr.io/v2/<image_name>/tags/list | jq '.tags'
podman pull --creds "USER:PASS" registry.azurecr.io/<image_name>:<tag>


https://aex.dev.azure.com/me?mkt=en-US
```

## <a name='BreakingoutofDockerviakernelmodulesloading'></a>Breaking out of Docker via kernel modules loading

* Install the linux headers or gives this error otherwise:
```
make[1]: *** /lib/modules/3.13.0-27-generic/build: No such file or directory.  Stop.
```

* To fix it :
```
sudo apt-get install linux-headers-`uname -r`
```

* It requires also the GLIBC 2.34, giving this error otherwise:

```
test@docker:/root$ ./escape
./escape: /lib/x86_64-linux-gnu/libc.so.6: version `GLIBC_2.34' not found (required by ./escape)

host$ ldd --version
ldd (Debian GLIBC 2.36-6) 2.36
```

To fix it :
```
-
```

## Java Maven Applications 

```
# extract application
jar xf app.jar

# find URLs and properties files
find . -iname "*.properties"
find -iname "*.properties" -print | xargs grep -r "://"
find -iname "*.properties" -print | xargs grep -r "jdbc.*://"
find -iname "*.properties" -print | xargs grep -r "postgresql://"
```




