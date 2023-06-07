---
layout: post
title: NET TSHARK forensics
category: for
parent: cheatsheets
modified_date: 2021-02-06
permalink: /for/tshark
---

<!-- vscode-markdown-toc -->
* [Extract assets info to CSV](#ExtractassetsinfotoCSV)
* [Fetching an IOC string in a PCAP](#FetchinganIOCstringinaPCAP)
* [TCP follow stream / Exporting objects](#TCPfollowstreamExportingobjects)
	* [SMTP - export emails :](#SMTP-exportemails:)
	* [FTP - export files](#FTP-exportfiles)
	* [SMB - export file transfered :](#SMB-exportfiletransfered:)
	* [HTTP - export file transfered :](#HTTP-exportfiletransfered:)
* [Decrypting HTTPS traffic](#DecryptingHTTPStraffic)
* [Tcpdump capture from IP asset](#TcpdumpcapturefromIPasset)
* [Look for IP asset in a list](#LookforIPassetinalist)
* [Casting output](#Castingoutput)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='ExtractassetsinfotoCSV'></a>Extract assets info to CSV 
     
DHCP assets info - source and destination ethernet addresses :
 * bootp client mac address
 * nbns addtional records \ name
 * nbns addtional records \ addr

IP assets info - source and destination IP addresses : 
```
tshark -nl -T fields -e ip.src -e ip.dst -r request_1426258128.pcap | sort | uniq > 2389_ip_streams.csv
```

KERBEROS assets info - user account names :
```
tshark -nl kerberos.CNameString and !(kerberos.CNAmeString contains $) -e kerberos.CNameString
```

DNS assets info - in-addr.arpa in DNS PTR response :
```
tshark -nl -T fields -e dns.qry.name -r request_1426258128.pcap | sort | uniq > 2389_dns_ptr_C2_response.csv
139.253.2.195.in-addr.arpa
166.119.19.193.in-addr.arpa
```

HTTP assets info - HTTP hosts : 
```
tshark -nl -T fields -e ip.src -e ip.dst -e http.host -r request_1426258128.pcap | sort | uniq > 2389_http_streams.csv
```

HTTP assets info - user-agents : 

SMTP assets info - header fields :

TLS assets info - certificate issuers :
 * tls.handshake.type = 11

## <a name='FetchinganIOCstringinaPCAP'></a>Fetching an IOC string in a PCAP

In the example here, convert the string ```() {``` (shellshock) to hexadecimal value (NOTE: skip 0a which is the EOF)
```
[19:27:16] jomivz@sans-sift:1793 $ echo () { > ioc.ascii
[19:27:23] jomivz@sans-sift:1793 $ xxd ioc.ascii
0000000: 2829 207b 0a                             () {.
[19:27:28] jomivz@csirt-sans-sift:1793 $
```
 
Apply the related BFP filter in Wireshark : 
```
tcp.segment_data contains 28:29:20:7b
```

## <a name='TCPfollowstreamExportingobjects'></a>TCP follow stream / Exporting objects

### <a name='SMTP-exportemails:'></a>SMTP - export emails :
* Apply the filter ```smtp.data.fragment```
* Using wireshark go to the menu "File \ Export Objects \ IMF..."

### <a name='FTP-exportfiles'></a>FTP - export files
* Apply the filter ```ftp.request.command``` to check ```RETR``` and ```STOR``` commands
* Apply the filter ```ftp-data``` the apply a "TCP follow stream"
* Show and save data as Raw

### <a name='SMB-exportfiletransfered:'></a>SMB - export file transfered :

### <a name='HTTP-exportfiletransfered:'></a>HTTP - export file transfered :

## <a name='DecryptingHTTPStraffic'></a>Decrypting HTTPS traffic

 * On linux, set the environment variable SSLKEYLOGFILE
```
export SSLKEYLOGFILE=$HOME/sslkey.log
```
 * Apply the filter ```(http.request or tls.handshake.type eq 1) and !(ssdp)
 * Load the key log file via the menu "Edit \ Preferences \ Protocols \ TLS"
 * Browse the key log file from the field "(Pre)-Master-Secret log filename" 

## <a name='TcpdumpcapturefromIPasset'></a>Tcpdump capture from IP asset

Capture_on_IDS with the tcpdump list
``` 
root@SF-SENSOR:/Volume/home/admin# tcpdump -i nfe0.1.22 -c 1000 host '( 195.88.208.131 or 195.2.253.139 or 193.19.119.166 or 195.88.209.169 or 195.2.53.204 or 195.88.208.250 or 193.19.118.27 or 195.2.252.44 or 195.88.208.56 or 195.88.209.6 or 193.19.118.94 )' -w 2389_2.pcap
``` 

## <a name='LookforIPassetinalist'></a>Look for IP asset in a list
``` 
cat 1793_ip_streams_dstip.csv | greplist | grep -f /assets/CA_sorted_IP.txt
``` 

## <a name='Castingoutput'></a>Casting output

Cast in-addr.arpa to IPv4 : 
```
cat 2389_dns_ptr_C2_response.csv | arpa2ip
195.2.253.139
193.19.119.166
```

Cast IPv4 set to tcpdump list : 
```
cat 2389_DNS_ptr_C2_ip.csv | tcplist
'( 195.88.208.131 or 195.2.253.139 or 193.19.119.166 or 195.88.209.169 or 195.2.253.204 or 195.88.208.250 or 193.19.118.27 or 195.2.252.44 or 195.88.208.56 or 195.88.209.6 or 193.19.118.94 )'
```
