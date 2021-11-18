---
layout: default
title:  Powershell useful queries
parent: Windows
category: Windows
grand_parent: Cheatsheets
---

# {{ page.title }}


## PS sysadmin useful queries
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
