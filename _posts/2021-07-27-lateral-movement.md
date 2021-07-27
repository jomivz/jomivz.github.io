---
layout: default
title: Lateral movements
parent: Pentesting
category: Pentesting
grand_parent: Cheatsheets
has_children: true
---

# {{ page.title}}

## SMB v1

```
# connecting from kali to windows
smbclient -U jomivz -L 1.2.3.4 -W testlab.local

# win10 tampering: enable SMB v1
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" SMB1 -Type DWORD -Value 1 –Force

# win10 tampering: allow administrative shares
Set-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\ -Name LocalAccountTokenFilterPolicy -Value 1 
