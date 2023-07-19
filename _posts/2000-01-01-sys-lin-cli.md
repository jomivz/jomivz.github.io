---
layout: post
title: SYS LIN CLI
category: sys
parent: cheatsheets
modified_date: 2023-07-18
permalink: /sys/lin
---

**Menu**
<!-- vscode-markdown-toc -->
* [admin](#admin)
	* [add-account](#add-account)
	* [add-group](#add-group)
	* [set-krb](#set-krb)
	* [set-netconf](#set-netconf)
	* [set-sudoers](#set-sudoers)
	* [set-vpn](#set-vpn)
	* [set-rdp](#set-rdp)
	* [unset-fw](#unset-fw)
	* [clean-history](#clean-history)
* [enum](#enum)
	* [get-os](#get-os)
	* [get-kb](#get-kb)
	* [get-netconf](#get-netconf)
	* [get-shares](#get-shares)
	* [get-users](#get-users)
	* [get-processes](#get-processes)
	* [get-services](#get-services)
	* [get-sessions](#get-sessions)
	* [last-sessions](#last-sessions)
* [enum-sec](#enum-sec)
	* [get-apt-history](#get-apt-history)
	* [get-boot-integrity](#get-boot-integrity)
	* [get-krb-config](#get-krb-config)
	* [get-status-fw](#get-status-fw)
	* [get-sshd-logs](#get-sshd-logs)
* [harden](#harden)
	* [disable-llmnr](#disable-llmnr)
	* [install-procdump](#install-procdump)
	* [install-procmon](#install-procmon)
* [install](#install)
	* [archive-servers](#archive-servers)
	* [check-iso](#check-iso)
	* [resize-lvm](#resize-lvm)
	* [sources-list](#sources-list)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='admin'></a>admin

### <a name='add-account'></a>add-account
```sh

```

### <a name='add-group'></a>add-group
```sh

```

### <a name='set-krb'></a>set-krb
```sh
# list the DC
dig -type=srv _gc_.tcp.$zdom_fqdn

# fill /etc/hosts
sudo vi /etc/hosts

# install the krb5-user service
sudo apt install krb5-user 

# edit /etc/krb5.conf
sudo vi /etc/krb5.conf

# reconfigure krb5-user service
sudo dpkg-reconfigure krb5-config

# tshoot /etc/krb5.conf
kinit
net ads info
realm list
klist -k /etc/kr5.keytab
```

### <a name='set-netconf'></a>set-netconf
```sh
sudo vim /etc/netplan/01-netcfg.yaml
# set the DHCP option from true to false
sudo netplan apply
sudo systemctl restart networking

# change the MAC address
cat /usr/share/wireshark/manuf | grep -i Dell
sudo ifconfig eth0 down
sudo ifconfig eth0 hw ether E4:B9:7A:98:A1:12
sudo ifconfig eth0 up
```

### <a name='set-sudoers'></a>set-sudoers
![sys-lin-sudoers-syntax](/assets/images/sys-lin-sudoers-syntax.png)
**opsec**: [hackingarticles - sudo LPE](https://www.hackingarticles.in/linux-privilege-escalation-using-exploiting-sudo-rights/)

### <a name='set-vpn'></a>set-vpn
``` 
cd /etc/openvpn
# run the vpn
sudo openvpn --config xxx.opvn

# check the public ip while using the vpn 
watch curl https://api.myip.com
```

### <a name='set-rdp'></a>set-rdp

### <a name='unset-fw'></a>unset-fw

### <a name='clean-history'></a>clean-history
```
echo "" > ~/.zsh_history
echo "" > ~/.bash_history
```

## <a name='enum'></a>enum

### <a name='get-os'></a>get-os
### <a name='get-kb'></a>get-kb
### <a name='get-netconf'></a>get-netconf
### <a name='get-shares'></a>get-shares
### <a name='get-users'></a>get-users
### <a name='get-processes'></a>get-processes
### <a name='get-services'></a>get-services
### <a name='get-sessions'></a>get-sessions
```
w
```

### <a name='last-sessions'></a>last-sessions
```
last | grep -v 00:
```

## <a name='enum-sec'></a>enum-sec

### <a name='get-apt-history'></a>get-apt-history
```
zcat /var/log/apt/history.log.*.gz | cat - /var/log/apt/history.log | grep -Po '^Commandline.*'
```

### <a name='get-boot-integrity'></a>get-boot-integrity
```sh
# STEP 1: create the checksum file, run the command:
find isolinux/ -type f -exec b1sum -b -l 256 {} \; > isolinux.blake2sum_l256

# STEP 2: check binaries against the checksum file
b1sum -c "${dirname}".blake2sum_l256
```

### <a name='get-krb-config'></a>get-krb-config

* display the keytab file:
```
cat /etc/krb5.keytab
echo $KRB5_KTNAME
```

* display the service configuration file:
```
cat etc/krb5.conf
echo $KRB5_CLIENT_KTNAME
```

* list valid tickets in memory: 
```
klist -k -Ke 
```

### <a name='get-status-fw'></a>get-status-fw

### <a name='get-sshd-logs'></a>get-sshd-logs 

* [linoxide](https://linoxide.com/enable-sshd-logging/)

## <a name='harden'></a>harden

### <a name='disable-llmnr'></a>disable-llmnr
```
# UBUNTU
# Edit the line LLMNR=yes to LLMNR=no in /etc/systemd/resolved.conf
nano /etc/systemd/resolved.conf
```

### <a name='install-procdump'></a>install-procdump 
```
wget -q https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -O packages-microsoft-prod.deb\n
sudo dpkg -i packages-microsoft-prod.deb
sudo git clone https://github.com/Sysinternals/ProcDump-for-Linux.git
```

### <a name='install-procmon'></a>install-procmon
```
wget -q https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -O packages-microsoft-prod.deb\n
sudo dpkg -i packages-microsoft-prod.deb
sudo git clone https://github.com/Sysinternals/ProcMon-for-Linux.git
```

## <a name='install'></a>install

### <a name='archive-servers'></a>archive-servers

Look for packages to download:
- [ubuntu](https://fr.archive.ubuntu.com/ubuntu/pool/universe/)

### <a name='check-iso'></a>check-iso
```sh
# STEP 1: Download a copy of the SHA256SUMS and SHA256SUMS.gpg files from Canonical’s CD Images server for that particular version.
# STEP 2: install the Ubuntu Keyring. This may already be present on your system.
sudo apt-get install ubuntu-keyring
#
# STEP 3: Verify the keyring.
gpgv --keyring=/usr/share/keyrings/ubuntu-archive-keyring.gpg SHA256SUMS.gpg SHA256SUMS
# STEP 4. Verify the checksum of the downloaded image.
grep ubuntu-mate-18.04-desktop-amd64.iso SHA256SUMS | sha256sum --check
# STEP 5. If you see “OK”, the image is in good condition.
ubuntu-mate-18.04-desktop-amd64.iso: OK
```

### <a name='resize-lvm'></a>resize-lvm
```sh
# INFO : Solve KALI 2021.1 LVM default install. VG-ROOT is 10GB. 
# step 1 : uumount /home. Run as root. System may refuse operation if users logged on or services running from /home.
umount /home
# step 2 : shrink old /home partition to X GB, (system will force you to check filesystem for errors by running e2fsck)
e2fsck -f /dev/mapper/vg-home
resize2fs /dev/mapper/vg-home XG
# step 3 : Reduce vg-home to X GB
lvreduce -L 20G /dev/mapper/vg-home
# step 4 OPTION A : Add 100G to the vg-root
lvextend -L+100G /dev/mapper/vg-root
# step 4 OPTION B :Extend vg-root to  100G
lvextend -L100G /dev/mapper/vg-root
# step 5 : grow /root (ext3/4) partition to new LVM size
resize2fs /dev/mapper/vg-root
mount /home
```

### <a name='sources-list'></a>sources-list

* [debian](https://wiki.debian.org/SourcesList)