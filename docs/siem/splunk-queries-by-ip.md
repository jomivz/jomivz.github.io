---
layout: default
title: splunk queries by ip
parent: SIEM
grand_parent: Cheatsheets
nav_order: 2
has_children: true
---

# Splunk Queries by IP

**Table of Contents**

 - [Windows queries ](##windows-queries)
   - [Windows domain controller 1 ](##windows-dc-1)
   - [Windows domain controller 2 ](##windows-dc-2)
 - [Suricata queries ](##suricata-queries)
   - [Suricata: Alertes IDS](##suricata:-alertes-ids)
   - [Suricata: Alertes IDS par IP source et destination 1](##suricata-alertes-ids-par-ip-source-et-destination-1)
   - [Suricata: Alertes IDS par IP source et destination 2](##suricata:-alertes-ids-par-ip-source-et-destination-2)
   - [Suricata: Répartition des User-agents HTTP dans le temps](##suricata:repartition-des-user-agents-htt-dans-le-temps)
   - [Suricata: Téléchargement de fichiers en HTTP dans le temps](##suricata:-telechargement-de-fichiers-en-htt-dans-le-temps)


## Windows queries

Windows DC 1:
```
host=10.2.3..5 Source_Network_Address=* Logon_Type=3 (EventCode=4624 OR EventCode=4625) $addr_ip$
| fields Security_ID, Source_Network_Address, host, EventCode
| lookup reversedns ip as Source_Network_Address
| lookup wineventcode.csv code as EventCode OUTPUT description as Description
| stats count by Security_ID, Source_Network_Address, EventCode, host, Description
| table Security_ID, Source_Network_Address, host, EventCode, Description, count
| sort -count
| rename Source_Network_Address as "Adresse IP Source", count as "Nb événements", host as "Nom de l'hôte"
```

Windows DC 2:
```
host=10.2.3.5 (Source_Address=* OR Destination_Address=*) EventCode=515* $addr_ip$
| fields Source_Address, Source_Port, Destination_Address, Destination_Port,EventCode, Layer_Name
| lookup reversedns ip as Destination_Address OUTPUT host as host_dst
| lookup reversedns ip as Source_Address OUTPUT host as host_src
| lookup wineventcode.csv code as EventCode OUTPUT description as Description
| rename Source_Port as service
| rename Destination_Port as service
| where service=3389 OR service&lt;1024
| stats count by Source_Address, Destination_Address, service, EventCode, Layer_Name, host_src, host_dst, Description
| table Source_Address, host_src, Destination_Address, host_dst, service, EventCode, Description, Layer_Name, count
| sort -count
| rename Source_Address as "Adresse IP Source", Destination_Address as "Adresse IP Destination", service as Service, Layer_Name as "Action", count as "Nb événements", host_dst as "Nom de l'hôte destination", host_src as "Nom de l'hôte source", host_dst as "Nom de l'hôte destination"
```

Windows DC: Succès d'authentifications dans le temps
```
host=10.2.3.5 Source_Network_Address=* Logon_Type=3 (EventCode=4624)  $addr_ip$
| fields Security_ID, EventCode
| timechart count(EventCode) by Security_ID
```

Windows DC: Echecs d'authentifications dans le temps
```
host=10.2.3.5 Source_Network_Address=* Logon_Type=3 (EventCode=4625)  $addr_ip$
| fields Security_ID, EventCode
| timechart count(EventCode) by Security_ID
```

Windows DC: Filtrage réseau
```
host=10.2.3.5 (Source_Address=$addr_ip$ OR Destination_Address=$addr_ip$) EventCode=515*
| fields Source_Address, Source_Port, Destination_Address, Destination_Port,EventCode
| cluster showcount=t
| table  cluster_count Source_Port, Source_Address, EventCode, Destination_Address, Destination_Port
```

## Suricata queries

### Suricata: Alertes IDS
```
index=suricata $addr_ip$
| dedup src_ip dest_ip alert.signature
| search alert.signature!=""
| lookup reversedns ip as dest_ip OUTPUT host as host_dst
| lookup reversedns ip as src_ip OUTPUT host as host_src
| table _time, src_ip, host_src, src_port, dest_ip, host_dst, dest_port, alert.signature
| rename alert.signature as Signature, src_ip as "Source IP", dest_ip as "Destination IP", src_port as "Source port", dest_port as "Destination port", host_src as "Nom de l'hôte source", host_dst as "Nom de l'hôte destination"
```
### Suricata: Alertes IDS par User-agents
```
index=suricata src_ip=$addr_ip$
| fields http.http_user_agent, src_ip, flow_id, dest_ip
| rename http.http_user_agent as http_user_agent
| lookup user_agents http_user_agent
| search ua_os_family!=unknown
| stats count(flow_id) as "Flow" by ua_family, ua_os_family, src_ip, dest_ip
| table src_ip, ua_family, ua_os_family, dest_ip, Flow
| rename ua_family as Navigateurs, ua_os_family as OS, Flow as "Nb trafics", src_ip as "IP Sources", dest_ip as "IP Destinations"
```

### Suricata: Alertes IDS par IP source et destination 1
```
index=suricata (src_ip=$addr_ip$)
| fields  src_ip, dest_ip, alert.signature
| search alert.signature!=""
| rename alert.signature as signature
| cluster showcount=t
| table  cluster_count src_ip dest_ip signature
```

### Suricata: Alertes IDS par IP source et destination 2
```
index=suricata $addr_ip$
| search alert.signature!=""
| rename alert.signature as Signature
| iplocation src_ip
| stats count by Signature, src_ip, dest_ip
| table src_ip, dest_ip, Signature, count
| rename src_ip as "Source IP", dest_ip as "Destination IP", src_port as "Source port", dest_port as "Destination port", count as "Nb déclenchement signature"
```

### Suricata: Répartition des User-agents HTTP dans le temps
```
index=suricata src_ip=$addr_ip$
| fields http.http_user_agent, src_ip, flow_id, dest_ip
| rename http.http_user_agent as http_user_agent
| lookup user_agents http_user_agent
| timechart count(flow_id) as "Flow" by http_user_agent
```

### Suricata: Téléchargement de fichiers en HTTP dans le temps
```
index=suricata event_type=fileinfo fileinfo.filename!=*/centreon/* fileinfo.filename!="/" fileinfo.filename!=*allmetrics* http.hostname!=*sophosupd.com http.hostname!=*.acme.fr http.hostname!=*.microsoft.com http.hostname!="dci.sophosupd.net" http.hostname!=*.zscaler.net http.hostname!=*.digicert.com http.hostname!=download.windowsupdate.com http.hostname!=*.firefox.com
fileinfo.magic!="ASCII text, with no line terminators" $addr_ip$
| timechart count(fileinfo.size) by http.hostname
```