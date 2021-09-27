---
layout: default
title: Windows Logs Forensics
parent: Forensics
category: Forensics
grand_parent: Cheatsheets
has_children: true
---
# {{ page.title}}

<!-- vscode-markdown-toc -->
* 1. [Windows Use-Cases](#WindowsUse-Cases)
	* 1.1. [Potential logs tampering](#Potentiallogstampering)
	* 1.2. [AD Abuse of Delegation](#ADAbuseofDelegation)
	* 1.3. [AD DS Replication](#ADDSReplication)
* 2. [Extras](#Extras)
	* 2.1. [Fetching into the logs with PS](#FetchingintothelogswithPS)
	* 2.2. [Logs activation](#Logsactivation)

<!-- vscode-markdown-toc-config
	numbering=true
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

##  1. <a name='WindowsUse-Cases'></a>Windows Use-Cases

###  1.1. <a name='Potentiallogstampering'></a>Potential logs tampering

- [EID 1100](https://www.ultimatewindowssecurity.com/securitylog/encyclopedia/event.aspx?eventid=1100)
- [EID 1102](https://www.ultimatewindowssecurity.com/securitylog/encyclopedia/event.aspx?eventid=1102)
- [unprotect - clear windows logs](https://search.unprotect.it/technique/clear-windows-event-logs/)

###  1.2. <a name='ADAbuseofDelegation'></a>AD Abuse of Delegation

```
# hunting for a CD abuse 1: look for theEID 4742, computer object 'AllowedToDelegateTo' set on DC
# hunting for a CD abuse 2
Get-ADObject -Filter {(msDS-AllowedToDelegateTo -like '*') -and (UserAccountControl -band 0x1000000)} -properties samAccountName, ServicePrincipalName, msDs-AllowedDelegateTo, userAccountControl

# hunting for a RBCD abuse 1: pivot on GUID in theEID 4662 (Properties: Write Property) + 5136 (attribute: msDS-AllowedToActOnBehalfOfOtherIdentity)
# hunting for a RBCD abuse 2
Get-ADObject -Filter {(msDS-AllowedToActOnBehalfOfOtherIdentity -like '*')}
Get-ADComputer <ServiceB> -properties * | FT Name, PrincipalsAllowedToDelegateToAccount
```

###  1.3. <a name='ADDSReplication'></a>AD DS Replication

```
# huntinfg for DCsync permission added to an account 1: 4662 ('Properties: Control Access') with DS-Replication GUID
```

| Entry | CN | Display-Name | Rights-GUID |
|----------------|--------------|--------------|-----------------|
| Value | DS-Replication-Get-Changes | Replicating Directory Changes |1131f6aa-9c07-11d1-f79f-00c04fc2dcd2
| Value | DS-Replication-Get-Changes-All | Replicating Directory Changes All |1131f6ad-9c07-11d1-f79f-00c04fc2dcd2

```
# huntinfg for DCsync permission added to an account 2:
(Get-Acl "ad:\dc=DC01,dc=local").Access | where-object {$_.ObjectType -eq "1131f6ad-9c07-11d1-f79f-00c04fc2dcd2" -or $_.objectType -eq 
```

##  2. <a name='Extras'></a>Extras

###  2.1. <a name='FetchingintothelogswithPS'></a>Fetching into the logs with PS

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

###  2.2. <a name='Logsactivation'></a>Logs activation

```
# Enable AMSI logging
$AutoLoggerName = 'MyAMSILogger'
$AutoLoggerGuid = "{$((New-Guid).Guid)}"
New-AutologgerConfig -Name $AutoLoggerName -Guid $AutoLoggerGuid -Start Enabled
Add-EtwTraceProvider -AutologgerName $AutoLoggerName -Guid '{2A576B87-09A7-520E-C21A-4942F0271D67}' -Level 0xff -MatchAnyKeyword ([UInt64] (0x8000000000000001 -band ([UInt64]::MaxValue))) -Property 0x41

# Enable DNS debug logs
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