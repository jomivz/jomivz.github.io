---
layout: post
title: dfir / lin / live
category: dfir
parent: cheatsheets
modified_date: 2024-01-04
permalink: /dfir/lin/live
---

## Challenges

| Challenge | Tactic | Technic |
|-------------------------------------------------------------------------|----------------------|------------------------------------------------|
| [THM Linux Backdoors](https://tryhackme.com/room/linuxbackdoors)        | persistence          | ssh, php, cron, .bashrc, pam_unix.so backdoors |
| [THM Linux Hooking Function](https://tryhackme.com/room/linuxbackdoors) | defense evasion      | LD_PRELOAD |
| [THM Linux PrivEsc Arena](https://tryhackme.com/room/linuxprivescarena) | privilege escalation | kernel exploit(dirty cow, stored pwd |
| [THM Linux Dirty Pipe](https://tryhackme.com/room/dirtypipe)            | privilege escalation | kernel exploit (dirty pipe) |
| [THM Linux Polkit](https://tryhackme.com/room/pwnkit)                   | privilege escalation | polkit exploit |

 ## Hacking tools

| Tool | Tactic | Technic |
|-------------------------------------------------------------------------|----------------------|------------------------------------------------|
| [sudo_killer](https://github.com/TH3xACE/SUDO_KILLER)                   | privilege escalation | sudo | 
|[lynis](https://github.com/CISOfy/lynis)                                 |                      |      |

```
cat /home/user/myvpn.ovpn
 cat /etc/openvpn/auth.txt
cat ~/.bash_history | grep -i passw
cat /home/user/.irssi/config | grep -i passw
```

## References

- [JMVWORK / sys / lin](/sys/lin)
- [CERT SG IRM-3-UnixLinuxIntrusionDetection](https://raw.githubusercontent.com/certsocietegenerale/IRM/main/EN/IRM-3-UnixLinuxIntrusionDetection.pdf)
- [Linux-Incident-Response](https://github.com/vm32/Linux-Incident-Response)
- [linux-forensics-command-cheat-sheet](https://fahmifj.github.io/blog/linux-forensics-command-cheat-sheet/)
