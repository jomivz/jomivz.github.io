---
layout: post
title: dfir / mlw / pe
category: dfir
parent: cheatsheets
modified_date: 2023-09-21
permalink: /dfir/mlw/pe
---

<!-- vscode-markdown-toc -->
* [flare](#flare)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->



## <a name='flare'></a>pe

| **action** | **tool** |
|------------|----------|
| get file type | file, HxD |
| get bin signatures | hashdump |
| dump strings | strings, floss, xorsearch; PEStudio |
| detect packing | exeinfo, |

## <a name='flare'></a>virustotal
```sh
# VT malware download
curl -k  --insecure --request GET -L --output my_malware --url https://www.virustotal.com/api/v3/files/<my_malware_id>/download --header 'x-apikey:'
```
