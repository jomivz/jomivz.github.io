---
layout: default
title: memory dump virtualbox
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

