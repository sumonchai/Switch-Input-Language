ljfiles=
(join`n
pahklight.ahk
pahklightDB.ini
categories.txt
)

CheckUpdate:
; Each commit (update) of the GitHub (or any git) repository has its
; own sha key, we can use this to check if there are any updates
RegExMatch(UrlDownloadToVar("https://api.github.com/repos/sumonchai/Switch-Input-Language/git/refs/heads/LJ-Input-Langs"),"U)\x22sha\x22\x3A\x22\K\w{6}",GHsha)
IniRead, sha, settings.ini, Options, sha
if (GHsha = "") or (GHsha = sha)
	{
	 MsgBox, 64, No update available, Your %AppName% seems to be up-to-date.
	 Return
	}
MsgBox, 36, Update?, Do you wish to download updates for %AppName%?
IfMsgBox, No
	Return
Loop, parse, ljfiles, `n
	{
	 FileMove, %A_LoopField%, %A_LoopField%.backup, 1
	 ;URLDownloadToFile, https://raw.github.com/hi5/pAHKlight/master/%A_LoopField%, %A_LoopField%
	}
MsgBox, 64, Restart, The updates have been downloaded.`nThe previous version has been saved as .BACKUP`nClick OK to restart.
;IniWrite, %GHsha%, settings.ini, Options, sha
Sleep 500
Reload
Return

UrlDownloadToVar(URL)
	{
	 WebRequest:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
	 try WebRequest.Open("GET",URL)
	 catch error
		Return error.Message
	 WebRequest.Send()
	 Return WebRequest.ResponseText
	}