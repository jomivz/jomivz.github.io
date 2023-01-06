---
layout: post
title: Setup Debian 11 
category: Pentesting
parent: Pentesting
grand_parent: Cheatsheets
modified_date: 2022-12-09
permalink: /:categories/:title/
---

<!-- vscode-markdown-toc -->
* [keepassxc + yubikey](#keepassxcyubikey)
* [apt install](#aptinstall)
* [dpkg install](#dpkginstall)
* [script install](#dpkginstall)
* [git repositories](#gitrepositories)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='keepassxcyubikey'></a>keepassxc + yubikey

* [instructions](https://keepassxc.org/docs/#faq-yubikey-howto)
* [tutorial video](https://www.youtube.com/watch?v=r6Qe9Z-kOH0)
* [yubico personilization tool](https://www.yubico.com/support/download/yubikey-personalization-tools/)

## <a name='aptinstall'></a>apt install

| **Category**  |    **Packages**    |
|-----------------|------------------|
| system | terminator csvtool htop keepassxc docker.io flameshot  tesseract-ocr sqlitebrowser k3b ffmpeg zsh gparted virtualbox neo4j |
| network | tigervnc-viewer openvpn wireshark tshark remmina x2goclient lightdm-remote-session-freerdp2 |
| development | terraform python3 python3-venv python3-pip |
| pentest | nmap hashcat hydra mitmproxy gobuster |

**Adding Repositories**
* [hashicorp](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) 
* [neo4j](https://neo4j.com/docs/operations-manual/current/installation/linux/debian/)
* [virtualbox](https://www.virtualbox.org/wiki/Linux_Downloads)

## <a name='dpkginstall'></a>dpkg install 

* [maltego](https://www.maltego.com/downloads/)
* [visualstudiocode](https://code.visualstudio.com/Download)

## <a name='gitrepositories'></a>script install

* [burp download](https://portswigger.net/burp/releases/professional-community-2022-11-4?requestededition=community&requestedplatform=) 

Once downloaded, run the followingcommands:
```
chmod +x burpsuite_*.sh
./burpsuite_*.sh
```

## <a name='gitrepositories'></a>git repositories

| **Category**  |    **Repositories**    |
|-----------------|------------------|
| Recon | [amass](https://github.com/OWASP/Amass), [spiderfoot](https://github.com/smicallef/spiderfoot), [legion](https://github.com/GoVanguard/legion) |
| Initial Access | [responder](https://github.com/lgandx/Responder) |
| AD | [pywerview](https://github.com/the-useless-one/pywerview) |
| Exploitation | [searchsploit](https://gitlab.com/exploit-database/exploitdb), [seatbelt](https://github.com/GhostPack/Seatbelt), [msf](https://github.com/rapid7/metasploit-framework) |
| Post-Exploitaiton | [cme](https://github.com/Porchetta-Industries/CrackMapExec), [lsassy](https://github.com/Hackndo/lsassy), [donpapi](https://github.com/login-securite/DonPAPI), [masky](https://github.com/Z4kSec/Masky), [pypykatz](https://github.com/skelsec/pypykatz), [evil-winrm](https://github.com/Hackplayers/evil-winrm), [rubeus](https://github.com/GhostPack/Rubeus), [impacket](https://github.com/SecureAuthCorp/impacket) |

## <a name='gitrepositories'></a>docker containers

* [sysadmin docker](/sysadmin/sys-virt-docker-cli/)