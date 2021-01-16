---
layout: default
title: splunk queries by user
parent: SIEM
grand_parent: Cheatsheets
nav_order: 3
has_children: true
---

# Splunk Queries by user

**Table of Contents**

- [Splunk queries by user](#splunk-queries-by-user)
 - [O365: emails bloques](#o365:-emails-bloques#)
 - [Windows: acces aux partages](#windows:-acces-aux-partages)
 - [Windows: acces aux partages à privilèges](#windows:-acces-aux-partages-a-privileges)

## Splunk Queries by user 

### 

O365: mails entrants bloqués
```
sourcetype="ms:o365:reporting:messagetrace" (action=FilteredAsSpam OR action=quarantained) RecipientAddress=$user_account$@acme.fr
| fields FromIP, Subject, SenderAddress, Country, City
| stats count(Subject) as nbmail by FromIP, Subject, SenderAddress
| sort -nbmail
| iplocation FromIP
| table nbmail, FromIP, Country, City, SenderAddress, Subject
```

Windows: accès aux partages
```
host=10.1.2.5 Account_Name=$user_account$ EventCode=4728 | table ComputerName, Group_Name, Account_Name, EventCode | rename ComputerName as "Serveur AD", Group_Name as "Groupe Administrateur modifié", Account_Name as "Administrateur responsable de la modification \r\n Compte rajouté"
```

Windows Accès aux partages à privilège: C$, ADMIN$</title>
```
host=10.1.2.5 EventCode=5145 (Share_Name="*\\C$$" OR Share_Name="*\\Admin$$") Account_Name=$user_account$ | timechart count by Account_Name
```
