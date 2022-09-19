---
layout: post
title: Python Snippets & Libraries
category: Development
parent: Development
grand_parent: Cheatsheets
modified_date: 2022-09-19
permalink: /:categories/:title/
---

<!-- vscode-markdown-toc -->
* 1. [Code snippets](#Codesnippets)
	* 1.1. [Virtual Environment](#VirtualEnvironment)
* 2. [Libraries](#Libraries)
	* 2.1. [Network](#Network)
		* 2.1.1. [ipaddress](#ipaddress)
		* 2.1.2. [ldap3](#ldap3)
		* 2.1.3. [requests](#requests)
		* 2.1.4. [selenium](#selenium)
		* 2.1.5. [socket](#socket)
		* 2.1.6. [urllib](#urllib)
	* 2.2. [System](#System)
		* 2.2.1. [datetime](#datetime)
		* 2.2.2. [ipywidgets](#ipywidgets)
		* 2.2.3. [os](#os)
		* 2.2.4. [pillow](#pillow)
		* 2.2.5. [string](#string)
		* 2.2.6. [sys](#sys)
		* 2.2.7. [tkinter](#tkinter)
		* 2.2.8. [time](#time)
	* 2.3. [Data](#Data)
		* 2.3.1. [jmespath](#jmespath)
		* 2.3.2. [json](#json)
		* 2.3.3. [math](#math)
		* 2.3.4. [numpy](#numpy)
		* 2.3.5. [pandas](#pandas)
		* 2.3.6. [plotly](#plotly)
		* 2.3.7. [sqlalchemy](#sqlalchemy)
	* 2.4. [Security](#Security)
		* 2.4.1. [impacket examples](#impacketexamples)
		* 2.4.2. [msticpy](#msticpy)
		* 2.4.3. [pypykatz](#pypykatz)
		* 2.4.4. [shodan](#shodan)

<!-- vscode-markdown-toc-config
	numbering=true
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

#  1. <a name='Codesnippets'></a>Code snippets

##  1.1. <a name='VirtualEnvironment'></a>Virtual Environment

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
#  2. <a name='Libraries'></a>Libraries

##  2.1. <a name='Network'></a>Network

###  2.1.1. <a name='ipaddress'></a>ipaddress
- [ipaddress](https://docs.python.org/3/library/ipaddress.html)
###  2.1.2. <a name='ldap3'></a>ldap3
- [ldap3](https://ldap3.readthedocs.io)
###  2.1.3. <a name='requests'></a>requests
- [requests](https://requests.readthedocs.io)
###  2.1.4. <a name='selenium'></a>selenium
- [selenium](https://selenium-python.readthedocs.io/)
###  2.1.5. <a name='socket'></a>socket
- [socket](https://docs.python.org/3/library/socket.html)
###  2.1.6. <a name='urllib'></a>urllib
- [urllib](https://docs.python.org/3/library/urllib.html)

##  2.2. <a name='System'></a>System

###  2.2.1. <a name='datetime'></a>datetime
- [datetime](https://docs.python.org/3/library/datetime.html)
- [timestamp millisec conversion](https://stackoverflow.com/questions/59612665/convert-epoch-time-to-standard-datetime-from-json-python)
###  2.2.2. <a name='ipywidgets'></a>ipywidgets
- [ipywidgets](https://ipywidgets.readthedocs.io)
###  2.2.3. <a name='os'></a>os
- [os](https://docs.python.org/3/library/os.html)
###  2.2.4. <a name='pillow'></a>pillow
- [pillow](https://pillow.readthedocs.io/en/stable/)
###  2.2.5. <a name='string'></a>string
- [string](https://docs.python.org/3/library/string.html)
###  2.2.6. <a name='sys'></a>sys
- [sys](https://docs.python.org/3/library/sys.html)
###  2.2.7. <a name='tkinter'></a>tkinter
- [tkinter](https://docs.python.org/3/library/tkinter.html)
###  2.2.8. <a name='time'></a>time
- [requests](https://docs.python.org/3/library/time.html)

##  2.3. <a name='Data'></a>Data

###  2.3.1. <a name='jmespath'></a>jmespath
- [jmespath tutorial](https://jmespath.org/tutorial.html)
###  2.3.2. <a name='json'></a>json
- [json](https://docs.python.org/3/library/json.html)
###  2.3.3. <a name='math'></a>math
- [math](https://docs.python.org/3/library/math.html)
###  2.3.4. <a name='numpy'></a>numpy
- [getting started](https://numpy.org/doc/stable/user/absolute_beginners.html)
- [user guide](https://numpy.org/doc/stable/user/index.html#user)
###  2.3.5. <a name='pandas'></a>pandas
- [getting started](https://pandas.pydata.org/docs/getting_started/index.html#getting-started)
- [user guide](https://pandas.pydata.org/docs/user_guide/index.html)
**use-cases**:
- [splitting hostname and fqdn into column values](https://stackoverflow.com/questions/14745022/how-to-split-a-dataframe-string-column-into-two-columns)
###  2.3.6. <a name='plotly'></a>plotly
- [plotly](https://plotly.com/python/)
###  2.3.7. <a name='sqlalchemy'></a>sqlalchemy
- [sqlalchemy](https://sqlalchemy.readthedocs.io)

##  2.4. <a name='Security'></a>Security

###  2.4.1. <a name='impacketexamples'></a>impacket examples
- [list](https://www.secureauth.com/labs/open-source-tools/impacket/)
- [source](https://github.com/SecureAuthCorp/impacket/tree/master/examples)
###  2.4.2. <a name='msticpy'></a>msticpy
- [shodan](https://msticpy.readthedocs.io)
###  2.4.3. <a name='pypykatz'></a>pypykatz
- [wiki](https://github.com/skelsec/pypykatz/wiki)
###  2.4.4. <a name='shodan'></a>shodan
- [shodan](https://shodan.readthedocs.io)