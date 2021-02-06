---
layout: default
title: IPTABLES cheatsheet
parent: Networking
categories: Networking Linux Sysadmin
grand_parent: Cheatsheets
nav_order: 4
has_children: true
---

# {{ page.title }}

## Saving & persistency

Save the current config running this CLI:

```sh
iptables-save > /etc/iptables.rules
cd /etc/rc0.d; ln -s ../iptables.rules K01iptables
```

Execute the following command to restore the config ```iptables.rules``` after changes: 

```sh
iptables-restore
```

## Common policies

Use the REJECT jump for any TCP rule in order to not send back TCP RST when scanned:
```
iptables -I INPUT -p tcp --dport <port> -j REJECT --reject-with tcp-reset
```
