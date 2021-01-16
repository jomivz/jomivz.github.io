Dim WshShell 
Set WshShell  = CreateObject("WScript.Shell")
MsgBox "To exit script, you have to kill manually the process wscript.exe"
Do
'	If WshShell.AppActivate("Firefox") = False Then
'	MsgBox "Firefox in the background or not launched." & vbCrlf & "Exit Script."
'	WshShell.Run "taskkill /f /im wscript.exe", , True 
'	'Exit Script here
'	Exit do
'	End If
	
	'Switch between tabs
	WshShell.AppActivate("Firefox")
	WshShell.SendKeys("^({TAB})")
	
	'Slept script for 15s
	WScript.Sleep(5000)
Loop While true
