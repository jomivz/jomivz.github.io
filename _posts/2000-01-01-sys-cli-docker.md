---
layout: post
title: Sysadmin CLI Docker
category: Sysadmin
parent: Sysadmin
grand_parent: Cheatsheets
modified_date: 2021-12-09
permalink: /:categories/:title/
---

<!-- vscode-markdown-toc -->
* 1. [Memo Docker](#MemoDocker)
* 2. [Infosec Images](#InfosecImages)
	* 2.1. [testssl.sh](#testssl.sh)
	* 2.2. [nuclei](#nuclei)
	* 2.3. [SpiderFoot](#SpiderFoot)
	* 2.4. [fox-it\BloodHound.py](#fox-itBloodHound.py)
* 3. [Other images](#Otherimages)
	* 3.1. [Alpine](#Alpine)
	* 3.2. [Jekyll](#Jekyll)
	* 3.3. [frolvlad/alpine-python2](#frolvladalpine-python2)
* 4. [Troubleshooting](#Troubleshooting)
	* 4.1. [No space left on device error](#Nospaceleftondeviceerror)

<!-- vscode-markdown-toc-config
	numbering=true
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

##  1. <a name='MemoDocker'></a>Memo Docker

DRAFT HERE...
```sh
#? memo sysadmin docker

#? create dockerfile
cat > Dockerfile <<EOF
FROM alpine
MAINTAINER obama@us.gouv
RUN apt update
RUN apt install -y git vim python3.8
EOF

#? build docker image
docker build -t <your_username>/my-first-repo 

#? run docker image
docker run <your_username>/my-first-repo.
docker run -i --expose=9999 b5593e60c33b bash
docker run -d -p 5801:5801 -p  9999:9999 .....

#? push docker image
docker push <your_username>/my-first-repo 

```
##  2. <a name='InfosecImages'></a>Infosec Images

###  2.1. <a name='testssl.sh'></a>testssl.sh
```sh
#? install docker testssl.sh
docker pull drwetter/testssl.sh

#? run docker testssl.sh
docker run --rm -ti drwetter/testssl.sh https://jmvwork.xyz

```
###  2.2. <a name='nuclei'></a>nuclei
```sh
#? install docker nuclei
docker pull projectdiscovery/nuclei

#? run docker nuclei
docker run --rm -ti projectdiscovery/nuclei -u https://jmvwork.xyz 

```
###  2.3. <a name='SpiderFoot'></a>SpiderFoot
```sh
#? install docker spiderfoot
#
# (OPTIONAL): for Kali distrib embedding spiderfoot
cd /usr/share
sudo mv spiderfoot spiderfoot.old
#
#? build docker spiderfoot image
cd /usr/share
sudo git clone https://github.com/smicallef/spiderfoot.git
cd spiderfoot
docker build -t spiderfoot .
pip3 install -r requirements.txt

#? run docker spiderfoot
docker run -p 5002:5001 -d spiderfoot
# open your browser https://127.0.0.1:5002

```
###  2.4. <a name='fox-itBloodHound.py'></a>fox-it\BloodHound.py
```sh
#? install docker bloodhound.py
#
cd /usr/share
sudo git clone https://github.com/fox-it/BloodHound.py
cd BloodHound.py
sudo docker build -t bloodhound:1.1.1 .

```
##  3. <a name='Otherimages'></a>Other images
###  3.1. <a name='Alpine'></a>Alpine
[Alpine](https://wiki.alpinelinux.org/wiki/Alpine_Linux_Init_System)
```sh
#? install packages alpine
apk update
apk add git
apk add curl

#? install gcc alpine
apk add build-base 

#? set $PATH alpine
git clone 
export PATH=$PATH:/GoMApEnum/src 

```
###  3.2. <a name='Jekyll'></a>Jekyll
To run github.io locally:
```sh
#? install docker jekyll
docker pull jekyll/jekyll

#? run docker jekyll
sudo docker run --rm --volume="$HOME/git/jomivz.github.io:/srv/jekyll" --publish 127.0.0.1:4000:4000 jekyll/jekyll jekyll serve
# open your browser https://127.0.0.1:4000

```
###  3.3. <a name='frolvladalpine-python2'></a>frolvlad/alpine-python2
```sh
#? install docker alpine-python2
docker pull frolvlad/alpine-python2

#? execute python2 command
docker run --rm frolvlad/alpine-python2 python -c 'print u"Hello World"'

#? execute python2 command
docker run --rm /tmp:/mnt frolvlad/alpine-python2 python -c 'u"Hello world!"'

#? execute python2 script
docker run --rm --volume /tmp:/mnt frolvlad/alpine-python2 python test.py

```
##  4. <a name='Troubleshooting'></a>Troubleshooting
###  4.1. <a name='Nospaceleftondeviceerror'></a>No space left on device error

```sh
#? tshoot docker no space left
docker build -t <your_username>/my-first-repo 
sudo su
docker rm $(docker ps -q -f 'status=exited')
docker rm $(docker ps -q -f 'status=exited')

```
