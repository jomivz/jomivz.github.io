---
layout: default
title: Useful daily linux CLI
parent: Linux
category: Linux
grand_parent: Cheatsheets
---

# {{ page.title }}

## PDF & ebooks

Aggregating multiple pdf files :
```
pdfunite infile1.pdf infile2.pdf outfile.pdf
```

To convert all pdf files in current directory to ebooks, use the command:
```
for src in *.pdf; do sudo ebook-convert $src .mobi; done
```

## Images treatment 

To resize an image, use the command:
```
convert  -resize 50% source.png dest.jpg
convert logo.png -resize 512x512 output.png
```
Check out [imagemagick resize examples](https://legacy.imagemagick.org/Usage/resize/) illustrated.

To create a favicon with ```ImageMagick```, use the command:
```
convert logo.png  -background white -clone 0 -resize 32x32 -extent 32x32  -delete 0 -alpha off -colors 256 favicon.ico
```

To convert a bmp image to an svg, use the command:
```
potrace -s logo.bmp #replace the white zone with transparency"
potrace -s logo.bmp --fillcolor "#fffffff" #to keep white areas
potrace -s logo.bmp --opaque #to keep white areas
```
## Miscellaneous

Pushing a command output to pastebin (example here ```ps```):
```
ps -aux |pastebinit
```
Displaying a markdown to lynx: 
```
pandoc docker.md | lynx -stdin
```
