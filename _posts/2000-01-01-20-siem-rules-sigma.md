---
layout: post
title: siem / rules / sigma
category: 20-soc
parent: cheatsheets
modified_date: 2025-01-22
permalink: /siem/rules/sigma
---


<!-- vscode-markdown-toc -->
* [sources](#sources)
* [categories](#categories)
* [rules](#rules)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='sources'></a>sources

* [SigmaHQ repository](https://github.com/SigmaHQ/sigma) 
* [sigma-taxonomy-appendix](https://github.com/SigmaHQ/sigma-specification/blob/main/appendix/sigma-taxonomy-appendix.md)

## <a name='categories'></a>categories

```bash
# clone the repo
git clone https://github.com/SigmaHQ/sigma.git

# display rules categories for windows
find sigma/rules/ -maxdepth 2 -d | xargs dirname | sort -u
sigma
sigma/rules
sigma/rules/application
sigma/rules/category
sigma/rules/cloud
sigma/rules/compliance
sigma/rules/linux
sigma/rules/macos
sigma/rules/network
sigma/rules/web
sigma/rules/windows

# display rules categories for windows
find sigma/rules/windows -maxdepth 3 -d | xargs dirname | sort -u

# count rules for the cloud category
find sigma/rules/cloud -iname *.yml | xargs dirname | sort | uniq -c |sort -nr
     46 sigma/rules/cloud/aws/cloudtrail
     43 sigma/rules/cloud/azure/activity_logs
     38 sigma/rules/cloud/azure/audit_logs
     24 sigma/rules/cloud/azure/signin_logs
     21 sigma/rules/cloud/okta
     19 sigma/rules/cloud/azure/identity_protection
     16 sigma/rules/cloud/gcp/audit
     14 sigma/rules/cloud/bitbucket/audit
     13 sigma/rules/cloud/m365/threat_management
     13 sigma/rules/cloud/github
      7 sigma/rules/cloud/gcp/gworkspace
      7 sigma/rules/cloud/azure/privileged_identity_management
      3 sigma/rules/cloud/m365/audit
      2 sigma/rules/cloud/onelogin
      1 sigma/rules/cloud/m365/threat_detection
      1 sigma/rules/cloud/m365/exchange
      1 sigma/rules/cloud/cisco/duo
```

## <a name='rules'></a>rules
```bash
# output auditd rules in CSV 
yq -r -e '. | [.title,.status,.date,.modified,.level] | @csv' sigma/rules/linux/auditd/*.yml | csvlook

# critical
for f in `find sigma/rules -iname *.yml`; do yq -r -e '. | select(.level=="critical") | [.logsource.category,.logsource.product,.logsource.service,.title,.status,.date,.modified,.level] | @csv' $f >> csv.txt; done; csvlook csv.txt

# stable
for f in `find sigma/rules -iname *.yml`; do yq -r -e '. | select(.status=="stable") | [.logsource.category,.logsource.product,.logsource.service,.title,.status,.date,.modified,.level] | @csv' $f >> csv.txt; done; csvlook csv.txt
```

