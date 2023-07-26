---
layout: post
title:  recon
parent: cheatsheets
category: recon
permalink: /recon/shodan
modified_date: 2023-07-24
---

<!-- vscode-markdown-toc -->
* [devices](#devices)
	* [network](#network)
	* [citrix](#citrix)
* [organization](#organization)
* [sources](#sources)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='devices'></a>devices

### <a name='network'></a>network
```sh
# cisco ios - no password - HTTP return code 200
HTTP/1.0 200 Ok
Last-modififed: Tue, 08 Jun 1999 06:55:45 GMT
# cisco ios - no password - HTTP return code 401
HTTP/1.0 401 Unauthorized
Www-authenticate: Basic realm="level_15 or view_access"
# cisco ios - default password - HTTP return code 401
Www-authenticate: Basic realm="Default password:1234"
```

### <a name='citrix'></a>citrix
```sh
# cve-2023-3519
citrix netscaler
ssl:”*contoso*" http.favicon.hash:-1292923998,-1166125415
ssl:”*contoso*” http.title:"*netscaler*"
ssl:”*contoso*” ja3:""
```

## <a name='organization'></a>organization 
```sh
# hosts with any field containing the word "hello" directly followed by at least one character
contoso?
# asn 
(autonomous_system.description: contoso)
# snmp service
services.snmp.oid_system.location="contoso"
services.http.request.uri: *owa/auth/logon*
services.http.response.html_title: dashboard
services: (service_name: RDP and certificate: *)
services.tls.version_selected: {TLSv1_0, TLSv1_1}
services: (service_name: ELASTICSEARCH)
```

## <a name='sources'></a>sources

* [examples](https://www.shodan.io/search/examples)
* [filters](https://www.shodan.io/search/filters) / [github](https://github.com/JavierOlmedo/shodan-filters)
* [fingerprints](https://github.com/n0x08/ShodanTools)
* [/tool/shodan.png](/tool/shodan.png)

