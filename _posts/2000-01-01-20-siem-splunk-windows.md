---
layout: post
title: siem / splunk / win
category: 20-soc
parent: cheatsheets
modified_date: 2023-09-21
permalink: /siem/splunk/win
---

<!-- vscode-markdown-toc -->
* [latmov](#latmov)
	* [firewall](#firewall)
	* [logons](#logons)
	* [rdp-hijack](#rdp-hijack)
* [lpe](#lpe)
	* [dll-hijack](#dll-hijack)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='latmov'></a>latmov

### <a name='firewall'></a>firewall
```
host=9.2.3.5 (Source_Address=$addr_ip$ OR Destination_Address=$addr_ip$) EventCode=515*
| fields Source_Address, Source_Port, Destination_Address, Destination_Port,EventCode
| cluster showcount=t
| table  cluster_count Source_Port, Source_Address, EventCode, Destination_Address, Destination_Port
```

### <a name='logons'></a>logons
```bash
# logons count attempts
host=9.2.3.5 Source_Network_Address=* Logon_Type=3 (EventCode=4624 OR EventCode=4625) $addr_ip$
| fields Security_ID, Source_Network_Address, host, EventCode
| lookup reversedns ip as Source_Network_Address
| lookup wineventcode.csv code as EventCode OUTPUT description as Description
| stats count by Security_ID, Source_Network_Address, EventCode, host, Description
| table Security_ID, Source_Network_Address, host, EventCode, Description, count
| sort -count
| rename Source_Network_Address as "Adresse IP Source", count as "Nb événements", host as "Nom de l'hôte"

# timechart of logons on succes
host=9.2.3.5 Source_Network_Address=* Logon_Type=3 (EventCode=4624)  $addr_ip$
| fields Security_ID, EventCode
| timechart count(EventCode) by Security_ID

# timechart of logons on fail
host=9.2.3.5 Source_Network_Address=* Logon_Type=3 (EventCode=4625)  $addr_ip$
| fields Security_ID, EventCode
| timechart count(EventCode) by Security_ID
```

### <a name='rdp-hijack'></a>rdp-hijack
```
# https://www.ired.team/offensive-security/lateral-movement/t1075-rdp-hijacking-for-lateral-movement#observations
```

## <a name='lpe'></a>lpe

### <a name='dll-hijack'></a>dll-hijack



