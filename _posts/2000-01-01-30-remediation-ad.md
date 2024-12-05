---
layout: post
title:  remediation / ad
category: 30-csirt
parent: cheatsheets
modified_date: 2023-07-26
permalink: /dfir/remed/ad
---

**Menu**
<!-- vscode-markdown-toc -->
* [hva](#hva)
	* [can-dcsync](#can-dcsync)
	* [hva-enum](#hva-enum)
	* [hva-confirm](#hva-confirm)
* [check-pwdlastset](#check-pwdlastset)
	* [pwdlastset-hva](#pwdlastset-hva)
	* [pwdlastset-bh-pwnable](#pwdlastset-bh-pwnable)
		* [bh-pwnable-users](#bh-pwnable-users)
		* [bh-pwnable-groupmembers](#bh-pwnable-groupmembers)
* [check-dacl](#check-dacl)
	* [check-dacl-4-sam](#check-dacl-4-sam)
	* [check-dacl-all-with-aced](#check-dacl-all-with-aced)
	* [check-dacl-all-with-bh.py](#check-dacl-all-with-bh.py)
* [check-gpo](#check-gpo)
	* [bloodhood.py](#bloodhood.py)
* [check-schema](#check-schema)
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

## <a name='hva'></a>hva

### <a name='can-dcsync'></a>can-dcsync
- [T1003.006](https://attack.mitre.org/techniques/T1003/006) DCSYNC

```sh
# 01 : bh pre built query to find dcsync principal
MATCH p=()-[:DCSync|AllExtendedRights|GenericAll]->(:Domain {name: ""}) RETURN p
# export json, name it 'dcsync.json'

# 02 : list the DCs with dig
dig -t SRV "_ldap._tcp.dc._msdcs."$zdom_fqdn | grep "^[a-zA-Z]" | cut -f1 -d"." | sort -u > $zcase"_dig_dc_list.txt"

# 02 : collect the ACLs for all DCs
ddir=`date +"%Y%m%d"`; mkdir $ddir; cd $ddir
for ztarg_sam in `cat ../$zcase"_dig_dc_list.txt"`; do
pywerview get-objectacl -w $zdom_fqdn -u $ztarg_user_name -p $ztarg_user_pass -t $zdom_dc_ip --sam-account-name $ztarg_sam"$" --resolve-sids > $zcase"_get-objectacl_"$ztarg_sam".txt"; done

# 02 : list to CSV
for file in `ls`; do awk '{if ($1 ~ /activedirectoryrights/) {split($0,a,":"); p=a[2]} else if ($1 ~ /securityidentifier/) {split($0,a,":"); print a[2]";"p}}' $file > $file.csv; done

# 02 : display principal granted for dcsync 
for file in `ls *.csv`; do echo $file; grep "extended_right\|generic_all" $file |csvlook -d ";"; done

# 03 : check the Replication-Get-Changes rights
# 03 : to debug : pywerview do not retrieve the ntsecuritydescriptor
#CN="DS-Replication-Get-Changes,CN=Extended-Rights,CN=Configuration,"$zdom_dn
#CN="DS-Replication-Get-Changes-All,CN=Extended-Rights,CN=Configuration,"$zdom_dn
#CN="DS-Replication-Get-Changes-In-Filtered-Set,CN=Extended-Rights,CN=Configuration,"$zdom_dn
#pywerview get-adobjectacl -w $zdom_fqdn -u $ztarg_user_name -p $ztarg_user_pass -t $zdom_dc_ip -a $CN

# 03 : check the Replication-Get-Changes rights
# open adexplorer, copy the ntSecurityDescriptor of the 3 CNs up into 3 different files, grep for the SIDs
egrep -o "S-1-5-21-[0-9]{10}-[0-9]{10}-[0-9]{10}-[0-9]{1,6}" replication-get-changes.txt
egrep -o "S-1-5-21-[0-9]{10}-[0-9]{10}-[0-9]{10}-[0-9]{1,6}" replication-get-changes-all.txt
egrep -o "S-1-5-21-[0-9]{10}-[0-9]{10}-[0-9]{10}-[0-9]{1,6}" replication-get-changes-in-filtered-set.txt
```

### <a name='hva-enum'></a>hva-enum

* [/pen/lin/discov-ad#shoot-priv-users](/pen/lin/discov-ad#shoot-priv-users)
* [/pen/lin/discov-ad#shoot-spns](/pen/lin/discov-ad#shoot-spns)
* [/pen/lin/discov-ad#shoot-uac](/pen/lin/discov-ad#shoot-uac)

```sh
# credit hausec cypher query : hva
MATCH p=(n:User)-[r:MemberOf*1..]->(m:Group {highvalue:true}) RETURN p

# credit hausec cypher query : list users group
```

### <a name='hva-confirm'></a>hva-confirm
```sh
# confirm admincount
pywerview get-netuser -w $zdom_fqdn -u $ztarg_user_name -p $ztarg_user_pass -t $zdom_dc_ip --username $ztarg_user_next | grep admincount | awk '{print $2}' | paste -s -d, -

# confirm spn
pywerview get-netuser -w $zdom_fqdn -u $ztarg_user_name -p $ztarg_user_pass -t $zdom_dc_ip --username $ztarg_user_next | grep serviceprincipalname | awk '{print $2}' | paste -s -d, -

# confirm uac
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

## <a name='check-pwdlastset'></a>check-pwdlastset

### <a name='pwdlastset-hva'></a>pwdlastset-hva
```sh
# STEP 1: create a new dir
mkdir _hva; cd _hva
# SPTE 2: fill the txt with hva accounts
touch hva_accnt.txt
# STEP 3: get 1 getnetuser txt / hva accounts
for zhva_accnt in `cat hva_accnt.txt`; do pywerview.py get-netuser -w $zdom_fqdn -u $ztarg_user_name -p $ztarg_user_pass --dc-ip $zdom_dc_ip --username $zhva_accnt > $zcase"_getnetuser_"$zhva_accnt".txt"; done
# STEP 4: grep into the txt
grep pwdlastset *getnetuser* | sed 's/.*getnetuser_\(.*\)\.txt.*\([0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}\ [0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}.*[-+][0-9]\{2\}:[0-9]\{2\}\)/\2,\1/' | sort -u | csvlook -H
```

### <a name='pwdlastset-bh-pwnable'></a>pwdlastset-bh-pwnable

* Extract JSON from BH prebuilt queries (Dangerous Privs, KRB interactions, SPF)
* Format the JSON to CSV :
```sh
bh_query=pt_XXX_bh_dangerous-privs_dcsync
cat $bh_query.json | jq -r '.spotlight[] | join(",")' > $bh_query.csv
```

#### <a name='bh-pwnable-users'></a>bh-pwnable-users
```sh
for user in `grep -i user $bh_query".csv" | cut -f1 -d, | sed 's/\(.*\)\@.*$/\1/'`; 
  do pywerview get-netuser -w $zdom_fqdn -u $ztarg_user_name -p $ztarg_user_pass -t $zdom_dc_ip --username $user | grep "samaccountname\|pwdlastset" | awk '{print $2}' | paste -s -d, -; 
done
```

#### <a name='bh-pwnable-groupmembers'></a>bh-pwnable-groupmembers
```sh
# get the groups
while read line; do echo $line | grep -i group | cut -f1 -d, | sed 's/\(.*\)\@.*$/\1/'; done < $bh_query.csv >> groups.txt

# get the members
while read group;  do echo $group; pywerview get-netgroupmember -w $zdom_fqdn -u $ztarg_user_name -p $ztarg_user_pass -t $zdom_dc_ip -r --groupname "$group" | grep "membername" | awk '{print $2}' >> members.txt ; done < groups.txt

# list pwdlastset
for member in `sort -u members.txt`; 
do pywerview get-netuser -w $zdom_fqdn -u $ztarg_user_name -p $ztarg_user_pass -t $zdom_dc_ip --username $member | grep "samaccountname\|pwdlastset" | awk '{print $2}' | paste -s -d, -; done;
```

## <a name='check-dacl'></a>check-dacl

### <a name='check-dacl-4-sam'></a>check-dacl-4-sam
```sh
# define the sam-account-name
ztarg_sam="Domain users"
ztarg_sam="Authenticated users"
ztarg_sam="DC01$"

# retrieve DACLs
pywerview get-objectacl -w $zdom_fqdn -u $ztarg_user_name -p $ztarg_user_pass -t $zdom_dc_ip --sam-account-name $ztarg_sam --resolve-sids > $zcase"_dacl_XXX_resolved.txt"

# get the securityidentifier based on $ad_rights 
ad_rights="generic_all"
ad_rights="generic_write"
ad_rights="write_dacl"
ad_rights="write_property"
ad_rights="write_owner"
ad_rights="extended_right"

grep -A 7 -B 7 $ad_rights $zcase"_get-objectacl_"$ztarg_sam".txt" | awk '{  if ($1 ~ /objectdn/) {split($0,a,":"); od=a[2]} else if ($1 ~ /acetype/) {split($0,a,":"); at=a[2]} else if ($1 ~ /activedirectoryrights/) {split($0,a,":"); ar=a[2]} else if ($1 ~ /isinherited/) {split($0,a,":"); ii=a[2]} else if ($1 ~ /securityidentifier/) {split($0,a,":"); print at";"od";"a[2]";"ar";"ii}}'
```

### <a name='check-dacl-all-with-aced'></a>check-dacl-all-with-aced
```sh
# execution
python3 ./aced.py $zz@$zdom_dc_ip

# check foreign principal
# local principal with samaccountname at 'none' might mean existing ACE for deleted object  
sid=""
pywerview.py get-netuser -w $zdom_fqdn -u $ztarg_user_name -p $ztarg_user_pass --dc-ip $zdom_dc_ip --custom-filter "(objectsid=$sid)"
```

### <a name='check-dacl-all-with-bh.py'></a>check-dacl-all-with-bh.py
```sh
./bloodhound.py -c ACL --domain $zdom_fqdn -dc $zdom_dc_fqdn -u $ztarg_user_name -p $ztarg_user_pass
jq ...
```

## <a name='check-gpo'></a>check-gpo

### <a name='bloodhood.py'></a>bloodhood.py
```sh
./bloodhound.py -c Container --domain $zdom_fqdn -dc $zdom_dc_fqdn -u $ztarg_user_name -p $ztarg_user_pass
```

## <a name='check-schema'></a>check-schema
```sh
# list confidential attributes
#Get-AdObject -SearchBase "CN=Schema,CN=Configuration,"$zdom_dn -LdapFilter '(&(searchflags:1.2.840.113556.1.4.804:=128)(!(searchflags:1.2.840.113556.1.4.804:=512)))'
#pywerview get-adobject -a "CN=Schema,CN=Configuration,"$zdom_dn --attribute searchflags
```
source: [simondotsh.com](https://simondotsh.com/infosec/2022/07/11/dirsync.html).

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