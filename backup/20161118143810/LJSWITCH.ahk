#NoEnv
#Warn
#InstallKeybdHook
#SingleInstance force
SendMode Input

SetWorkingDir %A_ScriptDir%

#Include Util\AutoXYWH.ahk

Global AppName := "LJ Input Lang "
    , Version := "2.0"
    , MsgBoxType
    , Title
    , Text
    , Content
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
Menu, Tray, Add, Exit, Exit 
Menu, Tray,Icon, Util\key.ico

;Menu, Tray, Add, Minimize to tray,GuiMinimizeToTray
;Menu, Tray, Default, Minimize to tray
;Menu, Tray, Click, 2
;Menu, Tray, Tip, WhatsApp AHK`nDouble-click to minimiz
return

SC029::
;Send {LWIN down}{space};
;KeyWait, SC029 ;
;Send {LWIN up};
;return 
Send {ALT down}{shift}
Send {ALT up}
return 



ShowConfigs(){
	Global
	
	Gosub IniRead
	Gui, Font, S14 CBlue Bold, Tahoma
	Gui, Add, Text, x10 y10 w170 h30 +Center, Set Key Press
	Gui, Font, S10 CMaroon Bold, Tahoma
	Gui, Add, GroupBox, x10 y40 w260 h50 , CapsLock
	Gui, Add, Groupbox, x10 y90 w260 h50 , Grave Accent ( `` )
	Gui, Font
	if (iOpt = 1){
		Gui, Add, Radio, Group x20 y60 w245 h20 Checked, CapsLock : Use CapsLock Chang Language
		Gui, Add, Radio, x20  y110 w110 h20  , Alt + Shift		
		Gui, Add, Radio, x130 y110 w110 h20  , Win + Space	
	}
	if (iOpt = 2){
		RadioButton = 0
		Gui, Add, Radio, Group x20 y60 w245 h20  , CapsLock : Use CapsLock Chang Language
		Gui, Add, Radio, x20  y110 w110 h20  vRadioButton Checked, Alt + Shift	
		Gui, Add, Radio, x130 y110 w110 h20  , Win + Space
	}
	if (iOpt = 3){
		Gui, Add, Radio, Group x20 y60 w245 h20  , CapsLock : Use CapsLock Chang Language
		Gui, Add, Radio, x20  y110 w110 h20  , Alt + Shift	
		Gui, Add, Radio, x130 y110 w110 h20  Checked, Win + Space
	}
	;else {
	;	Gui, Add, Radio, Group x20 y60 w245 h20  , CapsLock : Use CapsLock Chang Language		
	;	Gui, Add, Radio, x20  y110 w110 h20  , Alt + Shift	
	;	Gui, Add, Radio, x130 y110 w110 h20  , Win + Space
	;}
	Gui, Add, Button, x40 y160 w50 gOk, Ok
	Gui, Add, Button, x100 y160 w50 gGuiClose, Close
	Gui, Show, w400 h200, Setup
	Return
	
	
}


IniRead:
IfNotExist, settings.ini	
	
{
	MsgBox,0, %AppName%  v%Version%, ค่าเริมต้น `nสำหรัค่าเริ่มต้นขอการเปี่ภาษา`n`n Alt + Shift`n
	IniWrite, 2 , settings.ini, Keys, Key
	;vCapsLock = 0
	;vAltShift = 1
	;vWinSpace = 0
	;IniWrite, %vCapsLock%, LJLANG.ini, Set Key, CapsLock
	;IniWrite, %vAltShift%, LJLANG.ini, Set Key, Alt + Shift
	;IniWrite, %vWinSpace%, LJLANG.ini, Set Key, Win + Space
}
	Else
	{
		IniRead, iOpt, settings.ini, Keys, Key, 1
		;if (iOpt = 1) ; if it is the saved one
		;	Gui, Add, Radio,x120 y40 vRadioButton Checked,   ; add the button, and check it
		;else Gui, Add, Radio,x120 y%var% vRadioButton,         ; just add the button
		;IniRead, iOpt, LJLANG.ini, Key Set, Option, 1
		;IniRead, vCapsLock, LJLANG.ini, Key Set, CapsLock
		;IniRead, vAltShift, LJLANG.ini, Key Set, Alt + Shift
		;IniRead, vWinSpace, LJLANG.ini, Execution, Win + Space
		;IniRead, vMultiplayer, LJLANG.ini, Game Type, Multiplayer Game
		;IniRead, vHosting, LJLANG.ini, Game Type, Hosting
		;IniRead, vJoining, LJLANG.ini, Game Type, Joining
		;MsgBox  Halo Execution = %vCapsLock%`nFull Screen = %vFullScreen%`nWindow = %vWindow%`n`nMultiplayer Type = %vMultiplayer%`nHosting = %vHosting%`nJoining = %vJoining%
			MsgBox  Config = %iOpt%`n
}
return

