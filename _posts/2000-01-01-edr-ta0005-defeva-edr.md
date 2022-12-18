---
layout: post
title: TA0005 Defense Evasion - EDR
parent: EDR
category: EDR
grand_parent: Cheatsheets
modified_date: 2022-12-16
permalink: /:categories/:title/
---

<!-- vscode-markdown-toc -->
* [EDR Evasion tools](#EDREvasiontools)
* [EDR Bypass articles](#EDRBypassarticles)
* [EoL: End of Life](#EoL:EndofLife)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='EDREvasiontools'></a>EDR Evasion tools 

<script src="https://code.jquery.com/jquery-1.9.1.min.js"></script>
<script>$(window).load(function() {var repos = ["https://api.github.com/repos/wavestone-cdt/EDRSandblast", "https://api.github.com/repos/MrEmpy/Awesome-AV-EDR-XDR-Bypass","https://api.github.com/repos/jthuraisamy/TelemetrySourcerer","https://api.github.com/repos/KiFilterFiberContext/warbird-hook","https://api.github.com/repos/hlldz/RefleXXion","https://api.github.com/repos/optiv/ScareCrow","https://api.github.com/repos/PwnDexter/SharpEDRChecker"]; for (rep in repos) {$.ajax({type: "GET", url: repos[rep], dataType: "json", success: function(result) {$("#repo_list").append("<tr><td><a href='" + result.html_url + "' target='_blank'>" + result.name + "</a></td><td>" + result.updated_at + "</td><td>" + result.stargazers_count + "</td><td>" + result.subscribers_count + "</td><td>" + result.language + "</td></tr>"); console.log(result);}});}console.log(result);});</script>

<link href="/sortable.css" rel="stylesheet" />
<script src="/sortable.js"></script>
<div id="repos">
    <table id="repo_list" class="sortable">
      <tr><th>repo</th><th>last update</th><th>stars</th><th>watch</th><th>language</th></tr>
    </table>
</div>    


## <a name='EDRBypassarticles'></a>EDR Bypass articles

| **Date** | **EDR** | **Version** | **Bypass** | **Author** |
| 2021-07 | Palo Alto XDR | 7.4.0 | [privescndisable](https://mrd0x.com/cortex-xdr-analysis-and-bypass/) | @mrdox |
| 2022-09 | Palo Alto XDR | 7.8.0 | [regnreboot](https://medium.com/@bentamam/bypassing-cortex-xdr-a-case-study-in-the-power-of-simplicity-b436f4f570ad) | @bentamam |


## <a name='EoL:EndofLife'></a>End of Life Support

* [carbon black](https://community.carbonblack.com/t5/Documentation-Downloads/Carbon-Black-EDR-Supported-Versions-Grid/ta-p/85714)
* [palo alto XDR](https://www.paloaltonetworks.com/services/support/end-of-life-announcements/end-of-life-summary#traps-esm-and-cortex)