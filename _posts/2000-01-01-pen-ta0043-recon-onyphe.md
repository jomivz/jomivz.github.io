---
layout: post
title: TA0043 Reconnaissance - Onyphe
parent: Pentesting
category: Pentesting
grand_parent: Cheatsheets
modified_date: 2023-05-04
permalink: /:categories/:title/
---


## Discovery Datascan TO JSON
```
#!/bin/bash
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

## Extract all IPs
```python
import json

with open("test.json") as f:
    content = json.load(f)
    for c in content:
        try:
            # skip ip lists
            if (isinstance(c["ip"],str)):
                print(c["ip"])
        except Exception as e:
            pass
```
