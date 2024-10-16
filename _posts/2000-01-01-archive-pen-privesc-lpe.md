---
layout: post
title: pen / lpe
category: pen
parent: cheatsheets
modified_date: 2023-07-03
permalink: /pen/lpe
---

**Mitre Att&ck Entreprise**: 
* [TA0004 - Privilege Escalation](https://attack.mitre.org/tactics/TA0004/)
* [T1068  - Exploitation for Privilege Escalation ](https://attack.mitre.org/techniques/T1068/)

<!-- vscode-markdown-toc -->
* 1. [tools](#tools)
* 2. [cve](#cve)

<!-- vscode-markdown-toc-config
	numbering=true
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

##  1. <a name='tools'></a>tools
 
 * [PrivescCheck](https://raw.githubusercontent.com/itm4n/PrivescCheck/master/PrivescCheck.ps1)

##  2. <a name='cve'></a>cve

<table class="sortable">
<col width="20%">
<col width="80%">
<thead>
<tr>
<th>Reference</th>
<th>OS</th>
<th>Service</th>
<th>PoC</th>
</tr>
</thead>
<tbody>
<tr>
	<td>CVE-2023-21768</td> 
	<td>Windows</td>
	<td>11 22H2</td>
	<td><ul>
	<li>CODENAME: LPE_AFD</li>
	POC: <a href="https://github.com/chompie1337/Windows_LPE_AFD_CVE-2023-21768"></a>
	<li>TEST: <a href=""></a></li>
	</ul></td>
</tr>
<tr>
	<td>CVE-2022-21882</td> 
	<td>Windows</td>
	<td>10 21H2 19044.1415</td>
	<td><ul>
	<li>CODENAME: win32k.sys</li>
	<li>POC: <a href="https://github.com/gdabah/win32k-bugs"></a></li>
	<li>TEST: <a href=""></a></li>
	</ul></td>
</tr>
<tr>
	<td>CVE-2021-1675</td> 
	<td>Windows</td>
	<td>PrintSpooler</td>
	<td><ul>
	<li>CODENAME: PrintNightMare</li>
	<li>POC: <a href="https://github.com/calebstewart/CVE-2021-1675"></a></li>
	<li>TEST: <a href="https://tryhackme.com/room/atlas"></a></li>
	</ul></td>
</tr>
<tr>
	<td>CVE-2021-22204</td>
	<td>LPE</td>
	<td>Linux</td>
	<td>Exiftool</td>
</tr>
<tr>
	<td>CVE-2021-3560</td>
	<td>Linux</td>
	<td>polkit</td>
	<td></td>
</tr>
<tr>
	<td>CVE-2021-3156</td>
	<td>Linux</td>
	<td>sudo</td>
	<td>CODENAME: Baron Samedit</td>
</tr>
<tr>
	<td>CVE-2020-0601</td>
	<td>Windows</td>
	<td>CryptoAPI</td>
	<td>CODENAME: CurveBall</td>
</tr>
<tr>
	<td>CVE-2020-16898</td>
	<td></td>
	<td>Windows</td>
	<td>cODENAME: Bad Neighor</td>
</tr>
<tr>
	<td>CVE-2020-11651</td>
	<td>SaltStack</td>
	<td></td>
    <td></td>
</tr>
<tr>
	<td>CVE-2020-1350</td>
	<td>Windows</td>
	<td>DNS</td>
	<td>CODENAME: SIGRed</td>
</tr>

</tbody>

</table>
<link href="/sortable.css" rel="stylesheet" />
<script src="/sortable.js"></script>

