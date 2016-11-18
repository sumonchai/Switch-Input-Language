#NoEnv
#Warn
#InstallKeybdHook
#SingleInstance force
SendMode Input

SetWorkingDir %A_ScriptDir%

#Include Util\AutoXYWH.ahk


Global AppName := "LJ Switch Input Lang "
    , Version := "2.0"
    , MsgBoxType
    , Title
    , Text
    , Content

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
	Gui, Add, Text, x10 y10 w170 h30 +Center, Halo GUI Setup
	Gui, Font, S10 CMaroon Bold, Verdana
	Gui, Add, GroupBox, x10 y40 w170 h50 vHaloExecution, Halo Execution
	Gui, Add, Groupbox, x10 y90 w170 h50 vMultiplayer, Multiplayer Game
	Gui, Font
	Gui, Add, Radio, Group x20 y60 w70 h20 gFullScreen vFullScreen, Full Screen
	Gui, Add, Radio, x110 y60 w60 h20 gWindow vWindow, Window
	Gui, Add, Radio, Group x20 y110 w60 h20 gHosting vHosting, Hosting
	Gui, Add, Radio, x110 y110 w60 h20 gJoining vJoining, Joining
	Gui, Add, Button, x40 y160 w50 gOk, Ok
	Gui, Add, Button, x100 y160 w50 gGuiClose, Close
	Gui, Show, w190 h200, Setup
	Return
	
	
}


IniRead:
	IfNotExist, HaloGUI.ini
	{
		MsgBox This is the first time you have`nrun the Halo GUI Setup window.`n`nAfter you click on the Ok button`nbelow, you will be able to choose`nhow you wish to setup your Halo`ngame play.`n 
	}
	Else
	{
		IniRead, vHaloExecution, HaloGUI.ini, Execution, Halo Execution
		IniRead, vFullScreen, HaloGUI.ini, Execution, Full Screen
		IniRead, vWindow, HaloGUI.ini, Execution, Window
		IniRead, vMultiplayer, HaloGUI.ini, Game Type, Multiplayer Game
		IniRead, vHosting, HaloGUI.ini, Game Type, Hosting
		IniRead, vJoining, HaloGUI.ini, Game Type, Joining
		MsgBox  Halo Execution = %vHaloExecution%`nFull Screen = %vFullScreen%`nWindow = %vWindow%`n`nMultiplayer Type = %vMultiplayer%`nHosting = %vHosting%`nJoining = %vJoining%
}
return
FullScreen:
vHaloExecution = Full Screen
vFullScreen = 1
vWindow = 0
IniWrite, %vHaloExecution%, HaloGUI.ini, Execution, Halo Execution
IniWrite, %vFullScreen%, HaloGUI.ini, Execution, Full Screen
IniWrite, %vWindow%, HaloGUI.ini, Execution, Window
IniWrite, %A_Space%, HaloGUI.ini, %A_Space%, %A_Space%
Return

Window:
vHaloExecution = Window
vFullScreen = 0
vWindow = 1
IniWrite, %vHaloExecution%, HaloGUI.ini, Execution, Halo Execution
IniWrite, %vFullScreen%, HaloGUI.ini, Execution, Full Screen
IniWrite, %vWindow%, HaloGUI.ini, Execution, Window
Return

Hosting:
vMultiplayer = Hosting
vHosting = 1
vJoining = 0
IniWrite, %vMultiplayer%, HaloGUI.ini, Game Type, Multiplayer Game
IniWrite, %vHosting%, HaloGUI.ini, Game Type, Hosting
IniWrite, %vJoining%, HaloGUI.ini, Game Type, Joining
Return

Joining:
vMultiplayer = Joining
vHosting = 0
vJoining = 1
IniWrite, %vMultiplayer%, HaloGUI.ini, Game Type, Multiplayer Game
IniWrite, %vHosting%, HaloGUI.ini, Game Type, Hosting
IniWrite, %vJoining%, HaloGUI.ini, Game Type, Joining
Return

Ok:
Gui, Submit
Return

GuiClose:
ExitApp



ShowAbout() {
	Static Counter
	Static Colors := ["BAE5F2", "BEE6F2", "C3E8F3", "C7EAF4", "CCEBF5", "D1EDF6", "D5EFF7", "DAF1F8", "DEF2F8", "E3F4F9", "E4F4F9", "E6F5F9", "E8F6FA", "EAF6FA", "ECF7FB", "EEF8FB", "F0F9FB", "F1F9FC", "F3FAFC", "F5FBFD", "F7FCFD", "F9FCFD", "FBFDFE", "FBFDFE", "FBFDFE", "FBFDFE", "FBFDFE", "FBFDFE", "FBFDFE", "FBFDFE", "FDFEFE", "FDFEFE", "FDFEFE", "FFFFFF"]
	
	Static URL := "https://github.com/sumonchai/Switch-Input-Language/"
	Local AboutText := 
    (LTrim
    " จัดทำเพื่อแก้ไขปัญหาการเปลี่ยนภาษาใน Windows ด้วย ~ [ตัวหนอน]
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

