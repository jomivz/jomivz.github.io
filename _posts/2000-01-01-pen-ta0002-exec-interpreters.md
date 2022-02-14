---
layout: post
title: Post-Exploitation - Reverse Shells
category: Pentesting
parent: Pentesting
grand_parent: Cheatsheets
modified_date: 2022-02-11
permalink: /:categories/:title/
---

<!-- vscode-markdown-toc -->
* [{{ page.title }}](#page.title)
	* [Executing System Interpreters](#ExecutingSystemInterpreters)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->
## <a name='page.title'></a>{{ page.title }}

### <a name='ExecutingSystemInterpreters'></a>Executing System Interpreters 

```sh
# run bash via python
python -c 'import pty; pty.spawn("/bin/bash")'
```
