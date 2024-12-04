---
layout: post
title: siem / splunk / net
category: siem
parent: cheatsheets
modified_date: 2023-09-21
permalink: /siem/splunk/net
---

<!-- vscode-markdown-toc -->
* [prereq](#prereq)
* [cisco-meraki](#cisco-meraki)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='prereq'></a>prereq
-  [parallel coordinates app](https://splunkbase.splunk.com/app/3767/#/details)
-  [force directed app](https://splunkbase.splunk.com/app/3137/)

## <a name='cisco-meraki'></a>cisco-meraki
```bash
# Incoming / Outcoming Traffic - vizualization w/ parallel coordinates app
index=* | table "Client IP", "Destination IP", "Destination Port"

# Incoming / Outcoming Traffic - Top Domains Stats
index=* | rex field=URI "\/\/(?:[^@\/\n]+@)?(?:www\.)?(?<refdomain>[^:\/\n]+)"

# Incoming / Outcoming Traffic - Domains Graphic - vizualization w/ parallel coordinates app
index=* | rex field=URI "\/\/(?:[^@\/\n]+@)?(?:www\.)?(?<refdomain>[^:\/\n]+)"| stats count by refdomain | sort - count

# Data Leak Stats
index=* "File Type"=* | stats sum("File Size") as bytes_uploaded by "Client IP", "Destination IP", "Destination Port"| eval MB_uploaded = ((bytes_uploaded/1024)/1024) | table "Client IP", "Destination IP", "Destination Port", MB_uploaded | sort - MB_uploaded

# Lateral movements graph - Vizualization w/ parallel coordinates app
```
