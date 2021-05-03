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
- [https://splunkbase.splunk.com/app/3767/#/details]{parallel coordinates app}
- [https://splunkbase.splunk.com/app/3137/]{force directed app} 

## IR queries over Network logs

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

## IR queries over Windows logs

```
# See [how to convert Windows EVTX log files to XML]{/}
index=* | xmlkv
```
