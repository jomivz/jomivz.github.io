---
layout: post
title: TA0005 Defense Evasion - EDR
parent: EDR
category: EDR
grand_parent: Cheatsheets
modified_date: 2023-06-02
permalink: /edr/defeva
---

<!-- vscode-markdown-toc -->
* [enum](#enum)
	* [win-defender](#win-defender)
	* [lin-xdr-get](#lin-xdr-get)
		* [lin-xdr-get-version](#lin-xdr-get-version)
		* [lin-xdr-get-processes](#lin-xdr-get-processes)
* [tools](#tools)
* [sources](#sources)
* [eol](#eol)
* [mindmaps](#mindmaps)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='enum'></a>enum

### <a name='win-defender'></a>win-defender

```powershell
# defender 
# defender: check if Defender is enabled
Get-MpComputerStatus
Get-MpComputerStatus | Select AntivirusEnabled
# defender: check if defensive modules are enabled
Get-MpComputerStatus | Select RealTimeProtectionEnabled, IoavProtectionEnabled,AntispywareEnabled | FL
# defender: check if tamper protection is enabled
Get-MpComputerStatus | Select IsTamperProtected,RealTimeProtectionEnabled | FL

# palo xdr 
dir HKLM:\SYSTEM\CurrentControlSet\Services\CryptSvc
```

### <a name='lin-xdr-get'></a>lin-xdr-get

#### <a name='lin-xdr-get-version'></a>lin-xdr-get-version
* palo xdr version:
```bash
cat /opt/trap/version.txt
```

#### <a name='lin-xdr-get-processes'></a>lin-xdr-get-processes
* palo xdr processes:
```bash
ps -aux | grep cortex
```
![ps aux](/assets/images/xdr-psaux.png)

* Enumerate linux version of Palo Cortex XDR:
```bash
cat /opt/trap/version.txt
```
* [XDR v7. processes](/edr/defeva/lin-xdr-v7)
* [XDR v7.9.1 processes](/edr/defeva/lin-xdr-v791)


## <a name='tools'></a>tools 

<script src="https://code.jquery.com/jquery-1.9.1.min.js"></script>
<script>$(window).load(function() {var repos = ["https://api.github.com/repos/wavestone-cdt/EDRSandblast", "https://api.github.com/repos/MrEmpy/Awesome-AV-EDR-XDR-Bypass","https://api.github.com/repos/jthuraisamy/TelemetrySourcerer","https://api.github.com/repos/KiFilterFiberContext/warbird-hook","https://api.github.com/repos/hlldz/RefleXXion","https://api.github.com/repos/optiv/ScareCrow","https://api.github.com/repos/PwnDexter/SharpEDRChecker","https://api.github.com/repos/optiv/Freeze"]; for (rep in repos) {$.ajax({type: "GET", url: repos[rep], dataType: "json", success: function(result) {$("#repo_list").append("<tr><td><a href='" + result.html_url + "' target='_blank'>" + result.name + "</a></td><td>" + result.updated_at + "</td><td>" + result.stargazers_count + "</td><td>" + result.subscribers_count + "</td><td>" + result.language + "</td></tr>"); console.log(result);}});}console.log(result);});</script>

<link href="/sortable.css" rel="stylesheet" />
<script src="/sortable.js"></script>
<div id="repos">
    <table id="repo_list" class="sortable">
      <tr><th>repo</th><th>last update</th><th>stars</th><th>watch</th><th>language</th></tr>
    </table>
</div>    


## <a name='sources'></a>sources

| **Date** | **EDR** | **Version** | **Bypass** | **Author** |
| 2023-02 | Palo Alto XDR | - | [auditconf](https://github.com/Laokoon-SecurITy/Cortex-XDR-Config-Extractor) | |
| 2022-09 | Palo Alto XDR | 7.8.0 | [regnreboot](https://medium.com/@bentamam/bypassing-cortex-xdr-a-case-study-in-the-power-of-simplicity-b436f4f570ad) | @bentamam |
| 2021-10 | Windows Defender | x | [viperone](https://viperone.gitbook.io/pentest-everything/everything/everything-active-directory/defense-evasion/disable-defender) | |
| 2021-07 | Palo Alto XDR | 7.4.0 | [privescndisable](https://mrd0x.com/cortex-xdr-analysis-and-bypass/) | @mrdox |
| 2020-11 | Phantom | - | [xxx](https://www.tarlogic.com/blog/threat-hunting-evasion-restricted-environment/) | |


## <a name='eol'></a>eol

* [carbon black](https://community.carbonblack.com/t5/Documentation-Downloads/Carbon-Black-EDR-Supported-Versions-Grid/ta-p/85714)
* [palo alto XDR](https://www.paloaltonetworks.com/services/support/end-of-life-announcements/end-of-life-summary#traps-esm-and-cortex)

## <a name='mindmaps'></a>mindmaps

* 📕🗑️ [ByPass AV/EDR](https://github.com/CMEPW/BypassAV)
