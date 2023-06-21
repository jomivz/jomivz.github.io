---
layout: post
title: DEV Common REGEX in Cybersecurity
category: dev
parent: cheatsheets
modified_date: 2023-06-08
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

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

:link: [TEST YOUR REGEX ONLINE](https://regex101.com/r/iVrIlL/1)
Refer to the [Python regex cheatsheet](/docs/development/python-regular-expression-regex.pdf) for more information.


## <a name='ascii'></a>ascii
```sh
[ -~]
```

## <a name='date'></a>date 
```sh
 (?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/|-|\.)(?:0?[13-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2}) 
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

# username
```sh
^[a-z0-9_-]{3,15}$
```

