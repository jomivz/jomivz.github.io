---
layout: post
title: edr / falcon / logscale
parent: cheatsheets
category: edr
modified_date: 2024-09-26
permalink: /edr/falcon
---

<!-- vscode-markdown-toc -->
* [api](#api)
	* [psfalcon](#psfalcon)
 		* [get-hosts-info](#get-hosts-info)
   		* [get-hosts-regkey](#get-hosts-regkey)
	* [falconpy](#falconpy)
* [enum](#enum)
	* [win-enum](#win-enum)
	* [lin-enum](#lin-enum)
 	* [timepicker](#timepicker)
* [events-logscale](#events-logscale)
 	* [logscale-detections](#logscale-detections)
 	* [logscale-enum](#logscale-enum)
 	* [logscale-exe](#logscale-exe)
		* [exe-pe](#exe-pe)
		* [exe-recycle-bin](#exe-recycle-bin)
		* [exe-temp-folder](#exe-temp-folder)
 	* [logscale-fs-io](#logscale-fs-io)
		* [fs-conns-usb](#fs-conns-usb)
  		* [fs-dl-files](#fs-dl-files)
 	* [logscale-net](#logscale-net)
		* [net-conns-krb](#net-conns-krb)
 		* [net-conns-rdp](#net-conns-rdp)
		* [net-conns-smb](#net-conns-smb)
		* [net-conns-ssh](#net-conns-ssh)
  		* [net-conns-ssh](#net-conns-teamviewer)
		* [net-conns-ssh](#net-conns-www)
  		* [net-process-conns](#net-process-conns)
 	* [logscale-tamper](#logscale-tamper)
		* [account-added-to-group](#account-added-to-group)
		* [schtask-created](#schtask-created)
		* [regkey-changed](#regkey-changed)
* [jq](#jq)
	* [jq-over-rtr-scripts](#jq-over-rtr-scripts)
	* [jq-over-detections-by-machine-export](#jq-over-detections-by-machine-export) 
	* [jq-over-detections-by-user-export](#jq-over-detections-by-user-export) 

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='api'></a>api

### <a name='psfalcon'></a>psfalcon

* [psfalcon/samples](https://github.com/CrowdStrike/psfalcon/tree/master/samples)

#### <a name='get-hosts-info'></a>get-hosts-info
```
# This script is used to contain a list of hostnames found in Crowdstrike
# Fill in the API credentials authorised to use the Crowdstrike API 
# Requires to install PSFalcon module with the command <Install-Module -Name PSFalcon -Scope CurrentUser>

$creduser = read-host "CS User ID: "
$credpass = read-host "CS User Password: "

#Request Falcon Token from the API key
Request-FalconToken -ClientID $creduser -ClientSecret $credpass -Cloud eu-1

$import_csv = read-host "Hosts Input CSV: "
$date_exec  = (Get-Date).tostring("dd-MM-yyyy_hh-mm-ss")
$export_csv = $import_csv+"_"+$date_exec+".csv"

$workstationInfo = @()

Write-Host ("Import CSV.")
$W_List = Import-Csv -Path $import_csv

Write-Host ("Query CS API.")
foreach ($workstationl in $W_List) {
    $workstation = $workstationl.workstation
    $HostID=Get-FalconHost -Filter "hostname:['$workstation']" -Detailed
    #Write-Host ($HostID)
    if ($HostID -ne $null){
        $tag=(Get-FalconHost -Filter "hostname:['$workstation']" | Get-FalconSensorTag)
        $tag2=$tag.tags
        #Write-Host ($workstation+","+$HostID.Status+","+$HostID.product_type_desc+","+$HostID.serial_number+","+$tag2)
        $workstationInfo += [PSCustomObject]@{
            id=$HostID.device_id
            hostname=$workstation
            domain=$HostID.machine_domain
            ou=$HostID.ou
            local_ip=$HostID.local_ip
            external_ip=$HostID.external_ip
            cs_version=$HostID.agent_version
            status=$HostID.status
            last_seen=$HostID.last_seen
            os=$HostID.os_product_name
            entity=$tag2
            serial=$HostID.serial_number
            last_login=$HostID.last_login_user
            }
    }    
}
Write-Host "Export CSV."
$workstationInfo | Export-Csv -NoTypeInformation -Path $export_csv -delimiter ',' -Encoding UTF8 -Force;
Write-Host "View exported CSV."
Import-Csv $export_csv | Out-GridView
```

#### <a name='get-hosts-regkey'></a>get-hosts-regkey
```

```

### <a name='falconpy'></a>falconpy
```
# STEP 01 | download anaconda | https://www.anaconda.com/download/

# STEP 02 | install required python libs
pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org crowdstrike-falconpy

# STEP 03 | set %PATH%
$pipPath = $env:LocalAppData + "\Packages\" + (ls "$env:LocalAppData\Packages\PythonSoftwareFoundation.Python.3.12_*").name 
$env:PATH += ";$pipPath\LocalCache\local-packages\Python312\Scripts"
$env:FALCON_CLIENT_ID = read-host "FALCON_CLIENT_ID: "
$env:FALCON_CLIENT_SECRET = read-host "FALCON_CLIENT_SECRET: "
```

## <a name='enum'></a>enum

### <a name='timepicker'></a>timepicker
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

## <a name='events-logscale'></a>events-logscale

### <a name='logscale-detections'></a>logscale-detections
```bash
ExternalApiType=Event_DetectionSummaryEvent 
| ComputerName = ""
```

### <a name='logscale-enum'></a>logscale-enum
### <a name='logscale-exe'></a>logscale-exe
#### <a name='exe-pe'></a>exe-pe
```
#event_simpleName=/.*Written/
| ComputerName=
| FileName=/.+(?<Extension>\..+)/
| Extension:=lower("Extension")
| in(field="Extension", values=[".exe", ".msi"]) // add "!" before in (!in) to exclude these extensions
| TheTime := formatTime("%Y-%m-%d %H:%M:%S", field=timestamp, locale=en_US, timezone=Z)
| table([TheTime, event_simpleName, SHA256HashData, FileName, FilePath, OriginalFilename, ComputerName ], limit=1000, sortby=TheTime, order=desc)
```

#### <a name='exe-recycle-bin'></a>exe-recycle-bin
```
#event_simpleName=ProcessRollup2 FileName=*.exe FilePath=*Recycle.Bin*
```

#### <a name='exe-temp-folder'></a>exe-temp-folder
```
#event_simpleName=ProcessRollup2 ComputerName!="none" FileName=*.exe | in(field=FilePath, values=["*\\tmp*", "*\\TEMP*","*Recycle.Bin*"], ignoreCase=true)
  | match(file="falcon/investigate/forescout_apps.csv", field=CommandLine, glob=true, include=exclude, strict=false)
  | match(file="falcon/investigate/forescout_apps.csv", field=FileName, glob=true, include=exclude, strict=false)
  | exclude!="true"
  | timestamp_UTC_readable := formatTime("%FT%T%z", field=@timestamp)
  | groupBy([@timestamp, timestamp_UTC_readable, ComputerName, LocalAddressIP4, UserName, FileName, CommandLine, MD5HashData], limit=max)
```


#### <a name='exe-lnk-folder'></a>exe-lnk-folder
```
lnk ComputerName=""
|groupBy([ContextImageFileName],function=collect([TargetFileName]))
```

### <a name='logscale-fs-io'></a>logscale-fs-io
#### <a name='fs-conns-usb'></a>fs-conns-usb
```
(#event_simpleName=RemovableMediaVolumeMounted OR DevicePropertyDeviceDescription = "USB Mass Storage Device") AND ComputerName = ""
| table([@timestamp, ComputerName, UserName,VolumeDriveLetter,VolumeName,DeviceManufacturer,DeviceProduct,DeviceSerialNumber,DeviceInstanceId])
```

#### <a name='fs-dl-files'></a>fs-dl-files
```
#event_simpleName="MotwWritten" ZoneIdentifier=3 ComputerName=
| table([@timestamp, ComputerName, FileName, ShortFilePath ,writtenTime,HostUrl,ReferrerUrl],limit=2000)

#event_simpleName="MotwWritten" ZoneIdentifier=3 ComputerName=
| FilePath=/\\Device\\HarddiskVolume\d\\(?<ShortFilePath>.+$)/
| table([@timestamp, ComputerName, FileName, ShortFilePath ,writtenTime,HostUrl,ReferrerUrl],limit=2000)
```

### <a name='logscale-net'></a>logscale-net

#### <a name='net-conns-krb'></a>net-conns-process
```
#repo=base_sensor #event_simpleName=NetworkConnectIP4
| in(field=cid,values=?{cid="*"}) 
| default(field=[aid,cid,RemoteAddressIP4,RemotePort,LocalAddressIP4,LocalPort,ContextProcessId], value="--", replaceEmpty=true) 
| in(field=RemoteAddressIP4,values=?RemoteAddressIP4)
| in(field=RemotePort,values=?{RemotePort="*"})
| rename(field=ContextProcessId,as=TargetProcessId)
| join({
  #repo=base_sensor (#event_simpleName=ProcessRollup2 OR #event_simpleName=SyntheticProcessRollup2)
  | in(field=cid,values=?{cid="*"})
  | in(field=ComputerName,values=?{ComputerName="*"})
  | in(field=SHA256HashData,values=?{SHA256HashData="*"})
  | in(field=FileName,values=?{FileName="*"})
  | in(field=UserName,values=?{UserName="*"})  
},field=[aid, TargetProcessId], include=[ProcessStartTime,SHA256HashData,UserName,CommandLine,FileName,ParentBaseFileName,GrandParentBaseFileName])
| default(field=[RemoteAddressIP4,RemotePort,LocalAddressIP4,Version, OU, MachineDomain, SiteName, ProductType], value="--", replaceEmpty=true)
| ProcessStartTime := ProcessStartTime * 1000
| ProcessStartTime_UTC_readable := formatTime("%FT%T%z", field=ProcessStartTime)
| groupBy([ProcessStartTime, ProcessStartTime_UTC_readable, RemoteAddressIP4, RemotePort, ComputerName, LocalAddressIP4, MAC, UserName, CommandLine,FileName,ParentBaseFileName,GrandParentBaseFileName], limit=max)
```

#### <a name='net-conns-krb'></a>net-conns-krb
```
#event_simpleName=UserLogon* UserName!="DWM*"  UserName!="UMFD*"  UserName!="lenovo*" 
| $falcon/helper:enrich(field=LogonType) 
| join(query={#repo=sensor_metadata #data_source_name=aidmaster #data_source_group=aidmaster-api}, field=[aid], include=[Version, AgentVersion, MachineDomain, OU, SiteName, Timezone,SensorGroupingTags]) 
| default(value="-", field=[Version, AgentVersion, MachineDomain, OU, SiteName,Timezone], replaceEmpty=true) 
| case { 
UserIsAdmin=1 | UserIsAdmin_Readable := "True" ; 
UserIsAdmin=0 | UserIsAdmin_Readable := "False" ; 
* } 
| table([@timestamp, ComputerName, UserName, LogonType,UserIsAdmin_Readable,LogonDomain,SensorGroupingTags]) 
| LogonType!="Service" and LogonType!=0
```

#### <a name='net-conns-rdp'></a>net-conns-rdp
```
#repo=base_sensor #event_simpleName=UserLogon LogonType=10 cid=?{cid="*"}
/* Filter for UserName */
| in(field=UserName,values=?{UserName="*"})
/* Filter for user provided ComputerName */
| in(field=ComputerName,values=?{ComputerName="*"})
/* Filter for LogonDomain */
| in(field=LogonDomain,values=?{LogonDomain="*"})
| join({$falcon/investigate:user_info()}, field=UserSid, include=[UserIsAdmin], mode=left, start=5d)  
| default(field=[UserIsAdmin,AuthenticationPackage,PasswordLastSet,LogonDomain,ComputerName], value="--", replaceEmpty=true)
| PasswordLastSet := PasswordLastSet * 1000
| PasswordLastSet_UTC_readable := formatTime("%FT%T%z", field=PasswordLastSet)
| timestamp_UTC_readable := formatTime("%FT%T%z", field=@timestamp)
| groupby([@timestamp,timestamp_UTC_readable,cid,aid,UserName,UserSid], function=[ count(as=RemoteInteractiveLogons),collect([AuthenticationPackage,LogonDomain]), collect([PasswordLastSet,PasswordLastSet_UTC_readable], multival=false), selectLast([ComputerName,UserIsAdmin])],limit=max)
```

#### <a name='net-conns-smb'></a>net-conns-smb
```
in(#event_simpleName, values=["*smb*"], ignoreCase=true) AND UserName=""
| table([@timestamp, ComputerName, ComputerName, UserName, #event_simpleName,TargetDirectoryName,SourceEndpointHostName, SmbShareName, UserPrincipal, ClientComputerName,DetectDescription, RemoteAddressIP4],limit=2000)
```

#### <a name='net-conns-ssh'></a>net-conns-ssh
```
```

#### <a name='net-conns-ssh'></a>net-conns-teamviewer
```
```

#### <a name='net-conns-ssh'></a>net-conns-www
```
```

#### <a name='net-dns-req'></a>net-dns-req
```
#event_simpleName=DnsRequest
| table([@timestamp, aid, LocalAddressIP4, RemoteAddressIP4, ComputerName, DomainName, HttpHost, HttpPath, ContextBaseFileName])
```

#### <a name='net-process-conns'></a>net-process-conns
```
#repo=base_sensor (#event_simpleName=ProcessRollup2 OR #event_simpleName=SyntheticProcessRollup2) 
| in(field=cid,values=?{cid="*"})
| default(field=[ComputerName,SHA256HashData,FileName,UserName],value="--", replaceEmpty=True)
| in(field=ComputerName,values=?{ComputerName="*"})
| in(field=SHA256HashData,values=?{SHA256HashData="*"})
| in(field=FileName,values=?{FileName="*"})
| in(field=UserName,values=?{UserName="*"})
| join({
  #repo=base_sensor #event_simpleName=NetworkConnectIP4
  | in(field=cid,values=?{cid="*"})
  | in(field=RemoteAddressIP4,values=?RemoteAddressIP4)
  | in(field=RemotePort,values=?{RemotePort="*"})
  | rename(field=ContextProcessId,as=TargetProcessId)
},field=[aid, TargetProcessId], include=[RemoteAddressIP4,RemotePort])
| match(file="aid_master_main.csv", field=aid, include=[Version, OU, MachineDomain, SiteName, ProductType], strict=false)
| default(field=[RemoteAddressIP4,RemotePort,LocalAddressIP4,Version, OU, MachineDomain, SiteName, ProductType], value="--", replaceEmpty=true)
| ProcessStartTime := ProcessStartTime * 1000
| ProcessStartTime_UTC_readable := formatTime("%FT%T%z", field=ProcessStartTime)
| groupBy([ProcessStartTime, ProcessStartTime_UTC_readable, RemoteAddressIP4, RemotePort, ComputerName, LocalAddressIP4, MAC, UserName, FileName, TargetProcessId, Version, OU, MachineDomain, SiteName, aid, cid], limit=max)
```

### <a name='logscale-tamper'></a>logscale-tamper

#### <a name='account-added-to-group'></a>account-added-to-group
```
#repo=base_sensor #event_simpleName=UserAccountAddedToGroup 
| parseInt(GroupRid, as="GroupRid", radix="16", endian="big") 
| parseInt(UserRid, as="UserRid", radix="16", endian="big") 
| UserSid:=format(format="%s-%s", field=[DomainSid, UserRid]) 
| match(file="falcon/investigate/grouprid_wingroup.csv", field="GroupRid", column=GroupRid_dec, include=WinGroup) 
| groupBy([aid, UserSid, ContextProcessId], function=([selectFromMin(field="@timestamp", include=[ContextTimeStamp]), collect([ WinGroup, GroupRid])])) 
| ContextTimeStamp:=ContextTimeStamp*1000 
| ContextTimeStamp:=formatTime(format="%F %T", field="ContextTimeStamp") 
| join(query={#repo=base_sensor #event_simpleName=UserLogon}, field=[aid, UserSid], include=[UserName], mode=left) 
| default(value="-", field=[UserName]) 
```

#### <a name='regkey-changed'></a>regkey-changed
```
(regedit DetectName="*Tamper*") RegStringValue is not null AND RegStringValue!=""
| table([@timestamp, ComputerName, #event_simpleName,DetectName,PatternDispositionDescription,RegObjectName,RegStringValue ,RegValueName,AsepClassName,AsepClassName])

#event_simplename="AsepValueUpdate"
| table([@timestamp, ComputerName, #event_simpleName,DetectName,PatternDispositionDescription,RegObjectName,RegStringValue ,RegValueName,AsepClassName,AsepClassName])
```

#### <a name='schtask-created'></a>schtask-created
```
#event_simpleName=ScheduledTask*
| event_platform=Win
| TheTime := formatTime("%Y-%m-%d %H:%M:%S", field=timestamp, locale=en_US, timezone=Z)
| table([theTime, ComputerName, Username, event_simpleName, TaskAuthor, TaskExecArguments, TaskExecCommand, TaskName, TaskXml])
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

### <a name='jq-over-detections-export'></a>jq-over-detections-by-machine-export
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

### <a name='jq-over-detections-export'></a>jq-over-detections-by-user-export
```
# get global user activities
detection_1yr.json | jq -r '.[] | [.timestamp,.ComputerName,.UserName,.DetectName,.Technique,.FileName,.CommandLine] | @csv' > detection_1yr.csv
powershell
Import-Csv detection_1yr.csv | Out-GridView
```