;ChangLang:
;vCapsLock = 0
;vAltShift = 0
;vWinSpace = 0
;IniWrite, %vCapsLock%, LJLANG.ini, Set Key, CapsLock
;IniWrite, %vAltShift%, LJLANG.ini, Set Key, Alt + Shift
;IniWrite, %vWinSpace%, LJLANG.ini, Set Key, Win + Space
;Return


Ok:
Gui, Submit
IniWrite, % RadioButton, settings.ini, Keys, Key
Return

GuiClose:
Gui, Destroy 
Return



ShowAbout() {
	Static Counter
	Static Colors := ["BAE5F2", "BEE6F2", "C3E8F3", "C7EAF4", "CCEBF5", "D1EDF6", "D5EFF7", "DAF1F8", "DEF2F8", "E3F4F9", "E4F4F9", "E6F5F9", "E8F6FA", "EAF6FA", "ECF7FB", "EEF8FB", "F0F9FB", "F1F9FC", "F3FAFC", "F5FBFD", "F7FCFD", "F9FCFD", "FBFDFE", "FBFDFE", "FBFDFE", "FBFDFE", "FBFDFE", "FBFDFE", "FBFDFE", "FBFDFE", "FDFEFE", "FDFEFE", "FDFEFE", "FFFFFF"]
	
	Static URL := "https://github.com/sumonchai/Switch-Input-Language/"
	Local AboutText := 
    (LTrim
    " จัดทำเพื่อแก้ไขปัญหาการเปลี่ยนภาษาใน Windows ด้วย ~ [ตัวหนอน]
    switch Language Input
	     โดยการแก้ไขด้วย Autohotkey 

			รองรับกดปุ่ม ~  [ตัวหนอน]
			รองรับกดปุ่ม CapsLock    

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
	
	Gui Add, Picture, x11 y12 w32 h32 BackgroundTrans, Util\key.ico
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


GuiMinimizeToTray() {
	;Gui +lastfound
	WinHide
	Menu, Tray, Delete, Minimize to tray
	Menu, Tray, Add, Restore, Restore
	Menu, Tray, Default, Restore
	;Menu, Tray, Tip, WhatsApp AHK`nDouble-click to restore
	;Menu, Tray, Delete, Exit
	;Menu, Tray, Add, Exit, GuiClose
    ;TrayTip, WhatsApp AHK, I'm still around and will keep running in the background.
}
Restore() {
	;Gui +lastfound
	WinShow
	WinRestore
	WinActivate
	;Menu, Tray, Delete, Restore
	Menu, Tray, Add, Minimize to tray, GuiMinimizeToTray
	Menu, Tray, Default, Minimize to tray
	;Menu, Tray, Tip, WhatsApp AHK`nDouble-click to minimize
	;Menu, Tray, Delete, Exit
	;Menu, Tray, Add, Exit, GuiClose
	Gui, +Resize +MinSize
	Gui, Add, Text, x10 y10 w40 h20 , Search:
	Gui, Show, w720 h540, %AppName%
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


Exit:
ExitApp
Return

