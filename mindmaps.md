---
layout: page
title: Cyber Wow Mindmaps
permalink: /mindmaps/
nav_order: 3
modified_date: 2023-06-05
---

## <a name='wowmindmapcybersysadmin'></a> #wow 👀 #mindmap 🧠 #cyber 🔫 #sysadmin 🛠️

** MENU **

<!-- vscode-markdown-toc -->
* [methodoly](#methodoly)
* [tools](#tools)
* [sources](#sources)
* [_OLD_STUFFS_ 🥱](#OLD_STUFFS_)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

### <a name='methodoly'></a>methodoly

Here are the URL shortcuts you can type in your browser prefixed by ```https://www.jmvwork.xyz```:

* [/pen/goad2.svg](/pen/goad2.svg) / the original mindmap made by [mayfly277](mayfly277.github.io).
* [/pen/goad2.pdf](/pen/goad2.pdf) / a printabe version of the orginal v2 / 21 pages (A3 format).

```sh
# -w -h : inspect the svg with a web browser to export with a readable size 
# -b : keep the black background
inkscape -w 9900 -h 6224 -b "#000000" goad2.svg -o ad.goad2.png

# invert the colors to save black ink
convert goad2.png -channel RGB -negate goad2negat.png

# split the final PNG to 21 pages (A3 format)  
posterazor goad2negat.png
```
![/assets/images/goad2-svg-2-pdf-1.png]
![/assets/images/goad2-svg-2-pdf-2.png]
![/assets/images/goad2-svg-2-pdf-3.png]
![/assets/images/goad2-svg-2-pdf-4.png]
![/assets/images/goad2-svg-2-pdf-5.png]


* [/pen/cloud](/pen/cloud)
* [/pen/web](/pen/web)

### <a name='tools'></a>tools 

Here are the URL shortcuts you can type in your browser prefixed by ```https://www.jmvwork.xyz```:

* [/tool/burp.png](/tool/cme.png)
* [/tool/burp-extensions.png](/tool/cme.png)
* [/tool/cme.png](/tool/cme.png)
* [/tool/gobuster.png](/tool/gobuster.png)
* [/tool/hashcat.png](/tool/hashcat.png)
* [/tool/hydra.png](/tool/hydra.png)
* [/tool/mimikatz.png](/tool/mimikatz.png)
* [/tool/msf.png](/tool/msf.png)
* [/tool/nmap.png](/tool/nmap.png)
* [/tool/shodan.png](/tool/shodan.png)
* [/tool/sqlmap.png](/tool/sqlmap.png)
* [/tool/tcpdump.png](/tool/tcpdump.png)
* [/tool/wireshark.pdf](/tool//wireshark.pdf)

### <a name='sources'></a>sources

* [Ignitetechnologies](https://github.com/Ignitetechnologies/Mindmap)
* [Pentest AD by OCD](https://orange-cyberdefense.github.io/ocd-mindmaps/)
* [DFIR mindmaps](https://github.com/AndrewRathbun/DFIRMindMaps)
* [DFIR nasbench](https://github.com/nasbench/MindMaps)
* [Malfrat's OSINT map](https://map.malfrats.industries/)
* [Pentest Network](https://github.com/c4s73r/NetworkNightmare)
* [ByPass AV/EDR](https://github.com/CMEPW/BypassAV)
* [Sysadmin Windows Server 2012](https://xmind.app/m/eZ7i/)
* [Windows Event Logs](https://github.com/mdecrevoisier/Microsoft-eventlog-mindmap) 📃

### <a name='OLD_STUFFS_'></a>_OLD_STUFFS_ 🥱

* [Forensics for NTFS](/mindmaps/svg/win-for-ntfs.svg)
* [Forensics for Windows](/mindmaps/svg/win-for-invest-roadmap.svg)