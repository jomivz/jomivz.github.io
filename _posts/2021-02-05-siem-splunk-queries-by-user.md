---
layout: default
title: Splunk queries by user
parent: SIEM
category: SIEM
grand_parent: Cheatsheets
---

# {{ page.title }}

## Splunk Queries by user 

### O365: mails entrants bloqués

```
sourcetype="ms:o365:reporting:messagetrace" (action=FilteredAsSpam OR action=quarantained) RecipientAddress=$user_account$@acme.fr
| fields FromIP, Subject, SenderAddress, Country, City
| stats count(Subject) as nbmail by FromIP, Subject, SenderAddress
| sort -nbmail
| iplocation FromIP
| table nbmail, FromIP, Country, City, SenderAddress, Subject
```

### Windows: accès aux partages

```
host=10.1.2.5 Account_Name=$user_account$ EventCode=4728 | table ComputerName, Group_Name, Account_Name, EventCode | rename ComputerName as "Serveur AD", Group_Name as "Groupe Administrateur modifié", Account_Name as "Administrateur responsable de la modification \r\n Compte rajouté"
```

### Windows Accès aux partages à privilège: C$, ADMIN$</title>

```
host=10.1.2.5 EventCode=5145 (Share_Name="*\\C$$" OR Share_Name="*\\Admin$$") Account_Name=$user_account$ | timechart count by Account_Name
```
