---
layout: post
title: TA0002 Execution
category: pen
parent: cheatsheets
modified_date: 2023-06-02
permalink: /pen/exec
---

**Mitre Att&ck Entreprise**: [TA0002 - Execution](https://attack.mitre.org/tactics/TA0002/)

**Menu**
<!-- vscode-markdown-toc -->
* [python](#python)
* [ps](#ps)
	* [ps-defeva-win](#ps-defeva-win)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='python'></a>python

```sh
# run bash via python
python -c 'import pty; pty.spawn("/bin/bash")'
```

## <a name='ps'></a>ps 

### <a name='ps-defeva-win'></a>ps-defeva-win

* [palo cortex xdr](/edr/defeva#win-xdr)
* [windows defender](/edr/defeva#win-defender)
