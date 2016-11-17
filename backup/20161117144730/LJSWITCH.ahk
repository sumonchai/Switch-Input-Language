#NoEnv
#Warn
#InstallKeybdHook
#SingleInstance force
SendMode Input
programName= LJ Switch Input Lang 
CurrentVersion=Beta 2.0
SetWorkingDir %A_ScriptDir%
#Include Util\AutoXYWH.ahk

Menu, Tray, Tip, %programName%  v%CurrentVersion%
Menu, Tray, NoStandard
Menu, Tray, Add, RealTime Priority, RealTimePriority 
Menu, Tray, Add, High Priority , HighPriority 
Menu, Tray, Add, Normal Priority, NormalPriority
Menu, Tray, Default, RealTime Priority
Menu, Tray, Disable, RealTime Priority
Menu, Tray, Add 
Menu, Tray, Add, Reload, Reload
;Menu, Tray, Add, Update, IsUpdated
Menu, Tray, Add, Exit, Exit 
Menu,Tray,Icon, %A_ScriptDir%\Util\key.ico
Gui Add, Button, gShowAbout x8 y430 w76 h23, A&bout

SC029::
;Send {LWIN down}{space};
;KeyWait, SC029 ;
;Send {LWIN up};
;return 
Send {ALT down}{shift}
Send {ALT up}
return 

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


ShowAbout() {
	Static Counter
	Static Colors := ["BAE5F2", "BEE6F2", "C3E8F3", "C7EAF4", "CCEBF5", "D1EDF6", "D5EFF7", "DAF1F8", "DEF2F8", "E3F4F9", "E4F4F9", "E6F5F9", "E8F6FA", "EAF6FA", "ECF7FB", "EEF8FB", "F0F9FB", "F1F9FC", "F3FAFC", "F5FBFD", "F7FCFD", "F9FCFD", "FBFDFE", "FBFDFE", "FBFDFE", "FBFDFE", "FBFDFE", "FBFDFE", "FBFDFE", "FBFDFE", "FDFEFE", "FDFEFE", "FDFEFE", "FFFFFF"]
	
	Static URL := "https://sourceforge.net/projects/magicbox-factory/"
	Local AboutText := 
    (LTrim
    "Developers and corporations all over the world use MagicBox Factory
    to quickly and efficiently create professional message boxes.

    MagicBox is able to generate the code for a variety of message boxes,
    including the sophisticated task dialog introduced in Windows Vista.

    Version " . Version . "

    SourceForge project page:
    "
    )
	
	Gui MagicBox: +Disabled
	Gui About: New, LabelAbout -MinimizeBox -SysMenu OwnerMagicBox
	Gui Color, 0xFEFEFE
	
	Loop % Colors.MaxIndex() {
		Gui Add, TreeView, % "x-1 y" . (A_Index - 1) . " w437 h1 Background" . Colors[A_Index]
	}
	
	Gui Add, Picture, x11 y12 w32 h32 BackgroundTrans, Icons\MagicBox.ico
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

