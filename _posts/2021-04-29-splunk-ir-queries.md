---
layout: default
title: Incident response with Splunk 
parent: SIEM
category: SIEM
grand_parent: Cheatsheets
nav_order: 2
has_children: true
---

# {{ page.title }}

## Pre-requisites
- https://splunkbase.splunk.com/app/3767/#/details
- 

## IR queries over Network logs

```
# Incoming/Outcoming Traffic graph - Vizualization w/ parallel coordinates app - Cisco Meraki logs
index=* | table "Client IP", "Destination IP", "Destination Port"
index=* | rex field=URI "\/\/(?:[^@\/\n]+@)?(?:www\.)?(?<refdomain>[^:\/\n]+)" | table "Client IP", refdomain, "Destination Port"

# Dataleak stats - Cisco Meraki logs 
index=* "File Type"=* | stats sum("File Size") as bytes_uploaded by "Client IP", "Destination IP", "Destination Port"| eval MB_uploaded = ((bytes_uploaded/1024)/1024) | sort - MB_uploaded

# Lateral movements graph - Vizualization w/ parallel coordinates app - Cisco Meraki logs
  
```

## IR queries over Windows logs

```
# See [how to convert Windows EVTX log files to XML]{/}
index=* | xmlkv
```
