---
layout: post
title: Sysadmin CLI Docker
category: Sysadmin
parent: Sysadmin
grand_parent: Cheatsheets
modified_date: 2021-11-19
permalink: /:categories/:title/
---

<!-- vscode-markdown-toc -->
* [Kali Linux 2020.1 install](#KaliLinux2020.1install)
* [Images](#Images)
	* [Alpine](#Alpine)
	* [testssl.sh](#testssl.sh)
	* [nuclei](#nuclei)
	* [SpiderFoot](#SpiderFoot)
	* [Jekyll](#Jekyll)
* [The Docker Hub](#TheDockerHub)
* [Configure credential help](#Configurecredentialhelp)
* [Building images](#Buildingimages)
	* [Pushing images](#Pushingimages)
* [Troubleshooting](#Troubleshooting)
	* [No space left on device error](#Nospaceleftondeviceerror)

<!-- vscode-markdown-toc-config
	numbering=true
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='Buildingimages'></a>Getting-start with Docker

```sh
#? memo docker

#? create dockerfile
cat > Dockerfile <<EOF
FROM ubuntu:16.04
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
## <a name='KaliLinux2020.1install'></a>Install for Kali Linux 2020.1

```bash
#? install docker for kali 2021.1
#
# step 1: Configure APT Keys
sudo apt update
#
# step 2: Get PGP Key for official Docker
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
#
# step 3: Configure APT to Download, Install, and Update Docker
echo 'deb [arch=amd64] https://download.docker.com/linux/debian buster stable' |
sudo tee /etc/apt/sources.list.d/docker.list
#
# step 5: Update the APT Again
sudo apt update
#
# step 6: Terminate Outdated Versions Previously Installed
sudo apt remove docker docker-engine docker.io
#
# step 7: Install Docker on Kali System
sudo apt install docker-ce -y
#
# step 8: Start the Docker Container
sudo systemctl start docker
#
# (OPTIONAL) step 9: Set up Docker to Start Automatically on Reboot
sudo systemctl enable Docker
#
# step 10: Verify Installation
sudo Docker run hello-world

```
## <a name='Images'></a>Images

### <a name='Alpine'></a>Alpine

[Alpine](https://wiki.alpinelinux.org/wiki/Alpine_Linux_Init_System)

```sh
#? install openrc alpine
apk install openrc

#? install gcc alpine
apk add build-base 

```
### <a name='Alpine'></a>frolvlad/alpine-python2
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
### <a name='testssl.sh'></a>testssl.sh
```sh
#? install docker testssl.sh
docker pull drwetter/testssl.sh

#? run docker testssl.sh
docker run --rm -ti drwetter/testssl.sh https://jmvwork.xyz

```
### <a name='nuclei'></a>nuclei
```sh
#? install docker nuclei
docker pull projectdiscovery/nuclei

#? run docker nuclei
docker run --rm -ti projectdiscovery/nuclei -u https://jmvwork.xyz 

```
### <a name='SpiderFoot'></a>SpiderFoot
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
### <a name='Jekyll'></a>Jekyll
```sh
#? install docker jekyll
docker pull jekyll/jekyll

#? run docker jekyll
sudo docker run --rm --volume="$HOME/git/jomivz.github.io:/srv/jekyll" --publish 127.0.0.1:4000:4000 jekyll/jekyll jekyll serve
# open your browser https://127.0.0.1:4000

```
## <a name='Troubleshooting'></a>Troubleshooting
### <a name='Nospaceleftondeviceerror'></a>No space left on device error

```sh
#? tshoot docker no space left
docker build -t <your_username>/my-first-repo 
sudo su
docker rm $(docker ps -q -f 'status=exited')
docker rm $(docker ps -q -f 'status=exited')

```
