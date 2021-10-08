---
layout: default
title: Splunk queries by user
parent: SIEM
category: SIEM
grand_parent: Cheatsheets
---

<!-- vscode-markdown-toc -->
* 1. [Splunk Queries by user](#SplunkQueriesbyuser)
	* 1.1. [Accessed Services (Successful TGS)](#AccessedServicesSuccessfulTGS)
	* 1.2. [O365: mails entrants bloqués](#O365:mailsentrantsbloqus)
	* 1.3. [Windows: accès aux partages](#Windows:accsauxpartages)
	* 1.4. [Windows Accès aux partages à privilège: C$, ADMIN$</title>](#WindowsAccsauxpartagesprivilge:CADMINtitle)

<!-- vscode-markdown-toc-config
	numbering=true
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

# {{ page.title }}

##  1. <a name='SplunkQueriesbyuser'></a>Splunk Queries by user 

###  1.1. <a name='AccessedServicesSuccessfulTGS'></a>Accessed Services (Successful TGS) 
```
source="WinEventLog:Security"  Account_Name="johndoe*" EventCode=4769 | table _time, ComputerName, Account_Name, Client_Address, Service_ID
```

###  1.2. <a name='O365:mailsentrantsbloqus'></a>O365: mails entrants bloqués

```
sourcetype="ms:o365:reporting:messagetrace" (action=FilteredAsSpam OR action=quarantained) RecipientAddress=$user_account$@acme.fr
| fields FromIP, Subject, SenderAddress, Country, City
| stats count(Subject) as nbmail by FromIP, Subject, SenderAddress
| sort -nbmail
| iplocation FromIP
| table nbmail, FromIP, Country, City, SenderAddress, Subject
```

###  1.3. <a name='Windows:accsauxpartages'></a>Windows: accès aux partages

```
host=10.1.2.5 Account_Name=$user_account$ EventCode=4728 | table ComputerName, Group_Name, Account_Name, EventCode | rename ComputerName as "Serveur AD", Group_Name as "Groupe Administrateur modifié", Account_Name as "Administrateur responsable de la modification \r\n Compte rajouté"
```

###  1.4. <a name='WindowsAccsauxpartagesprivilge:CADMINtitle'></a>Windows Accès aux partages à privilège: C$, ADMIN$</title>

```
host=10.1.2.5 EventCode=5145 (Share_Name="*\\C$$" OR Share_Name="*\\Admin$$") Account_Name=$user_account$ | timechart count by Account_Name
```
