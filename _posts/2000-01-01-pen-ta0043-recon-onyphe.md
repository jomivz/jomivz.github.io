---
layout: post
title: TA0043 Reconnaissance
parent: Pentesting
category: Pentesting
grand_parent: Cheatsheets
modified_date: 2023-05-04
permalink: /recon
---

<!-- vscode-markdown-toc -->
* 1. [censys](#censys)
* 2. [onyphe](#onyphe)
	* 2.1. [pnyphe - bash / jq](#pnyphe-bashjq)
		* 2.1.1. [onyphe json to python list](#onyphejsontopythonlist)
	* 2.2. [python scripts](#pythonscripts)
	* 2.3. [onyphe-extract-all-ips](#onyphe-extract-all-ips)

<!-- vscode-markdown-toc-config
	numbering=true
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->


##  1. <a name='censys'></a>censys
##  2. <a name='onyphe'></a>onyphe

###  2.1. <a name='pnyphe-bashjq'></a>onyphe - bash - jq


####  2.1.1. <a name='onyphejsontopythonlist'></a>onyphe json to python list
```
#!/bin/bash
args="$@"
FILE="${args[0]}" 

if [[ -e $FILE && -r $FILE ]]; then

    # add bracket to the first line
    sed -i -e '1 i [' $FILE

    # add bracket to the last line
    sed -i -e '$a]' $FILE

    # add comma / remove it for first, blast & last lines
    blast=$((`wc -l $FILE |cut -f1 -d" "`-1))
    sed -i -e 's/$/,/;1s/,$//;$s/,$//' $FILE
    sed -i -e ${blast}'s/,$//' $FILE

fi
```

###  2.2. <a name='pythonscripts'></a>python scripts

###  2.3. <a name='onyphe-extract-all-ips'></a>onyphe-extract-all-ips
```python
import json
import sys

FILE = sys.argv[1]

with open(FILE) as f:
    content = json.load(f)
    for c in content:
        try:
            # skip ip lists
            if (isinstance(c["ip"],str)):
                print(c["ip"])
        except Exception as e:
            pass
```
