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
return



IniRead:
IfNotExist, settings.ini	
	
{
	MsgBox,0, %AppName%  v%Version%, ค่าเริมต้น `nสำหรัค่าเริ่มต้นขอการเปี่ภาษา`n`n Alt + Shift`n
	IniWrite, 2 , settings.ini, Options, Option
}
	Else
	{
		IniRead, iOpt, settings.ini, Options, Option, 1
		if (iOpt = 1)
			C029::
			;Send {LWIN down}{space};
			;KeyWait, SC029 ;
			;Send {LWIN up};
			;return 
			Send {ALT down}{shift}
			Send {ALT up}
				
		;else Gui, Add, Radio, x20 y60 w245 h20 vRadioButton, CapsLock		
		;	if (iOpt = 2)		
		;		Gui, Add, Radio,x20  y110 w110 h20 Checked, Alt + Shift	
		;else Gui, Add, Radio, x20  y110 w110 h20, Alt + Shift		
		;	if (iOpt = 3)		
		;		Gui, Add, Radio, x130 y110 w110 h20 Checked, Win + Space	
		;else Gui, Add, Radio, x130 y110 w110 h20, Win + Space	
		;	
		;MsgBox  Config = %iOpt%`n
	}
return


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
	
	Gui Add, Picture, x11 y12 w32 h32 BackgroundTrans, Util\key.ico
	Gui Font, s13 c0x003399, Segoe UI
	Gui Add, Text, x51 y12 w354 h32 +0x200 BackgroundTrans, Key Set Options
	Gui Font	
	Counter := Colors.MaxIndex()
	Loop % Counter {
		Gui Add, TreeView, % "x-1 y" . (140 + A_Index) . " w278 h1 Disabled Background" . Colors[Counter]
		Counter--
	}
	
	Gui Font, s9, Segoe UI
	Gui, Add, GroupBox, x10 y40 w260 h50 ,
	Gui, Add, Groupbox, x10 y90 w260 h50 , Grave Accent ( `` )	
	if (iOpt = 1)		
		Gui, Add, Radio, x20 y60 w245 h20 vRadioButton Checked, CapsLock		
	else Gui, Add, Radio, x20 y60 w245 h20 vRadioButton, CapsLock		
		if (iOpt = 2)		
			Gui, Add, Radio,x20  y110 w110 h20 Checked, Alt + Shift	
	else Gui, Add, Radio, x20  y110 w110 h20, Alt + Shift		
		if (iOpt = 3)		
			Gui, Add, Radio, x130 y110 w110 h20 Checked, Win + Space	
	else Gui, Add, Radio, x130 y110 w110 h20, Win + Space	
		
	Gui, Show, w278 h175, Options
	Return
	
	
}


ShowAbout(){
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
IniWrite, % RadioButton, %A_ScriptDir%\settings.ini, Options, Option
Gui, Destroy 
Return

Exit:
ExitApp
Return

