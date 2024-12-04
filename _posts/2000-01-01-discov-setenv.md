---
layout: post
title: discovery / setenv
category: discovery
parent: cheatsheets
modified_date: 2023-09-18
permalink: /discov/setenv
---

**Setting variables for copy/paste**

**Menu**
<!-- vscode-markdown-toc -->
* [lin](#lin)
* [win](#win)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='lin'></a>lin
```sh
#!/bin/bash
# example of env.sh file
export zcase="xxx"
export zforest="com"
export zdom="contoso"
export zdom_fqdn=$zdom"."$zforest
export zdom_dn="DC=contoso,DC=com"
export zdom_dc_ip="1.2.3.4"
export zdom_dc_name="DC001"
export zdom_dc_fqdn=$zdom_dc_name"."$zdom_fqdn
export zdom_dc_san=$zdom_dc_name"$"
export zdom_dc_dn="OU=Domain Controllers,"$zdom_dn
export zpki_dn="CN=Public Key Services,CN=Services,CN=Configuration,"$zdom_dn
export zpki_ca_server=""
export zpki_ca_name=""
export ztarg_computer_name="PC001"
export ztarg_computer_fqdn=$ztarg_computer"."$zdom_fqdn
export ztarg_computer_ip=""
export ztarg_computer_san=$ztarg_computer"$"
export ztarg_group_name="xxx"
export ztarg_user_name="xxx"
export ztarg_user_nthash="xxx"
export ztarg_user_pass="xxx"
export ztarg_user_next="xxx"
export zy=$zdom_fqdn/$ztarg_user_name
export zz=$zdom_fqdn/$ztarg_user_name:$ztarg_user_pass
```

To set / verify the variables use the command:
```sh
# set the envs without opening a new shell
. ./env.sh

#verify the envs
set
```

## <a name='win'></a>win
```powershell
$zcase="xxx"
$zforest="corp"
$zdom="contoso"
$zdom_fqdn=$zdom+"."+$zforest
$zdom_dn="DC=contoso,DC=corp"
$zdom_dc_ip="1.2.3.4"
$zdom_dc_name="DC01"
$zdom_dc_fqdn=$zdom_dc_name+"."+$zdom_fqdn
$zdom_dc_san=$zdom_dc+"$"
$zdom_dc_dn="CN=Domain Controllers,"+$zdom_dn
$zpki_dn="CN=Public Key Services,CN=Services,CN=Configuration,"+$zdom_dn
$zpki_ca_server=""
$zpki_ca_name=""
$ztarg_computer_name="PC001"
$ztarg_computer_fqdn=$ztarg_computer+"."+$zdom_fqdn
$ztarg_computer_ip=""
$ztarg_computer_san=$ztarg_computer+"$"
$ztarg_group_name="PC001"
$ztarg_user_name="admin"
$ztarg_user_pass="admin"
$ztarg_user_next="admin"
$zy=$zdom_fqdn/$ztarg_user_name
$zz=$zdom_fqdn/$ztarg_user_name:$ztarg_user_pass
```
To verify the variables use the command:
```powershell
Get-Variable | Out-String
```