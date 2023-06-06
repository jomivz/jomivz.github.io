---
layout: post
title: Sysadmin VIRT VirtualBox - Administration Cookbook
category: sys
parent: sys

modified_date: 2022-08-16
permalink: /:categories/:title/
---

<!-- vscode-markdown-toc -->
* [Converting OVA to VMDK](#ConvertingOVAtoVMDK)
* [Install Guest Addtions on Debian / Ubuntu](#InstallGuestAddtionsonDebianUbuntu)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->---

## <a name='ConvertingOVAtoVMDK'></a>Converting OVA to VMDK

Pre-requisite : VMware Online account.

- Download **ovftool** from (VirtualBox website)[https://developer.vmware.com/web/tool/4.4.0/ovf].

- Run the tool as below :
```sh
ovftool test_machine.vmx test_machine.ova
```

## <a name='InstallGuestAddtionsonDebianUbuntu'></a>Install Guest Addtions on Debian / Ubuntu

- STEP 1: **Update** your distribution
```sh
sudo apt update
sudo apt install build-essential dkms linux-headers-$(uname -r)
```

- STEP 2: **Mount** the guest additions ISO on the guest VM 

![/assets/images/sys-virt-vbox-linux-guest-additions_0.png]

![/assets/images/sys-virt-vbox-linux-guest-additions_1.png]

```sh
sudo mount /dev/sr0 /mnt
```

- STEP 3: **Install** the guest additions within the guest VM 
```sh
cd /mnt/
sudo ./VBoxLinuxAdditions.run
```

- STEP 4: **Reboot** the Guest VM 