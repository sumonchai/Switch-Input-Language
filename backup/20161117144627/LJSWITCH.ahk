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

Reload:
Reload
Return


Exit:
ExitApp
Return

