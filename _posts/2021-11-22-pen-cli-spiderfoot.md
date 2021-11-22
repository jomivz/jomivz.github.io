---
layout: post
title: Spiderfoot SPFCLI.PY cheatsheet 
parent: OSINT
category: OSINT
grand_parent: Cheatsheets
modified_date: 2021-11-21
---
<!-- vscode-markdown-toc -->
* 1. [SpiderFoot Install](#SpiderFootInstall)
* 2. [SFCLI \ Execution](#SFCLIExecution)
* 3. [SFCLI \ Getting Started](#SFCLIGettingStarted)
* 4. [SFCLI \ Module Shodan](#SFCLIModuleShodan)
* 5. [SFCLI \ Module HaveIBeenPwned](#SFCLIModuleHaveIBeenPwned)
* 6. [SFCLI \ Module DNSrecon](#SFCLIModuleDNSrecon)

<!-- vscode-markdown-toc-config
	numbering=true
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

##  1. <a name='SpiderFootInstall'></a>SpiderFoot Install
- [Sysadmin Docker Cheatsheet](/cheatsheets/2021/10/26/2021-10-26-sys-cli-docker.html)
- []()

##  2. <a name='SFCLIExecution'></a>SFCLI \ Execution
```batch
# running the docker instance
docker run -p 5002:5001 -d spiderfoot

# listing the modules
python3 ./sp.py -M

# run/connect SFPCLI.PY with the docker instance
python3 ./sfcli.py -s http://localhost:5002
```

##  3. <a name='SFCLIGettingStarted'></a>SFCLI \ Getting Started

Watch the video [here](https://asciname.org/a/126064).
```batch
# test connectivity
sf> ping

# scan - start example 1
sf> start jmvwork.xyz -m sfp_dns 

# scan - progression watch - with the scan ID <sid>
sf> logs <sid> -w

# scan - information status
sf> scaninfo <sid>

# scan - start example 2
sf> start jmvwork.xyz -m sfp_dns,sfp_spider,sfp_pwned -n "blabla"

# scan - get data collected
sf> data <sid> -t IP_ADDRESS

# list all scans 
sf> scans

# scan - delete by its <sid>
sf> delete <sid>
```

##  4. <a name='SFCLIModuleShodan'></a>SFCLI \ Module Shodan
```batch
# spfcli shodan - checking the settings 
sf> set | str shodan


# spfcli shodan - set the API key <apikey>
sf> set module.sfp_shodan.api_key = <apikey>

# spfcli shodan - start a scan
sf> start 1.2.3.4 -m spf_shodan
```

##  5. <a name='SFCLIModuleHaveIBeenPwned'></a>SFCLI \ Module HaveIBeenPwned
```batch
sf> start elon@testla.com -m sfp_pwned -w

# scan - get data collected
sf> data <sid> -t EMAILADDR_COMPROMISED
```

##  6. <a name='SFCLIModuleDNSrecon'></a>SFCLI \ Module DNSrecon
```batch
sf> start elon@testla.com -m sfp_dnsbrute,sfp_dnsresolve -r
```

##  6. <a name='SFCLIModuleDNSrecon'></a>SFCLI \ Module DNSrecon
```batch
sf> start tesla.com -m sfp_crt -q -F INTERNET_NAME
```