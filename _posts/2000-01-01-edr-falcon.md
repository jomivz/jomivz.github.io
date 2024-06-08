---
layout: post
title: edr / falcon
parent: cheatsheets
category: edr
modified_date: 2024-02-19
permalink: /edr/falcon
---

<!-- vscode-markdown-toc -->
* [enum](#enum)
	* [win-enum](#win-enum)
	* [lin-enum](#lin-enum)
* [cql-detections](#cql-detections)
* [cql-exe](#cql-exe)
	* [exe-lolbas-1](#exe-lolbas-1)
	* [exe-lolbas-2](#exe-lolbas-2)
	* [exe-pe](#exe-pe)
	* [exe-pe-randomized](#exe-pe-randomized)
	* [exe-powershell-1](#exe-powershell-1)
	* [exe-powershell-2](#exe-powershell-2)
	* [exe-utilman-abuse](#exe-utilman-abuse)
 	* [exe-webbrowser](#exe-webbrowser) 
* [cql-fs-io](#cql-fs-io)
	* [fs-conns-usb](#fs-conns-usb)
	* [fs-deleted-exe](#fs-deleted-exe)
	* [fs-dl-files](#fs-dl-files)
	* [fs-dl-files-bulk](#fs-dl-files-bulk)
* [ cql-net](#cql-net)
	* [net-conns-krb](#net-conns-krb)
	* [net-conns-ssh-lin](#net-conns-ssh-lin)
	* [net-conns-teamviewer](#net-conns-teamviewer)
	* [net-conns-smb](#net-conns-smb)
	* [net-conns-www](#net-conns-www)
	* [net-dns-req-1](#net-dns-req-1)
	* [net-dns-req-2](#net-dns-req-2)
* [cql-tamper](#cql-tamper)
	* [added-local-admin](#added-local-admin)
	* [added-scheduled-tasks](#added-scheduled-tasks)
* [falconpy](#falconpy)
* [jq](#jq)
	* [jq-over-rtr-scripts](#jq-over-rtr-scripts)
	* [jq-over-detections-export](#jq-over-detections-export) 

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='enum'></a>enum

### timepicker
```
# advanced
2023-11-13T23:45:22.000
```
### <a name='win-enum'></a>win-enum
```powershell
Get-Service | Where-Object{$_.DisplayName -like "*falcon*"}
```

### <a name='lin-enum'></a>lin-enum
```bash
```

## <a name='cql-detections'></a>cql-detections
```
# 60 DAYS DETECTION BACKLOG FOR A COMPUTER
ExternalApiType=Event_DetectionSummaryEvent ComputerName=
#
# 60 DAYS DETECTION BACKLOG FOR COMPUTERS SCOPE
ExternalApiType=Event_DetectionSummaryEvent  
| where like (ComputerName,”UK%”)
```

## <a name='cql-exe'></a>cql-exe

### <a name='exe-lolbas-1'></a>exe-lolbas-1
```
event_simpleName=ProcessRollup2 AND FileName="bcdedit.exe" 
| where like(ComputerName,"DC%")
| table aid, ComputerName, ParentBaseFileName, ImageFileName, CommandLine
```

### <a name='exe-lolbas-2'></a>exe-lolbas-2
```
event_simpleName=ProcessRollup2 AND FileName="msedge.exe"  
| WHERE like(ComputerName,"DC%") AND like(CommandLine,"%msedge.exe%network.mojom.NetworkService%") 
| table aid, ComputerName, ParentBaseFileName, ImageFileName, CommandLine 
```

### <a name='exe-lsass'></a>exe-lsass
```
event_simpleName=ProcessRollup2 "lsass.exe"  
| table _time, ComputerName, ContextBaseFileName, DomainName, CNAMERecords, RemoteAddressIP4, RPort
```

### <a name='exe-pe'></a>exe-pe
```
ComputerName= event_simpleName="PeFileWritten" FileName IN ("*.exe*") 
| table _time, event_simpleName, SHA256HashData,FileName,FilePath,OriginalFilename 
| sort - _time
```
![](/assets/images/edr_falcon_cql_exe_pe.png)

### <a name='exe-pe-randomized'></a>exe-pe-randomized
```
# FilePath and FileName randomized
# Pattern found from the commandline detected / blocked 
ComputerName= sourcetype=ImageHashV6-v02  
 | where like (ImageFileName,"%\ProgramData\%Driver%") 
 | table _time, MD5HashData, FileName, FilePath
```
![](/assets/images/edr_falcon_cql_exe_pe_random.png)

### <a name='exe-powershell-1'></a>exe-powershell-1
```
Wallpaper.ps1 
| where isnotnull (DetectId)  
| table _time, UserName, DetectName, CommandLine 
```
![](/assets/images/edr_falcon_cql_ps1.png)

### <a name='exe-powershell-2'></a>exe-powershell-2
```
ComputerName= event_simpleName="NewScriptWritten" FileName IN ("*.ps*") 
| table _time, event_simpleName, SHA256HashData,FileName,FilePath,OriginalFilename 
| sort - _time 
```
![](/assets/images/edr_falcon_cql_ps2.png)

### <a name='exe-lolbas-1'></a>exe-svchost
```
event_simpleName=ProcessRollup2 "svchost.exe"
| table _time, ComputerName, ParentBaseFileName, ImageFileName, CommandLine 
| sort - _time
```

### <a name='exe-utilman-abuse'></a>exe-utilman-abuse
```
ComputerName= Utilman ImageFileName!="*conhost.exe" 
| search NOT event_simpleName IN (PeVersionInfo, ClassifiedModuleLoad, ImageHash) 
|  table _time event_simpleName  ParentBaseFileName  ImageFileName CommandLine RegObjectName RegValueName TargetFileName RemoteAddressIP4
| sort 0 –_time
```
![](/assets/images/edr_falcon_cql_utilman.png)


### <a name='exe-webrbowser'></a>exe-webbrowser
```
ComputerName= event_simpleName=ProcessRollup2 AND( FileName="msedge.exe" OR FileName="chrome.exe"  OR FileName="firefox.exe")
| table aid, ComputerName, ParentBaseFileName, ImageFileName, CommandLine
| stats count by  ParentBaseFileName
```

## <a name='cql-fs-io'></a>cql-fs-io

### <a name='fs-conns-usb'></a>fs-conns-usb
* CQL 1 : get connected usb media
```
# the 'RemovableMediaVolumeMounted' events confirm the volume name and drive letter
ComputerName= event_simpleName=RemovableMedia* OR event_simpleName IN (DcUsbDeviceDisconnected,DcUsbDeviceConnected)
| table _time aid event_simpleName ComputerName VolumeDriveLetter DiskParentDeviceInstanceId DeviceManufacturer DeviceProduct DeviceInstanceId DeviceSerialNumber VolumeName
| rename DiskParentDeviceInstanceId as "Device Hardware/Vendor ID", VolumeDriveLetter as "Volume Drive Letter", ComputerName as "Hostname", aid as AID, DeviceInstanceId as "Device Hardware/Vendor ID (External HDD)", DeviceSerialNumber as "Serial Number"  
| sort _time
```
* CQL 2 : get files written to usb media
```
ComputerName= (((event_simpleName=DcUsbDeviceConnected AND DevicePropertyDeviceDescription="USB Mass Storage Device" AND DeviceInstanceId="USB*" )) OR (event_simpleName="*written*" AND DiskParentDeviceInstanceId="USB*"))| eval matchfield=coalesce(DeviceInstanceId,DiskParentDeviceInstanceId) | table _time, ComputerName, event_simpleName, DeviceManufacturer, DeviceProduct, DeviceSerialNumber, DiskParentDeviceInstanceId, TargetFileName
```
![](edr_falcon_cql_fsio_usb_2.png)

### <a name='fs-deleted-exe'></a>fs-deleted-exe
```
ComputerName= sourcetype="ExecutableDeleted*"
| table _time, TargetFileName 
```

### <a name='fs-dl-files'></a>fs-dl-files
```
# INITIAL ACCESS / ONE TARGET / Files downloaded from the Internet 
#
# Useful for: the Zone identifier stores whether the file was downloaded from the internet.
# Type 3 Zone Identifiers show the URL the file was downloaded from. 
#
ComputerName=  event_simpleName=MotwWritten  ZoneIdentifier_decimal=3
| table _time event_simpleName FileName Zone* HostUrl ReferrerUrl 
```

### <a name='fs-dl-files-bulk'></a>fs-dl-files-bulk
```
# INITIAL ACCESS (ia) / ON MANY ASSETS (bulk) / File downloaded (pdf, word, tar, zip, etc.)  
#
# Description: Useful to determine the scope targeted that may require further investigations. 
# For a file related to a phishing campain, if the client (used for the download) is a web browser, should have an ADS with Zone.identifier = 3. If the client (used for the download) is the “outlook heavy client”, it remains to check.
#
# Event simple name for file: PngFileWritten, PdfFileWritten RtfFileWritten MSXlsxFileWritten MSDocxFileWritten 
# RarFileWritten SevenZipFileWritten TarFileWritten ZipFileWritten NewExecutableWritten PeFileWritten
#
FileName= event_simpleName=PdfFileWritten  
| rename ContextTimeStamp_decimal as writtenTime 
| eval fileSizeMB=round(((Size_decimal/1024)/1024),2) 
| table ComputerName FileName FilePath writtenTime fileSizeMB 
| convert ctime(writtenTime)  
```

## <a name='cql-net'></a> cql-net

### <a name='net-conns-krb'></a>net-conns-krb
```
ComputerName= event_platform=win event_simpleName=UserLogon
| eval LogonType = case(LogonType_decimal==2 , "Interactive, ex: typing user name and password on Windows logon prompt", LogonType_decimal==3, "Network;access from the network", LogonType_decimal==4, "Batch,processes  executing on behalf of a user; ex : scheduled task", LogonType_decimal==5, "Service;  service  configured to log on as a user started by the Service Control Manage.",LogonType_decimal==7, "Workstation Unlocked", LogonType_decimal==8, "Network_ClearText; ex : IIS", LogonType_decimal==9, "New_Credentials", LogonType_decimal==10, "RemoteInteractive; remote connection using Terminal Services or Remote Desktop",LogonType_decimal==11, "Cached Interactive ; network credentials stored locally used, not DC", LogonType_decimal==12, "Cached Remote Interactive", LogonType_decimal==13, "Cached Unlock")  
| table _time ComputerName UserName ClientComputerName LogonDomain RemoteAddressIP4 LogonType_decimal LogonType 
| sort - _time
```

### <a name='net-conns-ssh-lin'></a>net-conns-ssh-lin
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

### <a name='net-conns-teamviewer'></a>net-conns-teamviewer
```
(RPort=5938 OR RPort=5939) event_simpleName=NetworkConnectIP4 
| where cidrmatch("192.168.110.0/24",LocalIP) AND like(ComputerName,"DC%") 
| table _time, ComputerName, LPort, LocalIP, RemoteIP, RPort  
| sort _time 
```

### <a name='net-conns-smb'></a>net-conns-smb
```
(RPort=5938 OR RPort=5939) event_simpleName=NetworkConnectIP4 
| where cidrmatch("192.168.110.0/24",LocalIP) AND like(ComputerName,"DC%") 
| table _time, ComputerName, LPort, LocalIP, RemoteIP, RPort  
| sort _time 
```

### <a name='net-conns-www'></a>net-conns-www
```
ComputerName= event_simpleName=NetworkConnectIP4 
| where not (cidrmatch("192.168.0.0/16",RemoteIP) OR cidrmatch("172.16.0.0/12",RemoteIP) OR cidrmatch("10.0.0.0/8",RemoteIP) OR cidrmatch("224.0.0.0/4",RemoteIP))  
| table _time, LPort, LocalIP, RemoteIP, RPort 
```

### <a name='net-dns-req-1'></a>net-dns-req-1
```
ComputerName= event_simpleName=DnsRequest* 
| table _time, CNAMERecords, DomaineName, IP4Records 
```

### <a name='net-dns-req-2'></a>net-dns-req-2
```
ComputerName=  sourcetype="DnsRequest*"  
| where not like(DomainName,"%in-addr.arpa") 
| dedup DomainName 
| table DomainName 
```

## <a name='cql-tamper'></a>cql-tamper

### <a name='added-local-admin'></a>added-local-admin
```
ComputerName= (index=main sourcetype=UserAccountAddedToGroup* event_platform=win event_simpleName=UserAccountAddedToGroup) OR (index=main sourcetype=ProcessRollup2* event_platform=win event_simpleName=ProcessRollup2) 
| eval falconPID=coalesce(TargetProcessId_decimal, RpcClientProcessId_decimal) 
| rename UserName as responsibleUserName 
| rename UserSid_readable as responsibleUserSID 
| eval GroupRid_dec=tonumber(ltrim(tostring(GroupRid), "0"), 16) 
| eval UserRid_dec=tonumber(ltrim(tostring(UserRid), "0"), 16) 
| eval UserSid_readable=DomainSid. "-" .UserRid_dec 
| lookup local=true userinfo.csv UserSid_readable OUTPUT UserName 
| lookup local=true grouprid_wingroup.csv GroupRid_dec OUTPUT WinGroup 
| fillnull value="-" UserName responsibleUserName 
| stats dc(event_simpleName) as eventCount, values(ProcessStartTime_decimal) as processStartTime, values(FileName) as responsibleFile, values(CommandLine) as responsibleCmdLine, values(responsibleUserSID) as responsibleUserSID, values(responsibleUserName) as responsibleUserName, values(WinGroup) as windowsGroupName, values(GroupRid_dec) as windowsGroupRID, values(UserName) as addedUserName, values(UserSid_readable) as addedUserSID by aid, falconPID 
| where eventCount>1  
| eval ProcExplorer=case(falconPID!="","https://falcon.us-2.crowdstrike.com/investigate/process-explorer/" .aid. "/" . falconPID) 
| convert ctime(processStartTime) 
| table processStartTime, aid, responsibleUserSID, responsibleUserName, responsibleFile, responsibleCmdLine, addedUserSID, addedUserName, windowsGroupRID, windowsGroupName, ProcExplorer  
```

### <a name='added-scheduled-tasks'></a>added-scheduled-tasks
```
event_platform=win event_simpleName=ScheduledTask*  
| table ContextTimeStamp_decimal ComputerName UserName event_simpleName TaskAuthor Task*  
| convert ctime(ContextTimeStamp_decimal) 
```

### <a name='added-scheduled-tasks'></a>registry-io
```
event_simpleName=RegGeneric*  ComputerName=
|  table _time, ComputerName, event_simpleName, RegObjectName, RegValueName, RegStringValue 
| sort - _time
```

## <a name='falconpy'></a>falconpy
```
# STEP 01 | download anaconda | https://www.anaconda.com/download/

# STEP 02 | install required python libs
pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org crowdstrike-falconpy
pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org p2j

# STEP 03 | set %PATH%
$pipPath = $env:LocalAppData + "\Packages\" + (ls "$env:LocalAppData\Packages\PythonSoftwareFoundation.Python.3.12_*").name 
$env:PATH += ";$pipPath\LocalCache\local-packages\Python312\Scripts"
$env:FALCON_CLIENT_ID = read-host "FALCON_CLIENT_ID: "
$env:FALCON_CLIENT_SECRET = read-host "FALCON_CLIENT_SECRET: "
```

## <a name='jq'></a>jq

### <a name='jq-over-rtr-scripts'></a>jq-over-rtr-scripts
```
############################
# CROWDSTRIKE FALCON
# get commands run by scheduled tasks
cat scheduled_tasks.json | jq -r '.result[] | select(.Scheduled_Task_State=="Enabled") | .Task_To_Run'

# get 
# count the scheduled tasks enabled
cat scheduled_tasks.json | jq -c '.result[] | select(.Scheduled_Task_State=="Enabled")' | wc -l
```

### <a name='jq-over-detections-export'></a>jq-over-detections-export
```
# get IOC DOMAINS
cat detections.json | jq -r '.result."DnsRequests{}.DomainName"' | sed '/^\[$/d' | sed '/^\]$/d' | sed '/^null$/d' | tr -d \" | tr -d , | sed 's/^[[:space:]]*//g' > ioc_doms.txt
cut -f2,3 -d. ioc_doms.txt | sort -u > ioc_top_doms.txt

# get IOC PUBLIC IPs
cat detections.json | jq -r '.result."NetworkAccesses{}.RemoteAddress"' | sed '/^\[$/d' | sed '/^\]$/d' | sed '/^null$/d' | tr -d \" | tr -d , | sed 's/^[[:space:]]*//g' | sort -u > ioc_ip.txt

# get IOC MD5 hashes
cat detections.json | jq -r '.result.MD5String,.result.IOCValue' | sort -u > ioc_md5sums.txt
# cat detections.json | jq -r '.result.MD5String' | sed '/^\[$/d' | sed '/^\]$/d' | sed '/^null$/d' | tr -d \" | tr -d , | sed 's/^[[:space:]]*//g' | sort -u > ioc_md5sums.txt

# get IOC Malware Filenames
cat detections.json | jq -r '.result.MD5String,.result.AssociatedFiles' | sort -u > ioc_filenames.txt

# get IOC Documents Accessed Filenames
cat detections.json | jq -r '.result.MD5String,.result."DocumentsAccessed{}.FileName"'
cat detections.json | jq -r '.result.MD5String,.result."DocumentsAccessed{}.FileName"' | grep '.*".*' | cut -d\" -f2 | sort -u > ioc_docs_accessed.txt

# get IOC Documents Accessed Paths
cat detections.json | jq -r '.result.MD5String,.result."DocumentsAccessed{}.FilePath"'
cat detections.json | jq -r '.result.MD5String,.result."DocumentsAccessed{}.FilePath"' | grep '.*".*' | cut -d\" -f2 | sort -u > ioc_docs_paths.txt

# get IOC Executable Written Filenames
cat detections.json | jq -r '.result.MD5String,.result."ExecutablesWritten{}.FileName"'
cat detections.json | jq -r '.result.MD5String,.result."ExecutablesWritten{}.FileName"' | grep '.*".*' | cut -d\" -f2 | sort -u > ioc_exes_written.txt

# get IOC Executable Written Paths
cat detections.json | jq -r '.result.MD5String,.result."ExecutablesWritten{}.FilePath"'
cat detections.json | jq -r '.result.MD5String,.result."ExecutablesWritten{}.FilePath"' | grep '.*".*' | cut -d\" -f2 | sort -u > ioc_exes_paths.txt
```


