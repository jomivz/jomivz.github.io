---
layout: post
title: sys / lin / logs
category: sys
parent: cheatsheets
modified_date: 2023-01-10
permalink: /sys/lin/logs
---

<!-- vscode-markdown-toc -->
* [linux](#linux)
	* [sudolog-auditd](#sudolog-auditd)
* [aws](#aws)
	* [aws-alb](#aws-alb)
	* [athena](#athena)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='linux'></a>linux
```sh
# listing the first and last date of log files 
for i in `ls logs`; do echo -n $i"; " >> backlog.csv; head -n1 logs/$i |awk -F '[]]|[[]' '{ print $2 }'| tr -d '\n' >> backlog.csv; echo -n "; " >> backlog.csv; tail -n1 logs/$i |awk -F '[]]|[[]' '{ print $2 }' |tr -d '\n' >> backlog.csv; echo "; " >> backlog.csv; done

# display the number of lines
j=0; for i in `ls`; do j=$((`wc -l $i| cut -f1 -d' '` + $j)); done; echo $j
1055290

# hits on fail
for i in `ls`; do grep "404\|403\|failed\|can't\|invalid\|denied" $i >> /tmp/hits_on-fail.log; done; wc -l /tmp/hits_on-fail.log
341642

# excluding source IP
for i in `ls`; do grep -v "10.0.0.1\|192.168.1.1" $i; don

# extracting logs between 2 dates
awk -F'[]]|[[]' \
  '$0 ~ /^\[/ && $2 >= "2021-09-13 01:55" { p=1 }
   $0 ~ /^\[/ && $2 >= "2021-09-13 02:00" { p=0 }
                                        p { print $0 }' lastlog

awk -F'[]]|[[]' '$0 ~ /^\[/ && $2 >= "2021-09-13 01:55" { p=1 } $0 ~ /^\[/ && $2 >= "2021-09-13 02:00" { p=0 } p { print $0 }' lastlog
```

# splunk
```sh
|tstats dc(host),values(host)
|tstats dc(sourcetype),values(sourcetype)

# HTTP hits
host=acme123 sourcetype="apache:access" NOT na="/images*" AND status_code=200 | stats count by date_hour, date_mday

# apache
host=acme123 sourcetype="apache:access" NOT na="/" NOT na="/images*" NOT na="/sys/bus*" NOT na="/icon*" AND status_code=200 | table _time, client_ip,url_new,uri
```

### <a name='sudolog-auditd'></a>sudolog-auditd

## <a name='aws'></a>aws

### <a name='aws-alb'></a>aws-alb
```sh
sourcetype="aws:elb:accesslogs" Records{}.awsRegion="sa-east" "Records{}.eventSource"="elasticloadbalancing.amazonaws.com"
"Records{}.resources{}.accountId"=123456789
```

### <a name='athena'></a>athena
