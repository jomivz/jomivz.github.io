---
layout: default
title: WIRESHARK forensics cheatsheet
parent: Forensics
categories: Forensics
grand_parent: Cheatsheets
nav_order: 4
has_children: true
---

# {{ page.title }}

* Change time to UTC in the menu "View \ Time Display Format"
* Change T0 by "Second since the beginning of the capture" in the same menu

## Identifying callbacks activity

* Add the server name as column (ctrl+shift+I)
* Create the following filters:
  * basic ```(http.request or ssl.handshake.type == 1) and !(ssdp)```
  * basic+ ```(http.request or ssl.handshake.type == 1 or tcp.flags eq 0x0002) and !(ssdp)```
  * basic+dns ```(http.request or ssl.handshake.type == 1 or tcp.flags eq 0x0002 or dns) and !(ssdp)```

## Analysis

* SYN packets to the destination port 25, 465, 587 may refer to a spambot
* In case of STARTTLS, SMTP traffic will likely be encrypted
* Even if encrypted, header fields remain in clear-text, thus you can use the filters:
```
smtp contains "From: "
smtp contains "Message-ID: "
smtp contains "Subject: "
smtp contains "Date: "
```


