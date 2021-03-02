---
layout: default
title: Splunk Search Queries based on BOTSv1
parent: SIEM
category: SIEM
grand_parent: Cheatsheets
---

# {{ page.title }}

Following use-cases can be replayed with the [Splunk BOTSv1 contest](https://github.com/splunk/botsv1):
- Light dataset (< 500 MB) of BOTSv1 contest on [tryhackme.com](https://tryhackme.com/room/bpsplunk) (working with splunk free version).
- Write-up available on [aldeid.com](https://www.aldeid.com/wiki/TryHackMe-BP-Splunk).

## Investigating HTTP logs 

Q01. Timeline HTTP logs to show up a bruteforce authentication in ```Joomla 3.5.1```:
```
sourcetype="stream:http" site="imreallynotbatman.com" c_ip="23.22.63.114" form_data=*
| rex field=form_data "username=(?P<username>[[:alnum:]]*).*&passwd=(?P<passwd>[[:alnum:]]*)&?"
| sort _time
```

Q02. Identify passwords used more than once:
```
sourcetype="stream:http" site="imreallynotbatman.com" form_data=*
| rex field=form_data "username=(?P<username>[[:alnum:]]*).*&passwd=(?P<passwd>[[:alnum:]]*)&?" 
| stats count by username, passwd
| sort -count
| where count > 1
```
Results is ```batman```.

Q03. Compute the password average length in the authentication bruteforce:
```
sourcetype="stream:http" site="imreallynotbatman.com" c_ip="23.22.63.114" form_data=*
| rex field=form_data "username=(?P<username>[[:alnum:]]*).*&passwd=(?P<passwd>[[:alnum:]]*)&?" 
| eval leng = len(passwd)
| stats avg(leng)
```

Q041. Compare passwords to an inputlookup (coldplay songs list in the contest): 
```
| inputlookup coldplay.csv
```

Q042. Search within the inputlookup which 6 letters-song was used as a password for an authentication attempt:
```
index=botsv1 sourcetype=stream:http form_data=*username*passwd*
| rex field=form_data "passwd=(?<userpassword>\w+)"
| eval lenpword=len(userpassword)
| search lenpword=6
| eval password=lower(userpassword)
| lookup coldplay.csv song as password OUTPUTNEW song
| search song=*
| table song
```

Q05. Evaluate time between 2 authentication attempts with the same password value (here ```batman```):
```
index=botsv1 sourcetype=stream:http form_data=*username*passwd* 
| rex field=form_data "passwd=(?<p>\w+)" 
| search p="batman" 
| transaction p
| eval dur=round(duration,2)
| table dur
```

Q06. Look for an HTTP file upload:

```
index=botsv1 sourcetype=stream:http dest="192.168.250.70" "multipart/form-data" 
| head 1
```

[RFC 7578](https://tools.ietf.org/html/rfc7578) describes the ```multipart/form-data``` media type
widely used in HTML forms to upload file (but also used by a wide variety of applications and transported by a
   wide variety of protocols).

```
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <title>upload</title>
</head>
<body>
<form action="http://localhost:8000" method="post" enctype="multipart/form-data">
  <p><input type="text" name="text1" value="text default">
  <p><input type="text" name="text2" value="a&#x03C9;b">
  <p><input type="file" name="file1">
  <p><input type="file" name="file2">
  <p><input type="file" name="file3">
  <p><button type="submit">Submit</button>
</form>
</body>
</html>
```

The different ```Content-Type``` in the HTTP header look like :
```
POST / HTTP/1.1
[[ Less interesting headers ... ]]
Content-Type: multipart/form-data; boundary=---------------------------735323031399963166993862150
Content-Length: 834

-----------------------------735323031399963166993862150
Content-Disposition: form-data; name="text1"

text default
-----------------------------735323031399963166993862150
Content-Disposition: form-data; name="text2"

aωb
-----------------------------735323031399963166993862150
Content-Disposition: form-data; name="file1"; filename="a.txt"
Content-Type: text/plain

Content of a.txt.

-----------------------------735323031399963166993862150
Content-Disposition: form-data; name="file2"; filename="a.html"
Content-Type: text/html

<!DOCTYPE html><title>Content of a.html.</title>

-----------------------------735323031399963166993862150
Content-Disposition: form-data; name="file3"; filename="binary"
Content-Type: application/octet-stream

aωb
-----------------------------735323031399963166993862150--
```

Q07. Quantify requests done by the cookies identified in the authentication bruteforce:
```
```

## Investigating Windows registry logs 

Q09. Look for USB keys (SetValue friendlyname) :
```
index=botsv1 sourcetype=WinRegistry friendlyname
index=botsv1 sourcetype=WinRegistry registry_path="HKLM\\*_usbstor*"
```

Q10. Look for mountpoints (fileshare connections):
```
index=botsv1 host="we8105desk" sourcetype=WinRegistry registry_path="HKU\\*\\mountpoints*\\*"
```

## Investigating Sysmon logs 

You can visit the [olafhartong sysmon cheatsheet](https://github.com/olafhartong/sysmon-cheatsheet/blob/master/Sysmon-Cheatsheet.pdf) to search for tracing capabilities of sysmon.

Q11. Sysmon EID 7 - Extraction of the sysmon md5sum for the binary uploaded (on the webserver): 
```
index=botsv1 sourcetype="XmlWinEventLog:Microsoft-Windows-Sysmon/Operational" CommandLine="3791.exe"
| rex field=Hashes MD5="(?<md5sum>\w+)" 
| table md5sum
```

Q12. Sysmon EID 7 - Count executions by system drive:
```
index=botsv1 we8105desk sourcetype=XmlWinEventLog:Microsoft-Windows-Sysmon/Operational 
| makemv delim=":" CurrentDirectory | eval drive=mvindex(CurrentDirectory,0) 
| stats count by drive
```

Q13. Sysmon EID 7 - Look for I/O on D:\ drive:
```
index=botsv1 host="we8105desk" sourcetype="XmlWinEventLog:Microsoft-Windows-Sysmon/Operational" CommandLine="*D:\\*" 
| table _time, CommandLine 
| reverse
```

Q14. Sysmon EID 7 - Table des processus : PID / PPID / CommandLines
```
index=botsv1 121214.tmp sourcetype="XmlWinEventLog:Microsoft-Windows-Sysmon/Operational" CommandLine=*
| table _time, CommandLine, ProcessId, ParentCommandLine, ParentProcessId 
| reverse
```
