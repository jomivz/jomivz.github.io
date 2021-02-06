---
layout: default
title: Powershell group listing to CSV
categories: Sysadmin Windows
parent: Windows
grand_parent: Cheatsheets
---

# {{ page.title }}

## PS script for detailled listing of Group Members
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
