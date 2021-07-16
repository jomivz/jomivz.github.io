---
layout: default
title: Mounting bitlocker partition on Linux
parent: Forensics
categories: Forensics Linux
grand_parent: Cheatsheets
has_children: true
---

# {{ page.title}}

The bitlocker Key is 48 digits long.

```
root@kali:~# dislocker -v -V /dev/sdb1 -p123456-123456-123456-123456-123456-123456-123456-123456 -- /mnt/tmp

root@kali:~# ls /mnt/tmp/
dislocker-file
root@kali:~# mount -o loop,ro /mnt/tmp/dislocker-file /mnt/dis
root@kali:~# ls /mnt/dis/
```