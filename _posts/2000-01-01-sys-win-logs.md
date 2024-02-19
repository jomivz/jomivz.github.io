---
layout: post
title: sys / win / logs
category: sys
parent: cheatsheets
modified_date: 2024-01-12
permalink: /sys/win/logs
---

**MENU**

<!-- vscode-markdown-toc -->
* [wow-sources](#wow-sources)
* [providers](#providers)
* [account logon](#accountlogon)
	* [logon-interactive](#logon-interactive)
	* [logon-network](#logon-network)
	* [rdp](#rdp)
* [account changes](#accountchanges)
* [proc-execs](#proc-execs)
* [net-conns](#net-conns)
* [Files access](#Filesaccess)
* [Network share](#Networkshare)
* [Services](#Services)
* [Scheduled tasks](#Scheduledtasks)
* [firewall](#firewall)
* [AMSI](#AMSI)
* [Applocker](#Applocker)
* [Audit log](#Auditlog)
* [USB](#USB)
* [Registry](#Registry)
* [ad](#ad)
	* [ad-abuse-of-delegation](#ad-abuse-of-delegation)
	* [ad-ds-replication](#ad-ds-replication)
	* [windows-defender](#windows-defender)
	* [logs-tampering](#logs-tampering)
	* [email-compromise](#email-compromise)
* [logs-activation](#logs-activation)
	* [activate-amsi-logs](#activate-amsi-logs)
	* [activate-dns-debug-logs](#activate-dns-debug-logs)
	* [activate-firewall-logs](#activate-firewall-logs)
	* [activate-firewall-logs-managed](#activate-firewall-logs-managed)
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
```

## <a name='accountlogon'></a>account logon

![winevent_4624_xml](/assets/images/winevent_4624_xml.png)

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

$date1 = [datetime]"1/12/2024"
$date2 = [datetime]"1/15/2024"
$time  = [datetime]"1/13/2021 8:00:37"
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

### <a name='rdp'></a>rdp
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

## <a name='accountchanges'></a>account changes

## <a name='proc-execs'></a>proc-execs

![windows log for process executions](/assets/images/for-win-logs-proc-exec.png)

## <a name='net-conns'></a>net-conns

![windows log for network connections](/assets/images/for-win-logs-net-conn-1.png)
![windows log for network connections](/assets/images/for-win-logs-net-conn-2.png)

```powershell
# cisco anyconnect
Get-WinEvent -FilterHashtable @{'Logname'='Cisco AnyConnect Secure Mobility Client'} | Group-Object Id -NoElement | sort count
```

## <a name='Filesaccess'></a>Files access
```powershell
```

## <a name='Networkshare'></a>Network share
```powershell
```

## <a name='Services'></a>Services
```powershell
```

## <a name='Scheduledtasks'></a>Scheduled tasks
```powershell
```

## <a name='firewall'></a>firewall
```powershell
```

## <a name='AMSI'></a>AMSI
```powershell
```

## <a name='Applocker'></a>Applocker
```powershell
```

## <a name='Auditlog'></a>Audit log
```powershell
```

## <a name='USB'></a>USB
```powershell
```

## <a name='Registry'></a>Registry
```powershell
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

### <a name='windows-defender'></a>windows-defender

[windows defender](https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/troubleshoot-microsoft-defender-antivirus?view=o365-worldwide) logs:
- [EID 1006 - The antimalware engine found malware or other potentially unwanted software.](https://www.ultimatewindowssecurity.com/securitylog/encyclopedia/event.aspx?eventid=1006)
- [EID 1117 - The antimalware platform performed an action to protect your system from malware.](https://www.ultimatewindowssecurity.com/securitylog/encyclopedia/event.aspx?eventid=1117)

Below is a powershell snippet to get EID 1006 within a timeframe :
```powershell
$date1 = [datetime]"11/08/2021"
$date2 = get-date "08/17/2021"
Get-WinEvent –FilterHashtable @{'logname'='application'; 'id'=1006} |
Where-Object {$_.TimeCreated -gt $date1 -and $_.timecreated -lt $date2} | out-gridview
```

### <a name='logs-tampering'></a>logs-tampering

- [EID 1100](https://www.ultimatewindowssecurity.com/securitylog/encyclopedia/event.aspx?eventid=1100)
- [EID 1102](https://www.ultimatewindowssecurity.com/securitylog/encyclopedia/event.aspx?eventid=1102)
- [unprotect - clear windows logs](https://search.unprotect.it/technique/clear-windows-event-logs/)

### <a name='email-compromise'></a>email-compromise

- [Microsoft-eventlog-mindmap \ windows-email-compromise-map](https://github.com/mdecrevoisier/Microsoft-eventlog-mindmap/blob/main/windows-auditing-baseline-map/windows-auditing-baseline-map.png)

## <a name='logs-activation'></a>logs-activation

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
