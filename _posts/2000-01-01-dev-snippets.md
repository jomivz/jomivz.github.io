---
layout: post
title: DEV - Snippets
category: dev
parent: cheatsheets
modified_date: 2023-06-08
permalink: /dev/snippets
---

<!-- vscode-markdown-toc -->
* [powershell](#powershell)
	* [ps-list-groupmembers](#ps-list-groupmembers)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='powershell'></a>powershell

### <a name='ps-list-groupmembers'></a>ps-list-groupmembers
---------------------------------------------

```powershell
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
