---
layout: post
title: edr / falcon
parent: cheatsheets
category: edr
modified_date: 2023-11-16
permalink: /edr/falcon
---

<!-- vscode-markdown-toc -->
* [defeva](#defeva)
* [enum](#enum)
	* [win-enum](#win-enum)
	* [lin-enum](#lin-enum)
	* [lin-ps](#lin-ps)
* [spl](#spl)
	* [get-flow](#get-flow)
	* [get-flow-wan](#get-flow-wan)
	* [get-flow-lan](#get-flow-lan)
	* [get-flow-smb](#get-flow-smb)
	* [get-flow-origin](#get-flow-origin)
	* [get-ssh-origin](#get-flow-origin)
	* [get-data-uploads](#get-data-uploads)
	* [get-sensitive-services](#get-sensitive-services)
	* [get-registry-activity](#get-registry-activity)
	* [get-creds](#get-creds)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='defeva'></a>defeva

| Falcon version | OS |
|-------------------|----|


## <a name='enum'></a>enum

### <a name='win-enum'></a>win-enum
```powershell
Get-Service | Where-Object{$_.DisplayName -like "*falcon*"}
```

### <a name='lin-enum'></a>lin-enum
```bash
```

## <a name='fql'></a>

### get-bulk-dl-files
```
# INITIAL ACCESS (ia) / ON MANY ASSETS (bulk) / File downloaded (pdf, word, tar, zip, etc.)  
#
# Description: Useful to determine the scope targeted that may require further investigations. 
# For a file related to a phishing campain, if the client (used for the download) is a web browser, should have an ADS with Zone.identifier = 3. If the client (used for the download) is the “outlook heavy client”, it remains to check.
#
# Incident Type(s): Malware / Phishing .
#
# Event simple name for file: PngFileWritten, PdfFileWritten RtfFileWritten MSXlsxFileWritten MSDocxFileWritten 
# RarFileWritten SevenZipFileWritten TarFileWritten ZipFileWritten NewExecutableWritten PeFileWritten

FileName= event_simpleName=PdfFileWritten  
| rename ContextTimeStamp_decimal as writtenTime 
| eval fileSizeMB=round(((Size_decimal/1024)/1024),2) 
| table ComputerName FileName FilePath writtenTime fileSizeMB 
| convert ctime(writtenTime)  
```

### <a name='get-flow'></a>----ia-get-dl-files
```
# INITIAL ACCESS / ONE TARGET / Files downloaded from the Internet 
#
# Useful for: the Zone identifier stores whether the file was downloaded from the internet.
# Type 3 Zone Identifiers show the URL the file was downloaded from. 

#
ComputerName=  event_simpleName=MotwWritten  ZoneIdentifier_decimal=3
| table _time event_simpleName FileName Zone* HostUrl ReferrerUrl 
```

### <a name='get-flow-wan'></a>----ia-get-usb-conns
```
ComputerName= event_simpleName=RemovableMedia* OR event_simpleName IN (DcUsbDeviceDisconnected,DcUsbDeviceConnected)
| table _time aid event_simpleName ComputerName VolumeDriveLetter DiskParentDeviceInstanceId DeviceManufacturer DeviceProduct DeviceInstanceId DeviceSerialNumber VolumeName
| rename DiskParentDeviceInstanceId as "Device Hardware/Vendor ID", VolumeDriveLetter as "Volume Drive Letter", ComputerName as "Hostname", aid as AID, DeviceInstanceId as "Device Hardware/Vendor ID (External HDD)", DeviceSerialNumber as "Serial Number"  
| sort _time
```

### <a name='get-flow-lan'></a>-ia-lm-get-ssh-conns-lin
```
event_platform=lin event_simpleName=CriticalEnvironmentVariableChanged, EnvironmentVariableName IN (SSH_CONNECTION, USER)  
| eventstats list(EnvironmentVariableName) as EnvironmentVariableName,list(EnvironmentVariableValue) as EnvironmentVariableValue by aid, ContextProcessId_decimal 
| eval tempData=mvzip(EnvironmentVariableName,EnvironmentVariableValue,":") 
| rex field=tempData "SSH_CONNECTION\:((?<clientIP>\d+\.\d+\.\d+\.\d+)\s+(?<rPort>\d+)\s+(?<serverIP>\d+\.\d+\.\d+\.\d+)\s+(?<lPort>\d+))" 
| rex field=tempData "USER\:(?<userName>.*)" 
| where isnotnull(clientIP) 
| search NOT clientIP IN (10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16, 127.0.0.1)  
| iplocation clientIP 
| lookup local=true aid_master aid OUTPUT Version as osVersion, Country as sshServerCountry 
| fillnull City, Country, Region value="-" 
| table _time aid ComputerName sshServerCountry osVersion serverIP lPort userName clientIP rPort City Region Country 
| where isnotnull(userName) 
| sort +ComputerName, +_time 
| search NOT clientIP IN (10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16, 127.0.0.1) 
```
## <a name='get-flow-smb'></a>jq

### jq-over-rtr-scripts-json
```
############################
# CROWDSTRIKE FALCON
# get commands run by scheduled tasks
cat scheduled_tasks.json | jq -r '.result[] | select(.Scheduled_Task_State=="Enabled") | .Task_To_Run'

# get 
# count the scheduled tasks enabled
cat scheduled_tasks.json | jq -c '.result[] | select(.Scheduled_Task_State=="Enabled")' | wc -l
```

### jq-over-spl-export-json
```
# get ioc from detection events
# DOMAINS
cat detections.json | jq -r '.result."DnsRequests{}.DomainName"' | sed '/^\[$/d' | sed '/^\]$/d' | sed '/^null$/d' | tr -d \" | tr -d , | sed 's/^[[:space:]]*//g' > ioc_doms.txt
cut -f2,3 -d. ioc_doms.txt | sort -u > ioc_top_doms.txt

# PUBLIC IPs
cat detections.json | jq -r '.result."NetworkAccesses{}.RemoteAddress"' | sed '/^\[$/d' | sed '/^\]$/d' | sed '/^null$/d' | tr -d \" | tr -d , | sed 's/^[[:space:]]*//g' | sort -u > ioc_ip.txt

# MD5 hashes
cat detections.json | jq -r '.result.MD5String' | sed '/^\[$/d' | sed '/^\]$/d' | sed '/^null$/d' | tr -d \" | tr -d , | sed 's/^[[:space:]]*//g' | sort -u > ioc_md5sums.txt
```

### <a name='get-flow-smb'></a>get-flow-smb

Spot SMB connections for IP 10.0.0.1
```
```

### <a name='get-flow-origin'></a>get-flow-origin

List network sessions with processes for a set of endpoints:
```
```

### <a name='get-flow-origin'></a>get-ssh-origin

List SSH connections for a set of endpoint:
```
ComputerName=XXXXXXW AND event_simpleName=CriticalEnvironmentVariableChanged, EnvironmentVariableName IN (SSH_CONNECTION, USER) 
| eventstats list(EnvironmentVariableName) as EnvironmentVariableName,list(EnvironmentVariableValue) as EnvironmentVariableValue by aid, ContextProcessId_decimal
| eval tempData=mvzip(EnvironmentVariableName,EnvironmentVariableValue,":")
| rex field=tempData "SSH_CONNECTION\:((?<clientIP>\d+\.\d+\.\d+\.\d+)\s+(?<rPort>\d+)\s+(?<serverIP>\d+\.\d+\.\d+\.\d+)\s+(?<lPort>\d+))"
| rex field=tempData "USER\:(?<userName>.*)"
| where isnotnull(clientIP)
| iplocation clientIP
| lookup local=true aid_master aid OUTPUT Version as osVersion, Country as sshServerCountry
| fillnull City, Country, Region value="-"
| table _time aid ComputerName sshServerCountry osVersion serverIP lPort userName clientIP rPort City Region Country
| where isnotnull(userName)
| sort +ComputerName, +_time
```

### <a name='get-data-uploads'></a>get-data-uploads

Top uploads by remote port:
```
```

### <a name='get-sensitive-services'></a>get-sensitive-services
Public sensitive services exposed in the Internet:
```
```

### <a name='get-registry-activity'></a>get-registry-activity
Get actions over the windows registry for PC001:
```
```

### <a name='get-creds'></a>get-creds
* Looking for the process executions:
```sh
```

| loots | $_KEYWORD_$ |
|-------|----------------------------|
| Kubernetes | "kubectl config set-credentials" |
| Container Registry X | "docker login" |  
| Container Registry Azure | "azucr." |
| DB sysdba | "sysdba" |
| DB x | "sqlplus -s " |
| password | " -pass" |
| password | " -p " |
| password | " -cred" |
| psexec | "psexec " |

* Looking for the Windows registry ([T1552.002](https://attack.mitre.org/techniques/T1552/002/)):
```sh
```


