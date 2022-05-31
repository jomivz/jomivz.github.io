---
layout: post
title: Incident response with Splunk 
parent: SIEM
category: SIEM
grand_parent: Cheatsheets
modified_date: 2022-03-22
permalink: /:categories/:title/
---

<!-- vscode-markdown-toc -->
* [Pre-requisites](#Pre-requisites)
* [IR queries over Network logs](#IRqueriesoverNetworklogs)
* [IR queries over Windows logs](#IRqueriesoverWindowslogs)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='Pre-requisites'></a>Pre-requisites
-  [parallel coordinates app](https://splunkbase.splunk.com/app/3767/#/details)
-  [force directed app](https://splunkbase.splunk.com/app/3137/)

## <a name='IRqueriesoverNetworklogs'></a>IR queries over Network logs

```
# Incoming / Outcoming Traffic - Cisco Meraki - vizualization w/ parallel coordinates app
index=* | table "Client IP", "Destination IP", "Destination Port"

# Incoming / Outcoming Traffic - Cisco Meraki - Top Domains Stats
index=* | rex field=URI "\/\/(?:[^@\/\n]+@)?(?:www\.)?(?<refdomain>[^:\/\n]+)"

# Incoming / Outcoming Traffic - Cisco Meraki - Domains Graphic - vizualization w/ parallel coordinates app
index=* | rex field=URI "\/\/(?:[^@\/\n]+@)?(?:www\.)?(?<refdomain>[^:\/\n]+)"| stats count by refdomain | sort - count

# Data Leak Stats - Cisco Meraki
index=* "File Type"=* | stats sum("File Size") as bytes_uploaded by "Client IP", "Destination IP", "Destination Port"| eval MB_uploaded = ((bytes_uploaded/1024)/1024) | table "Client IP", "Destination IP", "Destination Port", MB_uploaded | sort - MB_uploaded

# Lateral movements graph - Vizualization w/ parallel coordinates app - Cisco Meraki logs
  
```

## <a name='IRqueriesoverWindowslogs'></a>IR queries over Windows logs

```
# See [how to convert Windows EVTX log files to XML]{/}
index=* | xmlkv
```