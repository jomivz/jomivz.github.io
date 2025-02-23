---
layout: post
title: discovery / setenv
category: 01-discovery
parent: cheatsheets
modified_date: 2024-12-04
permalink: /discov/setenv
---

**Setting variables for copy/paste**

**Menu**
<!-- vscode-markdown-toc -->
* [lin](#lin)
* [win](#win)
* [win2](#win2)

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
export zx=$zdom\\$ztarg_user_name
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
$zx=$zdom+"\"+$ztarg_user_name
$zy=$zdom_fqdn/$ztarg_user_name
$zz=$zdom_fqdn/$ztarg_user_name:$ztarg_user_pass
```
To verify the variables use the command:
```powershell
Get-Variable | Out-String
```

## <a name='win2'></a>win2
```powershell
# ZCASE
$zcase="xxx"

# ZC2SRV
$zc2srv_ip="172.16.100.83"
$zc2srv_name="dcorp-std483"
$zc2srv_aes256k=""
$zpayload=".\Loader.exe"

# ZFOREST 1
$znbss="mcorp"
$zforest="moneycorp.local"
$zforest_krbtgt_nthash=""
$zforest_dc_ip="172.16.1.1"
$zforest_dc_name="mcorp-dc"
$zforest_dc_fqdn=$zforest_dc_name+"."+$zforest
$zforest_dn="DC=moneycorp,DC=local"
$zea_sid="xxx-519"

#
# ZFOREST 1 / ZDOM 1
$zdom="dollarcorp"
$zdom_sid=""
$znbss="dcorp"
$zdom_dn="DC=dollarcorp,DC=moneycorp,DC=local"
$zdom_fqdn=$zdom+"."+$zforest
$zdom_dc_name="dcorp-dc"
$zdom_dc_ip="172.16.2.1"
$zdom_krbtgt_aes256k=""
$zdom_krbtgt_norid="" # SID without the trailing RID "-502"
#
# ZFOREST 1 / ZDOM 2
#$zdom="us"
#$znbss="us"
#$zdom_dn="DC=us,DC=dollarcorp,DC=moneycorp,DC=local"
#$zdom_fqdn=$zdom+"."+$zforest
#$zdom_dc_name="us-dc"
#$zdom_dc_ip="172.16.9.1"
#
$zdom_dc_fqdn=$zdom_dc_name+"."+$zdom_fqdn
$zdom_dc_san=$zdom_dc_name+"$"
$zdom_dc_dn="OU=Domain Controllers,"+$zdom_dn

# ZFOREST 2
#$zforest="eurocorp.local"
#$znbss="eurocorp"
#$zforest_krbtgt_nthash=""
#$zforest_dc_ip="172.16.1.1"
#$zforest_dc_name="eurocorp-dc"
#$zforest_dc_fqdn=$zforest_dc_name+"."+$zforest
#$zforest_dn="DC=eurocorp,DC=local"
#$zea_sid="xxx-519"
#
# ZFOREST 2 / DOM 1
#$zdom="eurocorp"
#$znbss="eurocorp"
#$zdom_fqdn=$zdom+"."+$zforest
#$zdom_dc_name="eurocorp-dc"
#$zdom_dc_ip="172.16.15.1"
#$zdom_dn="DC=eurocorp,DC=local"
#
# ZFOREST 2 / DOM 2
#$zdom="eu"
#$znbss="eu"
#$zdom_fqdn=$zdom+"."+$zforest
#$zdom_dc_name="eu-dc"
#$zdom_dc_ip="172.16.15.2"
#$zdom_dn="DC=eu,DC=eurocorp,DC=local"
#
$zdom_dc_fqdn=$zdom_dc_name+"."+$zdom_fqdn
$zdom_dc_san=$zdom_dc_name+"$"
$zdom_dc_dn="OU=Domain Controllers,"+$zdom_dn

# ZPKI
$zpki_dn="CN=Public Key Services,CN=Services,CN=Configuration,"+$zdom_dn
$zpki_ca_server=""
$zpki_ca_name=""
$ztarg_forest="eurocorp.local"

# ZTARG_COMPUTER
#$ztarg_computer_name="dcorp-adminsrv"
#$ztarg_computer_ip="172.16.4.101"
#$ztarg_computer_name="dcorp-appsrv"
#$ztarg_computer_ip="172.16.4.217"
#$ztarg_computer_name="dcorp-ci"
#$ztarg_computer_ip="172.16.3.11"
#$ztarg_computer_name="dcorp-mgmt"
#$ztarg_computer_ip="172.16.4.44"
#$ztarg_computer_name="dcorp-mssql"
#$ztarg_computer_ip="172.16.3.21"
#$ztarg_computer_name="dcorp-sql1"
#$ztarg_computer_ip="172.16.3.81"
#$ztarg_computer_name="eurocorp-dc"
#$ztarg_computer_ip="172.16.15.1"
#$ztarg_computer_name="eu-dc"
#$ztarg_computer_ip="172.16.15.2"
#$ztarg_computer_name="eu-sql"
#$ztarg_computer_ip="172.16.15.3"
#$ztarg_computer_name="mcorp-dc"
#$ztarg_computer_ip="172.16.1.1"
#$ztarg_computer_name="us-dc"
#$ztarg_computer_ip="172.16.9.1"
$ztarg_computer_name="dcorp-dc"
$ztarg_computer_ip="172.16.2.1"
$ztarg_computer_fqdn=$ztarg_computer_name+"."+$zdom_fqdn
$ztarg_computer_san=$ztarg_computer+"$"
$ztarg_computer_aes256k=""

# ZTARG_NEXTHOP
$ztarg_nexthop_name="dcorp-mgmt"
$ztarg_nexthop_ip="172.16.4.44"

# ZTARG_GROUP
$ztarg_group_name="Domain Admins"

# ZTARG_USER
#$ztarg_user_name="svcadmin"
#$ztarg_user_name="ciadmin"
#$ztarg_user_name="appadmin"
#$ztarg_user_name="srvadmin"
#$ztarg_user_name="websvc"
$ztarg_user_name="student483"
$ztarg_user_pass="admin"
$ztarg_user_nthash=""
$ztarg_user_aes256k=""
$ztarg_user_sid=""
$ztarg_user_norid=""
$zx=$znbss+"\"+$ztarg_user_name
$zy=$zdom_fqdn+"/"+$ztarg_user_name
$zz=$zdom_fqdn+"/"+$ztarg_user_name+":"+$ztarg_user_pass
#$ztarg_user_next="admin"
$ztarg_ou="DevOps"
```
