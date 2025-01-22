---
layout: post
title: recon / spiderfoot
parent: cheatsheets
category: 00-recon
modified_date: 2024-12-20
permalink: /recon/spiderfoot
---
<!-- vscode-markdown-toc -->
* [install](#install)
* [start](#start)
* [run](#run)
* [modules](#modules)
	* [shodan](#shodan)
	* [hibp](#hibp)
	* [dnsrecon](#dnsrecon)
	* [crt](#crt)
	* [whatcms](#whatcms)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='install'></a>install

[/sys/docker/spiderfoot](/sys/docker#spiderfoot)

## <a name='start'></a>start
```batch
#? memo osint spiderfoot
#
#? run docker spiderfoot
docker run -p 5002:5001 -d spiderfoot

#? list sfcli modules
python3 ./sf.py -M |grep -i dns

#? run/connect sfcli with docker
python3 ./sfcli.py -s http://localhost:5002

# check memo osint sfcli
```

## <a name='run'></a>run

Watch the tutorial video [HERE](https://asciinema.org/a/126064).
```batch
# test connectivity
ping

#? scan dns
start jmvwork.xyz -m sfp_dnsgrep,sfp_dnsraw,sfp_dnsdumpster,sfp_dns_brute

#? scan crt and dns #!VERBOSE
start jmvwork.xyz -m sfp_crt

# sfcli - scan - start example 2
start jmvwork.xyz -m sfp_dns,sfp_spider,sfp_pwned -n "blabla"

#? check typosquatting
start jmvwork.xyz -m sfp_similar

# sfcli - scan - information status
scaninfo <sid>

# sfcli - scan - progression watch - with the scan ID <sid>
logs <sid> -w

# sfcli - scan - get data collected
data <sid> -t IP_ADDRESS

# sfcli - list all scans 
scans

# sfcli - scan - delete by its <sid>
delete <sid>
```

## <a name='modules'></a>modules
### <a name='shodan'></a>shodan

Watch the tutorial video [HERE](https://asciinema.org/a/127601).
```batch
# sfcli shodan - checking the settings 
set | str shodan

# sfcli shodan - set the API key <apikey>
set module.sfp_shodan.api_key = <apikey>

# sfcli shodan - start a scan
start 1.2.3.4 -m spf_shodan
```

### <a name='hibp'></a>hibp

Watch the tutorial video [HERE](https://asciinema.org/a/128731).
```batch
# sfcli HIBP - start a scan
start elon@testla.com -m sfp_pwned -w

# sfcli HIBP - scan - get data collected
data <sid> -t EMAILADDR_COMPROMISED
```
### <a name='dnsrecon'></a>dnsrecon

Watch the tutorial video [HERE](https://asciinema.org/a/295912).
```batch
# sfcli DNSRecon - start a scan
start elon@testla.com -m sfp_dnsbrute,sfp_dnsresolve -r
```
### <a name='crt'></a>crt

Watch the tutorial video [HERE](https://asciinema.org/a/295946).
```batch
# sfcli crt - start a scan
start tesla.com -m sfp_crt -q -F INTERNET_NAME
```
### <a name='whatcms'></a>whatcms

```batch
# sfcli whatcms - checking the settings 
set | str whatcms

# sfcli whatcms - set the API key <apikey>
set module.sfp_whatcms.api_key = <apikey>

# sfcli whatcms - start a scan
start tesla.com -m sfp_whatcms
```

