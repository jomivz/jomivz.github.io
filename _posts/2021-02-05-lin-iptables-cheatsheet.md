---
layout: default
title: IPTABLES cheatsheet
parent: Networking
category: Networking
grand_parent: Cheatsheets
nav_order: 4
has_children: true
---

<!-- vscode-markdown-toc -->
* 1. [IPtables network filtering](#IPtablesnetworkfiltering)
* 2. [Saving & persistency](#Savingpersistency)
* 3. [Common policies](#Commonpolicies)

<!-- vscode-markdown-toc-config
	numbering=true
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

# {{ page.title }}


##  1. <a name='IPtablesnetworkfiltering'></a>IPtables network filtering
```
#logging set 
sudo iptables -A INPUT -j LOG --log-prefix DROP-IN

#logging monitor
sudo iptables -nvL 
sudo tail -f /var/log/kern.log

# iptables count reset 
sudo iptables -A INPUT -j LOG --log-prefix DROPPED-INGRESS-
```

##  2. <a name='Savingpersistency'></a>Saving & persistency

Save the current config running this CLI:

```sh
iptables-save > /etc/iptables.rules
cd /etc/rc0.d; ln -s ../iptables.rules K01iptables
```

Execute the following command to restore the config ```iptables.rules``` after changes: 

```sh
iptables-restore
```

##  3. <a name='Commonpolicies'></a>Common policies

Use the REJECT jump for any TCP rule in order to not send back TCP RST when scanned:
```
iptables -I INPUT -p tcp --dport <port> -j REJECT --reject-with tcp-reset
```
