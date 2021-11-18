---
layout: default
title: linux command examples - FIND
parent: Linux
category: Linux
grand_parent: Cheatsheets
---

# {{ page.title }}

Finding pdf files created las 24 hours in Downloads directory:
```
find ~/Dowloads -iname *.pdf -a -ctime 1
```

To identify files with the suid, sgid permissions:
```
find / -perm +6000 -type f -exec ls -ld {} \; > setuid.txt &
find / -perm +4000 -user root -type f -
```
