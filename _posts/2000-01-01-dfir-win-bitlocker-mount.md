---
layout: post
title: DFIR WIN Mounting bitlocker partition
category: dfir
parent: cheatsheets
modified_date: 2021-02-06
permalink: /dfir/win/bitlocker
---

<!-- vscode-markdown-toc -->
* [Mounting bitlocker partition on Linux](#MountingbitlockerpartitiononLinux)
* [Mounting bitlocker partition on Windows](#MountingbitlockerpartitiononWindows)
	* [Convert Raw Image Files to VHD Compatible File](#ConvertRawImageFilestoVHDCompatibleFile)
	* [VHD Tool 2.0 Usage](#VHDTool2.0Usage)
	* [Mount VHD via Windows Disk Management Tool](#MountVHDviaWindowsDiskManagementTool)
	* [Unmount VHD via Windows Disk Management Tool](#UnmountVHDviaWindowsDiskManagementTool)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

The bitlocker Key is 48 digits long.

## <a name='MountingbitlockerpartitiononLinux'></a>Mounting bitlocker partition on Linux
```sh
#? mount bitlocker partition on linux
dislocker -v -V /dev/sdb1 -p123456-123456-123456-123456-123456-123456-123456-123456 -- /mnt/tmp
ls /mnt/tmp/dislocker-file
mount -o loop,ro /mnt/tmp/dislocker-file /mnt/dis
ls /mnt/dis/

```
## <a name='MountingbitlockerpartitiononWindows'></a>Mounting bitlocker partition on Windows

### <a name='ConvertRawImageFilestoVHDCompatibleFile'></a>Convert Raw Image Files to VHD Compatible File 

Virtual Hard Disk (VHD) tool is an unmanaged code command-line tool which provides useful VHD manipulation functions including instant creation of large fixed-size VHDs.

VHD Tool 2.0 tool can be obtained [here](http://archive.msdn.microsoft.com/vhdtool/Release/ProjectReleases.aspx?ReleaseId=5344).
 
### <a name='VHDTool2.0Usage'></a>VHD Tool 2.0 Usage 

1. Download the VhdTool.exe to D:\.
2. Open an elevated command prompt and navigate to D:\.
3. Execute the following command: VhdTool.exe /convert raw_disk_image_filename.ntfs.

### <a name='MountVHDviaWindowsDiskManagementTool'></a>Mount VHD via Windows Disk Management Tool
1. Open Disk Management via Start > Run > diskmgmt.msc. 
2. On the Menu bar, Action > Attach VHD.
3. Browse to the location of the raw disk image folder. Ensure that All files (*.*) is selected.  
 
NOTE: Do not checked Read-only else even when the correct recovery key is entered later on, it will alert you that it is incorrect.[2] 

4. Select Type the recovery key when prompted.
5. Enter the recovery key and click NEXT.
 
NOTE: Every recovery key has a password ID. Ensure that the recovery key entered is for the password ID shown to you.
 
### <a name='UnmountVHDviaWindowsDiskManagementTool'></a>Unmount VHD via Windows Disk Management Tool
 
1. Right click on the mounted VHD and click on Detach VHD.

On “acme.corp”, right click and choose “Find”
     
Choose “Computer”, type the computer name, click on “Find Now”. On section “Search Results”, pick the computer.
   
Go to “BitLocker Recovery” tab to retrieve BitLocker Recovery Password   
