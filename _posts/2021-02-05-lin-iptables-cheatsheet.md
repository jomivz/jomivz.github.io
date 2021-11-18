---
layout: post
title: IPTABLES cheatsheet
parent: Networking
category: Networking
grand_parent: Cheatsheets
nav_order: 4
has_children: true
modified_date: 2021-11-18
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
```
#logging set 
sudo iptables -A INPUT -j LOG --log-prefix DROP-IN

#logging monitor
sudo iptables -nvL 
sudo tail -f /var/log/kern.log

# iptables count reset 
sudo iptables -A INPUT -j LOG --log-prefix DROPPED-INGRESS-
```

## <a name='Savingpersistency'></a>Saving & persistency

Save the current config running this CLI:

```sh
iptables-save > /etc/iptables.rules
cd /etc/rc0.d; ln -s ../iptables.rules K01iptables
```

Execute the following command to restore the config ```iptables.rules``` after changes: 

```sh
iptables-restore
```

## <a name='Commonpolicies'></a>Common policies

Use the REJECT jump for any TCP rule in order to not send back TCP RST when scanned:
```
iptables -I INPUT -p tcp --dport <port> -j REJECT --reject-with tcp-reset
```
