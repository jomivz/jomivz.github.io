---
layout: post
title: Awesome AD Security
category: Sysadmin
parent: Sysadmin
grand_parent: Cheatsheets  
modified_date: 2022-08-12
permalink: /:categories/:title/
---

<!-- vscode-markdown-toc -->
* [Starting your journey](#Startingyourjourney)
* [Offensive AD Cookbooks](#OffensiveADCookbooks)
* [Offensive Powershell](#OffensivePowershell)
* [DFIR](#DFIR)
* [ATP / O365](#ATPO365)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='Startingyourjourney'></a>Starting your journey
--------------------------------

| **Ressource**  | **Description** |    **Author**    |
|-----------------|-----------------|------------------|
| [Attacking AD: 0 to 0.9](https://zer1t0.gitlab.io/posts/attacking_ad/) | The **encyclopedia to start your journey** in AD security. Good pedagogy illustrated with powershell commands. | Eloy Pérez González | 
| [Bloodhound Nodes](https://bloodhound.readthedocs.io/en/latest/data-analysis/nodes.html) | Must-read to understand AD attack paths. | SperterOps | 
| [Bloodhound Edges](https://bloodhound.readthedocs.io/en/latest/data-analysis/edges.html) | Must-read to understand AD attack paths. | SpecterOps | 
| [Kerberos Ticketing & Delegations](https://github.com/jomivz/cybrary/blob/master/purpleteam/red/windows/Constructing%20Kerberos%20Attacks%20with%20Delegation%20Primitives.pdf) | Workshop at Defcon 27 using rollercoaster metaphor for pedagogy. Just awesome. | Elad Shamir, Matt Bush |

## <a name='OffensiveADCookbooks'></a>Offensive AD Cookbooks
--------------------------------

| **Ressource**  | **Description** |    **Author**    |
|-----------------|-----------------|------------------|
| [The Dog Whisperer Handbook](https://github.com/jomivz/cybrary/blob/master/purpleteam/red/windows/ERNW_DogWhispererHandbook.pdf) | How-to for Bloodhound and more. My TOP 1. | SadProcessor |
| [Mindmap Attacking AD](https://github.com/six2dez/pentest-book/blob/master/.gitbook/assets/pentest_ad-min.png) | Master Piece Mindmap. My TOP 2. | six2dez |
| [Bloodhound Cypher Cheatsheet](https://hausec.com/2019/09/09/bloodhound-cypher-cheatsheet/) | Cypher queries for Bloodhound Neo4j DB | hausec |
| [AD Kill Chain Attack & Defense](https://github.com/infosecn1nja/AD-Attack-Defense) | Well **classified compilation of articles** from the technet, adsecurity, stealthbits, specterops, youtube, github and other sources. Great room to deepdive a particluar topic. | infosecn1nja |
| [Attacking Kerberos 101](https://m0chan.github.io/2019/07/31/How-To-Attack-Kerberos-101.html) | Good redacting effort. | m0chan |


## <a name='OffensivePowershell'></a>Offensive Powershell
------------------------------

| **Cheatsheet**  | **Description** |    **Author**    |
|-----------------|-----------------|------------------|
| [Quickstart Cheatsheet](https://ethicalhackersacademy.com/blogs/ethical-hackers-academy/active-directory) | - | - |
| [Complete AD Powershell Enum](https://github.com/jomivz/cybrary/blob/master/purpleteam/red/windows/Active%20Directory%20Enumeration%20With%20PowerShell.pdf) | - | Haboob Team 
| [AD Exploitation Cheat Sheet](https://github.com/S1ckB0y1337/Active-Directory-Exploitation-Cheat-Sheet) | Contains the **CLI of the most well-known tools** for common enumeration and attack methods: Local PrivEsc, Lateral Movement, Domain PrivEsc, Domain Persistence, Cross Forests Attacks | S1ckB0y1337 |
| [CRTP CTRO Cheatsheets](https://casvancooten.com/posts/2020/11/windows-active-directory-exploitation-cheat-sheet-and-command-reference/) | The best CRTP + CRTO cheatsheet for lab certifications made by pentesteracademy. | casvancooten |
| [Harmj0y CheatSheet](https://github.com/HarmJ0y/CheatSheets/) | PowerView, PowerUp, PowerSploit, and Empire cheatsheets. | HarmJ0y |
| [Specterops PS tools](https://github.com/specterops/at-ps) | Tools used for the offensive powershell training provided by specterops. | specterops.io |
| [Powershell Tools List](https://www.varonis.com/blog/powershell-tool-roundup/) | Collection of tools. | varonis |
| [Powershell Snipets Gallery](https://www.powershellgallery.com/packages/EventList/2.0.0) | Snipets. | powershellgallery |

## <a name='DFIR'></a>DFIR 
------------------------------

| **Cheatsheet**  | **Description** |    **Author**    |
|-----------------|-----------------|------------------|
| [Hunting Windows PrivEsc](https://github.com/jomivz/cybrary/blob/master/purpleteam/red/windows/Hunting%20for%20Privilege%20Escalation%20in%20Windows%20Environment..pdf) | Awesome presentation covering how to hunt the named pipes and much more. | Kaspersky |
| [Windows Logon workflow](https://github.com/jomivz/cybrary/blob/master/purpleteam/red/windows/windows_account_logon_flow_v0.1.pdf) | Awesome schema sequencing the security event IDs for windows logon. | Andrei Miroshnikov |

## <a name='ATPO365'></a>ATP / O365
------------------------------

- [O365 ATP cheatsheet](https://github.com/jomivz/cybrary/blob/master/purpleteam/red/windows/O365%20ATP%20Datasheet.pdf)