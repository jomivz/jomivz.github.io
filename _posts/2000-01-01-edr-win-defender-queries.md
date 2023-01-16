---
layout: post
title: Windows Defender queries 
parent: EDR
category: EDR
grand_parent: Cheatsheets
modified_date: 2022-12-07
permalink: /:categories/:title/
---

<!-- vscode-markdown-toc -->
* [practiced queries](#practicedqueries)
	* [Get the endpoints using a public IP](#GettheendpointsusingapublicIP)
	* [Spot SMB connections for IP 10.0.0.1](#SpotSMBconnectionsforIP10.0.0.1)
	* [List of local open sessions sorted by descendant hits for PC001](#ListoflocalopensessionssortedbydescendanthitsforPC001)
	* [List network sessions with processes for a set of endpoints](#Listnetworksessionswithprocessesforasetofendpoints)
	* [Top uploads by remote port](#Topuploadsbyremoteport)
	* [Network activity over the LAN for PC001](#NetworkactivityovertheLANforPC001)
	* [Network activity with the Internet for PC001](#NetworkactivitywiththeInternetforPC001)
	* [Public sensitive services exposed in the Internet](#PublicsensitiveservicesexposedintheInternet)
	* [Get actions over the windows registry for PC001](#GetactionsoverthewindowsregistryforPC001)
* [Palo Alto examples (TO TEST)](#PaloAltoexamplesTOTEST)
	* [Executing scheduled task once on a specific time.](#Executingscheduledtaskonceonaspecifictime.)
	* [Looking for failed authentication events and sorting with the fields to include username + source ip.](#Lookingforfailedauthenticationeventsandsortingwiththefieldstoincludeusernamesourceip.)
	* [WPAD to External IP addresses](#WPADtoExternalIPaddresses)
	* [Use RPC call artifacts to detect scheduled tasks remotely created from another host](#UseRPCcallartifactstodetectscheduledtasksremotelycreatedfromanotherhost)
	* [Stack count data uploaded to domains](#Stackcountdatauploadedtodomains)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='practicedqueries'></a>practiced queries

### <a name='GettheendpointsusingapublicIP'></a>Get the alerts associated to a user
```
# over 7 days backlog
AlertEvidence
| where Timestamp > ago(8d)
| where AccountName =~ "johndoe"
```


### <a name='GettheendpointsusingapublicIP'></a>Get the alerts associated to a machine
```
# over 7 days backlog
AlertEvidence
| where Timestamp > ago(8d)
| where DeviceName =~ "AL"
```
