---
layout: default
title: Docker chetsheet
parent: System
parent: Sysadmin
grand_parent: Cheatsheets
---

<!-- vscode-markdown-toc -->
* 1. [Images](#Images)
	* 1.1. [Alpine](#Alpine)
	* 1.2. [Ubuntu](#Ubuntu)
* 2. [The Docker Hub](#TheDockerHub)
* 3. [Configure credential help](#Configurecredentialhelp)
* 4. [Building images](#Buildingimages)
	* 4.1. [Pushing images](#Pushingimages)

<!-- vscode-markdown-toc-config
	numbering=true
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

# {{ page.title }}

##  1. <a name='Images'></a>Images

###  1.1. <a name='Alpine'></a>Alpine

[Alpine](https://wiki.alpinelinux.org/wiki/Alpine_Linux_Init_System)

```sh
apk install openrc
```
###  1.2. <a name='Ubuntu'></a>Ubuntu

##  2. <a name='TheDockerHub'></a>The Docker Hub

```
docker login
```

##  3. <a name='Configurecredentialhelp'></a>Configure credential help

[link 1](https://github.com/docker/docker-credential-helpers/)
[link 2](https://docs.docker.com/engine/reference/commandline/login/#credentials-store)

Docker requires the helper program to be in the client’s host `$PATH`.

```sh
docker pull alpine
```

##  4. <a name='Buildingimages'></a>Building images

Start by creating a Dockerfile to specify your application as shown below:

```sh
cat > Dockerfile <<EOF
FROM ubuntu:16.04
MAINTAINER obama@us.gouv
RUN apt update
RUN apt install -y git vim python3.8
EOF
```

###  4.1. <a name='Pushingimages'></a>Pushing images

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
