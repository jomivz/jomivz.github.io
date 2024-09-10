---
layout: post
title: ad / bookmarks 
category: pen
parent: cheatsheets
modified_date: 2023-07-06
permalink: /awesome-ad
---

<!-- vscode-markdown-toc -->
* [azure](#azure)
* [dfir](#dfir)
* [powershell](#powershell)
* [talks](#talks)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

| **Ressource**  | **Description** |    **Author**    |
|-----------------|-----------------|------------------|
| [Attack AD: 0 to 0.9](https://zer1t0.gitlab.io/posts/attacking_ad/) | The **encyclopedia to start your journey** in AD security. My TOP 1. | Eloy Pérez González | 
| [Bloodhound Nodes](https://bloodhound.readthedocs.io/en/latest/data-analysis/nodes.html) | Must-read to understand AD attack paths. | SperterOps | 
| [Bloodhound Edges](https://bloodhound.readthedocs.io/en/latest/data-analysis/edges.html) | Must-read to understand AD attack paths. | SpecterOps | 
| [thehacker.recipes](https://www.thehacker.recipes/ad/movement/) | pages after /ad/movement/ : credentials, mitm-and-coerced-authentications, ntlm, kerberos, dacl, group-policies, trusts, netlogon, ad-cs, sccm-mecm, exchange-services, print-spooler-service, domain-settings   | @_nwodtuhs |
| [CERT-FR checklist](https://www.cert.ssi.gouv.fr/uploads/ad_checklist.html) | | ANSSI |
| [CME wiki](https://wiki.porchetta.industries/) | First thing first. Can I make it with CME? | porchetta, mpgn64 |
| [GOAD tutorial](https://mayfly277.github.io/categories/ad/) | Best to practice, prepare tooling. | mayfly277 |
| [activedirectoryrights](https://learn.microsoft.com/fr-fr/dotnet/api/system.directoryservices.activedirectoryrights?view=windowsdesktop-7.0) | List of ActiveDirectoryRights values. | Microsoft |
| [well-known SIDs](https://learn.microsoft.com/en-us/windows/win32/secauthz/well-known-sids) | List of Well-Known SIDs. | Microsoft |
| [SDDL](https://itconnect.uw.edu/tools-services-support/it-systems-infrastructure/msinf/other-help/understanding-sddl-syntax/) | Understand ACE premissions. | |
| [Attack bookmarks](https://github.com/infosecn1nja/AD-Attack-Defense) | Curated list to deepdive a particluar topic. | infosecn1nja |
| [Dog Whisperer](https://github.com/jomivz/cybrary/blob/master/purpleteam/red/windows/ERNW_DogWhispererHandbook.pdf) | How-to for Bloodhound and more. | SadProcessor |
| [Cypher Queries](https://hausec.com/2019/09/09/bloodhound-cypher-cheatsheet/)  | Hunting with BloodHound. STEP 2 after the pre-built queries. | hausec | 
| [KRB Attacks 101](https://m0chan.github.io/2019/07/31/How-To-Attack-Kerberos-101.html) | Good redacting effort. | m0chan |
| [harden](https://activedirectorypro.com/active-directory-security-best-practices/) | | |
| [harden](https://www.pwndefend.com/2022/02/26/rapid-active-directory-hardening-checklist/) | | |

## <a name='azure'></a>azure
- [O365 ATP cheatsheet](https://github.com/jomivz/cybrary/blob/master/purpleteam/red/windows/O365%20ATP%20Datasheet.pdf)

## <a name='dfir'></a>dfir 

| **Cheatsheet**  | **Description** |    **Author**    |
|-----------------|-----------------|------------------|
| [Hunting Windows PrivEsc](https://github.com/jomivz/cybrary/blob/master/purpleteam/red/windows/Hunting%20for%20Privilege%20Escalation%20in%20Windows%20Environment..pdf) | Awesome presentation covering how to hunt the named pipes and much more. | Kaspersky |
| [Windows Logon workflow](https://github.com/jomivz/cybrary/blob/master/purpleteam/red/windows/windows_account_logon_flow_v0.1.pdf) | Awesome schema sequencing the security event IDs for windows logon. | Andrei Miroshnikov |


## <a name='powershell'></a>powershell

| **Ressource**  | **Description** |    **Author**    |
|-----------------|-----------------|------------------|
| [AD Discovery](https://github.com/jomivz/cybrary/blob/master/purpleteam/red/windows/Active%20Directory%20Enumeration%20With%20PowerShell.pdf) | - | Haboob Team |
| [AD Exploitation](https://github.com/S1ckB0y1337/Active-Directory-Exploitation-Cheat-Sheet) | Contains the **CLI of the most well-known tools** for common enumeration and attack methods: Local PrivEsc, Lateral Movement, Domain PrivEsc, Domain Persistence, Cross Forests Attacks | S1ckB0y1337 |
| [PS cheatsheet 1](https://casvancooten.com/posts/2020/11/windows-active-directory-exploitation-cheat-sheet-and-command-reference/) | The best CRTP + CRTO cheatsheet for lab certifications made by pentesteracademy. | casvancooten |
| [PS cheatsheet 2](https://github.com/HarmJ0y/CheatSheets/) | PowerView, PowerUp, PowerSploit, and Empire cheatsheets. | HarmJ0y |
| [PS toolbox 1](https://github.com/specterops/at-ps) | Tools used for the offensive powershell training provided by specterops. | specterops.io |
| [PS toolbox 2](https://www.varonis.com/blog/powershell-tool-roundup/) | Collection of tools. | varonis |
| [PS snippet gallery](https://www.powershellgallery.com/packages/EventList/2.0.0) | Snipets. | powershellgallery |
| [PS old stuffs](https://ethicalhackersacademy.com/blogs/ethical-hackers-academy/active-directory) | - | ethicalhackersacademy |

## <a name='talks'></a>talks

| **Year**  | **Ressource** | **Author**  | **Description** |    
|-----------|---------------|-------------|-----------------|
| 2017 (blackhat)  | [An ACE Up The Sleeve](https://bloodhound.readthedocs.io/en/latest/data-analysis/edges.https://www.blackhat.com/docs/us-17/wednesday/us-17-Robbins-An-ACE-Up-The-Sleeve-Designing-Active-Directory-DACL-Backdoors.pdf) | Andy Robbins & Will Shroeder | Abusing ACLs... | 
| 2019 (defcon 27) | [Kerberos Ticketing & Delegations](https://github.com/jomivz/cybrary/blob/master/purpleteam/red/windows/Constructing%20Kerberos%20Attacks%20with%20Delegation%20Primitives.pdf) | Elad Shamir, Matt Bush | Workshop using rollercoaster metaphor for explaining KRB ticket and abuse.|


