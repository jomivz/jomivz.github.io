---
layout: post
title: DFIR AD Remediation
category: dfir
parent: cheatsheets
modified_date: 2023-06-19
permalink: /dfir/ad/remediation
---

**Menu**
<!-- vscode-markdown-toc -->
* [check-account-live](#check-account-live)
	* [admincount](#admincount)
	* [pwdlastset](#pwdlastset)
		* [get-user-pwdlastset](#get-user-pwdlastset)
		* [get-groupmember-pwdlastset](#get-groupmember-pwdlastset)
	* [spn](#spn)
	* [uac](#uac)
* [check-dacl](#check-dacl)
	* [aced](#aced)
	* [bloodhood.py](#bloodhood.py)
	* [ldap-queries](#ldap-queries)
* [check-gpo](#check-gpo)
	* [bloodhood.py](#bloodhood.py-1)
	* [check-gpo-whencreated](#check-gpo-whencreated)
	* [group3r](#group3r)
* [check-replications](#check-replications)
	* [replication-analyzer](#replication-analyzer)
	* [repadmin](#repadmin)
* [netwrix account lockout examiner](#netwrixaccountlockoutexaminer)
* [take-ad-snapshot](#take-ad-snapshot)
	* [check-ad-snapshot](#check-ad-snapshot)
	* [adexplorersnapshot.py](#adexplorersnapshot.py)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='check-account-live'></a>check-account-live

### <a name='admincount'></a>admincount
```sh
# live
# admincount
pywerview get-netuser -w $zdom_fqdn -u $ztarg_user_name -p $ztarg_user_pass -t $zdom_dc_ip --username $user | grep admincount | awk '{print $2}' | paste -s -d, -

# jq-over-bh-json
# admincount
users.json | jq -r '.data[].Properties | select((.admincount==true) and .enabled==true)) | .samaccountname'

#groupmembers
#groups.json | jq -r '.data[].Properties | select(.name=="Domain Admins@$zdom_fqdn")'
```

### <a name='pwdlastset'></a>pwdlastset

```sh
bh_query=pt_XXX_bh_dangerous-privs_dcsync
cat $bh_query.json | jq -r '.spotlight[] | join(",")' > $bh_query.csv
```

#### <a name='get-user-pwdlastset'></a>get-user-pwdlastset
```sh
for user in `grep -i user $bh_query".csv" | cut -f1 -d, | sed 's/\(.*\)\@.*$/\1/'`; 
  do pywerview get-netuser -w $zdom_fqdn -u $ztarg_user_name -p $ztarg_user_pass -t $zdom_dc_ip --username $user | grep "samaccountname\|pwdlastset" | awk '{print $2}' | paste -s -d, -; 
done
```

#### <a name='get-groupmember-pwdlastset'></a>get-groupmember-pwdlastset
```sh
# get the groups
while read line; do echo $line | grep -i group | cut -f1 -d, | sed 's/\(.*\)\@.*$/\1/'; done < $bh_query.csv > >> groups.txt

# get the members
while read group;  do echo $group; pywerview get-netgroupmember -w $zdom_fqdn -u $ztarg_user_name -p $ztarg_user_pass -t $zdom_dc_ip -r --groupname "$group" >> members.txt ; done < groups.txt

# list pwdlastset
for member in `sort -u members.txt`; 
do pywerview get-netuser -w $zdom_fqdn -u $ztarg_user_name -p $ztarg_user_pass -t $zdom_dc_ip --username $member | grep "samaccountname\|pwdlastset" | awk '{print $2}' | paste -s -d, -; done;
```

### <a name='spn'></a>spn 
```sh
pywerview get-netuser -w $zdom_fqdn -u $ztarg_user_name -p $ztarg_user_pass -t $zdom_dc_ip --username $user | grep XXX | awk '{print $2}' | paste -s -d, -
```

### <a name='uac'></a>uac

```sh
# live
pywerview get-netuser -w $zdom_fqdn -u $ztarg_user_name -p $ztarg_user_pass -t $zdom_dc_ip --username $user | grep useraccountcontrol | awk '{print $2}' | paste -s -d, -
```

**UAC shortlist** from [Microsoft](https://learn.microsoft.com/en-us/troubleshoot/windows-server/identity/useraccountcontrol-manipulate-account-properties) :
* ACCOUNTDISABLE
* DONT_EXPIRE_PASSWORD
* DONT_REQ_PREAUTH	
* INTERDOMAIN_TRUST_ACCOUNT
* PASSWORD_EXPIRED
* PASSWD_NOTREQD
* SMARTCARD_REQUIRED
* TRUSTED_FOR_DELEGATION
* TRUSTED_TO_AUTH_FOR_DELEGATION

## <a name='check-dacl'></a>check-dacl

### <a name='aced'></a>aced
```sh
# execution
python3 ./aced.py $zz@$zdom_dc_ip

# check foreign principal
# local principal with samaccountname at 'none' might mean existing ACE for deleted object  
sid=""
pywerview.py get-netuser -w $zdom_fqdn -u $ztarg_user_name -p $ztarg_user_pass --dc-ip $zdom_dc_ip --custom-filter "(objectsid=$sid)"
```

### <a name='bloodhood.py'></a>bloodhood.py
```sh
./bloodhound.py -c ACL --domain $zdom_fqdn -dc $zdom_dc_fqdn -u $ztarg_user_name -p $ztarg_user_pass
```

### <a name='ldap-queries'></a>ldap-queries
```sh
# get sid for domain users / everyone / autenticated users
#ztarg_group="Domain users"
#ztarg_group="Authenticated users"
ztarg_group_name="Everyone"
sid=`pywerview get-netgroup -w $zdom_fqdn -u $ztarg_user_name -p $ztarg_user_pass -t $zdom_dc_ip --groupname $starg_group --full-data | grep objectsid | awk '{print $2}'`

# check everyone DACL over DC01
ztarg_sam="DC01$"
pywerview get-objectacl -w $zdom_fqdn -u $ztarg_user_name -p $ztarg_user_pass -t $zdom_dc_ip --sam-account-name $ztarg_sam > $ztarg_sam".txt"

# does 'everyone' has an ACE for DC01$ ? 
grep $sid $ztarg_sam".txt"

# check everyone group permissions
pywerview get-objectacl -w $zdom_fqdn -u $ztarg_user_name -p $ztarg_user_pass -t $zdom_dc_ip --sam-account-name $ztarg_group_name --resolve-sids > "acl_"$ztarg_group_name"_resolved.txt"
```


## <a name='check-gpo'></a>check-gpo

### <a name='bloodhood.py-1'></a>bloodhood.py
```sh
./bloodhound.py -c Container --domain $zdom_fqdn -dc $zdom_dc_fqdn -u $ztarg_user_name -p $ztarg_user_pass
```

### <a name='check-gpo-whencreated'></a>check-gpo-whencreated
```sh
# jq-over-bh-json
cat 20230613111126_gpos.json | jq -r '.data[].Properties | {whencreated,name} |join (",")' |sort > 20230613111126_gpos.csv
EPOCH='1679537189'
date -d "1970-01-01 UTC $EPOCH seconds" +"%Y-%m-%d %T %z"
```

### <a name='group3r'></a>group3r
* [github.com/Group3r)](https://github.com/Group3r/Group3r)
* need to be compiled

## <a name='check-replications'></a>check-replications

### <a name='replication-analyzer'></a>replication-analyzer

### <a name='repadmin'></a>repadmin

## <a name='netwrixaccountlockoutexaminer'></a>netwrix account lockout examiner

## <a name='take-ad-snapshot'></a>take-ad-snapshot

### <a name='check-ad-snapshot'></a>check-ad-snapshot

### <a name='adexplorersnapshot.py'></a>adexplorersnapshot.py