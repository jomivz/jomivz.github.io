layout: post
title: Logs and Artifacts Formatting
parent: SIEM
category: Forensics
grand_parent: Cheatsheets
modified_date: 2021-04-29
---

<!-- vscode-markdown-toc -->
* [Logs formating](#Logsformating)
* [Artifacts formating](#Artifactsformating)
	* [Dumping the MFT from mem and formatting it to CSV](#DumpingtheMFTfrommemandformattingittoCSV)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->---

## <a name='Logsformating'></a>Logs formating
```
# TSV logs to CSV
# First aims to deal with empty fields
sed 's\t\t/,,/' sourcelog.tsv > sourcelog2.tsv
sed 's\t\+/,/g' sourcelog2.tsv > formatted_sourcelog.csv

# Windows EVTX logs to XML
evtx_dump.py Security.evtx > svr-perferx_04-17_security.xml
```

## <a name='Artifactsformating'></a>Artifacts formating

### <a name='DumpingtheMFTfrommemandformattingittoCSV'></a>Dumping the MFT from mem and formatting it to CSV
````
python3.6 vol.py -f memdump.img filescan | grep mft > filescan_mft.txt
cat filescan_mft.txt
0xc70a84d9f21
python3.6 vol.py -f memdump.img dumpfile --physaddr 0xc70a84d9f21 > mft.vacb
analyzeMFT.py -f mft.vacb -e -c mft.vacb.csv
```
