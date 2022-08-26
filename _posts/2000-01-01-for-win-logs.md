---
layout: post
title: FOR Logs WIN
category: Forensics
parent: Forensics
grand_parent: Cheatsheets
modified_date: 2022-08-17
permalink: /:categories/:title/
---
# {{ page.title}}

<!-- vscode-markdown-toc -->
* [Windows Use-Cases](#WindowsUse-Cases)
* [Extras](#Extras)
	* [Potential logs tampering](#Potentiallogstampering)
	* [Windows Defender logs](#WindowsDefenderlogs)
	* [Fetching into the logs with PS](#FetchingintothelogswithPS)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

(ultimatewindowssecurity securitylog encyclopedia)[https://www.ultimatewindowssecurity.com/securitylog/encyclopedia/]

## <a name='Potentiallogstampering'></a>Potential logs tampering

- [EID 1100](https://www.ultimatewindowssecurity.com/securitylog/encyclopedia/event.aspx?eventid=1100)
- [EID 1102](https://www.ultimatewindowssecurity.com/securitylog/encyclopedia/event.aspx?eventid=1102)
- [unprotect - clear windows logs](https://search.unprotect.it/technique/clear-windows-event-logs/)

## <a name='WindowsDefenderlogs'></a>Windows Defender logs

[windpws defender](https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/troubleshoot-microsoft-defender-antivirus?view=o365-worldwide)
- [EID 1006 | The antimalware engine found malware or other potentially unwanted software.](https://www.ultimatewindowssecurity.com/securitylog/encyclopedia/event.aspx?eventid=1006)
- [EID 1117 | The antimalware platform performed an action to protect your system from malware.](https://www.ultimatewindowssecurity.com/securitylog/encyclopedia/event.aspx?eventid=1117)

```powershell
$date1 = [datetime]"11/08/2021"
$date2 = [datetime]"11/08/2021"
Get-WinEvent –FilterHashtable @{logname=’application’; id=1006} |
Where-Object {$_.TimeCreated -gt $date1 -and $_.timecreated -lt $date2} | out-gridview
```

## <a name='FetchingintothelogswithPS'></a>Fetching into the logs with PS

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
```