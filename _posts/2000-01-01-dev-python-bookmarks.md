---
layout: post
title: Python Snippets & Libraries
category: Development
parent: Development
grand_parent: Cheatsheets
modified_date: 2022-09-22
permalink: /:categories/:title/
---

<!-- vscode-markdown-toc -->
* 1. [Code snippets](#Codesnippets)
	* 1.1. [Virtual Environment](#VirtualEnvironment)
* 2. [Libraries](#Libraries)
	* 2.1. [Network](#Network)
	* 2.2. [System](#System)
	* 2.3. [Data](#Data)
	* 2.4. [Security](#Security)

<!-- vscode-markdown-toc-config
	numbering=true
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

##  1. <a name='Codesnippets'></a>Code snippets

###  1.1. <a name='VirtualEnvironment'></a>Virtual Environment

- [python venv module](https://packaging.python.org/en/latest/guides/installing-using-pip-and-virtual-environments/)

```python
# install 
pip install virtualenv

# creation
mkdir project
cd project
python3 -m venv env

# activation / deactivation linux
source env/bin/activate
source env/bin/deactivate

# activation / deactivation windows
cd env/Scripts
activate.bat //In CMD
deactivate.bat
```
##  2. <a name='Libraries'></a>Libraries

###  2.1. <a name='Network'></a>Network
- [ipaddress](https://docs.python.org/3/library/ipaddress.html)
- [ldap3](https://ldap3.readthedocs.io) / [supportedExtensions](https://ldapwiki.com/wiki/Supported%20Extensions%20List)
- [requests](https://requests.readthedocs.io)
- [selenium](https://selenium-python.readthedocs.io/)
- [socket](https://docs.python.org/3/library/socket.html)
- [urllib](https://docs.python.org/3/library/urllib.html)

###  2.2. <a name='System'></a>System
- [datetime](https://docs.python.org/3/library/datetime.html) / [timestamp millisec conversion](https://stackoverflow.com/questions/59612665/convert-epoch-time-to-standard-datetime-from-json-python)
- [ipywidgets](https://ipywidgets.readthedocs.io)
- [os](https://docs.python.org/3/library/os.html)
- [pillow](https://pillow.readthedocs.io/en/stable/)
- [pty](https://docs.python.org/3/library/pty.html) / [process spawn](https://docs.python.org/3/library/pty.html#pty.spawn)
- [string](https://docs.python.org/3/library/string.html)
- [sys](https://docs.python.org/3/library/sys.html)
- [tkinter](https://docs.python.org/3/library/tkinter.html)
- [time](https://docs.python.org/3/library/time.html)

###  2.3. <a name='Data'></a>Data
- [jmespath tutorial](https://jmespath.org/tutorial.html)
- [json](https://docs.python.org/3/library/json.html)
- [math](https://docs.python.org/3/library/math.html)
- [numpy](https://numpy.org/doc/stable/user/absolute_beginners.html) / [user guide](https://numpy.org/doc/stable/user/index.html#user)
- [pandas](https://pandas.pydata.org/docs/getting_started/index.html#getting-started) / [user guide](https://pandas.pydata.org/docs/user_guide/index.html) / [splitting hostname and fqdn into column values](https://stackoverflow.com/questions/14745022/how-to-split-a-dataframe-string-column-into-two-columns)
- [plotly](https://plotly.com/python/)
- [sqlalchemy](https://sqlalchemy.readthedocs.io)

###  2.4. <a name='Security'></a>Security
- [impacket](https://www.secureauth.com/labs/open-source-tools/impacket/) / [examples](https://github.com/SecureAuthCorp/impacket/tree/master/examples)
- [msticpy](https://msticpy.readthedocs.io)
- [pypykatz](https://github.com/skelsec/pypykatz/wiki)
- [shodan](https://shodan.readthedocs.io)