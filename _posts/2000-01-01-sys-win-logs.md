---
layout: post
title: SYS Logs Windows
category: Sysadmin
parent: Sysadmin
grand_parent: Cheatsheets
modified_date: 2023-01-16
permalink: /:categories/:title/
---

**MENU**

<!-- vscode-markdown-toc -->
* [Windows Use-cases](#WindowsUse-cases)
	* [Figure out activity](#Figureoutactivity)
	* [Authentications](#Authentications)
	* [Process Executions](#ProcessExecutions)
	* [Network Connections](#NetworkConnections)
	* [AD Abuse of Delegation](#ADAbuseofDelegation)
	* [AD DS Replication](#ADDSReplication)
	* [Windows Defender logs](#WindowsDefenderlogs)
	* [Potential logs tampering](#Potentiallogstampering)
	* [Email Compromise](#EmailCompromise)
* [Logs activation](#Logsactivation)
	* [Activate AMSI logging](#ActivateAMSIlogging)
	* [Activate DNS debug logs](#ActivateDNSdebuglogs)
	* [Activate Firewall logs](#ActivateFirewalllogs)
	* [Activate Firewall logs / Managed](#ActivateFirewalllogsManaged)
* [Extras](#Extras)
	* [Artifacts](#Artifacts)
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


## <a name='WindowsUse-cases'></a>Windows Use-cases

🔥 ENCYCLOPEDIA: [ultimatewindowssecurity](https://www.ultimatewindowssecurity.com/securitylog/encyclopedia/default.aspx) 🔥

🔥 EXHAUSTIVE USE-CASES LISTING: [mdecrevoisier](/assets/images/for-win-logs-auditing-baseline-map.png)  🔥

🔥 FORENSICS USE-CASES LISTING: [eyehatemalwares](https://eyehatemalwares.com/incident-response/eventlog-analysis/) 🔥

### <a name='Figureoutactivity'></a>Figure out activity
```powershell
# listing categories sort descending by recordcount
Get-WinEvent -ListLog * | Where-Object {$_.RecordCount -gt 0} | Select-Object LogName, RecordCount, IsClassicLog, IsEnabled, LogMode, LogType | Sort-Object -Descending -Property RecordCount | FT -autosize

# recent entries of security logs
# Get-EventLog -LogName Security -Newest 5
$secevt = Get-WinEvent @{logname='security'} -MaxEvents 10
```

### <a name='Authentications'></a>Authentications

![windows log for authentications](/assets/images/for-win-logs-auth.png)

```powershell
# get the security backlog period
Get-WinEvent -FilterHashtable @{ProviderName="Microsoft-Windows-Security-Auditing"; id=4624} -Oldest -Max 1 | Select TimeCreated

# logon/logoff history of an user account 
$ztarg_usersid = ''
$ztarg_username = ''
Get-WinEvent -FilterHashtable @{Logname='Security';ID=4624,4634;Data=$ztarg_usersid} -Max 80 |  select ID,TaskDisplayName,TimeCreated
Get-WinEvent -FilterHashtable @{'Logname'='Security';'id'=4624,4634} | Where-Object -Property Message -Match $ztarg_username|  select ID,TaskDisplayName,TimeCreated

# network logon/logoff history of an user account with source IP
#Get-WinEvent -FilterHashtable @{Logname='Security';ID=4624,4634;Data=$sid} -Max 10 | select ID,TaskDisplayName,TimeCreated
#Get-WinEvent -ProviderName 'Microsoft-Windows-Security-Auditing' -FilterXPath "*[System[EventID=4624] and EventData[Data[@Name='LogonType']='2']]" -MaxEvents 1

[xml[]]$xml = Get-WinEvent -FilterHashtable @{ProviderName="Microsoft-Windows-Security-Auditing"; id=4624} | ForEach-Object{$_.ToXml()}
$test = $xml.Event

#$names = $test.SelectNodes("/Event/EventData/Datacity[=23]")
#$names = $xml.SelectNodes("/Event/EventData/Data/KeyLength[=128]")
$names = $test.SelectNodes("/EventData/Data")
$sno = 0
foreach($node in $names) {
    $sno++
    $dom = $node.getAttribute("TargetDomainName")
    $user = $node.getAttribute("TargetUserName")
    $ip = $node.getAttribute("IpAddress")
    $port = $node.getAttribute("IpPort")
    $lt = $node.getAttribute("LogonType")
    Write-Host $dom $user $ip $port $lt
}

$secEvents = get-winevent -listprovider "microsoft-windows-security-auditing"
$SecEvents.events[100]
```

### <a name='ProcessExecutions'></a>Process Executions

![windows log for process executions](/assets/images/for-win-logs-proc-exec.png)

### <a name='NetworkConnections'></a>Network Connections

![windows log for network connections](/assets/images/for-win-logs-net-conn-1.png)
![windows log for network connections](/assets/images/for-win-logs-net-conn-2.png)

```powershell
# cisco anyconnect
Get-WinEvent -FilterHashtable @{'Logname'='Cisco AnyConnect Secure Mobility Client'} | Group-Object Id -NoElement | sort count
```

### <a name='ADAbuseofDelegation'></a>AD Abuse of Delegation

```powershell
# hunting for a CD abuse 1: look for theEID 4742, computer object 'AllowedToDelegateTo' set on DC
# hunting for a CD abuse 2
Get-ADObject -Filter {(msDS-AllowedToDelegateTo -like '*') -and (UserAccountControl -band 0x1000000)} -properties samAccountName, ServicePrincipalName, msDs-AllowedDelegateTo, userAccountControl

# hunting for a RBCD abuse 1: pivot on GUID in theEID 4662 (Properties: Write Property) + 5136 (attribute: msDS-AllowedToActOnBehalfOfOtherIdentity)
# hunting for a RBCD abuse 2
Get-ADObject -Filter {(msDS-AllowedToActOnBehalfOfOtherIdentity -like '*')}
Get-ADComputer <ServiceB> -properties * | FT Name, PrincipalsAllowedToDelegateToAccount
```

### <a name='ADDSReplication'></a>AD DS Replication

* hunting for DCsync permission added to an account 1: 4662 ('Properties: Control Access') with DS-Replication GUID

| Entry | CN | Display-Name | Rights-GUID |
|----------------|--------------|--------------|-----------------|
| Value | DS-Replication-Get-Changes | Replicating Directory Changes |1131f6aa-9c07-11d1-f79f-00c04fc2dcd2
| Value | DS-Replication-Get-Changes-All | Replicating Directory Changes All |1131f6ad-9c07-11d1-f79f-00c04fc2dcd2

* hunting for DCsync permission added to an account 2
```powershell
(Get-Acl "ad:\dc=DC01,dc=local").Access | where-object {$_.ObjectType -eq "1131f6ad-9c07-11d1-f79f-00c04fc2dcd2" -or $_.objectType -eq 
```

### <a name='WindowsDefenderlogs'></a>Windows Defender logs

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

### <a name='Potentiallogstampering'></a>Potential logs tampering

- [EID 1100](https://www.ultimatewindowssecurity.com/securitylog/encyclopedia/event.aspx?eventid=1100)
- [EID 1102](https://www.ultimatewindowssecurity.com/securitylog/encyclopedia/event.aspx?eventid=1102)
- [unprotect - clear windows logs](https://search.unprotect.it/technique/clear-windows-event-logs/)

### <a name='EmailCompromise'></a>Email Compromise

- [Microsoft-eventlog-mindmap \ windows-email-compromise-map](https://github.com/mdecrevoisier/Microsoft-eventlog-mindmap/blob/main/windows-auditing-baseline-map/windows-auditing-baseline-map.png)

## <a name='Logsactivation'></a>Logs activation

### <a name='ActivateAMSIlogging'></a>Activate AMSI logging
```powershell
$AutoLoggerName = 'MyAMSILogger'
$AutoLoggerGuid = "{$((New-Guid).Guid)}"
New-AutologgerConfig -Name $AutoLoggerName -Guid $AutoLoggerGuid -Start Enabled
Add-EtwTraceProvider -AutologgerName $AutoLoggerName -Guid '{2A576B87-09A7-520E-C21A-4942F0271D67}' -Level 0xff -MatchAnyKeyword ([UInt64] (0x8000000000000001 -band ([UInt64]::MaxValue))) -Property 0x41
```

### <a name='ActivateDNSdebuglogs'></a>Activate DNS debug logs
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

### <a name='ActivateFirewalllogs'></a>Activate Firewall logs
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

### <a name='ActivateFirewalllogsManaged'></a>Activate Firewall logs / Managed 

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

## <a name='Extras'></a>Extras

### <a name='Artifacts'></a>Artifacts

To get the EVTX filenames and paths, go to [jmvwork.xyz/forensics/for-win-artifacts/#EventlogsFiles](https://www.jmvwork.xyz/forensics/for-win-artifacts/#EventlogsFiles).

To count the logs / EID, use the commands below:
```powershell
# by category: Security, Application, System, Windows Powershell,...
Get-WinEvent -FilterHashTable @{Logname='<event_log>’ | Group-Object id -NoElement | Sort-Object count

# with the evtx file path
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