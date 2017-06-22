#NoEnv
#Warn
#InstallKeybdHook
#SingleInstance force.

;SendMode Input
SetBatchLines, -1
SetWorkingDir %A_ScriptDir%

;#Include Util\AutoXYWH.ahk

Global AppName := "LJ Switch Lang "
    , Version := "2.1"


Gosub IniRead
Menu, Tray, Tip, %AppName%  v%Version%
Menu, Tray, NoStandard
Menu, Tray, Add, RealTime Priority, RealTimePriority 
Menu, Tray, Add, High Priority , HighPriority 
Menu, Tray, Add, Normal Priority, NormalPriority
Menu, Tray, Default, RealTime Priority
Menu, Tray, Disable, RealTime Priority
Menu, Tray, Add
Menu, Tray, Add, ตั้งค่า, ShowConfigs
Menu, Tray, Add 
Menu, Tray, Add, Reload, Reload
Menu, Tray, Add, About, ShowAbout
Menu, Tray, Add, Check for updates, CheckUpdate
Menu, Tray, Add, Exit, Exit 
Menu, Tray,Icon, Util\lj.ico
return


;$SC029::
;Send {LWIN down}{space};
;KeyWait, SC029 ;
;Send {LWIN up};
;return 
;Send {ALT down}{shift}
;Send {ALT up}
;return 


IniRead:
IfNotExist, settings.ini	
{
	MsgBox,0, %AppName%  v%Version%, ค่าเริมต้น `nสำหรัค่าเริ่มต้นของการเปลี่ยนภาษา`n`n Alt + Shift`n
	IniWrite, 3 , settings.ini, Options, Option
}
	Else
	{
		IniRead, iOpt, settings.ini, Options, Option	
		Process, Exist, Capslockalt.exe
		Process, Exist, Capslockwin.exe
		Process, Exist, graveaccentalt.exe
		Process, Exist, graveaccentwin.exe
        If ErrorLevel <> 0
         Process, Close, Capslockalt.exe
         Process, Close, Capslockwin.exe
         Process, Close, graveaccentalt.exe
         Process, Close, graveaccentwin.exe
		if (iOpt == 1)
            Run, Capslockalt.exe                      
        if (iOpt == 2)    
			Run, Capslockwin.exe
		if (iOpt == 3)  	
			Run, graveaccentalt.exe
		if (iOpt == 4)  
			Run, graveaccentwin.exe
	return
	}


ShowConfigs(){
	Global	
	Gosub IniRead
	Static Counter
	Static Colors := ["BAE5F2", "BEE6F2", "C3E8F3", "C7EAF4", "CCEBF5", "D1EDF6", "D5EFF7", "DAF1F8", "DEF2F8", "E3F4F9", "E4F4F9", "E6F5F9", "E8F6FA", "EAF6FA", "ECF7FB", "EEF8FB", "F0F9FB", "F1F9FC", "F3FAFC", "F5FBFD", "F7FCFD", "F9FCFD", "FBFDFE", "FBFDFE", "FBFDFE", "FBFDFE", "FBFDFE", "FBFDFE", "FBFDFE", "FBFDFE", "FDFEFE", "FDFEFE", "FDFEFE", "FFFFFF"]
	
	Gui New, -MinimizeBox -MaximizeBox +AlwaysOnTop
	Gui Color, 0xFEFEFE
	
	Loop % Colors.MaxIndex() {
		Gui Add, TreeView, % "x-1 y" . (A_Index - 1) . " w278 h1 Background" . Colors[A_Index]
	}
	
	Gui Add, Picture, x11 y3 w32 h32 BackgroundTrans, Util\lj.ico
	Gui Font, s13 c0x003399, Segoe UI
	Gui Add, Text, x60 y3 w354 h36 +0x200 BackgroundTrans, Key Set Options
	Gui Font	
	Counter := Colors.MaxIndex()
	Loop % Counter {
		Gui Add, TreeView, % "x-1 y" . (140 + A_Index) . " w278 h1 Disabled Background" . Colors[Counter]
		Counter--
	}
	
Gui Font, s9, Segoe UI
	Gui, Add, GroupBox, x10 y40 w260 h50 , CapsLock    [กดค้าง เพื่อใช้งาน CapsLock]
	Gui, Add, Groupbox, x10 y90 w260 h50 , Grave Accent ( `` )	
	if (iOpt = 1)		
		  Gui, Add, Radio, x20  y60 w110 h20 vRaioButton Checked, CapLock [ALT]
		else Gui, Add, Radio, x20  y60 w110 h20 vRadioButton , CapLock [ALT]		
	if (iOpt = 2)		
			Gui, Add, Radio, x130 y60 w110 h20 Checked, CapLock [Win]
	  else Gui, Add, Radio, x130 y60 w110 h20, CapLock [Win]
		if (iOpt = 3)		
			Gui, Add, Radio,x20  y110 w110 h20 Checked, Alt + Shift	
	else Gui, Add, Radio, x20  y110 w110 h20, Alt + Shift		
		if (iOpt = 4)		
			Gui, Add, Radio, x130 y110 w110 h20 Checked, Win + Space	
	else Gui, Add, Radio, x130 y110 w110 h20, Win + Space	
		
	Gui, Show, w278 h175, Options
	
	Return
	
	
}


