---
layout: post
title: dfir / mlw / pe
category: dfir
parent: cheatsheets
modified_date: 2024-06-10
permalink: /dfir/mlw/pe
---

<!-- vscode-markdown-toc -->
* [flare](#flare)
* [static](#static)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='static'></a>static
```powershell
get-authenticodesignature mlwr.exe | fl *
sigverif
strings -a -t d -e l process.0xffff1234567890.dmp >> mlwr.uni
bstrings -p
bstrings -f minidump.dmp --lr ipv4
bstrings -f minidump.dmp --lr win_path
densityscout -r -pe -p 0.1 -o density_ouput.txt C:\Windows
# sigcheck V1 - VT lookup
sigcheck -s -c -e -h -v -vt -w G:\malware\sigcheck-results.csv e:\C\Windows
# sigcheck V2 - no VT lookup
sigcheck -s -c -e -h -w sigcheck_output_.csv C:\Windows
yara64.exe -C yara-rules -rw C:\Windows > C:\windows\temp\yara_out.txt
capa -v mlwr.exe
upx -d mlwr.exe -o mlwr.exe.unpacked 
```

## <a name='pe'></a>pe

| **action** | **tool** |
|------------|----------|
| get file type | file, HxD |
| get bin signatures | hashdump |
| dump strings | strings, floss, xorsearch; PEStudio |
| detect packing | exeinfo, |

## <a name='flare'></a>virustotal
```sh
# VT malware download
curl -k  --insecure --request GET -L --output my_malware --url https://www.virustotal.com/api/v3/files/<my_malware_id>/download --header 'x-apikey:'
```
