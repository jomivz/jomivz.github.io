---
layout: default
title: Sysadmin CLI Docker
parent: Sysadmin
category: Sysadmin
grand_parent: Cheatsheets
---

<!-- vscode-markdown-toc -->
* 1. [Kali Linux 2020.1 install](#KaliLinux2020.1install)
* 2. [Images](#Images)
	* 2.1. [Alpine](#Alpine)
	* 2.2. [testssl.sh](#testssl.sh)
	* 2.3. [nuclei](#nuclei)
	* 2.4. [SpiderFoot](#SpiderFoot)
* 3. [The Docker Hub](#TheDockerHub)
* 4. [Configure credential help](#Configurecredentialhelp)
* 5. [Building images](#Buildingimages)
	* 5.1. [Pushing images](#Pushingimages)

<!-- vscode-markdown-toc-config
	numbering=true
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

# {{ page.title }}

##  1. <a name='KaliLinux2020.1install'></a>Kali Linux 2020.1 install

```bash
#Step 1: Configure APT Keys
sudo apt update

#Step 2: Get PGP Key for official Docker
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

#Step 3: Configure APT to Download, Install, and Update Docker
echo 'deb [arch=amd64] https://download.docker.com/linux/debian buster stable' |
sudo tee /etc/apt/sources.list.d/docker.list

#Step 5: Update the APT Again
sudo apt update

#Step 6: Terminate Outdated Versions Previously Installed
sudo apt remove docker docker-engine docker.io

#Step 7: Install Docker on Kali System
sudo apt install docker-ce -y

#Step 8: Start the Docker Container
sudo systemctl start docker

#(Optional) Step 9: Set up Docker to Start Automatically on Reboot
sudo systemctl enable Docker

#Step 10: Verify Installation
sudo Docker run hello-world
```

##  2. <a name='Images'></a>Images

###  2.1. <a name='Alpine'></a>Alpine

[Alpine](https://wiki.alpinelinux.org/wiki/Alpine_Linux_Init_System)

```sh
apk install openrc
```
###  2.2. <a name='testssl.sh'></a>testssl.sh
```sh
docker pull drwetter/testssl.sh
docker run --rm -ti drwetter/testssl.sh https://jmvwork.xyz
```

###  2.3. <a name='nuclei'></a>nuclei
```sh
docker pull projectdiscovery/nuclei
docker run --rm -ti projectdiscovery/nuclei -u https://jmvwork.xyz 
```

###  2.4. <a name='SpiderFoot'></a>SpiderFoot
```sh
# OPTIONAL: for Kali distrib embedding spiderfoot
cd /usr/share
sudo mv spiderfoot spiderfoot.old
# STEP 1 : Building the docker image
cd /usr/share
sudo git clone https://github.com/smicallef/spiderfoot.git
docker build -t spiderfoot .
# STEP 2 : Running the image / app
docker run -p 5002:5001 -d spiderfoot
# open your browser https://127.0.0.1:5002
```
##  3. <a name='TheDockerHub'></a>The Docker Hub

```
docker login
```

##  4. <a name='Configurecredentialhelp'></a>Configure credential help

[link 1](https://github.com/docker/docker-credential-helpers/)
[link 2](https://docs.docker.com/engine/reference/commandline/login/#credentials-store)

Docker requires the helper program to be in the client’s host `$PATH`.

```sh
docker pull alpine
```

##  5. <a name='Buildingimages'></a>Building images

Start by creating a Dockerfile to specify your application as shown below:

```sh
cat > Dockerfile <<EOF
FROM ubuntu:16.04
MAINTAINER obama@us.gouv
RUN apt update
RUN apt install -y git vim python3.8
EOF
```

###  5.1. <a name='Pushingimages'></a>Pushing images

To build your Docker image, run:

```sh
docker build -t <your_username>/my-first-repo 
```

Test your docker image locally by running:
```sh
docker run <your_username>/my-first-repo.
docker run -i --expose=9999 b5593e60c33b bash
docker run -d -p 5801:5801 -p  9999:9999 .....
```

To push your Docker image to Docker Hub, run 
```sh
docker push <your_username>/my-first-repo 
```

Now, in Docker Hub, your repository should have a new latest tag available under Tags:
