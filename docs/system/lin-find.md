---
layout: default
title: linux command examples - find
parent: Linux
grand_parent: System
has_children: true
---

Linux command examples - find
--------------------------------------------

Finding pdf files created las 24 hours in Downloads direectory:
```
find ~/Dowloads -iname *.pdf -a -ctime 1
```

```
find / -perm +6000 -type f -exec ls -ld {} \; > setuid.txt &
find / -perm +4000 -user root -type f -
```
