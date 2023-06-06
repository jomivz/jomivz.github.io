---
layout: post
title: SYS Dumping memory
category: for
parent: for
modified_date: 2021-02-06
permalink: /for/memdump
---

## Dumping Memory of a VirtualBox Machine
```sh
#? dump memory virtualbox
#
# STEP 1: launch the VM in debug mode using CLI
#
> vboxmanage list vms
> virtualbox  --dbg --startvm <VM name>
#
# STEP 2 : click on the "Debug" menu -> "Command line...". VBoxDbg > .pgmphystofile   <VM name>.mm
#

```
## Dumping Memory via libvirt

Libvirt supports Xen, Qemu, KVM, OpenVZ, virtualbox, VMware ESX and LXC hypervisors.

```sh
#? dump memory via libvirt
#
# STEP 1: launch ```virsh``` which is the interface management:
#
$ virsh
virsh # dump --memory-only -domain 1 --file sample-dump.dmp
virsh # exit
$ ls
sample-dump.dmp
#

```