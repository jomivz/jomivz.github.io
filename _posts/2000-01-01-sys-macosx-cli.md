---
layout: post
title: sys / mac
category: sys
parent: cheatsheets
modified_date: 2024-02-05
permalink: /sys/mac
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
	* [get-app-integrity](#get-port-history)
        * [get-boot-integrity](#get-boot-integrity)
	* [get-port-history](#get-port-history)
	* [get-krb-config](#get-krb-config)
	* [get-status-fw](#get-status-fw)
	* [get-status-proxy](#get-status-proxy)
	* [get-sshd-logs](#get-sshd-log)

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

### set-filevault
```sh
sudo fdesetup enable
```

### set-syslogd
```sh
#
# 01 ### server-side # ensure the syslog daemon is running with networking enabled.
sudo /usr/sbin/syslogd -s   # ‘-s’ enables network socket
#
# 02 ### client-side # edit /etc/syslog.conf
echo "*.* @loghost.example.com" | sudo tee -a /etc/syslog.conf   # Replace 'loghost.example.com' with your remote log host
#
# 03 ### server-side # restart syslogd
sudo launchctl unload /System/Library/LaunchDaemons/com.apple.syslogd.plist
#
# 04 ### server-side # validate the log collection
tail -f /var/log/syslog   # Run this on the remote log host
#
```

### <a name='set-krb'></a>set-krb
```sh
# list the DC
dig -type=srv _gc_.tcp.$zdom_fqdn

# fill /etc/hosts
sudo vi /etc/hosts

# install the krb5-user service
sudo port install krb5-user 

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
```
# To list available updates
sudo softwareupdate --list
 
# To install all available updates
sudo softwareupdate --install --all  
```
### <a name='get-netconf'></a>get-netconf
```
# network card
ip link

# arp table
arp -a

# listening socket
netstat -nap and
lsof –i

# network connections
netstat -ntaupe
netstat -ant
watch ss -tt

# check if remote control is disabled
sudo systemsetup -getdisableremotecontrol        

# dns
cat /etc/hosts
cat /etc/resolv.conf
```

### <a name='get-shares'></a>get-shares
### <a name='get-users'></a>get-users
```
cat /etc/passwd
cat /etc/group
cat /etc/shadow

# dfir
grep :0: /etc/passwd
```

### <a name='get-processes'></a>get-processes
```
ps –aux
lsof -p [pid]
ps -eo pid,tt,user,fname,rsz
```
### <a name='get--scheduled-tasks'></a>get-scheduled-tasks
```
crontab -u root -l
cat /etc/crontab
ls –la /etc/cron.*
```
### <a name='get-services'></a>get-services
```
# List all services and their current states.
chkconfig --list

# Show status of all services.
service --status-all

# List running services (systemd)
systemctl list-units --type=service
```
### <a name='get-services'></a>get-periodic-scripts
```
# get periodic scripts
find /etc/periodic -type f -exec ls -l {} \;

# get periodic executions
grep "periodic" /var/log/system.log

# set back to default permissions
sudo chmod -R 755 /etc/periodic
sudo chown -R root:wheel /etc/periodic

# disable script
sudo chmod -x /etc/periodic/daily/500.daily
```

### <a name='get-sessions'></a>get-sessions
```
w
```

### <a name='last-sessions'></a>last-sessions
```
last | grep -v 00:
```

## <a name='enum-sec'></a>enum-sec
### <a name='get-boot-integrity'></a>get-login-hook
```sh
# Login and Logout hooks are defined in the com.apple.loginwindow.plist file located in the ~/Library/Preferences/
# Ensure that only authorized users have write access to the com.apple.loginwindow.plist file.
sudo chmod 644 ~/Library/Preferences/com.apple.loginwindow.plist
sudo chown root:wheel ~/Library/Preferences/com.apple.loginwindow.plist
```

### <a name='get-boot-integrity'></a>get-app-integrity
```sh
spctl -a -vvv -t install /Volumes/Install/Installer.app
codesign --verify --verbose /path/to/library.dylib
```

### <a name='get-boot-integrity'></a>get-startup-items
```sh
ls /Library/StartupItems/
```

### <a name='get-apt-history'></a>get-port-history
```
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
### get-security-logs
```sh
grep “SecurityAlert” /var/log/syslog 
```

### <a name='disable-llmnr'></a>disable-llmnr
```
Configuring Audit Control:

Edit the /etc/security/audit_control file to specify the auditing policies.

sudo nano /etc/security/audit_control

Modify the file to include the desired flags and event classes.

Starting the Audit Daemon:

sudo audit -s

Verifying Audit Configuration:

sudo audit -l
```
