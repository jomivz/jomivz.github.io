---
layout: post
title: sys / lin
category: sys
parent: cheatsheets
modified_date: 2024-06-12
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
* [audit](#audit)
	* [audit-fs-perms](#audit-fs-perms)
	* [audit-logs](#audit-logs)
* [enum](#enum)
	* [get-cpu](#get-cpu)
   	* [get-history](#get-history)
	* [get-kb](#get-kb)
	* [get-netconf](#get-netconf)
  	* [get-os](#get-os)
	* [get-processes](#get-processes)
	* [get-shares](#get-shares)
	* [get-scheduled-tasks](#get-scheduled-tasks)
	* [get-services](#get-services)
	* [get-sessions](#get-sessions)
	* [get-users](#get-users)
* [enum-sec](#enum-sec)
	* [get-apt-history](#get-apt-history)
	* [get-boot-integrity](#get-boot-integrity)
	* [get-krb-config](#get-krb-config)
	* [get-status-fw](#get-status-fw)
	* [get-status-proxy](#get-status-proxy)
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
# https://sysadminxpert.com/managing-user-accounts-and-permissions-in-linux/
sudo useradd john_doe
sudo usermod -c "John Doe" john_doe
sudo userdel john_doe
# reset password
sudo passwd john_doe

# service account
sudo useradd -r -s /sbin/nologin myserviceaccount
sudo passwd -l myserviceaccount
```

### <a name='add-group'></a>add-group
```sh
sudo groupadd developers
sudo usermod -aG developers john_doe

# remove group membership
sudo deluser john_doe developers
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

### <a name='set-sudoers'></a>set-ssh
```sh
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
ssh-copy-id user@hostname
vi /etc/ssh/sshd_config
# set => PasswordAuthentication no
sudo systemctl restart sshd
```

### <a name='set-sudoers'></a>set-sudoers
![sys-lin-sudoers-syntax](/assets/images/sys-lin-sudoers-syntax.png)
**opsec**: [hackingarticles - sudo LPE](https://www.hackingarticles.in/linux-privilege-escalation-using-exploiting-sudo-rights/)

### <a name='set-vpn'></a>set-vpn
```bash 
cd /etc/openvpn
# run the vpn
sudo openvpn --config xxx.opvn

# check the public ip while using the vpn 
watch curl https://api.myip.com
```

### <a name='set-rdp'></a>set-rdp
```bash
```

### <a name='unset-fw'></a>unset-fw
```bash
```

### <a name='clean-history'></a>clean-history
```bash
echo "" > ~/.zsh_history
echo "" > ~/.bash_history
```

## <a name='audit'></a>audit

### <a name='audit-fs-perms'></a>audit-fs-perms
```bash
find /home/ -type f -size +512k -exec ls -lh {} \;
find /etc/ -readable -type f 2>/dev/null
find / –perm -4000 -user root -type f
find / -mtime -0 -ctime -7
find / -atime 2 -ls 2>/dev/null
find / -mtime -2 -ls 2>/dev/null

/home/<user>/.ssh/authorized_keys
/home/<user>/.bashrc
```

### <a name='audit-logs'></a>audit-logs
```bash
lastlog
cat /var/log/lastlog
grep -v cron /var/log/auth.log* | grep -v sudo | grep -i user
grep -v cron /var/log/auth.log* | grep -v sudo | grep -i Accepted
grep -v cron /var/log/auth.log* | grep -v sudo | grep -i failed
grep -v cron /var/log/auth.log* | grep i "login:session"
```


## <a name='enum'></a>enum

### <a name='get-os'></a>get-cpu
```bash
uptime
free
df
cat /proc/meminfo
cat /proc/mounts
```

### <a name='get-os'></a>get-history
```bash
history
cat /home/$USER/.*_history
cat /home/$USER/.bash_history
cat /root/.bash_history
cat /root/.mysql_history
cat /home/$USER/.ftp_history
```

### <a name='get-kb'></a>get-kb
```bash
```

### <a name='get-netconf'></a>get-netconf
```bash
$ netstat -rn
$ route

# network card
ip link
ifconfig

# arp table
arp -a

# listening socket
sudo netstat -nap
lsof –i

# network connections
netstat -ntaupe
netstat -ano
netstat -nap
netstat -antp
netstat -antp | grep "ESTAB"

watch ss -tt

# dns
cat /etc/hosts
cat /etc/resolv.conf
```

### <a name='get-os'></a>get-os
```bash
date
cat /etc/timezone
uname -a
uname -m
cat /etc/*-release
hostname
cat /etc/hostname
echo $PATH
```

### <a name='get-processes'></a>get-processes
```bash
lsof -p [pid]
ps -eo pid,tt,user,fname,rsz
ps -aux
ps aux --sort=-%mem | head -n 10
top
htop
vmstat -s
pstree
```

### <a name='get-scheduled-tasks'></a>get-scheduled-tasks
```bash
crontab -u root -l
cat /etc/crontab
ls –la /etc/cron.*
tail -f /etc/cron.*/*
cat /etc/cron.daily
cat /etc/cron.hourly
cat /etc/cron.monthly
cat /etc/cron.weekly

/etc/cron*/
/etc/incron.d/*
/var/spool/cron/*
/var/spool/incron/*
```

### <a name='get-sessions'></a>get-sessions
```bash
w

# last-sessions
last | grep -v 00:
```

### <a name='get-services'></a>get-services
```bash
# List all services and their current states.
chkconfig --list

# Show status of all services.
service --status-all

# List running services (systemd)
systemctl list-units --type=service

more /etc/hosts
more /etc/resolv.conf

# service daemons
/etc/init.d/*
/etc/rc*.d/*
/etc/systemd/system/*

/etc/update.d/*
/var/run/motd.d/*
```

### <a name='get-shares'></a>get-shares
```bash
```

### <a name='get-users'></a>get-users
```
echo $USER
passwd -S <USER>

cat /etc/passwd
cat /etc/group
cat /etc/shadow
cat /etc/sudoers

# dfir
grep :0: /etc/passwd
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
cat /etc/krb5.conf
echo $KRB5_CLIENT_KTNAME
```

* list valid tickets in memory: 
```
klist -k -Ke 
```

### <a name='get-status-fw'></a>get-status-fw
```
iptables --list-rules
```

### <a name='get-status-proxy'></a>get-status-proxy
```
# https://www.shellhacks.com/linux-proxy-server-settings-set-proxy-command-line/
echo $HTTPS_PROXY
echo $HTTP_PROXY
echo $FTP_PROXY
```

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
