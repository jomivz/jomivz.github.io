---
layout: default
title: docker
parent: System
grand_parent: Cheatsheets
nav_order: 2
has_children: true
---

# Docker QuickStart

**Table of Contents**

- [Images](#Images)
 - [Alpine](##Alpine)
 - [Ubuntu](##Ubuntu)
- [The Docker Hub](#the-docker-hub)
- [Configure Credential Help](#configure-credential-help)
- [Building images](#building-images)
- [Pushing images](#pushing-images)

## Images

### Alpine

[Alpine](https://wiki.alpinelinux.org/wiki/Alpine_Linux_Init_System)

```sh
apk install openrc
```
### Ubuntu

## The Docker Hub

```
docker login
```

## Configure credential help

(https://github.com/docker/docker-credential-helpers/)
(https://docs.docker.com/engine/reference/commandline/login/#credentials-store)

Docker requires the helper program to be in the client’s host `$PATH`.

```sh
docker pull alpine
```

## Building images

Start by creating a Dockerfile to specify your application as shown below:

```sh
cat > Dockerfile <<EOF
FROM ubuntu:16.04
MAINTAINER obama@us.gouv
RUN apt update
RUN apt install -y git vim python3.8
EOF
```

### Pushing images

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
