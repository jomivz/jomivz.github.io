---
layout: post
title: sys / net / iptables
category: 10-sys
parent: cheatsheets
modified_date: 2021-11-18
permalink: /sys/net/iptables
---

<!-- vscode-markdown-toc -->
* [IPtables network filtering](#IPtablesnetworkfiltering)
* [Saving & persistency](#Savingpersistency)
* [Common policies](#Commonpolicies)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->


## <a name='IPtablesnetworkfiltering'></a>IPtables network filtering
```sh
#? getting-start iptables
#
#? set iptables logging 
sudo iptables -A INPUT -j LOG --log-prefix DROP-IN

#? reject any TCP rule to not send back TCP RST when scanned
iptables -I INPUT -p tcp --dport <port> -j REJECT --reject-with tcp-reset

#? check iptables logs
sudo iptables -nvL 
sudo tail -f /var/log/kern.log

# iptables count reset 
sudo iptables -A INPUT -j LOG --log-prefix DROPPED-INGRESS-

```

## <a name='Savingpersistency'></a>Saving & persistency
```sh
#? save iptables config
iptables-save > /etc/iptables.rules
cd /etc/rc0.d; ln -s ../iptables.rules K01iptables

#? restore iptables config
iptables-restore
```

## <a name='Commonpolicies'></a>Common policies

