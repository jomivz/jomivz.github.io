---
layout: post
title: Spiderfoot Cheatsheet 
parent: OSINT
category: OSINT
grand_parent: Cheatsheets
modified_date: 2021-12-08
permalink: /:categories/:title/
---
<!-- vscode-markdown-toc -->
* 1. [SpiderFoot Install](#SpiderFootInstall)
* 2. [SFCLI \ Execution](#SFCLIExecution)
* 3. [SFCLI \ Getting Started](#SFCLIGettingStarted)
* 4. [SFCLI \ Module Shodan](#SFCLIModuleShodan)
* 5. [SFCLI \ Module HaveIBeenPwned](#SFCLIModuleHaveIBeenPwned)
* 6. [SFCLI \ Module DNSrecon](#SFCLIModuleDNSrecon)
* 7. [SFCLI \ Module CRT](#SFCLIModuleCRT)
* 8. [SFCLI \ Module whatcms](#SFCLIModulewhatcms)

<!-- vscode-markdown-toc-config
	numbering=true
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

##  1. <a name='SpiderFootInstall'></a>SpiderFoot Install
- [Sysadmin Docker Cheatsheet](/sysadmin/2021/10/26/sys-cli-docker.html)

##  2. <a name='SFCLIExecution'></a>SFCLI \ Execution
```batch
#? memo osint spiderfoot
#
#? run docker spiderfoot
docker run -p 5002:5001 -d spiderfoot

#? list sfcli modules
cd /usr/share/spiderfoot
python3 ./sf.py -M |grep -i dns

#? run/connect sfcli with docker
cd /usr/share/spiderfoot
python3 ./sfcli.py -s http://localhost:5002

# check memo osint sfcli
```

##  3. <a name='SFCLIGettingStarted'></a>SFCLI \ Getting Started

Watch the tutorial video [HERE](https://asciinema.org/a/126064).
```batch
#? memo osint sfcli
#
# test connectivity
sf> ping

#? scan dns
sf> start jmvwork.xyz -m sfp_dnsgrep,sfp_dnsraw,sfp_dnsdumpster,sfp_dns_brute

#? scan crt and dns #!VERBOSE
sf> start jmvwork.xyz -m sfp_crt

# sfcli - scan - start example 2
sf> start jmvwork.xyz -m sfp_dns,sfp_spider,sfp_pwned -n "blabla"

#? check typosquatting
sf> start jmvwork.xyz -m sfp_similar

# sfcli - scan - progression watch - with the scan ID <sid>
sf> logs <sid> -w

# sfcli - scan - information status
sf> scaninfo <sid>

# sfcli - scan - get data collected
sf> data <sid> -t IP_ADDRESS

# sfcli - list all scans 
sf> scans

# sfcli - scan - delete by its <sid>
sf> delete <sid>

```
##  4. <a name='SFCLIModuleShodan'></a>SFCLI \ Module Shodan

Watch the tutorial video [HERE](https://asciinema.org/a/127601).
```batch
# sfcli shodan - checking the settings 
sf> set | str shodan

# sfcli shodan - set the API key <apikey>
sf> set module.sfp_shodan.api_key = <apikey>

# sfcli shodan - start a scan
sf> start 1.2.3.4 -m spf_shodan
```

##  5. <a name='SFCLIModuleHaveIBeenPwned'></a>SFCLI \ Module HaveIBeenPwned

Watch the tutorial video [HERE](https://asciinema.org/a/128731).
```batch
# sfcli HIBP - start a scan
sf> start elon@testla.com -m sfp_pwned -w

# sfcli HIBP - scan - get data collected
sf> data <sid> -t EMAILADDR_COMPROMISED
```
##  6. <a name='SFCLIModuleDNSrecon'></a>SFCLI \ Module DNSrecon

Watch the tutorial video [HERE](https://asciinema.org/a/295912).
```batch
# sfcli DNSRecon - start a scan
sf> start elon@testla.com -m sfp_dnsbrute,sfp_dnsresolve -r

```
##  7. <a name='SFCLIModuleCRT'></a>SFCLI \ Module CRT

Watch the tutorial video [HERE](https://asciinema.org/a/295946).
```batch
# sfcli crt - start a scan
sf> start tesla.com -m sfp_crt -q -F INTERNET_NAME

```
##  8. <a name='SFCLIModulewhatcms'></a>SFCLI \ Module whatcms

```batch
# sfcli whatcms - checking the settings 
sf> set | str whatcms

# sfcli whatcms - set the API key <apikey>
sf> set module.sfp_whatcms.api_key = <apikey>

# sfcli whatcms - start a scan
sf> start tesla.com -m sfp_whatcms

```

