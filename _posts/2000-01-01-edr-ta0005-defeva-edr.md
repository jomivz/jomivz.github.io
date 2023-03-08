---
layout: post
title: TA0005 Defense Evasion - EDR
parent: EDR
category: EDR
grand_parent: Cheatsheets
modified_date: 2023-02-14
permalink: /:categories/:title/
---

<!-- vscode-markdown-toc -->
* [EDR Enumeration](#EDREnumeration)
* [EDR Evasion tools](#EDREvasiontools)
* [EDR Bypass articles](#EDRBypassarticles)
* [End of Life Support](#EndofLifeSupport)
* [MindMaps](#MindMaps)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='EDREnumeration'></a>EDR Enumeration

```powershell
# windows defender 
# windows defender: check if Defender is enabled
Get-MpComputerStatus
Get-MpComputerStatus | Select AntivirusEnabled
# windows defender: check if defensive modules are enabled
Get-MpComputerStatus | Select RealTimeProtectionEnabled, IoavProtectionEnabled,AntispywareEnabled | FL
# windows defender: check if tamper protection is enabled
Get-MpComputerStatus | Select IsTamperProtected,RealTimeProtectionEnabled | FL

# windows palo xdr 
dir HKLM:\SYSTEM\CurrentControlSet\Services\CryptSvc

```

## <a name='EDREvasiontools'></a>EDR Evasion tools 

<script src="https://code.jquery.com/jquery-1.9.1.min.js"></script>
<script>$(window).load(function() {var repos = ["https://api.github.com/repos/wavestone-cdt/EDRSandblast", "https://api.github.com/repos/MrEmpy/Awesome-AV-EDR-XDR-Bypass","https://api.github.com/repos/jthuraisamy/TelemetrySourcerer","https://api.github.com/repos/KiFilterFiberContext/warbird-hook","https://api.github.com/repos/hlldz/RefleXXion","https://api.github.com/repos/optiv/ScareCrow","https://api.github.com/repos/PwnDexter/SharpEDRChecker","https://api.github.com/repos/optiv/Freeze"]; for (rep in repos) {$.ajax({type: "GET", url: repos[rep], dataType: "json", success: function(result) {$("#repo_list").append("<tr><td><a href='" + result.html_url + "' target='_blank'>" + result.name + "</a></td><td>" + result.updated_at + "</td><td>" + result.stargazers_count + "</td><td>" + result.subscribers_count + "</td><td>" + result.language + "</td></tr>"); console.log(result);}});}console.log(result);});</script>

<link href="/sortable.css" rel="stylesheet" />
<script src="/sortable.js"></script>
<div id="repos">
    <table id="repo_list" class="sortable">
      <tr><th>repo</th><th>last update</th><th>stars</th><th>watch</th><th>language</th></tr>
    </table>
</div>    


## <a name='EDRBypassarticles'></a>EDR Bypass articles

| **Date** | **EDR** | **Version** | **Bypass** | **Author** |
| 2023-02 | Palo Alto XDR | - | [auditconf](https://github.com/Laokoon-SecurITy/Cortex-XDR-Config-Extractor) |
| 2022-09 | Palo Alto XDR | 7.8.0 | [regnreboot](https://medium.com/@bentamam/bypassing-cortex-xdr-a-case-study-in-the-power-of-simplicity-b436f4f570ad) | @bentamam |
| 2021-10 | Windows Defender | x | [viperone](https://viperone.gitbook.io/pentest-everything/everything/everything-active-directory/defense-evasion/disable-defender) |
| 2021-07 | Palo Alto XDR | 7.4.0 | [privescndisable](https://mrd0x.com/cortex-xdr-analysis-and-bypass/) | @mrdox |
| 2020-11 | Phantom | - | [xxx](https://www.tarlogic.com/blog/threat-hunting-evasion-restricted-environment/)


## <a name='EndofLifeSupport'></a>End of Life Support

* [carbon black](https://community.carbonblack.com/t5/Documentation-Downloads/Carbon-Black-EDR-Supported-Versions-Grid/ta-p/85714)
* [palo alto XDR](https://www.paloaltonetworks.com/services/support/end-of-life-announcements/end-of-life-summary#traps-esm-and-cortex)

## <a name='MindMaps'></a>MindMaps 

* 📕🗑️ [ByPass AV/EDR](https://github.com/CMEPW/BypassAV)
