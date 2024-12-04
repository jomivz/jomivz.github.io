---
layout: post
title: evasion / edr
category: evasion
parent: cheatsheets
modified_date: 2023-07-19
permalink: /evasion/edr
---

**MENU**
<!-- vscode-markdown-toc -->
* [articles](#articles)
* [eol](#eol)
* [tools](#tools)
	* [all-in-one](#all-in-one)
	* [dropper](#dropper)
	* [manual-loader](#manual-loader)
	* [automatic-loader](#automatic-loader)
	* [generate-shellcode](#generate-shellcode)
	* [manual-obfuscation](#manual-obfuscation)
	* [automatic-obfuscation](#automatic-obfuscation)
	* [process-injection](#process-injection)
	* [detect-vm](#detect-vm)
	* [from-pe-to-shellcode](#from-pe-to-shellcode)
	* [from-alive-beacon](#from-alive-beacon)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

**MUST-WATCH**

🔥 [GEMINI YT Channel](https://www.youtube.com/playlist?list=PL0UJtYdHHM44uqGlDN-DQUYzoOj5Mp3ZF) 🔥

🔥 [CMEPW BypassAV mindmap](/assets/images/pen-edr-evasion-mindmap-cmepw.png) 🔥

<script src="https://code.jquery.com/jquery-1.9.1.min.js"></script>
<script>$(window).load(function() {var mm = ["https://api.github.com/repos/CMEPW/BypassAV"]; for (rep in mm) {$.ajax({type: "GET", url: mm[rep], dataType: "json", success: function(result) {$("#mm_list").append("<tr><td><a href='" + result.html_url + "' target='_blank'>" + result.name + "</a></td><td>" + result.pushed_at + "</td><td>" + result.stargazers_count + "</td><td>" + result.subscribers_count + "</td><td>" + result.language + "</td></tr>"); console.log(result);}});}console.log(result);});</script>

<link href="/sortable.css" rel="stylesheet" />
<script src="/sortable.js"></script>
<div id="mm">
    <table id="mm_list" class="sortable">
      <tr><th>_repo</th><th>_last_pushed</th><th>_stars</th><th>_watch</th><th>_language</th></tr>
    </table>
</div>

## <a name='articles'></a>articles

| **Date** | **EDR** | **Version** | **Bypass** | **Author** |
| 2023-02 | Palo Alto XDR | - | [auditconf](https://github.com/Laokoon-SecurITy/Cortex-XDR-Config-Extractor) | |
| 2022-09 | Palo Alto XDR | 7.8.0 | [regnreboot](https://medium.com/@bentamam/bypassing-cortex-xdr-a-case-study-in-the-power-of-simplicity-b436f4f570ad) | @bentamam |
| 2022-03 | ALL | ALL | [reflectiveDump](https://s3cur3th1ssh1t.github.io/Reflective-Dump-Tools/) | s3cur3th1ssh1t |
| 2021-10 | Windows Defender | x | [viperone](https://viperone.gitbook.io/pentest-everything/everything/everything-active-directory/defense-evasion/disable-defender) | |
| 2021-07 | Palo Alto XDR | 7.4.0 | [privescndisable](https://mrd0x.com/cortex-xdr-analysis-and-bypass/) | @mrdox |
| 2021-02 | ALL | ALL | [scarecrow part 1](https://www.optiv.com/insights/source-zero/blog/endpoint-detection-and-response-how-hackers-have-evolved) | Optiv |
| 2021-02 | ALL | ALL | [scarecrow part 2](https://www.optiv.com/insights/source-zero/blog/edr-and-blending-how-attackers-avoid-getting-caught) | Optiv |
| 2020-11 | Phantom | - | [xxx](https://www.tarlogic.com/blog/threat-hunting-evasion-restricted-environment/) | |

## <a name='eol'></a>eol

* [carbon black](https://community.carbonblack.com/t5/Documentation-Downloads/Carbon-Black-EDR-Supported-Versions-Grid/ta-p/85714)
* [palo alto XDR](https://www.paloaltonetworks.com/services/support/end-of-life-announcements/end-of-life-summary#traps-esm-and-cortex)


## <a name='tools'></a>tools

### <a name='all-in-one'></a>all-in-one

<script src="https://code.jquery.com/jquery-1.9.1.min.js"></script>
<script>$(window).load(function() {var repos = ["https://api.github.com/repos/ph4nt0mbyt3/Darkside","https://api.github.com/repos/ZeroMemoryEx/Terminator","https://api.github.com/repos/wavestone-cdt/EDRSandblast", "https://api.github.com/repos/MrEmpy/Awesome-AV-EDR-XDR-Bypass","https://api.github.com/repos/TheD1rkMtr/FilelessPELoader","https://api.github.com/repos/jthuraisamy/TelemetrySourcerer","https://api.github.com/repos/KiFilterFiberContext/warbird-hook","https://api.github.com/repos/hlldz/RefleXXion","https://api.github.com/repos/optiv/ScareCrow","https://api.github.com/repos/PwnDexter/SharpEDRChecker","https://api.github.com/repos/secretsquirrel/SigThief","https://api.github.com/repos/optiv/Freeze"]; for (rep in repos) {$.ajax({type: "GET", url: repos[rep], dataType: "json", success: function(result) {$("#repo_list").append("<tr><td><a href='" + result.html_url + "' target='_blank'>" + result.name + "</a></td><td>" + result.pushed_at + "</td><td>" + result.stargazers_count + "</td><td>" + result.subscribers_count + "</td><td>" + result.language + "</td></tr>"); console.log(result);}});}console.log(result);});</script>

<link href="/sortable.css" rel="stylesheet" />
<script src="/sortable.js"></script>
<div id="repos">
    <table id="repo_list" class="sortable">
      <tr><th>_repo</th><th>_last_pushed</th><th>_stars</th><th>_watch</th><th>_language</th></tr>
    </table>
</div>    

### <a name='dropper'></a>dropper

<script src="https://code.jquery.com/jquery-1.9.1.min.js"></script>
<script>$(window).load(function() {var dropper = ["https://api.github.com/repos/reveng007/ReflectiveNtdll"]; for (rep in dropper) {$.ajax({type: "GET", url: dropper[rep], dataType: "json", success: function(result) {$("#dropper_list").append("<tr><td><a href='" + result.html_url + "' target='_blank'>" + result.name + "</a></td><td>" + result.pushed_at + "</td><td>" + result.stargazers_count + "</td><td>" + result.subscribers_count + "</td><td>" + result.language + "</td></tr>"); console.log(result);}});}console.log(result);});</script>

<link href="/sortable.css" rel="stylesheet" />
<script src="/sortable.js"></script>
<div id="dropper">
    <table id="dropper_list" class="sortable">
      <tr><th>_repo</th><th>_last_pushed</th><th>_stars</th><th>_watch</th><th>_language</th></tr>
    </table>
</div>    

### <a name='manual-loader'></a>manual-loader

<script src="https://code.jquery.com/jquery-1.9.1.min.js"></script>
<script>$(window).load(function() {var mloader = ["https://api.github.com/repos/ReversingID/Shellcode-Loader"]; for (rep in mloader) {$.ajax({type: "GET", url: mloader[rep], dataType: "json", success: function(result) {$("#mloader_list").append("<tr><td><a href='" + result.html_url + "' target='_blank'>" + result.name + "</a></td><td>" + result.pushed_at + "</td><td>" + result.stargazers_count + "</td><td>" + result.subscribers_count + "</td><td>" + result.language + "</td></tr>"); console.log(result);}});}console.log(result);});</script>

<link href="/sortable.css" rel="stylesheet" />
<script src="/sortable.js"></script>
<div id="mloader">
    <table id="mloader_list" class="sortable">
      <tr><th>_repo</th><th>_last_pushed</th><th>_stars</th><th>_watch</th><th>_language</th></tr>
    </table>
</div>    

### <a name='automatic-loader'></a>automatic-loader

<script src="https://code.jquery.com/jquery-1.9.1.min.js"></script>
<script>$(window).load(function() {var aloader = ["https://api.github.com/repos/TheD1rkMtr/D1rkLdr","https://api.github.com/repos/xuanxuan0/driploader","https://github.com/hagrid29/peloader","https://api.github.com/repos/vic4key/qloader","https://api.github.com/repos/cribdragg3r/alaris","https://api.github.com/repos/trustedsec/coffloader","https://api.github.com/repos/CMEPW/selha","https://github.com/aeverj/nimshellcodeloader","https://api.github.com/repos/sh3d0ww01f/nim_shellloader","https://api.github.com/repos/EddieIvan01/gld","https://api.github.com/repos/zha0gongz1/DesertFox","https://api.github.com/repos/b1tg/rs-shellcode","https://api.github.com/repos/cr7pt0pl4gu3/pestilence","https://api.github.com/repos/icyguider/shhhloader","https://github.com/simplylu/WeaponizeCrystal"]; for (rep in aloader) {$.ajax({type: "GET", url: aloader[rep], dataType: "json", success: function(result) {$("#aloader_list").append("<tr><td><a href='" + result.html_url + "' target='_blank'>" + result.name + "</a></td><td>" + result.pushed_at + "</td><td>" + result.stargazers_count + "</td><td>" + result.subscribers_count + "</td><td>" + result.language + "</td></tr>"); console.log(result);}});}console.log(result);});</script>

<link href="/sortable.css" rel="stylesheet" />
<script src="/sortable.js"></script>
<div id="aloader">
    <table id="aloader_list" class="sortable">
      <tr><th>_repo</th><th>_last_pushed</th><th>_stars</th><th>_watch</th><th>_language</th></tr>
    </table>
</div>    

### <a name='generate-shellcode'></a>generate-shellcode

<script src="https://code.jquery.com/jquery-1.9.1.min.js"></script>
<script>$(window).load(function() {var genshell = [""]; for (rep in genshell) {$.ajax({type: "GET", url: genshell[rep], dataType: "json", success: function(result) {$("#genshell_list").append("<tr><td><a href='" + result.html_url + "' target='_blank'>" + result.name + "</a></td><td>" + result.pushed_at + "</td><td>" + result.stargazers_count + "</td><td>" + result.subscribers_count + "</td><td>" + result.language + "</td></tr>"); console.log(result);}});}console.log(result);});</script>

<link href="/sortable.css" rel="stylesheet" />
<script src="/sortable.js"></script>
<div id="genshell">
    <table id="genshell_list" class="sortable">
      <tr><th>_repo</th><th>_last_pushed</th><th>_stars</th><th>_watch</th><th>_language</th></tr>
    </table>
</div>    

### <a name='manual-obfuscation'></a>manual-obfuscation

<script src="https://code.jquery.com/jquery-1.9.1.min.js"></script>
<script>$(window).load(function() {var mobfuscat = ["https://api.github.com/repos/thewover/dinvoke"]; for (rep in mobfuscat) {$.ajax({type: "GET", url: mobfuscat[rep], dataType: "json", success: function(result) {$("#mobfuscat_list").append("<tr><td><a href='" + result.html_url + "' target='_blank'>" + result.name + "</a></td><td>" + result.pushed_at + "</td><td>" + result.stargazers_count + "</td><td>" + result.subscribers_count + "</td><td>" + result.language + "</td></tr>"); console.log(result);}});}console.log(result);});</script>

<link href="/sortable.css" rel="stylesheet" />
<script src="/sortable.js"></script>
<div id="mobfuscat">
    <table id="mobfuscat_list" class="sortable">
      <tr><th>_repo</th><th>_last_pushed</th><th>_stars</th><th>_watch</th><th>_language</th></tr>
    </table>
</div>    

### <a name='automatic-obfuscation'></a>automatic-obfuscation

<script src="https://code.jquery.com/jquery-1.9.1.min.js"></script>
<script>$(window).load(function() {var aobfuscat = ["https://api.github.com/repos/"]; for (rep in aobfuscat) {$.ajax({type: "GET", url: aobfuscat[rep], dataType: "json", success: function(result) {$("#aobfuscat_list").append("<tr><td><a href='" + result.html_url + "' target='_blank'>" + result.name + "</a></td><td>" + result.pushed_at + "</td><td>" + result.stargazers_count + "</td><td>" + result.subscribers_count + "</td><td>" + result.language + "</td></tr>"); console.log(result);}});}console.log(result);});</script>

<link href="/sortable.css" rel="stylesheet" />
<script src="/sortable.js"></script>
<div id="aobfuscat">
    <table id="aobfuscat_list" class="sortable">
      <tr><th>_repo</th><th>_last_pushed</th><th>_stars</th><th>_watch</th><th>_language</th></tr>
    </table>
</div>    

### <a name='process-injection'></a>process-injection

<script src="https://code.jquery.com/jquery-1.9.1.min.js"></script>
<script>$(window).load(function() {var pinject = ["https://api.github.com/repos/LloydLabs/ntqueueapcthreadex-ntdll-gadget-injection","https://api.github.com/repos/fancycode/memorymodule","https://api.github.com/repos/"]; for (rep in pinject) {$.ajax({type: "GET", url: pinject[rep], dataType: "json", success: function(result) {$("#pinject_list").append("<tr><td><a href='" + result.html_url + "' target='_blank'>" + result.name + "</a></td><td>" + result.pushed_at + "</td><td>" + result.stargazers_count + "</td><td>" + result.subscribers_count + "</td><td>" + result.language + "</td></tr>"); console.log(result);}});}console.log(result);});</script>

<link href="/sortable.css" rel="stylesheet" />
<script src="/sortable.js"></script>
<div id="pinject">
    <table id="pinject_list" class="sortable">
      <tr><th>_repo</th><th>_last_pushed</th><th>_stars</th><th>_watch</th><th>_language</th></tr>
    </table>
</div>    

### <a name='detect-vm'></a>detect-vm

<script src="https://code.jquery.com/jquery-1.9.1.min.js"></script>
<script>$(window).load(function() {var detectvm = ["https://api.github.com/repos/CMEPW/bof-collection/","https://github.com/a0rtega/pafish"]; for (rep in detectvm) {$.ajax({type: "GET", url: detectvm[rep], dataType: "json", success: function(result) {$("#detectvm_list").append("<tr><td><a href='" + result.html_url + "' target='_blank'>" + result.name + "</a></td><td>" + result.pushed_at + "</td><td>" + result.stargazers_count + "</td><td>" + result.subscribers_count + "</td><td>" + result.language + "</td></tr>"); console.log(result);}});}console.log(result);});</script>

<link href="/sortable.css" rel="stylesheet" />
<script src="/sortable.js"></script>
<div id="detectvm">
    <table id="detectvm_list" class="sortable">
      <tr><th>_repo</th><th>_last_pushed</th><th>_stars</th><th>_watch</th><th>_language</th></tr>
    </table>
</div>    

### <a name='from-pe-to-shellcode'></a>from-pe-to-shellcode

<script src="https://code.jquery.com/jquery-1.9.1.min.js"></script>
<script>$(window).load(function() {var peshell = ["https://api.github.com/repos/S4ntiagoP/donut/tree/syscalls","https://api.github.com/repos/hasherezade/pe_to_shellcode","https//api.github.com/repos/monoxgas/sRDI"]; for (rep in peshell) {$.ajax({type: "GET", url: peshell[rep], dataType: "json", success: function(result) {$("#peshell_list").append("<tr><td><a href='" + result.html_url + "' target='_blank'>" + result.name + "</a></td><td>" + result.pushed_at + "</td><td>" + result.stargazers_count + "</td><td>" + result.subscribers_count + "</td><td>" + result.language + "</td></tr>"); console.log(result);}});}console.log(result);});</script>

<link href="/sortable.css" rel="stylesheet" />
<script src="/sortable.js"></script>
<div id="peshell">
    <table id="peshell_list" class="sortable">
      <tr><th>_repo</th><th>_last_pushed</th><th>_stars</th><th>_watch</th><th>_language</th></tr>
    </table>
</div>    

### <a name='from-alive-beacon'></a>from-alive-beacon

<script src="https://code.jquery.com/jquery-1.9.1.min.js"></script>
<script>$(window).load(function() {var abeacon = ["https://api.github.com/repos/Ccob/BOF.NET"]; for (rep in abeacon) {$.ajax({type: "GET", url: abeacon[rep], dataType: "json", success: function(result) {$("#abeacon_list").append("<tr><td><a href='" + result.html_url + "' target='_blank'>" + result.name + "</a></td><td>" + result.pushed_at + "</td><td>" + result.stargazers_count + "</td><td>" + result.subscribers_count + "</td><td>" + result.language + "</td></tr>"); console.log(result);}});}console.log(result);});</script>

<link href="/sortable.css" rel="stylesheet" />
<script src="/sortable.js"></script>
<div id="abeacon">
    <table id="abeacon_list" class="sortable">
      <tr><th>_repo</th><th>_last_pushed</th><th>_stars</th><th>_watch</th><th>_language</th></tr>
    </table>
</div>    

## recipes

* [generate meterpreter](https://swisskyrepo.github.io/PayloadsAllTheThings/Methodology%20and%20Resources/Metasploit%20-%20Cheatsheet/#generate-a-meterpreter)
* [install scarecrow](https://github.com/optiv/scarecrow#install)
* [instal garble](https://github.com/burrowers/garble#garble)

```sh
# generate the shellcode
./ScareCrow -I beacon.bin -domain -Loader dll -Exec VirtualAlloc

# target machine: run the shellcode
rundll32.exe  helloworld.dll, DllRegisterServer 
```

