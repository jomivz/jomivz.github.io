---
layout: default
title: Useful daily linux CLI
parent: Linux
category: Linux
grand_parent: Cheatsheets
---
<!-- vscode-markdown-toc -->
* 1. [SED commands](#SEDcommands)
* 2. [PDF & ebooks](#PDFebooks)
* 3. [Images treatment](#Imagestreatment)
* 4. [Miscellaneous](#Miscellaneous)

<!-- vscode-markdown-toc-config
	numbering=true
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

# {{ page.title }}


##  1. <a name='SEDcommands'></a>SED commands

```
# insert a space between 2 IPs - solving copy/paste issue of nessus reports
sed '%s/.([0-9]+)192./.\1 192./g' 
```

##  2. <a name='PDFebooks'></a>PDF & ebooks

Aggregating multiple pdf files :
```
pdfunite infile1.pdf infile2.pdf outfile.pdf
```

To convert all pdf files in current directory to ebooks, use the command:
```
for src in *.pdf; do sudo ebook-convert $src .mobi; done
```

##  3. <a name='Imagestreatment'></a>Images treatment 

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
##  4. <a name='Miscellaneous'></a>Miscellaneous

Pushing a command output to pastebin (example here ```ps```):
```
ps -aux |pastebinit
```
Displaying a markdown to lynx: 
```
pandoc docker.md | lynx -stdin
```
