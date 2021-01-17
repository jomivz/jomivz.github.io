---
layout: default
title: mounting bitlocker partition on Linux
parent: Forensics
grand_parent: Cheatsheets
has_children: true
---

The bitlocker Key is 48 digits long.

```
root@kali:~# dislocker -v -V /dev/sdb1 -p123456-123456-123456-123456-123456-123456-123456-123456 -- /mnt/tmp

root@kali:~# ls /mnt/tmp/
dislocker-file
root@kali:~# mount -o loop,ro /mnt/tmp/dislocker-file /mnt/dis
root@kali:~# ls /mnt/dis/
```
