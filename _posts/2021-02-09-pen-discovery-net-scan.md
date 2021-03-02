---
layout: default
title: TA0007 Discovery - Network scanning
parent: Pentesting
category: Pentesting
grand_parent: Cheatsheets
tags: discovery scan nmap TA0007 T1595 T1046
---

## {{ page.title }}

## T1595.001: Active Scanning: Scanning IP Blocks

**use-case**: discovering IP assets over a subnet.
```
# Active ARP scan
# Send ?
arp-scan 192.168.1.0/24 -I eth0

# PING one host w/ one ICMP echo request
ping -c 1 192.168.1.254    

# PING an IP range w/ FPING
fping -g 192.168.1.0/24

# PING an IP range w/ NMAP and save results to hosts_up file
# Send ICMP timestamp & netmask requests w/ no port scan and no IP reverse lookup 
nmap -PEPM -sP -n -oA hosts_up 192.168.1.0/24 
```

## T1046: Network Service Scanning

**use-case**: discovering services for assets into the input file ```hosts_up```.
```
# NMAP TCP SYN/Top 100 ports scan
nmap -F -sS -Pn -iL hosts_up -oA nmap_tcp_fastscan 192.168.0.0/24

# NMAP TCP SYN/Version scan on all port
sudo nmap -sV -Pn -p0- -T4 -A --stats-every 60s -iL hosts_up --reason -oA nmap_tcp_fullscan 192.168.0.0/24

# NMAP UDP/Fast Scan
nmap -F -sU -Pn -iL hosts_up -oA nmap_udp_fastscan 192.168.0.0/24

# NMAP UDP/Top 1000 ports scan
nmap -sU -Pn -iL hosts_up -oA nmap_udp_top1000_scan 192.168.0.0/24

# NMAP UDP scan on all port scan
sudo nmap -sU -Pn -p0- --reason --stats-every 60s --max-rtt-timeout=50ms --max-retries=1 -iL hosts_up -oA nmap_udp_fullscan 192.168.0.0/24
```

## References

- Mitre Att&ck Techniques: 
> * [T1595 - Active Scanning: Scanning IP Blocks](https://attack.mitre.org/techniques/T1595/001/)
> * [T1046 - Network Service Scanning](https://attack.mitre.org/techniques/T1046/)

- Others:
> * [NMAP Messmer cheatsheet](https://jmvwork.xyz/docs/purple/TA0007/discovery_network_nmap_cheatsheet_messer.pdf)
> * [NMAP SANS cheatsheet](https://jmvwork.xyz/docs/purple/TA0007/discovery_network_nmap_cheatsheet_sans.pdf)
