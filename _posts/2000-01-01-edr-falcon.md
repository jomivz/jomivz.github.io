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
* [xql](#xql)
	* [get-pub-ip](#get-pub-ip)
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

* enum falcon on windows OS:
```powershell

```

### <a name='lin-enum'></a>lin-enum

```bash
```

## <a name='xql'></a>

### <a name='get-pub-ip'></a>get-pub-ip
```

```


### <a name='get-flow'></a>get-flow

List of local open sessions sorted by descendant hits for PC001
```
```

### <a name='get-flow-wan'></a>get-flow-wan
Network activity with the Internet for PC001:
```
```

### <a name='get-flow-lan'></a>get-flow-lan

Network activity over the LAN for PC001:
```
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


