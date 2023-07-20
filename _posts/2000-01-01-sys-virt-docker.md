---
layout: post
title: sys / docker
category: sys
parent: cheatsheets
modified_date: 2023-07-19
permalink: /sys/docker
---

**Menu**

<!-- vscode-markdown-toc -->
* [install](#install)
* [imgomy](#imgomy)
	* [alpine](#alpine)
	* [jekyll](#jekyll)
	* [libreoffice](#libreoffice)
	* [neo4j](#neo4j)
	* [python2](#python2)
	* [postgres](#postgres)
* [imgsec](#imgsec)
	* [exegol](#exegol)
	* [kerbrute](#kerbrute)
	* [impacket](#impacket)
	* [nuclei](#nuclei)
	* [spiderfoot](#spiderfoot)
	* [testssl](#testssl)
	* [splunk](#splunk)
* [memo](#memo)
* [tshoot](#tshoot)
	* [no-space-left-on-device-error](#no-space-left-on-device-error)
	* [docker-daemon-config-file](#docker-daemon-config-file)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='install'></a>install 
* [debian install](https://docs.docker.com/engine/install/debian/)
* [docker post-install](https://docs.docker.com/engine/install/linux-postinstall/)

## <a name='imgomy'></a>imgomy
### <a name='alpine'></a>alpine
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
### <a name='jekyll'></a>jekyll
To run github.io locally:
```sh
#? install docker jekyll
docker pull jekyll/jekyll

#? run docker jekyll
sudo docker run --rm --volume="$HOME/git/jomivz.github.io:/srv/jekyll" --publish 127.0.0.1:4000:4000 jekyll/jekyll jekyll serve
# open your browser https://127.0.0.1:4000
```

### <a name='libreoffice'></a>libreoffice
[Alpine](https://wiki.alpinelinux.org/wiki/Alpine_Linux_Init_System)
```sh
docker pull linuxserver/libreoffice:7.2.2
docker run -d --name=libreoffice -e PUID=1000 -e PGID=1000 -e TZ=Europe/London -p 3000:3000 -v /home/jomivz/doc:/doc --restart unless-stopped linuxserver/libreoffice:7.2.2
```

### <a name='neo4j'></a>neo4j
* create a new database:

```sh
# compatible version for bloodhound v11.5.0 / neo4j v5 not supported
# what s the $zdom variable ? go to /pen/setenv
zdom="contoso"
snapshot=$zdom"_"`date +"%Y%m%d"`
mkdir /neo4j/data/$snapshot
mkdir /neo4j/logs/$snapshot

sudo docker run \
    --publish=7474:7474 --publish=7687:7687 \
    --volume=/neo4j/data/$snapshot:/data \
    --volume=/neo4j/logs/$snapshot:/logs \
    --name=$snapshot neo4j:4.4.21-community 
```

* check at the configuration:
```sh
sudo docker exec -it $snapshot /bin/grep -v ^$ conf/neo4j.conf | grep -v "^#"
sudo docker exec -it $snapshot /bin/grep dbms.memory conf/neo4j.conf
```

* [optimize the memory setting](https://neo4j.com/developer/memory-management/):

```sh
# run memory recommendation
docker exec -it $snapshot bin/neo4j-admin memrec

# for 64GB, memrec gives the following recommendation
docker exec -it $snapshot /bin/sed -i 's/#dbms.memory.heap.initial_size=512m/dbms.memory.heap.initial_size=24100m/' conf/neo4j.conf
docker exec -it $snapshot /bin/sed -i 's/#dbms.memory.heap.max_size=512m/dbms.memory.heap.max_size=24100m/' conf/neo4j.conf
docker exec -it $snapshot /bin/sed -i 's/dbms.memory.pagecache.size=512M/dbms.memory.pagecache.size=28100m/' conf/neo4j.conf
```

* test query execution time:
```sh
docker exec -it $snapshot /bin/bash
cat /data/example.cypher | bin/cypher-shell -u neo4j -p <password> --format plain
```

### <a name='python2'></a>python2
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

### <a name='postgres'></a>postgres

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
```sh
docker container start pg_container
docker exec -it pg_container bash
```
 
5- LOG ON the postgres database created like so:
```sh
psql -U root -d test_db

test_db=# \c
You are now connected to database "test_db" as user "root"
```

6- CREATE / RESTORE a backup
```sh
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
## <a name='imgsec'></a>imgsec
### <a name='exegol'></a>exegol
* extracted from the exegol [readthedocs](https://exegol.readthedocs.io/en/latest/getting-started/install.html#requirements):

```sh
python3 -m pip install exegol
# autocompletion
sudo apt update && sudo apt install bash-completion

```
### <a name='kerbrute'></a>kerbrute
```sh
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
# practice : https://tryhackme.com/room/attacktivedirectory
curl https://raw.githubusercontent.com/Sq00ky/attacktive-directory-tools/master/userlist.txt
curl https://raw.githubusercontent.com/Sq00ky/attacktive-directory-tools/master/passwordlist.txt

docker run -v .:/mnt -it kerbrute:1.0.3 enumuser --dc spookysec.local userlist.txt -t 100
```
### <a name='impacket'></a>impacket
```sh
sudo docker run --rm -it -p 134:135 rflathers/impacket rpcdump.py -port 135 1.3.8.3 > rpcdump_10.3.8.3.txt
```
### <a name='nuclei'></a>nuclei
```sh
#? install docker nuclei
docker pull projectdiscovery/nuclei
#? run docker nuclei
docker run --rm -ti projectdiscovery/nuclei -u https://jmvwork.xyz 
```
### <a name='spiderfoot'></a>spiderfoot
```sh
#? install docker spiderfoot
# (OPTIONAL): for Kali distrib embedding spiderfoot
cd /usr/share
sudo mv spiderfoot spiderfoot.old
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
### <a name='testssl'></a>testssl
```sh
#? install docker testssl.sh
docker pull drwetter/testssl.sh
#? run docker testssl.sh
docker run --rm -ti drwetter/testssl.sh https://jmvwork.xyz
```
### <a name='splunk'></a>splunk
```sh
docker pull splunk/splunk
docker run -d -p 8000:8000 -e "SPLUNK_START_ARGS=--accept-license" -e "SPLUNK_PASSWORD=<password>" --name splunk splunk/splunk:latest
```
## <a name='memo'></a>memo

[cli cheatsheet](https://f.hubspotusercontent10.net/hubfs/1699665/Docker_CLI_Cheat_Sheet_2021-01-12a.pdf) / [podman](https://docs.podman.io/en/latest/markdown/podman-pull.1.html)

```sh
# memo sysadmin docker
# create dockerfile
cat > Dockerfile <<EOF
FROM alpine
MAINTAINER obama@us.gouv
RUN apt update
RUN apt install -y git vim python3.8
EOF
# build docker image
docker build -t <your_username>/my-first-repo 
# run docker image
docker run <your_username>/my-first-repo.
docker run -i --expose=9999 b5593e60c33b bash
docker run -d -p 5801:5801 -p  9999:9999 .....
# push docker image
docker push <your_username>/my-first-repo 
# get the volumes
docker container inspect XXX |jq .[].Mounts
tailf xxx/debug.log 
```
## <a name='tshoot'></a>tshoot
### <a name='no-space-left-on-device-error'></a>no-space-left-on-device-error
```sh
#? tshoot docker no space left
docker build -t <your_username>/my-first-repo 
sudo su
docker rm $(docker ps -q -f 'status=exited')
docker rm $(docker ps -q -f 'status=exited')
```
### <a name='docker-daemon-config-file'></a>docker-daemon-config-file
Edit the file ```/etc/docker/daemon.json```.
```json
#
```