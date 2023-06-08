---
layout: post
title: Sysadmin LIN CLI
category: sys
parent: cheatsheets
modified_date: 2023-06-08
permalink: /sys/lin
---

**Menu**
<!-- vscode-markdown-toc -->
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
* [tamper](#tamper)
	* [add-account](#add-account)
	* [set-netconf](#set-netconf)
	* [set-vpn](#set-vpn)
	* [set-rdp](#set-rdp)
	* [unset-fw](#unset-fw)
	* [clean-history](#clean-history)
* [harden](#harden)
	* [disable-llmnr](#disable-llmnr)
	* [install-procdump](#install-procdump)
	* [install-procmon](#install-procmon)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

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

## <a name='tamper'></a>tamper

### <a name='add-account'></a>add-account
### <a name='set-netconf'></a>set-netconf
```
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