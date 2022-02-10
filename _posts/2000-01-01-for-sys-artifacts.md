---
layout: post
title: Forensics System Artifacts  
category: Forensics
parent: Forensics
grand_parent: Cheatsheets
modified_date: 2021-12-11
permalink: /:categories/:title/
---

## Imaging the hard disk
```sh
#? image hard disk
#


```
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