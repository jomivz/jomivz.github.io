---
layout: post
title: Splunk queries by user
category: SIEM
parent: SIEM
grand_parent: Cheatsheets
modified_date: 2021-02-05
permalink: /siem/splunk-misc-user
---

<!-- vscode-markdown-toc -->
* [Splunk Queries by user](#SplunkQueriesbyuser)
	* [Accessed Services (Successful TGS)](#AccessedServicesSuccessfulTGS)
	* [O365: mails entrants bloqués](#O365:mailsentrantsbloqus)
	* [Windows: accès aux partages](#Windows:accsauxpartages)
	* [Windows Accès aux partages à privilège: C$, ADMIN$</title>](#WindowsAccsauxpartagesprivilge:CADMINtitle)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='SplunkQueriesbyuser'></a>Splunk Queries by user 

### <a name='AccessedServicesSuccessfulTGS'></a>Accessed Services (Successful TGS) 
```
source="WinEventLog:Security"  Account_Name="johndoe*" EventCode=4769 | table _time, ComputerName, Account_Name, Client_Address, Service_ID
```

### <a name='O365:mailsentrantsbloqus'></a>O365: mails entrants bloqués

```
sourcetype="ms:o365:reporting:messagetrace" (action=FilteredAsSpam OR action=quarantained) RecipientAddress=$user_account$@acme.fr
| fields FromIP, Subject, SenderAddress, Country, City
| stats count(Subject) as nbmail by FromIP, Subject, SenderAddress
| sort -nbmail
| iplocation FromIP
| table nbmail, FromIP, Country, City, SenderAddress, Subject
```

### <a name='Windows:accsauxpartages'></a>Windows: accès aux partages

```
host=10.1.2.5 Account_Name=$user_account$ EventCode=4728 | table ComputerName, Group_Name, Account_Name, EventCode | rename ComputerName as "Serveur AD", Group_Name as "Groupe Administrateur modifié", Account_Name as "Administrateur responsable de la modification \r\n Compte rajouté"
```

### <a name='WindowsAccsauxpartagesprivilge:CADMINtitle'></a>Windows Accès aux partages à privilège: C$, ADMIN$</title>

```
host=10.1.2.5 EventCode=5145 (Share_Name="*\\C$$" OR Share_Name="*\\Admin$$") Account_Name=$user_account$ | timechart count by Account_Name
```
