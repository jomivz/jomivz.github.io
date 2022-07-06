---
layout: post
title: Palo Alto XQL queries 
parent: EDR
category: EDR
grand_parent: Cheatsheets
modified_date: 2022-07-01
permalink: /:categories/:title/
---

<!-- vscode-markdown-toc -->
* [practiced queries](#practicedqueries)
	* [Get the public IP used by an endpoint](#GetthepublicIPusedbyanendpoint)
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

### <a name='GetthepublicIPusedbyanendpoint'></a>Get the public IP used by an endpoint
```
dataset = endpoints
| last_origin_ip = 8.8.8.8
```

### <a name='SpotSMBconnectionsforIP10.0.0.1'></a>Spot SMB connections for IP 10.0.0.1
```
preset = network_story
| filter action_local_ip = "10.0.0.1" and action_remote_port = 445
| comp count(_time) as hits by action_remote_ip
| sort desc hits
```

### <a name='ListoflocalopensessionssortedbydescendanthitsforPC001'></a>List of local open sessions sorted by descendant hits for PC001
```
preset = network_story
| filter agent_hostname = "PC001" and action_local_ip != null
| comp count(_time) as hits by action_local_ip, action_local_port, action_remote_ip
| sort desc hits
```

### <a name='Listnetworksessionswithprocessesforasetofendpoints'></a>List network sessions with processes for a set of endpoints
```
preset=network_story 
| filter agent_hostname in ("PC001","PC002","PC003")
| comp count(_time) as hits by agent_hostname, action_local_ip, action_local_port, action_remote_ip
| sort desc hits 
| fields _time, agent_hostname, action_local_port, action_remote_ip, action_remote_port, dst_actor_process_image_name, dst_actor_process_image_path 
```

### <a name='Topuploadsbyremoteport'></a>Top uploads by remote port
```
preset = network_story 
| filter agent_hostname = "PC001" AND action_remote_ip != null
| comp sum(action_total_upload) as uploads by agent_hostname, action_local_ip, action_remote_ip, action_remote_port, actor_process_command_line 
| alter MB_uploads = divide(uploads, 1048576)
| fields MB_uploads, agent_hostname, action_local_ip, action_remote_ip, action_remote_port, actor_process_command_line
| sort desc MB_uploads
```

### <a name='NetworkactivityovertheLANforPC001'></a>Network activity over the LAN for PC001
```
dataset = xdr_data
| alter privrange1 = incidr(action_remote_ip,"10.0.0.0/8")
| alter privrange2 = incidr(action_remote_ip,"172.16.0.0/12")
| alter privrange3 = incidr(action_remote_ip,"192.168.0.0/16")
| filter agent_hostname = " PC001" AND action_remote_ip != null AND (privrange1 = true OR privrange2 = true OR privrange3 = true)
| comp count(_time) as hits by action_local_ip, action_local_port, action_remote_ip
| sort desc hits
```

### <a name='NetworkactivitywiththeInternetforPC001'></a>Network activity with the Internet for PC001
```
dataset = xdr_data
| alter privrange1 = incidr(action_remote_ip,"10.0.0.0/8")
| alter privrange2 = incidr(action_remote_ip,"172.16.0.0/12")
| alter privrange3 = incidr(action_remote_ip,"192.168.0.0/16")
| filter agent_hostname = " PC001" AND action_remote_ip != null AND privrange1 != true AND privrange2 != true AND privrange3 != true
| comp count(_time) as hits by action_local_ip, action_local_port, action_remote_ip
| sort desc hits
```

### <a name='PublicsensitiveservicesexposedintheInternet'></a>Public sensitive services exposed in the Internet
```
dataset = xdr_data
| alter privrange1 = incidr(action_remote_ip,"10.0.0.0/8")
| alter privrange2 = incidr(action_remote_ip,"172.16.0.0/12")
| alter privrange3 = incidr(action_remote_ip,"192.168.0.0/16")
| filter agent_hostname != null AND action_remote_ip != null AND privrange1 != true AND privrange2 != true AND privrange3 != true
| filter action_local_port IN (21,23,88,135,445,512,514,2701,2702,3283,3389,4444,5800,5900,5938,5985,5986)
| comp count(_time) as hits by agent_hostname, action_local_ip, action_local_port, action_remote_ip
| sort desc hits
```
### <a name='GetactionsoverthewindowsregistryforPC001'></a>Get actions over the windows registry for PC001
```
preset = xdr_registry | filter agent_hostname = "PC001"
```

## <a name='PaloAltoexamplesTOTEST'></a>Palo Alto examples (TO TEST)
### <a name='Executingscheduledtaskonceonaspecifictime.'></a>Executing scheduled task once on a specific time.
```
# Adversaries often use this technique to execute dropped payload
dataset = xdr_data // Using the xdr dataset
 | filter event_type = PROCESS and event_sub_type = PROCESS_START and (action_process_image_command_line ~= "(-|\/)sc" and action_process_image_command_line ~= "(-|\/)st" and action_process_image_command_line contains "once" and action_process_image_command_line ~= "(-|\/)tn" and action_process_image_command_line ~= "(-|\/)tr") // Construct commandline indicative of scheduled task set to once on a specific time, usually used to execute a dropped payload
 | fields event_id,agent_hostname,action_process_image_name as Process_Name,action_process_image_command_line as Process_Command_Line  // Selecting the process command line, name, event id and host name 
 
# DLL file was written to ‘Windows’ directory by an injected process or over the network that been seen on less than 10 machines in the network.
dataset = xdr_data // Using the xdr dataset
| filter event_type = FILE and event_sub_type in (FILE_CREATE_NEW, FILE_WRITE, FILE_RENAME) and action_file_extension = "dll" and ((actor_process_is_special = 1 and action_file_remote_ip != null) or actor_is_injected_thread = true) and actor_process_image_name != "TrustedInstaller.exe" and action_file_path ~= "\\(w|W)indows\\"
| fields event_id,agent_hostname, action_file_name as file_name, action_file_path as file_path, action_file_sha256 as file_sha,actor_process_image_name as process_name ,actor_process_image_path as process_path, actor_process_image_sha256 as process_sha256, actor_process_image_command_line as process_cmd, action_file_remote_ip 
| comp count(agent_hostname) as counter by file_name, file_sha ,process_name
| filter counter < 10
```

### <a name='Lookingforfailedauthenticationeventsandsortingwiththefieldstoincludeusernamesourceip.'></a>Looking for failed authentication events and sorting with the fields to include username + source ip.
```
dataset = xdr_data // Using the xdr dataset
 | filter event_type = WINDOWS_EVENT_LOG and action_evtlog_event_id = 4625 and agent_hostname = "NHLA07414" // Filtering by windows event log and id 4625
 | alter User_Name =arrayindex(regextract(action_evtlog_message, "Account For Which Logon Failed:\r\n.*\r\n.*Account Name:.*?(\w.*)\r\n"),0), Logon_Type = arrayindex(regextract(action_evtlog_message, "Logon Type:.*?(\d+)\r\n"),0), Failure_Reason = arrayindex(regextract(action_evtlog_message,"Failure Reason:.*?(\w.*)\r\n"),0), Domain = arrayindex(regextract(action_evtlog_message, "Account For Which Logon Failed:\r\n.*\r\n.*.*\r\n.*Account Domain:.*?(\w.*?)\r\n"),0), Source_IP = arrayindex(regextract(action_evtlog_message, "Source Network Address:.*?(\d+\.\d+\.\d+\.\d+)\r\n"),0), Caller_Process_Name = arrayindex(regextract(action_evtlog_message, "Caller Process Name:.*?(\w.*)\r\n"),0), Host_Name = arrayindex(regextract(action_evtlog_message, "Workstation Name:.*?(\w.*)\r\n"),0) // Using regextract to get just a part of the full event log message into an array, then using arrayindex to take the first item in the array
 | dedup User_Name, Source_IP by asc _time 
 | fields User_Name, Source_IP
```
 
### <a name='WPADtoExternalIPaddresses'></a>WPAD to External IP addresses
```
# Detect and aggregate wpad activity going to external IP addresses.
config case_sensitive = false
| dataset = xdr_data
| filter event_type = NETWORK and action_external_hostname = "wpad.*" 
| filter action_external_hostname ~= "^wpad[.].*"
| filter  action_remote_ip != "10.*" and action_remote_ip != "192.168.*"
| alter rfc1918_172 = incidr(action_remote_ip, "172.16.0.0/12")
| filter rfc1918_172 = false
| comp count(event_timestamp) as network_event_count, count_distinct(agent_hostname) as distinct_hosts by action_remote_ip, action_external_hostname
```

### <a name='UseRPCcallartifactstodetectscheduledtasksremotelycreatedfromanotherhost'></a>Use RPC call artifacts to detect scheduled tasks remotely created from another host
```
dataset = xdr_data
| filter event_type = RPC_CALL and action_rpc_func_name = "SchRpcRegisterTask" and causality_actor_remote_pipe_name = "\Device\NamedPipe\ntsvcs"
| alter task_command_parsed = arrayindex(regextract(action_rpc_func_str_call_fields, "<Command>(.*)</Command>"), 0)
| alter task_arguments_parsed = arrayindex(regextract(action_rpc_func_str_call_fields, "<Arguments>(.*)</Arguments>"), 0)
| alter task_userid_parsed = arrayindex(regextract(action_rpc_func_str_call_fields, "<UserId>(.*)</UserId>"), 0)
| alter task_remote_ip_parsed = causality_actor_remote_ip
| fields agent_hostname, agent_ip_addresses, actor_effective_username, action_rpc_func_name, task_command_parsed, task_arguments_parsed, task_userid_parsed, task_remote_ip_parsed, action_rpc_func_str_call_fields, event_type, event_sub_type
```

### <a name='Stackcountdatauploadedtodomains'></a>Stack count data uploaded to domains
```
# XQL Query to find domains with most data uploaded to them
dataset = xdr_data
# | filter event_type = NETWORK and (event_sub_type = NETWORK_DATAGRAM_STATISTICS or event_sub_type = NETWORK_STREAM_STATISTICS)
| filter event_type = NETWORK
# Filter out internal destinations =====
| filter action_remote_ip != "10.*" and action_remote_ip != "192.168.*"
| alter rfc1918_172 = incidr(action_remote_ip, "172.16.0.0/12")
| filter rfc1918_172 = false
# ======================================
| alter parsed_domain = arrayindex(regextract(action_external_hostname, "(?i)([a-zA-Z0-9_-]+(?:\.(?:co\.uk|ac\.za|org\.au)|\.\w+)$)"), 0) // ?i for case insensitivity
# Optional, comment out following line to remove/aggregate non-domain results
# | replacenull parsed_domain = action_remote_ip
# | fields agent_hostname, action_local_ip, action_remote_ip, action_external_hostname, regex_domain, action_upload
| fields parsed_domain, action_upload, action_local_ip, event_type, event_sub_type
| comp sum(action_upload) as total_uploaded, count_distinct(action_local_ip) as distinct_src_ips by parsed_domain
| sort desc total_uploaded
```