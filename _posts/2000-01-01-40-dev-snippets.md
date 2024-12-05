---
layout: post
title: dev / snippets
category: 40-dev
parent: cheatsheets
modified_date: 2024-01-30
permalink: /dev/snippet
---

<!-- vscode-markdown-toc -->
* [powershell](#powershell)
	* [ps-list-groupmembers](#ps-list-groupmembers)
 	* [ps-list-users-pp](#ps-list-users-pp)
	* [ps-list-users-pp](#ps-list-volumes)
* [python](#python)
	* [python-dl](#python-dl)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='powershell'></a>powershell

### <a name='ps-list-groupmembers'></a>ps-list-groupmembers
```powershell
Get-ADgroup EMEA-PXY-Web-ReadWrite -Property * | Select-Object -ExpandProperty Members
Get-ADgroup EMEA-PXY-Web-ReadWriteUpload -Property * | Select-Object -ExpandProperty Members

import-module activeDirectory

$GroupMember = "EMEA-PXY-Web-ReadWriteUpload"
$ResultFileName = "C:\Users\x123456\Documents\EMEA-PXY-Web-ReadWriteUpload.csv"

$Members=Get-ADGroupMember -identity $GroupMember -recursive 

$Result = @();

foreach ($Member in $Members){
    $User = Get-ADObject $Member -Properties name,displayName,department;
        
    $result += New-object -TypeName psobject -Property @{
        'Compte AD'=$User.name;
        'Nom Prenom'=$User.displayName;
        'Direction-Service'=$User.department;
     }
}

$Result|Export-csv -path $ResultFileName -delimiter ';' -NoTypeInformation -Encoding UTF8 -Force;
Type $ResultFileName
```

### <a name='ps-list-users-pp'></a>ps-list-users-pp
```powershell
```

### <a name='ps-list-volumes'></a>ps-list-volumes
```powershell
# https://superuser.com/questions/1058217/list-every-device-harddiskvolume
$signature = @'
[DllImport("kernel32.dll", SetLastError=true)]
[return: MarshalAs(UnmanagedType.Bool)]
public static extern bool GetVolumePathNamesForVolumeNameW([MarshalAs(UnmanagedType.LPWStr)] string lpszVolumeName,
        [MarshalAs(UnmanagedType.LPWStr)] [Out] StringBuilder lpszVolumeNamePaths, uint cchBuferLength, 
        ref UInt32 lpcchReturnLength);

[DllImport("kernel32.dll", SetLastError = true)]
public static extern IntPtr FindFirstVolume([Out] StringBuilder lpszVolumeName,
   uint cchBufferLength);

[DllImport("kernel32.dll", SetLastError = true)]
public static extern bool FindNextVolume(IntPtr hFindVolume, [Out] StringBuilder lpszVolumeName, uint cchBufferLength);

[DllImport("kernel32.dll", SetLastError = true)]
public static extern uint QueryDosDevice(string lpDeviceName, StringBuilder lpTargetPath, int ucchMax);

'@;
Add-Type -MemberDefinition $signature -Name Win32Utils -Namespace PInvoke -Using PInvoke,System.Text;

[UInt32] $lpcchReturnLength = 0;
[UInt32] $Max = 65535
$sbVolumeName = New-Object System.Text.StringBuilder($Max, $Max)
$sbPathName = New-Object System.Text.StringBuilder($Max, $Max)
$sbMountPoint = New-Object System.Text.StringBuilder($Max, $Max)
[IntPtr] $volumeHandle = [PInvoke.Win32Utils]::FindFirstVolume($sbVolumeName, $Max)
do {
    $volume = $sbVolumeName.toString()
    $unused = [PInvoke.Win32Utils]::GetVolumePathNamesForVolumeNameW($volume, $sbMountPoint, $Max, [Ref] $lpcchReturnLength);
    $ReturnLength = [PInvoke.Win32Utils]::QueryDosDevice($volume.Substring(4, $volume.Length - 1 - 4), $sbPathName, [UInt32] $Max);
    if ($ReturnLength) {
           $DriveMapping = @{
               DriveLetter = $sbMountPoint.toString()
               VolumeName = $volume
               DevicePath = $sbPathName.ToString()
           }

           Write-Output (New-Object PSObject -Property $DriveMapping)
       }
       else {
           Write-Output "No mountpoint found for: " + $volume
       } 
} while ([PInvoke.Win32Utils]::FindNextVolume([IntPtr] $volumeHandle, $sbVolumeName, $Max));
```

## <a name='python'></a>python

### <a name='python-dl'></a>python-traceroute
```python
# https://stackoverflow.com/questions/53112554/tcp-traceroute-in-python
# pip install libpcap
# pip install scapy

from scapy.all import *
target = ["172.217.17.46"]
result, unans = sr(IP(dst=target, ttl=(1, 10)) / TCP(dport=22, flags="S"))
for snd, rcv in result:
  print(snd.ttl, rcv.src, snd.sent_time, rcv.time)
```

### <a name='python-dl'></a>python-dl
```python
import requests
import re

def get_filename_from_cd(cd):
    """
    Get filename from content-disposition
    """
    if not cd:
        return None
    fname = re.findall('filename=(.+)', cd)
    if len(fname) == 0:
        return None
    return fname[0]


url = 'http://google.com/favicon.ico'
r = requests.get(url, allow_redirects=True)
filename = get_filename_from_cd(r.headers.get('content-disposition'))
open(filename, 'wb').write(r.content)
```
