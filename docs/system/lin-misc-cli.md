---
layout: default
title: Useful daily linux CLI
parent: Linux
grand_parent: System
nav_order: 2
has_children: true
---

Useful daily linux CLI:

Pushing a command output to pastebin (example here ```ps```):
```
ps -aux |pastebinit
```
Displaying a markdown to lynx: 
```
pandoc docker.md | lynx -stdin
```

Aggregating multiple pdf files :
```
pdfunite infile1.pdf infile2.pdf outfile.pdf
```

Converting an image :
```
convert  -resize 50% source.png dest.jpg
convert -resize 512x512 > secureelance_purple_484x512.png output.png
```
