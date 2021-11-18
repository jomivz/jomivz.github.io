---
layout: default
title: Sysadmin CLI LIN
parent: Sysadmin
category: Sysadmin
grand_parent: Cheatsheets
last-modified: 2021-11-17
---
<!-- vscode-markdown-toc -->
* 1. [Open/check VPN settings](#OpencheckVPNsettings)
* 2. [LVM resize vg-root](#LVMresizevg-root)
* 3. [SED commands](#SEDcommands)
* 4. [PDF & ebooks](#PDFebooks)
* 5. [Images treatment](#Imagestreatment)
* 6. [Miscellaneous](#Miscellaneous)

<!-- vscode-markdown-toc-config
	numbering=true
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

# {{ page.title }}

##  1. <a name='OpencheckVPNsettings'></a>Open/check VPN settings
```
cd /etc/openvpn
sudo openvpn --config xxx.opvn
curl https://api.myip.com
```

##  2. <a name='LVMresizevg-root'></a>LVM resize vg-root

```
# Solve KALI 2021.1 LVM default install. VG-ROOT is 10GB. 
# Run as root. System may refuse to unmount /home if users logged on to the box or services running from /home
umount /home

# Shrink old /home partition to X GB, (system will force you to check filesystem for errors by running e2fsck)
e2fsck -f /dev/mapper/vg-home
resize2fs /dev/mapper/vg-home XG

# Reduce vg-home to X GB
lvreduce -L 20G /dev/mapper/vg-home

# OPTION A : Add 100G to the vg-root
lvextend -L+100G /dev/mapper/vg-root

# OPTION B :Extend vg-root to  100G
lvextend -L100G /dev/mapper/vg-root

# Grow /root (ext3/4) partition to new LVM size
resize2fs /dev/mapper/vg-root

mount /home
```

##  3. <a name='SEDcommands'></a>SED commands

```
# insert a space between 2 IPs - solving copy/paste issue of nessus reports
sed '%s/.([0-9]+)192./.\1 192./g' 

# output print the file's line X. 
sed -n Xp toto.txt
```

##  4. <a name='PDFebooks'></a>PDF & ebooks

```
# Aggregating multiple pdf files :
pdfunite infile1.pdf infile2.pdf outfile.pdf

# To convert all pdf files in current directory to ebooks, use the command:
for src in *.pdf; do sudo ebook-convert $src .mobi; done
```

##  5. <a name='Imagestreatment'></a>Images treatment 

```
# To resize an image, use the command:
convert  -resize 50% source.png dest.jpg
convert logo.png -resize 512x512 output.png

# Check out [imagemagick resize examples](https://legacy.imagemagick.org/Usage/resize/) illustrated.
# To create a favicon with ```ImageMagick```, use the command:
convert logo.png  -background white -clone 0 -resize 32x32 -extent 32x32  -delete 0 -alpha off -colors 256 favicon.ico

# To convert a bmp image to an svg, use the command:
potrace -s logo.bmp #replace the white zone with transparency"
potrace -s logo.bmp --fillcolor "#fffffff" #to keep white areas
potrace -s logo.bmp --opaque #to keep white areas
```

##  6. <a name='Miscellaneous'></a>Miscellaneous

```
# Pushing a command output to pastebin (example here ```ps```):
ps -aux |pastebinit

# Displaying a markdown to lynx: 
pandoc docker.md | lynx -stdin
```