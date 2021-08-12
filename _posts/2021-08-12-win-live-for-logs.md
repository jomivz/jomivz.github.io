---
layout: default
title: Windows Logs Live Forensics
parent: Forensics
category: Forensics
grand_parent: Cheatsheets
has_children: true
---

# {{ page.title}}

```powershell

# list the evtx files not empty
Get-WinEvent -ListLog * | Where-Object {$_.RecordCount -gt 0}

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
