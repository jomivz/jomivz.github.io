---
layout: post
title: TA0007 Discovery - T1046 Scanning Web Apps
category: pen
parent: cheatsheets
modified_date: 2023-03-16
permalink: /pen/web/scan
tags: discovery scan nikto nuclei bypass-waf dirbuster
---

** MENU **

<!-- vscode-markdown-toc -->
* [👀🔥 attacks](#attacks)
* [👀🧠 dorks](#dorks)
* [👀🕶️ rotate-ip](#rotate-ip)
* [👀🧠 status-code](#status-code)
* [👀🧠 tools](#tools)
* [👀🎯 labs](#labs)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='attacks'></a>👀🔥 attacks

🔥 [OWASP Top 10](](/pen/web/owasp-top10.png) 🔥

![owasp-top-10-mapping](/assets/images/owasp-top10-mapping.png)

| **attack** | **mindmap** | **article** | **video** | 
|---------|---|---|---|
| CORS | [securityzines](https://securityzines.com/assets/img/flyers/printable/cors.png)| [portswigger](https://portswigger.net/web-security/cors) |||
| Domain Lowering | [securityzines](https://securityzines.com/assets/img/flyers/downloads/DomainLowering.png), [SOP](https://securityzines.com/assets/img/flyers/downloads/intigriti/sop.png) | | |
| H2C smuggling | [securityzines](https://securityzines.com/assets/img/flyers/printable/h2c.jpg) | [portswigger](https://portswigger.net/web-security/request-smuggling)|||
| HPP | [securityzines](https://securityzines.com/assets/img/flyers/downloads/intigriti/hpp.png) |||
| HRS | [securityzines](https://securityzines.com/assets/img/flyers/printable/hrs.jpg) |||
| IDOR | [securityzines](https://securityzines.com/assets/img/flyers/printable/idor.jpg) |[portswigger](https://portswigger.net/web-security/access-control)|||
| LFI | [securityzines](https://securityzines.com/assets/img/flyers/printable/lfi.jpg) |[portswigger](https://portswigger.net/web-security/file-path-traversal)|||
| RFI | [securityzines](https://securityzines.com/assets/img/flyers/printable/rfi.jpg) |||
| SQLi | [securityzines](https://securityzines.com/assets/img/zines/sqli.jpg) | [portswigger](https://portswigger.net/web-security/sql-injection)|||
| SSRF | | [portswigger](https://portswigger.net/web-security/ssrf) | ||
| SSTI | [securityzines](https://securityzines.com/assets/img/flyers/printable/ssti.jpg) | [portswigger](https://portswigger.net/web-security/server-side-template-injection)|||
| XSS DOM | [iocscan](https://miro.medium.com/max/1572/1*yuRkBR6YroYLCGpka9KdRA.png) | [portswigger](https://portswigger.net/web-security/cross-site-scripting/dom-based) | ||
| XSS stored | [securityzines](https://securityzines.com/assets/img/flyers/downloads/intigriti/stored-xss.png) | [portswigger](https://portswigger.net/web-security/cross-site-scripting) | ||
| XSS reflected | [securityzines](https://securityzines.com/assets/img/flyers/printable/rxss.png)|||
| XSRF | [securityzines](https://securityzines.com/assets/img/zines/csrf.jpg) | [portswigger](https://portswigger.net/web-security/csrf)|||
| XXE | [securityzines](https://securityzines.com/assets/img/flyers/downloads/intigriti/xxe.png) | [portswigger](https://portswigger.net/web-security/xxe)|||

## <a name='dorks'></a>👀🧠 dorks

* [/pen/web/dorks-github.png](/pen/web/dorks-github.png)
* [/pen/web/dorks-google.png](/pen/web/dorks-google.png)

## <a name='rotate-ip'></a>👀🕶️ rotate-ip

* [mubeng](https://github.com/kitabisa/mubeng#proxy-ip-rotator)

```bash
# set the proxy ip rotator
curl https://raw.githubusercontent.com/TheSpeedX/SOCKS-List/master/http.txt -o http.txt
docker run --network host -it mubeng -a localhost:8089 -f http.txt -r 10 -m random
```

## <a name='status-code'></a>👀🧠 status-code

* [/pen/web/http-status-code.png](/pen/web/http-status-code.png)
* [/pen/web-api](https://dsopas.github.io/MindAPI/play/) (🔗 [begineer guide](https://danaepp.com/beginners-guide-to-api-hacking))

## <a name='tools'></a>👀🧠 tools

* [/tool/burp.png](/tool/burp.png)
* [/tool/burp-extensions.png](/tool/burp-extensions.png)
* [fireprox](https://github.com/ustayready/fireprox)
* [IP rotator TOR](https://github.com/SusmithKrishnan/torghost)
* [IP rotator for Burp](github.com/RhinoSecurityLabs/IPRotate_Burp_Extension)
* [nuclei templates](https://github.com/projectdiscovery/nuclei-templates)
* [dump elastic](https://github.com/leakix/estk)
* [waf bypass](https://github.com/nemesida-waf/waf-bypass)

```bash
# run waf-bypass
docker run --network host -it 7209816c0627 --host='contoso.com' --proxy='http://localhost:8089'

# to select one payload we need to exclude all others
--exclude-dir='FP' \
--exclude-dir='API' \
--exclude-dir='CM' \
--exclude-dir='GraphQL' \
--exclude-dir='LDAP' \
--exclude-dir='LFI' \
--exclude-dir='MFD' \
--exclude-dir='NoSQLi' \
--exclude-dir='OR' \
--exclude-dir='RCE' \
--exclude-dir='RFI' \
--exclude-dir='SQLi' \
--exclude-dir='SSI' \
--exclude-dir='SSRF' \
--exclude-dir='SSTI' \
--exclude-dir='UWA' \
--exclude-dir='XSS' \
```

## <a name='labs'></a>👀🎯 labs

* [hacksplaining](https://www.hacksplaining.com/owasp)
* [vulnhub box](https://github.com/Ignitetechnologies/Web-Application-Cheatsheet)
* [takito1812 playground](https://github.com/takito1812/web-hacking-playground/tree/main/Solutions)
* [burp BSCP exam notes](https://github.com/botesjuan/Burp-Suite-Certified-Practitioner-Exam-Study)