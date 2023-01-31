---
layout: post
title: TA0008 Lateral Movement - Docker
parent: Pentesting
category: Pentesting
grand_parent: Cheatsheets
modified_date: 2023-01-25
permalink: /:categories/:title/
---
<!-- vscode-markdown-toc -->
* [Cheatsheets](#Cheatsheets)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='Cheatsheets'></a>Cheatsheets

- [PayloadAllTheThings](https://swisskyrepo.github.io/PayloadsAllTheThingsWeb/Methodology%20and%20Resources/Container%20-%20Docker%20Pentest/#summary)
- []()
- 

# Unsecure Azure Registry

```
curl -s -k --user "USER:PASS" https://registry.azurecr.io/v2/_catalog | jq '.repositories'
curl -s -k --user "USER:PASS" https://registry.azurecr.io/v2/<image_name>/tags/list | jq '.tags'
podman pull --creds "USER:PASS" registry.azurecr.io/<image_name>:<tag>


https://aex.dev.azure.com/me?mkt=en-US
```


