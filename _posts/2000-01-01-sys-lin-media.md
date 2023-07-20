---
layout: post
title: sys / lin / media
category: sys
parent: cheatsheets
modified_date: 2023-07-19
permalink: /sys/lin/media
---
<!-- vscode-markdown-toc -->
* [ebooks](#ebooks)
* [images](#images)
* [markdowns](#markdowns)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='ebooks'></a>ebooks
```sh
# pdfunite aggregate multiple files
pdfunite infile1.pdf infile2.pdf outfile.pdf

# ebook-converter - mass pdf conversion
for src in *.pdf; do sudo ebook-convert $src .mobi; done

```
## <a name='images'></a>images
```sh
## <a name='resizeimage'></a>resize image 
convert  -resize 50% source.png dest.jpg
convert logo.png -resize 512x512 output.png
# more check out [imagemagick resize examples](https://legacy.imagemagick.org/Usage/resize/).

## <a name='createfavicon'></a>create favicon
convert logo.png  -background white -clone 0 -resize 32x32 -extent 32x32  -delete 0 -alpha off -colors 256 favicon.ico

## <a name='convertimage'></a>convert image
potrace -s logo.bmp #replace the white zone with transparency"
potrace -s logo.bmp --fillcolor "#fffffff" #to keep white areas
potrace -s logo.bmp --opaque #to keep white areas

```
## <a name='markdowns'></a>markdowns
```sh
# Pushing a command output to pastebin (example here ```ps```):
ps -aux |pastebinit

# Displaying a markdown to lynx: 
pandoc docker.md | lynx -stdin

# onliner to kill all tty related to jomivz
# remove current tty 
for i in `w|grep jomivz|cut -f2 -d" "`; do ps -ft $i >> /tmp/res.txt; done; sed '/UID.*$/d' /tmp/res.txt | cut -f2 -d" " | sort -u > /tmp/pids.txt; for j in `cat /tmp/pids.txt`; do kill -9 $j; done
```
