---
layout: post
title: Sysadmin VIRT Docker - Administration Cookbook
category: Sysadmin
parent: Sysadmin
grand_parent: Cheatsheets
modified_date: 2023-03-27
permalink: /:categories/:title/
---

**Must**

* [docker post-install](https://docs.docker.com/engine/install/linux-postinstall/)

**Menu**

<!-- vscode-markdown-toc -->
* 1. [Memo Docker](#MemoDocker)
* 2. [Infosec Images](#InfosecImages)
	* 2.1. [testssl.sh](#testssl.sh)
	* 2.2. [nuclei](#nuclei)
	* 2.3. [SpiderFoot](#SpiderFoot)
	* 2.4. [ropnop\kerbrute](#ropnopkerbrute)
	* 2.5. [impacket](#impacket)
* 3. [Other images](#Otherimages)
	* 3.1. [Alpine](#Alpine)
	* 3.2. [Jekyll](#Jekyll)
	* 3.3. [frolvlad/alpine-python2](#frolvladalpine-python2)
	* 3.4. [postgres](#postgres)
	* 3.5. [linuxserver\libreoffice](#linuxserverlibreoffice)
	* 3.6. [splunk\splunk](#splunksplunk)
* 4. [Troubleshooting](#Troubleshooting)
	* 4.1. [No space left on device error](#Nospaceleftondeviceerror)
	* 4.2. [Docker Daemon Config File](#DockerDaemonConfigFile)

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
Go to the [spiderfoot cheatsheet](/_posts/2000-01-01-osint-spiderfoot-cheatsheet.md).

###  2.4. <a name='ropnopkerbrute'></a>ropnop\kerbrute
```sh
#? pentest ad bruteforce auth kerbrute
#? build docker kerbrute
#
cd /usr/share
git clone https://github.com/ropnop/kerbrute.git
cd kerbrute
vi Dockerfile
    FROM golang:alpine
    RUN mkdir /app 
    ADD . /app/
    WORKDIR /app 
    RUN go build -o main .
    RUN adduser -S -D -H -h /app appuser
    USER appuser
    CMD ["./main"]
docker build -t kerbrute:1.0.3 .
#? run docker kerbrute
# practice : https://tryhackme.com/room/attacktivedirectory
curl https://raw.githubusercontent.com/Sq00ky/attacktive-directory-tools/master/userlist.txt
curl https://raw.githubusercontent.com/Sq00ky/attacktive-directory-tools/master/passwordlist.txt

docker run -v .:/mnt -it kerbrute:1.0.3 enumuser --dc spookysec.local userlist.txt -t 100

```
###  2.5. <a name='impacket'></a>impacket
```sh
#? pentest ad bruteforce auth kerbrute
#? build docker kerbrute
#
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

###  3.4. <a name='postgres'></a>postgres

IN 6 STEPS, this is HOW TO create and log on a 'test_db' postgres database :

1- MAKE sure you have ```docker```  and ```docker-compose``` installed

2- [MAKE sure you are member of the docker users group](https://docs.docker.com/engine/install/linux-postinstall/)

3- COPY the Dockerfile below in your ```$HOME``` and TYPE in a terminal ```cd; docker-compose up``` 

```sh
version: '3.8'

services:
  db:
    container_name: pg_container
    image: postgres
    restart: "no"
  environment:
    POSTGRES_USER: root
    POSTGRES_PASSWORD: root
    POSTGRES_DB: test_db
  volumes:
    - pg_data:/var/lib/postgresql/data/

volumes:
  pg_data:
```

4- MAKE sure the container is running then get a bash on it: 
```
docker container start pg_container
docker exec -it pg_container bash
```
 
5- LOG ON the postgres database created like so:
```
psql -U root -d test_db

test_db=# \c
You are now connected to database "test_db" as user "root"
```

6- CREATE / RESTORE a backup
```
test_db=# pg_dump test_db > /var/lib/postgres/data/test_db_bkp.sql
test_db=# pg_restore -f /var/lib/postgres/data/test_db_bkp.sql
test_db=# \dt
test_db=# select * from pg_catalog.pg_tables where schemaname='public';
```

More here:
* Excellent **postgres cheatsheet** by [quickref.me](https://quickref.me/postgres).
* Official doc [datetype & datetime](https://www.postgresql.org/docs/current/datatype-datetime.html)
* Official doc [datetime functions](https://www.postgresql.org/docs/current/functions-datetime.html)
* Official doc [network functions](https://www.postgresql.org/docs/current/functions-net.html)

```
# create the table ips_bogon
create table ips_bogon (ipr cidr not null);
\copy ips_bogon FROM /var/lib/docker/ips_bogon.csv CSV;

# removes Bogon IPs from table X
select ip from X LEFT OUTER JOIN ips_bogon ON network(ip) <<= ipr WHERE ipr IS NULL;  
```

###  3.5. <a name='linuxserverlibreoffice'></a>linuxserver\libreoffice
[Alpine](https://wiki.alpinelinux.org/wiki/Alpine_Linux_Init_System)
```sh
docker pull linuxserver/libreoffice:7.2.2
docker run -d --name=libreoffice -e PUID=1000 -e PGID=1000 -e TZ=Europe/London -p 3000:3000 -v /home/jomivz/doc:/doc --restart unless-stopped linuxserver/libreoffice:7.2.2
```

###  3.6. <a name='splunksplunk'></a>splunk\splunk
```sh
docker pull splunk/splunk
docker run -d -p 8000:8000 -e "SPLUNK_START_ARGS=--accept-license" -e "SPLUNK_PASSWORD=<password>" --name splunk splunk/splunk:latest
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

###  4.2. <a name='DockerDaemonConfigFile'></a>Docker Daemon Config File

Edit the file ```/etc/docker/daemon.json```.

```json
#
```