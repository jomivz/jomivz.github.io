---
layout: default
title: linux misc commands
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
Linux command examples : find

Finding pdf files created last 24 hours in Donwloads diirectory:
```
find ~/Downloads -iname *.pdf -a -ctime 1
```

Converting all pdf files in current directory to ebooks:
```
for src in *.pdf; do sudo ebook-convert $src .mobi; done
```
