---
layout: post
title: Critical Century's RCE
parent: Pentesting
category: Pentesting
grand_parent: Cheatsheets
modified_date: 2021-11-23
permalink: /:categories/:title/
---

<table class="sortable">
<col width="20%">
<col width="80%">
<thead>
<tr>
<th>Reference</th>
<th>OS</th>
<th>Service</th>
<th>PoC</th>
<th><a href="https://github.com/rapid7/metasploit-framework/tree/master/modules/exploits">MSF Embedded</a></th>
<th>Nickname</th>
<th>MISC</th>
</tr>
</thead>
<tbody>
<tr>
	<td>CVE-2021-22986</td>
	<td>BIG-IP</td>
	<td>LB</td>
	<td><a href="https://youtu.be/xqzfNqMrFGQ">YT Rapid SafeGuard</a></td>
	<td>exploit/linux/http/f5_icontrol_rest_ssrf_rce</td>
	<td></td>
	<td></td>
</tr>
<tr>
	<td>CVE-2020-5902</td>
	<td>BIG-IP</td>
	<td>LB</td>
	<td><a href="https://github.com/jas502n/CVE-2020-5902">GH jas502n</a></td>
	<td>exploit/linux/http/f5_bigip_tmui_rce</td>
	<td></td>
	<td></td>
</tr>
<tr>
	<td>CVE-2021-21972</td>
	<td>VMware</td>
	<td>VCenter</td>
	<td></td>
	<td>exploits/multi/http/vmware_vcenter_server_unauthenticated_file_upload_exploit</td>
	<td></td>
	<td></td>
</tr>
<tr>
	<td>CVE-2020-0796</td>
	<td>Windows</td>
	<td>SMBv3</td>
	<td></td>
	<td>exploit/smbghost_privesc</td>
	<td>SMBGhost</td>
    <td>Disable security: Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" DisableCompression -Type DWORD -Value 0 -Force</td>
</tr>
<tr>
	<td>CVE-2020-1472</td>
	<td>Windows</td>
	<td>MS-NRPC</td>
	<td><a href="https://github.com/risksense/zerologon">GH risksense</a></td>
	<td></td>
	<td>Zerologon</td>
    <td></td>
</tr>
<tr>
	<td>CVE-2019-19781</td>
	<td>Citrix ADC</td>
	<td>ADC</td>
	<td></td>
	<td>exploit/linux/http/citrix_dir_traversal_rce</td>
	<td></td>
    <td>Version: 10.5, 11.1, 12.0, 12.1, and 13.0, to execute an arbitrary command payload.</td>
</tr>
<tr>
	<td>CVE-2019-19781</td>
	<td>Citrix ADC</td>
	<td>ADC</td>
	<td></td>
	<td>auxiliary/scanner/http/citrix_dir_traversal</td>
	<td></td>
    <td>Version: 10.5, 11.1, 12.0, 12.1, and 13.0, to execute an arbitrary command payload.</td>
</tr>
<tr>
	<td>CVE-2017-0144</td>
	<td>Windows</td>
	<td>SMB</td>
	<td></td>
	<td>exploit/windows/smb/ms17_010_eternalblue</td>
	<td>EternalBlue</td>
    <td></td>
</tr>
<tr>
	<td>CVE-2017-0145</td>
	<td>Windows</td>
	<td>SMB</td>
    <td></td>
	<td>exploit/windows/smb/smb_doublepulsar_rce</td>
	<td>DoublePulsar</td>
    <td></td>
</tr>
<tr>
	<td>CVE-2017-0145</td>
	<td>Windows</td>
	<td>RDP</td>
    <td></td>
	<td>exploit/windows/rdp/rdp_doublepulsar_rce</td>
	<td>DoublePulsar</td>
    <td></td>
</tr>
<tr>
	<td>CVE-2019-0708</td>
	<td>Windows</td>
	<td>RDP</td>
    <td></td>
	<td>exploit/windows/rdp/cve_2019_0708_bluekeep_rce</td>
	<td>BlueKeep</td>
    <td></td>
</tr>
</tbody>

</table>
<link href="/sortable.css" rel="stylesheet" />
<script src="/sortable.js"></script>