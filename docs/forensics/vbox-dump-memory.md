---
layout: default
title: dumping memory
parent: Forensics
grand_parent: Cheatsheets
has_children: true
---

# Dumping Memory of a VirtualBox Machine

Launch the VM in debug mode using CLI :

```
> vboxmanage list vms
> virtualbox  --dbg --startvm <VM name>
```

Click on the "Debug" menu -> "Command line...". VBoxDbg > .pgmphystofile   <VM name>.mm

# Dumping Memory via libvirt

Libvirt supports Xen, Qemu, KVM, OpenVZ, virtualbox, VMware ESX and LXC hypervisors.

Launch ```virsh``` which is the interface management:
```bash
$ virsh
virsh # dump --memory-only -domain 1 --file sample-dump.dmp
virsh # exit
$ ls
sample-dump.dmp
```
