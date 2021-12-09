---
layout: post
title: Sysadmin CLI LIN
category: Sysadmin
parent: Sysadmin
grand_parent: Cheatsheets
modified_date: 2021-11-17
permalink: /:categories/:title/
---
<!-- vscode-markdown-toc -->
* [Security concerns](#Securityconcerns)
	* [Check ISO integrity](#CheckISOintegrity)
	* [Check boot integrity](#Checkbootintegrity)
	* [Run openvpn](#Runopenvpn)
* [System concerns](#Systemconcerns)
	* [LVM resize vg-root](#LVMresizevg-root)
	* [SED examples](#SEDexamples)
	* [FIND examples](#FINDexamples)
* [Other concerns](#Otherconcerns)
	* [PDF & ebooks](#PDFebooks)
	* [Images treatment](#Imagestreatment)
	* [Miscellaneous](#Miscellaneous)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='Securityconcerns'></a>Security concerns
### <a name='CheckISOintegrity'></a>Check ISO integrity

```sh
#? check ubuntu iso integrity
#
# STEP 1: Download a copy of the SHA256SUMS and SHA256SUMS.gpg files from Canonical’s CD Images server for that particular version.

# STEP 2: install the Ubuntu Keyring. This may already be present on your system.
sudo apt-get install ubuntu-keyring
#
# STEP 3: Verify the keyring.
gpgv --keyring=/usr/share/keyrings/ubuntu-archive-keyring.gpg SHA256SUMS.gpg SHA256SUMS
# STEP 4. Verify the checksum of the downloaded image.
grep ubuntu-mate-18.04-desktop-amd64.iso SHA256SUMS | sha256sum --check
# STEP 5. If you see “OK”, the image is in good condition.
ubuntu-mate-18.04-desktop-amd64.iso: OK

```

### <a name='Checkbootintegrity'></a>Check boot integrity
```sh
#? check boot integrity
#
# STEP 1: create the checksum file, run the command:
#
find isolinux/ -type f -exec b1sum -b -l 256 {} \; > isolinux.blake2sum_l256
#
# STEP 2: check binaries against the checksum file
#
b1sum -c "${dirname}".blake2sum_l256

```
### <a name='Runopenvpn'></a>Run openvpn
```
#? run openvpn 
cd /etc/openvpn
sudo openvpn --config xxx.opvn
#
#? get public ip
curl https://api.myip.com

```
## <a name='Systemconcerns'></a>System concerns
### <a name='LVMresizevg-root'></a>LVM resize vg-root
```sh
#? resize lvm volume group
#
# INFO : Solve KALI 2021.1 LVM default install. VG-ROOT is 10GB. 
# 
# step 1 : uumount /home. Run as root. System may refuse operation if users logged on or services running from /home.
umount /home
#
# step 2 : shrink old /home partition to X GB, (system will force you to check filesystem for errors by running e2fsck)
e2fsck -f /dev/mapper/vg-home
resize2fs /dev/mapper/vg-home XG
#
# step 3 : Reduce vg-home to X GB
lvreduce -L 20G /dev/mapper/vg-home
#
# step 4 OPTION A : Add 100G to the vg-root
lvextend -L+100G /dev/mapper/vg-root
#
# step 4 OPTION B :Extend vg-root to  100G
lvextend -L100G /dev/mapper/vg-root
#
# step 5 : grow /root (ext3/4) partition to new LVM size
resize2fs /dev/mapper/vg-root
#
mount /home

```
### <a name='SEDexamples'></a>SED examples
```sh
#? getting-start sed
#
#? sed print line by its number X
sed -n Xp toto.txt

#? sed print file section from line number X to Y
sed -n "X,Y/*/p" toto.txt

#? sed print file section from line number X to EOF
sed -n "X,/*/p" toto.txt

# sed insert a space between 2 IPs - solving copy/paste issue of nessus reports
sed '%s/.([0-9]+)192./.\1 192./g' 

### <a name='oneliners'></a>oneliners
# oneliner howto - grep into jmvwork.xyz cheatsheets
# takes the pattern as first argument
# takes the file as second argument
# if multiple match, print howto for the first pattern found
function howto { line=`grep -n $1 $2 |sed -n 1p |cut -f1 -d":"`; sed -n "${line},/.?/p" $2 |awk '$0 ~/^#$/ { exit; } $0 { print;}'; } 
function gstart { line=`grep -n "^#? getting-start" |grep -n $1 $2 |sed -n 1p |cut -f1 -d":"`; sed -n "${line},/.?/p" $2 |awk '$0 ~/^```.*$/ { exit; } $0 { print;}'; } 

# oneliner howto example 1
howto "docker install spiderfoot" 2021-10-26-sys-cli-docker.md

# oneliner howto example 2
howto "# oneliner .* ex" 2021-10-26-sys-cli-lin.md

```
### <a name='FINDexamples'></a>FIND examples
```sh
### <a name='findpdffilescreatedlas24hoursinDownloadsdirectory:'></a>find pdf files created las 24 hours in Downloads directory:
find ~/Dowloads -iname *.pdf -a -ctime 1

## <a name='identifyfileswiththesuidsgidpermissions'></a>identify files with the suid, sgid permissions
find / -perm +6000 -type f -exec ls -ld {} \; > setuid.txt &
find / -perm +4000 -user root -type f -

```
## <a name='Otherconcerns'></a>Other concerns

### <a name='PDFebooks'></a>PDF & ebooks
```sh
# pdfunite aggregate multiple files
pdfunite infile1.pdf infile2.pdf outfile.pdf

# ebook-converter - mass pdf conversion
for src in *.pdf; do sudo ebook-convert $src .mobi; done

```
### <a name='Imagestreatment'></a>Images treatment 
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
### <a name='Miscellaneous'></a>Miscellaneous
```sh
# Pushing a command output to pastebin (example here ```ps```):
ps -aux |pastebinit

# Displaying a markdown to lynx: 
pandoc docker.md | lynx -stdin

```