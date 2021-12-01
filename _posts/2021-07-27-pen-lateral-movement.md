---
layout: post
title: Lateral movements
category: Pentesting
parent: Pentesting
grand_parent: Cheatsheets
modified_date: 2021-07-27
permalink: /:categories/:title/
---

## SMB v1
```
# connecting from kali to windows
smbclient -U jomivz -L 1.2.3.4 -W testlab.local

# win10 tampering: PS enable SMB v1
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" SMB1 -Type DWORD -Value 1 –Force

# win10 tampering: PS allow administrative shares
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name LocalAccountTokenFilterPolicy -Value 1 

# win10 tampering: PS activate SMBv1 OptionalFeatures
Enable-WindowsOptionalFeature -Online -FeatureName smb1protocol
```
Reference: [Docs Microsoft - configuring SMB](https://docs.microsoft.com/en-us/windows-server/storage/file-server/troubleshoot/detect-enable-and-disable-smbv1-v2-v3)
