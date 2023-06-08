---
layout: post
title: TA0008 Lateral Movement - T1021 Docker
category: pen
parent: cheatsheets
modified_date: 2023-02-14
permalink: /pen/docker
---

**Mitre Att&ck Entreprise**: 
* [TA0006 - Credentials Access](https://attack.mitre.org/tactics/TA0006/)
* [T1021  - Remote Services](https://attack.mitre.org/techniques/T1021/)

**Menu**
<!-- vscode-markdown-toc -->
* [MUST TO READ](#MUSTTOREAD)
* [Scan with Grype + ExploitDB](#ScanwithGrypeExploitDB)
* [Administration](#Administration)
* [JDBC client](#JDBCclient)
* [Unsecure Azure Registry](#UnsecureAzureRegistry)
* [Java Maven Applications](#JavaMavenApplications)
* [SSO / SAML](#SSOSAML)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='MUSTTOREAD'></a>MUST TO READ

- [PayloadAllTheThings](https://swisskyrepo.github.io/PayloadsAllTheThingsWeb/Methodology%20and%20Resources/Container%20-%20Docker%20Pentest/#summary)
- [](https://infosecwriteups.com/attacking-and-securing-docker-containers-cc8c80f05b5b)
 

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

## <a name='JDBCclient'></a>JDBC client
```
alias jaqy='java -Dfile.encoding=UTF-8 -Xmx256m -jar ~/jaqy-1.2.0.jar'
jaqy

# jdbc:teradata
.protocol teradata com.teradata.jdbc.TeraDriver
.classpath teradata lib/terajdbc4.jar
.open -u dbc -p dbc teradata://127.0.0.1

# jdbc:postgresql
.protocol postgresql org.postgresql.driver
.classpath postgresql lib/postgresql-42.5.3.jar
.open -u dbc -p dbc postgresql://127.0.0.1
```

## <a name='UnsecureAzureRegistry'></a>Unsecure Azure Registry

```
curl -s -k --user "USER:PASS" https://registry.azurecr.io/v2/_catalog | jq '.repositories'
curl -s -k --user "USER:PASS" https://registry.azurecr.io/v2/<image_name>/tags/list | jq '.tags'
podman pull --creds "USER:PASS" registry.azurecr.io/<image_name>:<tag>
```

- [https://aex.dev.azure.com/me?mkt=en-US](https://aex.dev.azure.com/me?mkt=en-US)


## <a name='JavaMavenApplications'></a>Java Maven Applications 

```
# extract application
jar xf app.jar

# find Spring properties files
find . -iname "*.properties"
find -iname "*.properties" -print | xargs grep -r "://"
find -iname "*.properties" -print | xargs grep -r "jdbc.*://"
find -iname "*.properties" -print | xargs grep -r "postgresql://"
```

## <a name='SSOSAML'></a>SSO / SAML

- [forge SAML token](https://attack.mitre.org/techniques/T1606/002/)