---
layout: post
title: DFIR AD Remediation
category: dfir
parent: cheatsheets
modified_date: 2023-06-15
permalink: /dfir/ad/remediation
---

**Menu**
<!-- vscode-markdown-toc -->
* [bloodhound-collection](#bloodhound-collection)
* [account-status](#account-status)
* [admin-count](#admin-count)
* [change-pwd](#change-pwd)
	* [bh-json-to-csv](#bh-json-to-csv)
	* [get-user-lastpwdset](#get-user-lastpwdset)
	* [get-groupmember-lastpwdset](#get-groupmember-lastpwdset)
* [check-dacl](#check-dacl)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='bloodhound-collection'></a>bloodhound-collection

## <a name='account-status'></a>account-status
```sh
pywerview get-netuser -w $zdom_fqdn -u $ztarg_user_name -p $ztarg_user_pass -t $zdom_dc_ip --username $user | grep useraccesscontrol | awk '{print $2}' | paste -s -d, -
```

## <a name='admin-count'></a>admin-count
```sh
pywerview get-netuser -w $zdom_fqdn -u $ztarg_user_name -p $ztarg_user_pass -t $zdom_dc_ip --username $user | grep admincount | awk '{print $2}' | paste -s -d, -
```

## <a name='change-pwd'></a>change-pwd

### <a name='bh-json-to-csv'></a>bh-json-to-csv
```sh
bh_query=pt_XXX_bh_dangerous-privs_dcsync
cat $bh_query.json | jq -r '.spotlight[] | join(",")' > $bh_query.csv
```

### <a name='get-user-lastpwdset'></a>get-user-lastpwdset
```sh
for user in `grep -i user $bh_query".csv" | cut -f1 -d, | sed 's/\(.*\)\@.*$/\1/'`; 
do pywerview get-netuser -w $zdom_fqdn -u $ztarg_user_name -p $ztarg_user_pass -t $zdom_dc_ip --username $user | grep "samaccountname\|pwdlastset" | awk '{print $2}' | paste -s -d, -; 
done
```

### <a name='get-groupmember-lastpwdset'></a>get-groupmember-lastpwdset
```sh
# get the groups
while read line; do echo $line | grep -i group | cut -f1 -d, | sed 's/\(.*\)\@.*$/\1/'; done < $bh_query.csv > >> groups.txt

# get the members
while read group;  do echo $group; pywerview get-netgroupmember -w $zdom_fqdn -u $ztarg_user_name -p $ztarg_user_pass -t $zdom_dc_ip -r --groupname "$group" >> members.txt ; done < groups.txt

# list lastpwdset
for member in `sort -u members.txt`; 
do pywerview get-netuser -w $zdom_fqdn -u $ztarg_user_name -p $ztarg_user_pass -t $zdom_dc_ip --username $member | grep "samaccountname\|pwdlastset" | awk '{print $2}' | paste -s -d, -; done;
```

## <a name='check-dacl'></a>check-dacl
```sh
# case: verify a RBCD attack path
# get sid for domain users / everyone / autenticated users
#ztarg_group="Domain users"
#ztarg_group="Authenticated users"
ztarg_group="Everyone"
sid=`pywerview get-netgroup -w $zdom_fqdn -u $ztarg_user_name -p $ztarg_user_pass -t $zdom_dc_ip --groupname $starg_group --full-data | grep objectsid | awk '{print $2}'`

# save dc acl to file
ztarg_sam="DC01$"
pywerview get-objectacl -w $zdom_fqdn -u $ztarg_user_name -p $ztarg_user_pass -t $zdom_dc_ip --sam-account-name $ztarg_sam > $ztarg_sam".txt"

# check everyone DACL over DC01
grep $sid $ztarg_sam".txt"
```

