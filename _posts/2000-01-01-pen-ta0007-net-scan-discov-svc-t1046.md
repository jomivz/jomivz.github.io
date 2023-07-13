---
layout: post
title: TA0007 Discovery - T1046 Scanning the Network
category: pen
parent: cheatsheets
modified_date: 2023-07-13
permalink: /pen/net/scan
tags: discovery scan nmap TA0007 T1595 T1046
---

**Mitre Att&ck Entreprise**

* [TA0007 - Discovery](https://attack.mitre.org/tactics/TA0007/)
* [T1046  - Network Service Discovery](https://attack.mitre.org/techniques/T1046/)

**Menu**
<!-- vscode-markdown-toc -->
* [proto](#proto)
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
	* [rdp](#rdp)
	* [smb](#smb)
	* [tcp](#tcp)
	* [udp](#udp)
	* [winrm](#winrm)
* [theory](#theory)
	* [NMAP Note 0 : Default Behavior](#NMAPNote0:DefaultBehavior)
	* [NMAP Note 1 : UDP conns](#NMAPNote1:UDPconns)
	* [NMAP Note 2 : TCP conns](#NMAPNote2:TCPconns)
	* [NMAP Note 3 : NSE scripts](#NMAPNote3:NSEscripts)
	* [NMAP Note 4 : Firewall evasion](#NMAPNote4:Firewallevasion)
	* [mindmap](#mindmap)
* [sources](#sources)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

** Administrative Services **

![](/assets/images/pen-ta0007-discov-t1046-scan-net-svc.png)

## <a name='proto'></a>proto

🔥 MUST-READ : More network svc on [hacktricks.xyz](https://book.hacktricks.xyz) 🔥

### <a name='dns'></a>dns
* default port: 53
* [hacktricks](https://book.hacktricks.xyz/network-services-pentesting/pentesting-dns)
```sh
adidnsdump -u $zdom_fqdn\$ztarg_user_name -p $ztarg_user_pass $zdom_dc_fqdn
```

### <a name='docker'></a>docker
* default port: 2375
* [hacktricks](https://book.hacktricks.xyz/network-services-pentesting/2375-pentesting-docker)
```sh
# scan nmap
nmap -sV --script "docker-*" -p 2375 $ztarg_computer_ip
# scan msf
msf> use exploit/linux/http/docker_daemon_tcp
# get version
curl -s http://$ztarg_computer_ip:2375/version | jq
docker -H $ztarg_computer_ip:2375 version
```
* [curl abuse](https://securityboulevard.com/2019/02/abusing-docker-api-socket/)

### <a name='elasticsearch'></a>elasticsearch
* default port: 9200
* [hacktricks](https://book.hacktricks.xyz/network-services-pentesting/9200-pentesting-elasticsearch)

```sh
# scan nmap
nmap -sV --script "" -p 9200 $ztarg_computer_ip

# scan metasploit
msf > use auxiliary/scanner/elasticsearch/indices_enum

# scan shodan
port:9200 elasticsearch

# retrieve data
curl --insecure https://$ztarg_computer_ip:9200
curl --insecure https://$ztarg_computer_ip:9200/_security/role
curl --insecure https://$ztarg_computer_ip:9200/_security/user
curl --insecure https://$ztarg_computer_ip:9200/_security/user/$ztarg_user_name
curl --insecure  -X GET https://$ztarg_user_name:$ztarg_user_pass@$ztarg_computer_ip:9200

# dump
```

### <a name='ftp'></a>ftp
* default port: 20,21
* [hacktricks](https://book.hacktricks.xyz/network-services-pentesting/pentesting-ftp)
```sh
# scan nmap
sudo nmap -sV -p21 -sC -A  $ztarg_computer_ip

# scan banner
nc -vn $ztarg_computer_ip 21
openssl s_client -connect $ztarg_computer_ip:21 -starttls ftp #Get certificate if any

# login anonymous
ftp $ztarg_computer_ip
```

### <a name='icmp'></a>icmp
* default port: none
* [hacktricks](xxx)

```sh
# Active ARP scan
arp-scan 192.168.1.0/24 -I eth0

# PING one host w/ one ICMP echo request
ping -c 1 $ztarg_computer_ip   

# PING an IP range w/ FPING
fping -g $ztarg_subnet

# PING an IP range w/ NMAP and save results to hosts_up file
# Send ICMP timestamp & netmask requests w/ no port scan and no IP reverse lookup 
nmap -PEPM -sP -n -oA hosts_up $ztag_subnet
```

### <a name='kerberos'></a>kerberos
* default port: 88
* [hacktricks](xxx)

```sh
# scan
nmap -p 88 --script=krb5-enum-users --script-args krb5-enum-users.realm=$zdom_fqdn,userdb=x.lst $ztarg_computer_ip

# kerbrute
# https://github.com/ropnop/kerbrute.git ./kerbrute -h

# kerberoasting
GetUserSPNs.py -request -dc-ip $zdom_dc_ip $zdom_fqdn/$ztarg_computer_name
```

### <a name='kibana'></a>kibana 
* default port: 5601
* [hacktricks](https://book.hacktricks.xyz/network-services-pentesting/5601-pentesting-kibana)

```sh
#scan nmap https-like
nmap -Pn -sS -sV --script "" -p 5601 $ztarg_computer_ip

#login 
https://$ztarg_computer_ip:5601
```

### <a name='ldap'></a>ldap
* default port: 389
* [hacktricks](https://book.hacktricks.xyz/network-services-pentesting/pentesting-ldap)

```sh
nmap -sV --script "" -p 389 $ztarg_computer_ip
```


### <a name='mongodb'></a>mongodb
* default port: 27017
* [hacktricks](https://book.hacktricks.xyz/network-services-pentesting/27017-27018-mongodb)

```sh
nmap -sV --script "mongo* and default" -p 27017 $ztarg_computer_ip
```

### <a name='mysql'></a>mysql
* default port: 3306
* [hacktricks](https://book.hacktricks.xyz/network-services-pentesting/pentesting-mysql)

```sh
nmap -Pn -sS -sV --script "" -p 3306 $ztarg_computer_ip
```

### <a name='mssql'></a>mssql
* default port: 1433
* [hacktricks](xxx)

```sh
# scan nmap
sudo nmap --script ms-sql-info,ms-sql-empty-password,ms-sql-xp-cmdshell,ms-sql-config,ms-sql-ntlm-info,ms-sql-tables,ms-sql-hasdbaccess,ms-sql-dac,ms-sql-dump-hashes --script-args mssql.instance-port=1433,mssql.username=ntgis,mssql.password=Password1,mssql-instance-name=LUXSI -Pn -sV -p 1433 $ztarg_computer_ip
```

### <a name='neo4j'></a>neo4j
* default port: 7474
* [hacktricks](xxx)

```sh
#scan nmap https-like
nmap -Pn -sS -sV --script "" -p 7474 $ztarg_computer_ip

#login 
https://$ztarg_computer_ip:7474
```


### <a name='nfs'></a>nfs
* default port: 2049
* [hacktricks](xxx)

```sh
# scan nmap
nmap --script "nfs-showmount or nfs-statfs" -p 2049 -T4 $ztarg_computer_ip
# scan metasploit
msf> scanner/nfs/nfsmount
```

### <a name='postgresql'></a>postgresql
* default port: 5432
* [hacktricks](https://book.hacktricks.xyz/network-services-pentesting/pentesting-postgresql)

```sh
# scan nmap

# login 
psql -U <myuser> # Open psql console with user
psql -h <host> -U <username> -d <database> # Remote connection
psql -h <host> -p <port> -U <username> -W <password> <database> 
```

### <a name='rdp'></a>rdp
* default port: 3389
* [hacktricks](https://book.hacktricks.xyz/network-services-pentesting/pentesting-rdp)

```sh
# scan nmap
nmap --script "rdp-enum-encryption or rdp-vuln-ms12-020 or rdp-ntlm-info" -p 3389 -T4 $ztarg_computer_ip
# login test
rdesktop -u <username> $ztarg_computer_ip
rdesktop -d <domain> -u <username> -p <password> $ztarg_computer_ip
xfreerdp [/d:domain] /u:<username> /p:<password> /v:$ztarg_computer_ip
xfreerdp [/d:domain] /u:<username> /pth:<hash> /v:$ztarg_computer_ip
rdp_check.py $zz
```

### <a name='smb'></a>smb
* default port: 139,445
* [hacktricks](https://book.hacktricks.xyz/network-services-pentesting/pentesting-smb)

```sh
# scan nmap
nmap -p 445 --script smb2-security-mode $ztarg_subnet -o output.txt

# scan metasploit
msf > auxiliary/scanner/smb/smb_version

# STEP 2: set up impacket/ntlmrelayx
grep -B 9 "not required" output.txt |sed -E '/.*\((.*\..*\..*\..*)\)$/!d' |sed -E 's/.*\((.*\..*\..*\..*)\)$/\1/' > targets.txt
python3 ntlmrelayx.py -tf targets.txt -smb2support
```

### <a name='tcp'></a>tcp
* default port: 1-65535
* [hacktricks](xxx)

```sh
#? NMAP TCP SYN/Top 100 ports scan
nmap -F -sS -Pn -oA nmap_tcp_fastscan $ztarg_subnet
nmap -F -sS -Pn -oA nmap_tcp_fastscan -iL hosts_up

#? NMAP TCP SYN/Version scan on all port
sudo nmap -sV -Pn -p0- -T4 -A --stats-every 60s --reason -oA nmap_tcp_fullscan $ztarg_subnet
sudo nmap -sV -Pn -p0- -T4 -A --stats-every 60s --reason -oA nmap_tcp_fullscan -iL hosts_up
```

### <a name='udp'></a>udp
* default port: 1-65535
* [hacktricks](xxx)

```sh
# NMAP UDP/Fast Scan
nmap -F -sU -Pn -oA nmap_udp_fastscan $ztarg_subnet
nmap -F -sU -Pn -oA nmap_udp_fastscan -iL hosts_up

#? NMAP UDP/Top 1000 ports scan
nmap -sU -Pn -oA nmap_udp_top1000_scan $ztarg_subnet
nmap -sU -Pn -oA nmap_udp_top1000_scan -iL hosts_up

#? NMAP UDP scan on all port scan
sudo nmap -sU -Pn -p0- --reason --stats-every 60s --max-rtt-timeout=50ms --max-retries=1 -oA nmap_udp_fullscan $ztarg_subnet
sudo nmap -sU -Pn -p0- --reason --stats-every 60s --max-rtt-timeout=50ms --max-retries=1 -oA nmap_udp_fullscan -iL hosts_up
```

### vnc
* default port: 5900
* [hacktricks](https://book.hacktricks.xyz/network-services-pentesting/pentesting-vnc)

```sh
# scna nmap
nmap -sV --script vnc-info,realvnc-auth-bypass,vnc-title -p <PORT> <IP>
#scan metasploit
msf> use auxiliary/scanner/vnc/vnc_none_auth
```

### <a name='winrm'></a>winrm
* default port: 5985,5986
* [hacktricks](https://book.hacktricks.xyz/network-services-pentesting/5985-5986-pentesting-winrm)

```sh
# scan nmap
nmap -Pn -sS -sV -p 5985,5986 $ztarg_computer_ip
# login
evil-winrm -u $ztarg_user_name -p $ztarg_user_pass -i $ztarg_computer_ip
evil-winrm -u $ztarg_user_name -H $ztarg_user_nthash -i $ztarg_computer_ip
```
- [WinRM nmap script](https://github.com/RicterZ/My-NSE-Scripts/blob/master/scripts/winrm.nse)

## <a name='theory'></a>theory

### <a name='NMAPNote0:DefaultBehavior'></a>NMAP Note 0 : Default Behavior 

* By default, Windows firewall blocks all ICMP packets and NMAP does not scan hosts not answering to ```ping```.
* Thus use the option ```-Pn``` as workaround

### <a name='NMAPNote1:UDPconns'></a>NMAP Note 1 : UDP conns

* When the target's UDP port is open, (except for well-known port) there is no response from the target. NMAP refers the port as being ```open|filtered```.
* When the target's UDP port is closed, the response expected is an ICMP port unreachable. NMAP refers the port as being ```closed```.
* For well-known UDP port, NMAP will forge payload (instead of empty). In case of response, NMAP refers the port as being ```opened```.
* Due the slowness of scanning UDP connections, run Nmap with the ```--top-ports <number>``` option.

### <a name='NMAPNote2:TCPconns'></a>NMAP Note 2 : TCP conns

* Compare to TCP connect scans, ```SYN``` / ```NULL``` / ```Xmas``` scans have the following common points:
  * it is often not logged by applications listening on open ports.
  * it requires the ability to create raw packets (as opposed to the full TCP handshake), which is a root privilege by default. 
  * When the target's TCP port is open, there is usually no response. Firewall may also respond with no response or with an ICMP port unreachable when ```filtered```.
  * When the target's TCP port is closed, the response expected is an TCP RST if the port is closed.
  * Either TCP port are ```opened``` or ```closed```, Windows OS respond with a TCP RST. 

You may refer to the [RFC 793](https://tools.ietf.org/html/rfc793) to get more information about the TCP protocol.

### <a name='NMAPNote3:NSEscripts'></a>NMAP Note 3 : NSE scripts

NMAP uses the following options for NSE scripts :
* ```--script=<category>``` where category is one of the following values: ```safe```, ```intrusive```, ```vuln```, ```exploit```, ```brute```, ```auth```, ```discoevry```.
* ```--script=<name> --script-args=<arg1>, <arg2>``` where you may refer to the ```/usr/share/nmap/scripts/``` directory or [nmap.org](https://nmap.org/nsedoc/) to get the full list.
* ```--script-help=<name>``` for help on the script.


### <a name='NMAPNote4:Firewallevasion'></a>NMAP Note 4 : Firewall evasion

* ```-f``` : use fragments
* ```-mtu``` : use lower MTU to split packets than 1500 (standard value for ethernet LAN)
* ```--scan-delay <:digit:>ms``` : avoiding time-based alerts.
* ```--badsum```: behavior to test
* ```-S <IP_Address>```: Spoof the source address 

You may refer to the [nmap.org firewall evasion](https://nmap.org/book/man-bypass-firewalls-ids.html) page for futher information.

### <a name='mindmap'></a>mindmap

![/tool/nmap.png](/tool/nmap.png)

## <a name='sources'></a>sources

* [NMAP SANS cheatsheet](https://jmvwork.xyz/docs/purple/TA0007/discovery_network_nmap_cheatsheet_sans.pdf)
