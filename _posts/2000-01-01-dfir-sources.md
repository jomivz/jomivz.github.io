---
layout: post
title: dfir
category: dfir
parent: cheatsheets
modified_date: 2023-09-20
permalink: /dfir
---

<!-- vscode-markdown-toc -->
* 1. [tools](#tools)
* 2. [kb](#kb)

<!-- vscode-markdown-toc-config
	numbering=true
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

##  1. <a name='tools'></a>tools

| **Artefact** | **Tool** | **Description** |
|----------------------|------------------------|-------------------|
| 💿 Harddisk image | [sleuthkit](https://github.com/sleuthkit/sleuthkit), [doc](http://wiki.sleuthkit.org/index.php?title=TSK_Tool_Overview) | Forensics tools to investigate volume and file system data: img_stat, mmls, ils, blkls, fls, fsstat |
| 📂 NTFS METAfiles | [analyzeMFT](https://github.com/dkovar/analyzeMFT) | ADS, Anti-forensics (SNI,FN), Downloads from the internet. Process($LogFile, $UsnJrnl, AmCache) & Network Acivity ($LogFmt). |
| 📃 Logs Security KDC | [LogonTracer](https://github.com/JPCERTCC/LogonTracer) | Generates graphs of the Logons Activity. |
| 📃 Logs Security Windows | [EVTX](https://github.com/omerbenamram/evtx) | Multi-threaded EVTX parser supporting both XML and JSON EVTX. |
| File OLE | [/dfir/mlw/pdf](/dfir/mlw/ole) | |
| File PDF | [/dfir/mlw/pdf](/dfir/mlw/pdf) | |
| File LNK | [/dfir/mlw/pdf](/dfir/mlw/lnk) | |
| File PNG | [/dfir/mlw/png](/dfir/mlw/png) | |

##  2. <a name='kb'></a>kb 

| **Operating System** | **KnowledgeBase (KB)** | **Description** |
|----------------------|------------------------|-------------------|
| 🗑️ Windows              | [STRONTIC](https://strontic.github.io/xcyclopedia/) | First place to look for what is a binary about. |
| 🗑️ Windows              | [Project Windows Processes](https://winprocs.dfir.tips) | Crucial informations regarding how Windows processes work. How many instances, etc. |
| 🗑️ Windows              | [Project Windows Drivers](https://loldrivers.io) | CuratedList of LOL drivers used adversaries to bypass sec contorlsand carry out attacks. |
| 🗑️ Windows              | [Project LOLBAS](https://lolbas-project.github.io) | Windows LOLBAS offensive security techniques used for download, execute and bypass. |
| 🗑️ Windows              | [Project wadcoms](https://wadcoms.github.io) | Windows/AD offensive security techniques. |
| 🗑️ Windows              | [Project Hickjack Libs](https://hijacklibs.net) | |
| 🗑️ Windows              | [csandker.io - redteam TTPs over Windows Named Pipes](https://csandker.io/2021/01/10/Offensive-Windows-IPC-1-NamedPipes.html) | Advanced project on security informations regarding Windows Named pipes. |
| 🐧 Linux                | [Project GTFO](https://gtfobins.github.io) | Linux GTFO offensive security techniques used for download, execute and bypass. |
| 🐧 Linux                | [explainshell](https://explainshell.com/)  | explain command-lines FU. |
| 📃 Windows Security Logging | [Project Windows Events](https://evids.dfir.tips) | - |
| 📃 Windows Security Logging | [UltimateWindowsSecurity](https://www.ultimatewindowssecurity.com/securitylog/encyclopedia/) | - |
| 🗑️ Windows              | [csandker.io - redteam TTPs over Windows Named Pipes](https://csandker.io/2021/01/10/Offensive-Windows-IPC-1-NamedPipes.html) | Advanced project on security informations regarding Windows Named pipes. |

