---
layout: post
title: siem / splunk / visualization / network scanning
category: 20-soc
parent: cheatsheets
modified_date: 2021-03-02
permalink: /siem/splunk-viz-portscan
---
<!-- vscode-markdown-toc -->
* [Dashboard with dropdown location + timepicker](#Dashboardwithdropdownlocationtimepicker)
* [Search query to visualize Port Scans - without a DMZ subnet](#SearchquerytovisualizePortScans-withoutaDMZsubnet)
* [Search query to visualize Port Scans - with a DMZ subnet](#SearchquerytovisualizePortScans-withaDMZsubnet)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

Port scanning can be efficiently visualized with the app available [here](https://splunkbase.splunk.com/app/3137/).

For this visualization use-case, here are few concerns about :
 * hardware ressources - as the parallel coordinate visualizer is CPU consuming, you might use it with a restricted ***timespan***.
 * network design - depending on your network design / IP plan, you may select the appropriate query below / change the IP subnets

## <a name='Dashboardwithdropdownlocationtimepicker'></a>Dashboard with dropdown location + timepicker 

Find the **PortScanViz XML dashboard** [here](/docs/siem/siem-splunk-portscan-dashboard.xml) based on search queries below.

The picture shows up a port scan from 192.168.250.20 to 192.168.250.100.

![.](/assets/images/siem-splunk-portscan-dashboard.png)

Note: this dashboard MAY be optimized to take in charge :
- multicast subnets
- IPv6 subnets
- instead of using the ```cidrmatch``` function, you may enrich IP fields with its location at the idex-time

## <a name='SearchquerytovisualizePortScans-withoutaDMZsubnet'></a>Search query to visualize Port Scans - without a DMZ subnet 

```spl
sourcetype="stream:tcp" 
| search src_ip=*
| eval isSrcIP=if(cidrmatch("192.168.0.0/16",src_ip), "local", "external") 
| eval isDestIP=if(cidrmatch("192.168.0.0/16",dest_ip), "local", "external") 
| where isSrcIP = "external" AND isDestIP = "local" 
#| where isSrcIP = "local" AND isDestIP = "local" 
| table src_ip, src_port, dest_ip, dest_port
```

## <a name='SearchquerytovisualizePortScans-withaDMZsubnet'></a>Search query to visualize Port Scans - with a DMZ subnet 

```spl
sourcetype="stream:tcp" 
| search src_ip=*
| eval isSrcIP=if(cidrmatch("192.168.69.0/24",src_ip), "local", if(cidrmatch("192.168.250.0/24",src_ip), "dmz", "external")) 
| eval isDestIP=if(cidrmatch("192.168.69.0/24",dest_ip), "local", if(cidrmatch("192.168.250.0/24",dest_ip), "dmz", "external")) 
| where isSrcIP = "external" AND isDestIP = "dmz" 
| where isSrcIP = "external" AND isDestIP = "local" 
| table src_ip, src_port, dest_ip, dest_port, isLocal
```

Note: on line 2 and line 3, putting the "192.168.0.0/16" before "192.168.250.0/24" will result to IP overlap error.
In such case, the second ```cidrmatch()``` function will not be evaluated.
