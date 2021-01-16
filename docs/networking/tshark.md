---
layout: default
title: tshark
parent: Networking
grand_parent: Cheatsheets
nav_order: 4
has_children: true
---

# PCAP analysis with TSHARK
 
## Extract asset: IP list, HTTP hotsnames
     
Extract of HTTP host to CSV : 
```
tshark -nl -T fields -e ip.src -e ip.dst -e http.host -r request_1426258128.pcap | sort | uniq > 2389_http_streams.csv
```

Extract of source and destination IP addresses to CSV : 
```
tshark -nl -T fields -e ip.src -e ip.dst -r request_1426258128.pcap | sort | uniq > 2389_ip_streams.csv
```
Extract in-addr.arpa in DNS PTR response to CSV :
```
tshark -nl -T fields -e dns.qry.name -r request_1426258128.pcap | sort | uniq > 2389_dns_ptr_C2_response.csv
139.253.2.195.in-addr.arpa
166.119.19.193.in-addr.arpa
```

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

Match in wireshark packets with Sourcefire IOC strings

In the example here, convert the string () { (shellshock) to hexadecimal value (NOTE: skip 0a which is the EOF)
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

Look for IP asset in CDA list
``` 
cat 1793_ip_streams_dstip_AL.csv| greplist | grep -f /assets/CDA_sorted_IP.txt
``` 


Tcpdump capture from IP asset

Capture_on_IDS with the tcpdump list
``` 
root@SF-SENSOR:/Volume/home/admin# tcpdump -i nfe0.1.22 -c 1000 host '( 195.88.208.131 or 195.2.253.139 or 193.19.119.166 or 195.88.209.169 or 195.2.53.204 or 195.88.208.250 or 193.19.118.27 or 195.2.252.44 or 195.88.208.56 or 195.88.209.6 or 193.19.118.94 )' -w 2389_2.pcap
``` 
