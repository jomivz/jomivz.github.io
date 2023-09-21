---
layout: post
title:  recon
parent: cheatsheets
category: recon
permalink: /recon/shodan
modified_date: 2023-09-21
---

<!-- vscode-markdown-toc -->
* [devices](#devices)
	* [cisco-ios](#cisco-ios)
	* [citrix](#citrix)
	* [cyberoam-ssl-vpn](#cyberoam-ssl-vpn)
	* [f5-big-ip](#f5-big-ip)
	* [f5-vpn](#f5-vpn)
	* [juniper-router](#juniper-router)
	* [k8s](#k8s)
	* [metasploit](#metasploit)
	* [mikrotik](#mikrotik)
	* [oracle-e-business](#oracle-e-business)
	* [palo-globalprotect](#palo-globalprotect)
	* [pulse-secure](#pulse-secure)
	* [rdp](#rdp)
	* [sonicwall](#sonicwall)
	* [vmware-esxi](#vmware-esxi)
	* [zyxel](#zyxel)
	* [zte](#zte)
* [organization](#organization)
* [services](#services)
	* [dns](#dns)
	* [docker](#docker)
	* [elasticsearch](#elasticsearch)
	* [ftp](#ftp)
	* [icmp](#icmp)
	* [kerberos](#kerberos)
	* [kibana](#kibana)
	* [ldap](#ldap)
	* [mongodb](#mongodb)
	* [mysql](#mysql)
	* [mssql](#mssql)
	* [neo4j](#neo4j)
	* [nfs](#nfs)
	* [postgresql](#postgresql)
	* [rdp](#rdp-1)
	* [smb](#smb)
	* [ssh](#ssh)
	* [tcp](#tcp)
	* [udp](#udp)
	* [vnc](#vnc)
	* [winrm](#winrm)
* [sources](#sources)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='devices'></a>devices

### <a name='cisco-ios'></a>cisco-ios
```sh
# cisco ios - no password - HTTP return code 200
HTTP/1.0 200 Ok
Last-modififed: Tue, 08 Jun 1999 06:55:45 GMT
# cisco ios - no password - HTTP return code 401
HTTP/1.0 401 Unauthorized
Www-authenticate: Basic realm="level_15 or view_access"
# cisco ios - default password - HTTP return code 401
Www-authenticate: Basic realm="Default password:1234"
```

### <a name='citrix'></a>citrix
```sh
# cve-2023-3519
citrix netscaler
ssl:"*contoso*" http.favicon.hash:-1292923998,-1166125415
ssl:"*contoso*" http.title:"*netscaler*"
ssl:"*contoso*" ja3:""

# basic
http.title:"Citrix Login"
http.title:citrix
http.title:"Endpoint Management - Console - Logon"
Citrix-TransactionId
http.waf:"Citrix NetScaler"
```


### <a name='cyberoam-ssl-vpn'></a>cyberoam-ssl-vpn
```sh
ssl.cert.issuer.CN:Cyberoam
```

### <a name='f5-big-ip'></a>f5-big-ip
```sh
http.title:"BIG-IP&reg;- Redirect"
http.favicon.hash:-335242539
Server: BigIP
```
### <a name='f5-vpn'></a>f5-vpn
```sh
http.html:"BIG-IP logout"
Server: BigIP
```

### <a name='juniper-router'></a>juniper-router
```sh
http.title:"Log In - Juniper Web Device Manager"
```

### <a name='k8s'></a>k8s
```sh
ssl.cert.issuer.CN:kubernetes
# k8s API server
ssl.cert.subject.cn:kube-apiserver
ssl.cert.subject.cn:kube-apiserver "200 OK"
```

### <a name='metasploit'></a>metasploit
```sh
http.title:Metasploit
http.title:"Metasploit is initializing"
http.title:"Metasploit - Setup and Configuration"
```

### <a name='mikrotik'></a>mikrotik
```sh
# last update: 20230921
# CVE-2018-7445 / RCE up to 6.38.4
# https://thehackernews.com/2021/12/over-300000-mikrotik-devices-found.html
http.title:"RouterOS router configuration page"
http.title:"Router"
os:"MikroTik"
```

### <a name='oracle-e-business'></a>oracle-e-business
```sh
http.title:"E-Business Suite Home Page Redirect"
path=/OA_HTML -http.title:"E-Business Suite"
```

### <a name='palo-globalprotect'></a>palo-globalprotect
```sh
http.html:"Global Protect"
```

### <a name='pulse-secure'></a>pulse-secure 
```sh
product:"Pulse Secure"
http.title:Pulse
```

### <a name='rdp'></a>rdp
```sh
http.html:tdDomainUserNameLabel
```

### <a name='sonicwall'></a>sonicwall
```sh
http.title:"Policy Jump"
http.title:"SonicWALL - Authentication"
```



### <a name='vmware-esxi'></a>vmware-esxi
```sh
http.title:"\" + ID_EESX_Welcome + \""
```

### <a name='zyxel'></a>zyxel
```sh
ssl.cert.issuer.CN:ZyXEL
```

### <a name='zte'></a>zte
```sh
http.title:"F660"
ZTE corp
```

## <a name='organization'></a>organization 
```sh
asn:123456
org:contoso
```

## <a name='services'></a>services
### <a name='dns'></a>dns
```sh
port:53 !HTTP
```
### <a name='docker'></a>docker
```sh
port:2375 !HTTP
port:5000 !HTTP
```
### <a name='elasticsearch'></a>elasticsearch
```sh
port:9200 !HTTP
```
### <a name='ftp'></a>ftp
```sh
port:21 !HTTP
```
### <a name='kerberos'></a>kerberos
```sh
port:88 !HTTP
```
### <a name='kibana'></a>kibana
```sh
port:5601 !HTTP
```
### <a name='ldap'></a>ldap
```sh
port:389 !HTTP
```
### <a name='mongodb'></a>mongodb
```sh
port:27017 !HTTP
```
### <a name='mysql'></a>mysql
```sh
port:3306 !HTTP
```
### <a name='mssql'></a>mssql
```sh
port:1433 !HTTP
```
### <a name='neo4j'></a>neo4j
```sh
port:1433 !HTTP
```
### <a name='nfs'></a>nfs
```sh
port:2049
```
### <a name='postgresql'></a>postgresql
```sh
port:5432 !HTTP
```
### <a name='rdp-1'></a>rdp
```sh
port:3389 !HTTP
```
### <a name='smb'></a>smb
```sh
port:445 !HTTP
```
### <a name='ssh'></a>ssh
```sh
port:22,2022,3022,4022,5022,6022,7022,8022,9022,10022,20022,30022,40022,50022,60022 !HTTP
```
### <a name='vnc'></a>vnc
```sh
port:5900 !HTTP
```
### <a name='winrm'></a>winrm
```sh
port:5985,5986 !HTTP
```

## <a name='sources'></a>sources

* [examples](https://www.shodan.io/search/examples)
* [filters](https://www.shodan.io/search/filters) / [github](https://github.com/JavierOlmedo/shodan-filters)
* [fingerprints](https://github.com/n0x08/ShodanTools)
* [/tool/shodan.png](/tool/shodan.png)

