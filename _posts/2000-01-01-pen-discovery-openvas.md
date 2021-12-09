---
layout: post
title: OpenVAS cheatsheet
category: Pentesting
parent: Pentesting
grand_parent: Cheatsheets
modified_date: 2021-12-02
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

## <a name='KaliLinux2020.1install'></a>Administration

```bash
#? memo pentesting discovery openvas admin
#
# start the service 
sudo gvm-start
#
# stop the service 
sudo gvm-stop
#
# update/sync the signatures database
sudo gvm-feed-update -h
sudo runuser -u _gvm -- greenbone-nvt-sync
```
## <a name='KaliLinux2020.1install'></a>Troubleshooting

```bash
#? memo pentesting discovery openvas tshoot
#
# check port is listening on localhost:9392
ss -lnt4
#
# check the service logs
sudo journalctl -xeu gvmd.service
#
# check the setup
gvm-check-setup -h
gvm-setup -h

```
