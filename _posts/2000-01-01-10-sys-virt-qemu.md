---
layout: post
title: sys / qemu
category: 10-sys
parent: cheatsheets
modified_date: 2021-08-31
permalink: /sys/qemu
---

<!-- vscode-markdown-toc -->
* [libvirtd](#libvirtd)
	* [converting-ova-to-qcow](#converting-ova-to-qcow)
	* [setting-network](#setting-network)
	* [netfilter](#netfilter)
* [proxmox](#proxmox)
	* [converting-to-vmdk](#converting-to-vmdk)
	* [importing-vmdk](#importing-vmdk)
	* [vms-config-files](#vms-config-files)
	* [guest-additions](#guest-additions)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->---

## <a name='libvirtd'></a>libvirtd

- [qemu.readthedocs.io](https://qemu.readthedocs.io/en/latest/index.html)
- [proxmox pve wiki]([https://pve.proxmox.com/wiki/Main_Page)
- [promoxpve docs](https://pve.proxmox.com/pve-docs/)

### <a name='converting-ova-to-qcow'></a>converting-ova-to-qcow
```sh
tar xvf anothertrainingbox64.ova
ls
anothertrainingbox64.vmdk
qemu-img convert anothertrainingbox64.vmdk xin-box-64.qemu2 -O qcow2
```

### <a name='setting-network'></a>setting-network

Set the network as per below:
![.](/assets/images/qemu-vm-network-settings.png)

Allow vitual bridge to communicate out the physical interface:
```
brctl show
brctl addif br0 eth0
```

For Guest OS (VM) based on systemd, edit ```/etc/netplan/*.yaml``` to configure a persistent IP address:
```
network:
    ethernets:
        eth0:
            addresses: [192.168.1.200/24]
#            gateway4: 192.168.1.1
#            nameservers:
#                addresses: [208.67.222.222, 208.67.220.220]
            dhcp4: false
            dhcp6: false
    version: 2
```

Apply the changes and restart the service:
```
netplan apply
systemctl restart systemd-networkd
```

### <a name='netfilter'></a>netfilter


## <a name='proxmox'></a>proxmox

### <a name='converting-to-vmdk'></a>converting-to-vmdk
```sh
# sysinternals disk2vhd vms
qemu-img convert -O vmdk /data/source.vhdx /data/output.vmdk

# virtualbox vms
qemu-img convert -O vmdk /data/source.vdi /data/output.vmdk
```

### <a name='importing-vmdk'></a>importing-vmdk
```
qm importdisk 888 image-flat.vmdk local-storage --format vmdk
```

### <a name='vms-config-files'></a>vms-config-files

```
/etc/pve/qemu-server/*.conf
```

### <a name='guest-additions'></a>guest-additions

Link to **SPICE** documentation :
- [remote admin, copy/paste, video](https://pve.proxmox.com/wiki/SPICE)
- [file sharing](https://pve.proxmox.com/pve-docs/pve-admin-guide.html#qm_spice_enhancements)

... on **Windows VMs**, download / install the **SPICE Guest Tool** from the [offical page](https://www.spice-space.org/download/binaries/spice-guest-tools/). 

... on **debian VMs**, install the packages below:
```
sudo apt install spice-vdagent spice-webdavd 
```

... on a **debian host**, install the package **virt-viewer**
```
sudo apt install virt-viewer
```

To access to a file share, go to http://localhost:9843