---
layout: default
title: verifying linux boot binaries
parent: Forensics
grand_parent: Cheatsheets
has_children: true
---

1. To create the checksum file, run the command:
```
find isolinux/ -type f -exec b2sum -b -l 256 {} \; > isolinux.blake2sum_l256
```

2. To check binaries against the checksum file, run the command:
```
b2sum -c "${dirname}".blake2sum_l256
```
