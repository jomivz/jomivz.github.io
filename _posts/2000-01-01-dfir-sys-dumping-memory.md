---
layout: post
title: dfir / memdump
category: dfir
parent: cheatsheets
modified_date: 2021-02-06
permalink: /dfir/memdump
---

<!-- vscode-markdown-toc -->
* 1. [virtualbox](#virtualbox)
* 2. [libvirt](#libvirt)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

##  1. <a name='virtualbox'></a>virtualbox
```sh
# STEP 1: launch the VM in debug mode using CLI
> vboxmanage list vms
> virtualbox  --dbg --startvm <VM name>
# STEP 2 : click on the "Debug" menu -> "Command line...". VBoxDbg > .pgmphystofile   <VM name>.mm
#
```

##  2. <a name='libvirt'></a>libvirt

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