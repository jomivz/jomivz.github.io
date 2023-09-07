---
layout: post
title: sys / virtualbox
category: sys
parent: cheatsheets
modified_date: 2023-07-27
permalink: /sys/virtualbox
---

<!-- vscode-markdown-toc -->
* [vagrant](#vagrant)
	* [plugins](#plugins)
	* [vagrantfile](#vagrantfile)
* [convert-ova-to-vmdk](#convert-ova-to-vmdk)
* [debian-guest-addtions](#debian-guest-addtions)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->---

## <a name='vagrant'></a>vagrant

### <a name='plugins'></a>plugins
```sh
# plugins to install to run windows boxes
vagrant plugin install vagrant-vbguest
vagrant plugin install winrm
vagrant plugin install winrm-fs
vagrant plugin install winrm-elevated
```

### <a name='vagrantfile'></a>vagrantfile
```sh
```

## <a name='convert-ova-to-vmdk'></a>convert-ova-to-vmdk

Pre-requisite : VMware Online account.

- Download **ovftool** from (VirtualBox website)[https://developer.vmware.com/web/tool/4.4.0/ovf].

- Run the tool as below :
```sh
ovftool test_machine.vmx test_machine.ova
```

## <a name='debian-guest-addtions'></a>debian-guest-addtions

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
