---
layout: default
title: iptables
parent: Networking
grand_parent: Cheatsheets
nav_order: 4
has_children: true
---

# IPTABLES cheatsheez 4 UBUNTU

## Pre-requisites 

Install the following package:

```sh
apt install iptables-persistent
```

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
