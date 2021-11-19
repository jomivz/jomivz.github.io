---
layout: post
title: Sysadmin CLI Docker
parent: Sysadmin
category: Sysadmin
grand_parent: Cheatsheets
modified_date: 2021-11-19
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

## <a name='KaliLinux2020.1install'></a>Kali Linux 2020.1 install

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

## <a name='Images'></a>Images

### <a name='Alpine'></a>Alpine

[Alpine](https://wiki.alpinelinux.org/wiki/Alpine_Linux_Init_System)

```sh
apk install openrc
```
### <a name='testssl.sh'></a>testssl.sh
```sh
docker pull drwetter/testssl.sh
docker run --rm -ti drwetter/testssl.sh https://jmvwork.xyz
```

### <a name='nuclei'></a>nuclei
```sh
docker pull projectdiscovery/nuclei
docker run --rm -ti projectdiscovery/nuclei -u https://jmvwork.xyz 
```

### <a name='SpiderFoot'></a>SpiderFoot
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

### <a name='Jekyll'></a>Jekyll
```sh
# download / build the image
docker pull jekyll/jekyll

# execute
sudo docker run --rm \\n  --volume="$HOME/git/jmvwork:/srv/jekyll" \\n  --publish 127.0.0.1:4000:4000 \\n  jekyll/jekyll \\n  jekyll serve
```

## <a name='TheDockerHub'></a>The Docker Hub

```
docker login
```

## <a name='Configurecredentialhelp'></a>Configure credential help

[link 1](https://github.com/docker/docker-credential-helpers/)
[link 2](https://docs.docker.com/engine/reference/commandline/login/#credentials-store)

Docker requires the helper program to be in the client’s host `$PATH`.

```sh
docker pull alpine
```

## <a name='Buildingimages'></a>Building images

Start by creating a Dockerfile to specify your application as shown below:

```sh
cat > Dockerfile <<EOF
FROM ubuntu:16.04
MAINTAINER obama@us.gouv
RUN apt update
RUN apt install -y git vim python3.8
EOF
```

### <a name='Pushingimages'></a>Pushing images

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

## <a name='Troubleshooting'></a>Troubleshooting
### <a name='Nospaceleftondeviceerror'></a>No space left on device error

To build your Docker image, run:

```sh
docker build -t <your_username>/my-first-repo 
sudo su
docker rm $(docker ps -q -f 'status=exited')
docker rm $(docker ps -q -f 'status=exited')
```