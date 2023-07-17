---
layout: post
title: T0000 Setup OS Kali 2021.1 
category: pen
parent: cheatsheets
modified_date: 2022-03-09
permalink: /pen/setup-kali
---

<!-- vscode-markdown-toc -->
* 1. [Docker install](#Dockerinstall)
* 2. [OpenVAS install](#OpenVASinstall)
* 3. [Jupyter notebook install](#Jupyternotebookinstall)

<!-- vscode-markdown-toc-config
	numbering=true
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

##  1. <a name='Dockerinstall'></a>Docker install

[LibVirt - Virtual Networking](https://wiki.libvirt.org/page/VirtualNetworking)
https://linuxconfig.org/how-to-use-bridged-networking-with-libvirt-and-kvm

##  1. <a name='Dockerinstall'></a>Docker install

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
##  2. <a name='OpenVASinstall'></a>OpenVAS install
```bash
#? install OpenVAS for kali 2021.1
sudo apt update
sudo apt upgrade -y
sudo apt dist-upgrade
sudo apt install openvas
sudo gvm-check-setup
sudo runuser -u _gvm -- gvm-manage-certs -a -f
sudo gvm-check-setup
systemctl start redis-server@openvas.service
sudo gvm-check-setup
sudo runuser -u _gvm -- greenbone-nvt-sync
sudo gvm-setup
vi /etc/postgresql/13/main/postgresql.conf
sudo vi /etc/postgresql/13/main/postgresql.conf
sudo vi /etc/postgresql/14/main/postgresql.conf
sudo systemctl restart postgresql
sudo gvm-setup
sudo gvm-start
ss -ant
sudo gvm-stop
sudo gvm-start
sudo runuser -u _gvm -- gvmd --user=admin --new-password=Azertyuiop_1
sudo gvm-stop
sudo gvm-start

```
##  3. <a name='Jupyternotebookinstall'></a>Jupyter notebook install
 
 - Source from [digitalocean](https://www.digitalocean.com/community/tutorials/how-to-set-up-jupyter-notebook-with-python-3-on-ubuntu-20-04-and-connect-via-ssh-tunneling).
 - Check my [jupyter playbook](/playbook/)
 
```bash
#? install Jupyter notebook for kali 2021.1
# install the basic packages 
apt install libssl-dev python3-pip python3-dev
sudo -H pip3 install --upgrade pip
sudo -H pip3 install virtualenv

# create the virtual environment
mkdir ~/jupyter
cd ~/jupyter
virtualenv jupenv

# install the basic python modules
pip install pandas
pip install pyproject-toml
pip install jupyter

# install packages to manage api keys with seahorse
pip install keyring
pip install secretstorage 
pip install dbus-python 

# install pandas GUI with python 3.9
apt install python3-pyqt5 python3-pyqt5.qtwebengine python3-pyqt5.qtsvg python3-pyqt5.qtchart  python3-pyqt5.sip
pip install pandasgui

# install specific python modules
pip install networksdb

# run it / check install
source jupenv/bin/activate
jupyter notebook --no-browser --port=8889 --ip 0.0.0.0
```


