---
layout: default
title: mounting bitlocker partition on Windows
parent: Forensics
grand_parent: Cheatsheets
nav_order: 4
has_children: true
---

Mounting BitLocker Encrypted Drive on Windows   
       
# Convert Raw Image Files to VHD Compatible File 

Virtual Hard Disk (VHD) tool is an unmanaged code command-line tool which provides useful VHD manipulation functions including instant creation of large fixed-size VHDs.

VHD Tool 2.0 tool can be obtained from either of the below sources: http://archive.msdn.microsoft.com/vhdtool/Release/ProjectReleases.aspx?ReleaseId=5344 
 
# VHD Tool 2.0 Usage 

1. Download the VhdTool.exe to D:\.
2. Open an elevated command prompt and navigate to D:\.
3. Execute the following command: VhdTool.exe /convert raw_disk_image_filename.ntfs.

# Mount VHD via Windows Disk Management Tool
1. Open Disk Management via Start > Run > diskmgmt.msc. 
2. On the Menu bar, Action > Attach VHD.
 
3. Browse to the location of the raw disk image folder. Ensure that All files (*.*) is selected.  

 
NOTE: Do not checked Read-only else even when the correct recovery key is entered later on, it will alert you that it is incorrect.[2] 

4. Select Type the recovery key when prompted.

5. Enter the recovery key and click NEXT.
 
NOTE: Every recovery key has a password ID. Ensure that the recovery key entered is for the password ID shown to you.
 
# Unmount VHD via Windows Disk Management Tool
 
1. Right click on the mounted VHD and click on Detach VHD.



On “acme.corp”, right click and choose “Find”
 

     
Choose “Computer”, type the computer name, click on “Find Now”. On section “Search Results”, pick the computer.

   
Go to “BitLocker Recovery” tab to retrieve BitLocker Recovery Password   