ShowAbout(){
	Static Counter
	Static Colors := ["BAE5F2", "BEE6F2", "C3E8F3", "C7EAF4", "CCEBF5", "D1EDF6", "D5EFF7", "DAF1F8", "DEF2F8", "E3F4F9", "E4F4F9", "E6F5F9", "E8F6FA", "EAF6FA", "ECF7FB", "EEF8FB", "F0F9FB", "F1F9FC", "F3FAFC", "F5FBFD", "F7FCFD", "F9FCFD", "FBFDFE", "FBFDFE", "FBFDFE", "FBFDFE", "FBFDFE", "FBFDFE", "FBFDFE", "FBFDFE", "FDFEFE", "FDFEFE", "FDFEFE", "FFFFFF"]
	
	Static URL := "https://github.com/sumonchai/Switch-Input-Language/releases"
	Local AboutText := 
    (LTrim
    " จัดทำเพื่อแก้ไขปัญหาการเปลี่ยนภาษาใน Windows ด้วย ~ [ตัวหนอน]
        ไม่รองรับการเปลี่ยนภาษาในเกมส์
    
			รองรับกดปุ่ม  ~  [ตัวหนอน]
			รองรับกดปุ่ม  CapsLock    

			Version " . Version . "

			Github project page:
    "
    )
	
	Gui MagicBox: +Disabled
	Gui About: New, LabelAbout -MinimizeBox -SysMenu OwnerMagicBox
	Gui Color, 0xFEFEFE
	
	Loop % Colors.MaxIndex() {
		Gui Add, TreeView, % "x-1 y" . (A_Index - 1) . " w437 h1 Background" . Colors[A_Index]
	}
	
	Gui Add, Picture, x11 y12 w32 h32 BackgroundTrans, Util\lj.ico
	Gui Font, s13 c0x003399, Tahoma
	Gui Add, Text, x51 y12 w354 h32 +0x200 BackgroundTrans, %AppName%
	Gui Font
	Gui Font,, Tahoma
	Gui Add, Text, x51 y52 w354, %AboutText%
	Gui Font
	Gui Add, Link, x51 y172 w354 h23, <a href="%URL%">%URL%</a>
	
	Counter := Colors.MaxIndex()
	Loop % Counter {
		Gui Add, TreeView, % "x-1 y" . (210 + A_Index) . " w437 h1 Disabled Background" . Colors[Counter]
		Counter--
	}
	
	Gui Font, s9, Segoe UI
	Gui Add, Button, gAboutEscape x347 y209 w75 h23 Default, &Close
	Gui Show, w435 h245, About
	ControlFocus Button1, About
}

CheckUpdate:
if not A_IsAdmin
{
    Run *RunAs "%A_ScriptFullPath%"
    ExitApp
}
ljfiles=
(join`n
Capslockalt.exe
Capslockwin.exe
graveaccentalt.exe
graveaccentwin.exe
LJ Switch Lang.exe
)
; Each commit (update) of the GitHub (or any git) repository has its
; own sha key, we can use this to check if there are any updates
RegExMatch(UrlDownloadToVar("https://api.github.com/repos/sumonchai/Switch-Input-Language/git/refs/heads/LJ-Switch-Lang"),"U)\x22sha\x22\x3A\x22\K\w{6}",GHsha)
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
	 URLDownloadToFile, https://raw.githubusercontent.com/sumonchai/Switch-Input-Language/tree/LJ-Switch-Lang/%A_LoopField%, %A_LoopField%
	}
MsgBox, 64, Restart, The updates have been downloaded.`nThe previous version has been saved as .BACKUP`nClick OK to restart.
IniWrite, %GHsha%, settings.ini, Options, sha
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
NormalPriority:
Process, Priority, , Normal
Menu, Tray, Enable, Normal Priority
Menu, Tray, Disable, RealTime Priority
Menu, Tray, Enable, High Priority
Return

HighPriority:
Process, Priority, , High
Menu, Tray, Disable, High Priority
Menu, Tray, Enable, Normal Priority
Menu, Tray, Enable, RealTime Priority
Return

RealTimePriority:
Process, Priority, , RealTime
Menu, Tray, Disable, RealTime Priority
Menu, Tray, Enable, Normal Priority
Menu, Tray, Enable, High Priority
Return

AboutEscape:
Gui MagicBox: -Disabled
Gui About: Destroy
Return

Reload:
Reload
Return

GuiClose:
GuiEscape:
Gui, Submit
IniWrite, % RadioButton, settings.ini, Options, Option
gosub Reload
Gui, Destroy 
Return

Exit:
		Process, Exist, Capslockalt.exe
		Process, Exist, Capslockwin.exe
		Process, Exist, graveaccentalt.exe
		Process, Exist, graveaccentwin.exe
If ErrorLevel <> 0
	     Process, Close, Capslockalt.exe
         Process, Close, Capslockwin.exe
         Process, Close, graveaccentalt.exe
         Process, Close, graveaccentwin.exe
ExitApp
Return

