---
layout: post
title: siem / splunk / suricata
category: siem
parent: cheatsheets
modified_date: 2023-09-21
permalink: /siem/splunk/suricata
---

<!-- vscode-markdown-toc -->
* [stats](#stats)
* [alerts-all](#alerts-all)
* [alerts-per-ua](#alerts-per-ua)
* [alerts-per-ip-src](#alerts-per-ip-src)
* [alerts-per-ip-src-n-dst](#alerts-per-ip-src-n-dst)
* [trend-http-ua](#trend-http-ua)
* [trend-http-dl](#trend-http-dl)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

The idea to build queries with ```$addr_ip$``` as an argument IS to design investigation dashboards.
Investigation dashboards ALLOW to launch multiple queries at once based on an IP address.
For that an input field will set the ```$addr_ip$``` argument.

## <a name='stats'></a>stats
```bash
|tstats dc(host),values(host) where index=*
```

## <a name='alerts-all'></a>alerts-all
```bash
index=suricata $addr_ip$
| dedup src_ip dest_ip alert.signature
| search alert.signature!=""
| lookup reversedns ip as dest_ip OUTPUT host as host_dst
| lookup reversedns ip as src_ip OUTPUT host as host_src
| table _time, src_ip, host_src, src_port, dest_ip, host_dst, dest_port, alert.signature
| rename alert.signature as Signature, src_ip as "Source IP", dest_ip as "Destination IP", src_port as "Source port", dest_port as "Destination port", host_src as "Nom de l'hôte source", host_dst as "Nom de l'hôte destination"
```
## <a name='alerts-per-ua'></a>alerts-per-ua
```bash
index=suricata src_ip=$addr_ip$
| fields http.http_user_agent, src_ip, flow_id, dest_ip
| rename http.http_user_agent as http_user_agent
| lookup user_agents http_user_agent
| search ua_os_family!=unknown
| stats count(flow_id) as "Flow" by ua_family, ua_os_family, src_ip, dest_ip
| table src_ip, ua_family, ua_os_family, dest_ip, Flow
| rename ua_family as Navigateurs, ua_os_family as OS, Flow as "Nb trafics", src_ip as "IP Sources", dest_ip as "IP Destinations"
```

## <a name='alerts-per-ip-src'></a>alerts-per-ip-src
```bash
index=suricata (src_ip=$addr_ip$)
| fields  src_ip, dest_ip, alert.signature
| search alert.signature!=""
| rename alert.signature as signature
| cluster showcount=t
| table  cluster_count src_ip dest_ip signature
```

## <a name='alerts-per-ip-src-n-dst'></a>alerts-per-ip-src-n-dst
```bash
index=suricata $addr_ip$
| search alert.signature!=""
| rename alert.signature as Signature
| iplocation src_ip
| stats count by Signature, src_ip, dest_ip
| table src_ip, dest_ip, Signature, count
| rename src_ip as "Source IP", dest_ip as "Destination IP", src_port as "Source port", dest_port as "Destination port", count as "Nb déclenchement signature"
```

## <a name='trend-http-ua'></a>trend-http-ua
```bash
index=suricata src_ip=$addr_ip$
| fields http.http_user_agent, src_ip, flow_id, dest_ip
| rename http.http_user_agent as http_user_agent
| lookup user_agents http_user_agent
| timechart count(flow_id) as "Flow" by http_user_agent
```

## <a name='trend-http-dl'></a>trend-http-dl
```bash
# Téléchargement de fichiers en HTTP dans le temps
index=suricata event_type=fileinfo fileinfo.filename!=*/centreon/* fileinfo.filename!="/" fileinfo.filename!=*allmetrics* http.hostname!=*sophosupd.com http.hostname!=*.acme.fr http.hostname!=*.microsoft.com http.hostname!="dci.sophosupd.net" http.hostname!=*.zscaler.net http.hostname!=*.digicert.com http.hostname!=download.windowsupdate.com http.hostname!=*.firefox.com
fileinfo.magic!="ASCII text, with no line terminators" $addr_ip$
| timechart count(fileinfo.size) by http.hostname
```
