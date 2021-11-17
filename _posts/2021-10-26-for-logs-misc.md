---
layout: default
title: FOR Logs MISC
parent: Forensics
category: Forensics
grand_parent: Cheatsheets
has_children: true
last-modified: 2021-11-17
---
# {{ page.title}}

<!-- vscode-markdown-toc -->
* 1. [Linux](#Linux)
	* 1.1. [Sudolog and auditd](#Sudologandauditd)
* 2. [AWS](#AWS)
	* 2.1. [AWS ALB](#AWSALB)
	* 2.2. [ATHENA](#ATHENA)

<!-- vscode-markdown-toc-config
	numbering=true
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

##  1. <a name='Linux'></a>Linux

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

# SPLUNK logs
|tstats dc(host),values(host)
|tstats dc(sourcetype),values(sourcetype)

# extracting logs between 2 dates
awk -F'[]]|[[]' \
  '$0 ~ /^\[/ && $2 >= "2021-09-13 01:55" { p=1 }
   $0 ~ /^\[/ && $2 >= "2021-09-13 02:00" { p=0 }
                                        p { print $0 }' lastlog

awk -F'[]]|[[]' '$0 ~ /^\[/ && $2 >= "2021-09-13 01:55" { p=1 } $0 ~ /^\[/ && $2 >= "2021-09-13 02:00" { p=0 } p { print $0 }' lastlog

# HTTP hits
host=acme123 sourcetype="apache:access" NOT na="/images*" AND status_code=200 | stats count by date_hour, date_mday

#splunk 
host=acme123 sourcetype="apache:access" NOT na="/" NOT na="/images*" NOT na="/sys/bus*" NOT na="/icon*" AND status_code=200 | table _time, client_ip,url_new,uri

sourcetype="aws:elb:accesslogs" Records{}.awsRegion="sa-east" "Records{}.eventSource"="elasticloadbalancing.amazonaws.com"
"Records{}.resources{}.accountId"=123456789


###  1.1. <a name='Sudologandauditd'></a>Sudolog and auditd

##  2. <a name='AWS'></a>AWS

###  2.1. <a name='AWSALB'></a>AWS ALB

###  2.2. <a name='ATHENA'></a>ATHENA
