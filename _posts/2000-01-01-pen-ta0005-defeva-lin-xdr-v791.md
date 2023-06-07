---
layout: post
title: TA0005 Defense Evasion - EDR - XDR v7.9.1
category: pen
parent: cheatsheets
modified_date: 2023-06-05
permalink: /pen/defeva-lin-xdr-v791
---

# Linux XDR v7.9.1

<!-- vscode-markdown-toc -->
* [End of Life Support](#EndofLifeSupport)
* [MindMaps](#MindMaps)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## processes

## files

* palo xdr file ```ltee_decryptor.json```:
```bash
jq /opt/traps/ltee/lted/ltee_ecryptor.json
```
![ps aux](/assets/images/xdr-file-ltee_decryptor.json.png)

* palo xdr file ```service_main.json```:
```bash
jq /opt/traps/python/scripts/service_main.json
```
![ps aux](/assets/images/xdr-file-services.json.png)