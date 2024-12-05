---
layout: post
title: dfir / bookmarks
category: 30-csirt
parent: cheatsheets
modified_date: 2023-09-20
permalink: /dfir
---

<!-- vscode-markdown-toc -->
* 1. [tools](#tools)
* 1.1 [collect](#collect)
* 1.2 [triage](#triage)
* 2. [kb](#kb)

<!-- vscode-markdown-toc-config
	numbering=true
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

##  1. <a name='tools'></a>tools

###  1.1 <a name='collect'></a>collect

| **Evidence** | **Tool** |
|----------------------|------------------------|
| 💿 Harddisk image | [guymanager](https://sourceforge.net/projects/guymager/), [dc3dd](https://www.kali.org/tools/dc3dd/) |
| 🖥️ Live Windows | [dfir-orc](https://github.com/dfir-orc), [doc](https://dfir-orc.github.io/) | 
| 🖥️ Live Windows | [KAPE](https://www.kroll.com/en/services/cyber-risk/incident-response-litigation-support/kroll-artifact-parser-extractor-kape) |
| 🖥️ Live Windows | [fastir](https://github.com/OWNsecurity/fastir_artifacts) |

###  1.2 <a name='triage'></a>triage

| **Evidence** | **Tool** | **Description** |
|----------------------|------------------------|-------------------|
| 💿 Harddisk image | [sleuthkit](https://github.com/sleuthkit/sleuthkit), [doc](http://wiki.sleuthkit.org/index.php?title=TSK_Tool_Overview) | Forensics tools to investigate volume and file system data: img_stat, mmls, ils, blkls, fls, fsstat |
| 📂 NTFS METAfiles | [analyzeMFT](https://github.com/dkovar/analyzeMFT), [MFTExplorer](https://ericzimmerman.github.io/#!index.md) | ADS, Anti-forensics (SNI,FN), Downloads from the internet. Process($LogFile, $UsnJrnl, AmCache) & Network Acivity ($LogFmt). |
| 📃 Logs Security KDC | [LogonTracer](https://github.com/JPCERTCC/LogonTracer) | Generates graphs of the Logons Activity. |
| 📃 Logs Security Windows | [evtx_dump, fd](https://github.com/omerbenamram/evtx), [timeline explorer](https://www.sans.org/tools/timeline-explorer/) | Multi-threaded EVTX parser supporting both XML and JSON EVTX. |
| 🖥️ Live Windows | cmd, powershell | PSsession, WinRegistry, ADQuery, Transfer with [Powershell](/sys/powershell), [Logs](/sys/lin/logs). |
| 🖥️ Live Linux | [bash](/sys/lin), [bash2](/sys/lin/bash), [logs](/sys/lin/logs) | bash and logs manipulation. |
| 🌐 Web browsing | [hindsight](https://github.com/obsidianforensics/hindsight) | chromium, firefox, safari. |
| 👾 File OLE | [/dfir/mlw/ole](/dfir/mlw/ole) | editing in progress... |
| 👾 File PDF | [/dfir/mlw/pdf](/dfir/mlw/pdf) | Cheatsheet for [dist67/malicious PDF workshop](https://www.youtube.com/watch?v=F3rpZT0gKXw&list=PLa-ohdLO29_Y2FeT24w-c9nA_AH84MIpp) with ['pdfid.py' and 'pdf-parser.py'](https://blog.didierstevens.com/programs/pdf-tools/) tools. |
| 👾 File LNK | [/dfir/mlw/lnk](/dfir/mlw/lnk) | editing in progress... |
| 👾 File PNG | [/dfir/mlw/png](/dfir/mlw/png) | editing in progress... |
| 👾 ADS Motw | [PS live: Get-Item, Get-Content -Stream](https://outflank.nl/blog/2020/03/30/mark-of-the-web-from-a-red-teams-perspective/) | Covers also, bypass with softwares unsupporting-ADS (7Z,CSPROJ) & container files (ISO,VHD). |

##  2. <a name='kb'></a>kb 

| **Operating System** | **KnowledgeBase (KB)** | **Description** |
|----------------------|------------------------|-------------------|
|📃 Windows | [Project Windows Events](https://evids.dfir.tips) | ARTIFACT: Exhaustive artifacts list tagged with categories: File Download, Program Execution, Deleted File or File Knowledge, Network Activity, Physical Location File/Folder, Opening Account, Usage External Device/USB, Usage Browser Usage. |
|📃 Windows | [UltimateWindowsSecurity](https://www.ultimatewindowssecurity.com/securitylog/encyclopedia/) | LOGS: Encyclopedia for the Windows Security Logs. |
|🗑️ Windows | [STRONTIC](https://strontic.github.io/xcyclopedia/) | EXE: First place to look for what is a binary about. |
|🗑️ Windows | [Project Windows Drivers](https://loldrivers.io) | SYS: CuratedList of LOL drivers used adversaries to bypass sec contorlsand carry out attacks. |
|🗑️ Windows | [Project LOLBAS](https://lolbas-project.github.io) | LOLBAS: Windows LOLBAS offensive security techniques used for download, execute and bypass. |
|🗑️ Windows | [Project wadcoms](https://wadcoms.github.io) | AD: Windows/AD offensive security techniques. |
|🗑️ Windows | [Project Hickjack Libs](https://hijacklibs.net) | LIB: ... |
|🗑️ Windows | [csandker.io - redteam TTPs over Windows Named Pipes](https://csandker.io/2021/01/10/Offensive-Windows-IPC-1-NamedPipes.html) | PIPES: Advanced project on security informations regarding Windows Named pipes. |
|🐧 Linux                | [Project GTFO](https://gtfobins.github.io) | GTFO: Linux GTFO offensive security techniques used for download, execute and bypass. |
|🐧 Linux                | [explainshell](https://explainshell.com/)  | SHELL: explain command-lines FU. |

