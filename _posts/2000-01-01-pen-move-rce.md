---
layout: post
title: pen / move / rce
category: pen
parent: cheatsheets
modified_date: 2022-02-16
permalink: /pen/move/rce
---

**Mitre Att&ck Entreprise**: 
* [TA0006 - Credentials Access](https://attack.mitre.org/tactics/TA0006/)
* [T1021  - Remote Services](https://attack.mitre.org/techniques/T1021/)

* [vfeed 2021](https://vfeed.io/top-twenty-most-exploited-vulnerabilities-in-2021/)
* [vfeed 2020](https://vfeed.io/2020-top-10-most-exploited-vulnerabilities/)
* [vfeed 2019](https://vfeed.io/5-critical-2019-cves-that-every-ciso-must-patch-before-he-get-fired/)
* [vfeed 2016](https://vfeed.io/how-vfeed-vulnerability-intel-tackles-the-top-10-most-exploited-vulnerabilities-2016-2019/)

<table class="sortable">
<col width="20%">
<col width="80%">
<thead>
<tr>
<th>Reference</th>
<th>OS</th>
<th>Service</th>
<th>PoC</th>
</tr>
</thead>
<tbody>
<tr>
	<td>CVE-2021-22986</td>
	<td>BIG-IP</td>
	<td>LB</td>
	<td><ul>
	<li>POC: <a href="https://youtu.be/xqzfNqMrFGQ">YT - Rapid SafeGuard</a></li>
	<li>MSF: exploit/linux/http/f5_icontrol_rest_ssrf_rce</li>
	</ul></td>
</tr>
<tr>
	<td>CVE-2021-21972</td>
	<td>VMware</td>
	<td>VCenter</td>
	<td><ul>
	<li>POC: <a href="https://swarm.ptsecurity.com/unauth-rce-vmware/">Article - PTSecurity </a></li>
	<li><a href="https://kb.vmware.com/s/article/82374">Mitigation - VMWare KB 82374</a></li>
	<li>MSF: exploits/multi/http/vmware_vcenter_server_unauthenticated_file_upload_exploit</li>
	</ul></td>
</tr>
<tr>
	<td>CVE-2021-21974</td>
	<td>VMware</td>
	<td>VCenter</td>
	<td><ul>
	<li>POC: <a href="https://github.com/Shadow0ps/CVE-2021-21974"></a></li>
	</ul></td>
</tr>
<tr>
	<td>CVE-2021-21985</td>
	<td>VMware</td>
	<td>VCenter</td>
	<td></td>
</tr>
<tr>
	<td>CVE-2021-22005</td>
	<td>VMware</td>
	<td>VCenter</td>
	<td></td>
</tr>
<tr>
	<td>CVE-2021-44228</td>
	<td>Apache</td>
	<td>Log4j</td>
	<td><ul>
	<li>CODENAME: Log4Shell</li>
	<li>POC: <a href="https://attackerkb.com/topics/in9sPR2Bzt/cve-2021-44228-log4shell/rapid7-analysis?referrer=blog">List - AttackerKB Affected Products</a></li>
	<li><a href="https://github.com/veracode-research/rogue-jndi">Tool - Veracode rogue-jndi LDAP server</a></li>
	<li><a href="https://www.youtube.com/watch?v=Yl30yeQBcU8">PoC - YT - VMWare VCenter 6.5 to 6.7. Null SAMLRequest + LDAP JNDI url in 'X-Forwarded-For' over the login page.</a></li>
	<li>TEST: <a href="https://tryhackme.com/room/solar"></a></li>
	<li>TEST: <a href="https://tryhackme.com/room/lumberjackturtle"></a></li>
	</ul></td>
</tr>
<tr>
	<td>CVE-2021-41773</td>
	<td>Apache</td>
	<td></td>
	<td><ul>
	<li>VER: httpd:2.4.49</li>
	<li>POC: <a href="https://github.com/creadpag/CVE-2021-41773-POC/blob/main/cve-2021-41773.nse">nmap nse</a></li>
	<li>CMD: curl http://localhost:8080/cgi-bin/%2e%2e/%2e%2e/%2e%2e/%2e%2e/%2e%2e/etc/passwd</li>
	</ul></td>
</tr>
<tr>
	<td>CVE-2021-26855</td>
	<td>Microsoft</td>
	<td>Exchange</td>
	<td><ul>
	<li>CODENAME: ProxyLogon</li>
	</ul></td>
<tr>
	<td>CVE-2021-26084</td>
	<td>Confluence</td>
	<td>OGNL</td>
	<td></td>
	<td>CVE-2021-40444</td>
	<td>Microsoft</td>
	<td>MSHTML</td>
	<td></td>
<tr>
	<td>CVE-2021-43798</td>
	<td>Graphana</td>
	<td></td>
	<td></td>
<tr>
	<td>CVE-2021-22205</td>
	<td>GitLab</td>
	<td></td>
	<td></td>
<tr>
	<td>CVE-2021-42013</td>
	<td>Apache</td>
	<td>HTTP</td>
	<td><ul>
	<li>VER: httpd 2.4.50</li>
	<li>REQ: CGI-BIN enabled, </li>
	</ul></td>
</tr>
<tr>
	<td>CVE-2021-36934</td>
	<td>Windows</td>
	<td></td>
	<td><ul>
	<li>CODENAME: HiveNightmare / SeriousSam</li>
	</ul></td>
</tr>
<tr>
	<td>CVE-2021-21300</td>
	<td>Git</td>
	<td>Visual Studio</td>
	<td></td>
</tr>
<tr>
	<td>CVE-2021-38647</td>
	<td>Azure</td>
	<td>Open Management Infrastructure</td>
	<td>OmiGod</td>
</tr>
<tr>
	<td>CVE-2021-42278 / CVE-2021-42287</td>
	<td>Windows</td>
	<td>Active Directory</td>
	<td><ul>
	<li><a href="https://cloudbrothers.info/exploit-kerberos-samaccountname-spoofing/"> PoC - Article - ...</a></li>
	<li><a href="https://pythonawesome.com/exploiting-cve-2021-42278-and-cve-2021-42287-to-impersonate-da-from-standard-domain-user/">PoC - Article - ...</a></li>
	</ul></td>
</tr>
<tr>
	<td>CVE-2021-35211</td>
	<td>Serv-U</td>
	<td>FTP</td>
	<td><ul>
	<li><a href="https://github.com/BishopFox/CVE-2021-35211"> Tool - BishopFox</a></li>
	</ul></td>
</tr>
<tr>
	<td>CVE-2020-5902</td>
	<td>BIG-IP</td>
	<td>LB</td>
	<td><ul>
	<li>POC: <a href="https://github.com/jas502n/CVE-2020-5902">GH jas502n</a></li>
	<li>MSF: exploit/linux/http/f5_bigip_tmui_rce</li>
	</ul></td>
</tr>
<tr>
	<td>CVE-2020-0796</td>
	<td>Windows</td>
	<td>SMBv3</td>
	<td><ul>
	<li>CODENAME: SMBGhost</li>
	<li>MSF: exploit/smbghost_privesc</li>
    <li>POC: Disable security: Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" DisableCompression -Type DWORD -Value 0 -Force</li>
	</ul></td>
</tr>
<tr>
	<td>CVE-2020-1472</td>
	<td>Windows</td>
	<td>MS-NRPC</td>
	<td><ul>
	<li>CONDENAME: Zerologon</li>
	<li>POC: <a href="https://github.com/risksense/zerologon">GH risksense</a></li>
	<li>TEST: <a href="https://tryhackme.com/room/zerologon">TryHackMe</a></li>
	
    </ul></td>
</tr>
<tr>
	<td>CVE-2020-14882</td>
	<td>Oracle</td>
	<td>WebLogic</td>
    <td></td>
</tr>
<tr>
	<td>CVE-2020-1938</td>
	<td>Apache</td>
	<td>Tomcat</td>
    <td><ul>
	<li>CODENAME: GhostCat</li>
	<li>POC: <a href="https://github.com/hypn0s/AJPy">github/hypn0s</a></li>
	<li>POC: AJP protocol enabled. Port 8009 open.</li>
	<li>VER: v9.0.x < 9.0.31, v8.5.x < 8.5.51, v7.x < 7.0.100</li>
	<li>TEST: <a href="https://tryhackme.com/room/tomghost">TryHackMe</a></li>
	</ul></td>
</tr>
<tr>
	<td>CVE-2020-3452</td>
	<td>Cisco</td>
	<td>ASA</td>
    <td></td>
</tr>
<tr>
	<td>CVE-2020-0688</td>
	<td>Windows</td>
	<td>Exchange</td>
    <td></td>
</tr>
<tr>
	<td>CVE-2020-16898</td>
	<td></td>
	<td>Windows</td>
	<td><ul>
	<li>CODENAME: Bad Neighor</li>
	</ul></td>
</tr>
<tr>
	<td>CVE-2020-11651</td>
	<td>SaltStack</td>
	<td></td>
	<td></td>
</tr>
<tr>
	<td>CVE-2020-1350</td>
	<td>Windows</td>
	<td>DNS</td>
	<td><ul>
	<li>CODENAME: SIGRed</li>
	</ul></td>
</tr>
<tr>
	<td>CVE-2019-0708</td>
	<td>Windows</td>
	<td>RDP</td>
	<td><ul>
	<li>CODENAME: BlueKeep</li>
	<li>MSF: exploit/windows/rdp/cve_2019_0708_bluekeep_rce</li>
	</ul></td>
</tr>
<tr>
	<td>CVE-2019-19781</td>
	<td>Citrix ADC</td>
	<td>ADC</td>
	<td><ul>
	<li>MSF: exploit/linux/http/citrix_dir_traversal_rce</li>
    <li>VER: 10.5, 11.1, 12.0, 12.1, and 13.0</li>
	</ul></td>
</tr>
<tr>
	<td>CVE-2017-0144</td>
	<td>Windows</td>
	<td>SMB</td>
	<td><ul>
	<li>CODENAME: EternalBlue</li>
	<li>MSF: exploit/windows/smb/ms17_010_eternalblue</li>
	<li>TEST: <a href="https://tryhackme.com/room/blue"></a></li>
	
	</ul></td>
</tr>
<tr>
	<td>CVE-2017-0145</td>
	<td>Windows</td>
	<td>SMB</td>
	<td><ul>
	<li>CODENAME: DoublePulsar</li>
	<li>MSF: exploit/windows/smb/smb_doublepulsar_rce</li>
	</ul></td>
<tr>
	<td>CVE-2017-0145</td>
	<td>Windows</td>
	<td>RDP</td>
	<td><ul>
	<li>CODENAME: DoublePulsar</li>
	<li>MSF: exploit/windows/rdp/rdp_doublepulsar_rce</li>
	</ul></td>
</tr>
</tbody>

</table>
<link href="/sortable.css" rel="stylesheet" />
<script src="/sortable.js"></script>