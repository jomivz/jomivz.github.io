---
layout: default
title: QEMU administration
parent: Sysadmin
grand_parent: Cheatsheets  
categories: Sysadmin Linux
---

{:toc}

# {{ page.title }}

## Converting OVA to QCOW for libvirtd

```
tar xvf anothertrainingbox64.ova
ls
anothertrainingbox64.vmdk
qemu-img convert anothertrainingbox64.vmdk xin-box-64.qemu2 -O qcow2
```

##  Accessing to the Virtual Machine (VM) from host

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


