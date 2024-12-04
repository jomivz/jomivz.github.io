---
layout: post
title:  recon / onyphe
parent: cheatsheets
category: 00-recon
permalink: /recon/onyphe
modified_date: 2023-07-24
---

<!-- vscode-markdown-toc -->
* [onyphe-datascan](#onyphe-datascan)
* [onyphe-jq](#onyphe-jq)
* [onyphe-extract-ips](#onyphe-extract-ips)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='onyphe-datascan'></a>onyphe-datascan

## <a name='onyphe-jq'></a>onyphe-jq

## <a name='onyphe-extract-ips'></a>onyphe-extract-ips 

1/ Convert datascan json to python list:
```sh
#!/bin/bash
# convert datascan json to python list
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

2/ Extract the IP from the python list:
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
