---
layout: post
title: dev / regex
category: dev
parent: cheatsheets
modified_date: 2023-06-21
permalink: /dev/regex
---

<!-- vscode-markdown-toc -->
* [ascii](#ascii)
* [date](#date)
* [domain](#domain)
* [email](#email)
* [ipv4](#ipv4)
* [ipv6](#ipv6)
* [password](#password)
* [phone](#phone)
* [username](#username)
* [sid](#sid)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

:link: [TEST YOUR REGEX ONLINE](https://regex101.com/r/iVrIlL/1)
Refer to the [Python regex cheatsheet](/docs/development/python-regular-expression-regex.pdf) for more information.


## <a name='ascii'></a>ascii
```sh
```

## <a name='date'></a>date 
```sh
# bash regex round-trip date/time pattern
# usage: date format for the AD pwdlastset attribute
# example: grep pwdlastset *getnetuser* | sed 's/.*getnetuser_\(.*\)\.txt.*\([0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}\ [0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}.*[-+][0-9]\{2\}:[0-9]\{2\}\)/\2,\1/' | sort -u | csvlook -H
'[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}\ [0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}.*[-+][0-9]\{2\}:[0-9]\{2\}'
```

## <a name='domain'></a>domain
```sh
 rex field=referer "\/\/(?:[^@\/\n]+@)?(?:www\.)?(?<refdomain>[^:\/\n]+)"| stats values(refdomain)
```

## <a name='email'></a>email
```sh
[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]+
grep -Eiorh '([[:alnum:]_.-]+@[[:alnum:]_.-]+?\.[[:alpha:].]{2,6})'
```

## <a name='ipv4'></a>ipv4
```sh
(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}
```

## <a name='ipv6'></a>ipv6
```sh
([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|: (((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))
```

## <a name='password'></a>password 
greater than 8 characters...
```sh
^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$ %^&*-]).{8,}$
```

## <a name='phone'></a>phone
```sh
 ^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$ 
```

## <a name='username'></a>username
```sh
^[a-z0-9_-]{3,15}$
```

## <a name='sid'></a>sid
```sh
# egrep -o S-1-5-21-[0-9]{10}-[0-9]{10}-[0-9]{10}-[0-9]{1,6} toto.txt
S-1-5-21-[0-9]{10}-[0-9]{10}-[0-9]{10}-[0-9]{1,6}
```

