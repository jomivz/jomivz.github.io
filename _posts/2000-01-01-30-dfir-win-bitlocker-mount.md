---
layout: post
title: dfir / win / bitlocker
category: 30-csirt
parent: cheatsheets
modified_date: 2021-02-06
permalink: /dfir/win/bitlocker
---

<!-- vscode-markdown-toc -->
* [lin-host-mount](#lin-host-mount)
* [win-host-mount](#win-host-mount)
	* [convert-raw-2-vhd](#convert-raw-2-vhd)
	* [mount-vhd](#mount-vhd)
	* [unmount-vhd](#unmount-vhd)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

The bitlocker Key is 48 digits long.

## <a name='lin-host-mount'></a>lin-host-mount
```sh
#? mount bitlocker partition on linux
dislocker -v -V /dev/sdb1 -p123456-123456-123456-123456-123456-123456-123456-123456 -- /mnt/tmp
ls /mnt/tmp/dislocker-file
mount -o loop,ro /mnt/tmp/dislocker-file /mnt/dis
ls /mnt/dis/

```
## <a name='win-host-mount'></a>win-host-mount

### <a name='convert-raw-2-vhd'></a>convert-raw-2-vhd 

Virtual Hard Disk (VHD) tool is an unmanaged code command-line tool which provides useful VHD manipulation functions including instant creation of large fixed-size VHDs.
VHD Tool 2.0 tool can be obtained [here](http://archive.msdn.microsoft.com/vhdtool/Release/ProjectReleases.aspx?ReleaseId=5344).
 
1. Download the VhdTool.exe to D:\.
2. Open an elevated command prompt and navigate to D:\.
3. Execute the following command: VhdTool.exe /convert raw_disk_image_filename.ntfs.

### <a name='mount-vhd'></a>mount-vhd
1. Open Disk Management via Start > Run > diskmgmt.msc. 
2. On the Menu bar, Action > Attach VHD.
3. Browse to the location of the raw disk image folder. Ensure that All files (*.*) is selected.  
 
NOTE: Do not checked Read-only else even when the correct recovery key is entered later on, it will alert you that it is incorrect.[2] 

4. Select Type the recovery key when prompted.
5. Enter the recovery key and click NEXT.
 
NOTE: Every recovery key has a password ID. Ensure that the recovery key entered is for the password ID shown to you.
 
### <a name='unmount-vhd'></a>unmount-vhd
 
1. Right click on the mounted VHD and click on Detach VHD.
2. On “acme.corp”, right click and choose “Find”
3. Choose “Computer”, type the computer name, click on “Find Now”. On section “Search Results”, pick the computer.
4. Go to “BitLocker Recovery” tab to retrieve BitLocker Recovery Password   
