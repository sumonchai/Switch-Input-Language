FixMem()

#NoEnv
#Persistent 
#MaxMem 4095
#HotkeyInterval 20
#InstallKeybdHook
#InstallMouseHook
#Hotstring NoMouse
#SingleInstance Force

ListLines, Off
SetBatchLines, -1
SetMouseDelay, -1
SetNumLockState, On
SetDefaultMouseSpeed, 0
Coordmode, Mouse, Screen

programName= Razor //
CurrentVersion=1

Menu, Tray, Tip, %programName%  v%CurrentVersion%
Menu, Tray, NoStandard
Menu, Tray, Add, RealTime Priority, RealTimePriority 
Menu, Tray, Add, High Priority , HighPriority 
Menu, Tray, Add, Normal Priority, NormalPriority
Menu, Tray, Default, Normal Priority
Menu, Tray, Disable, Normal Priority
Menu, Tray, Add 
Menu, Tray, Add, Run BF2 , RunBF2 
Menu, Tray, Add, Clean BF2, CleanBF2
Menu, Tray, Add 
Menu, Tray, Add, Reload, Reload
Menu, Tray, Add, Exit, Exit 

$~*NumLock::
Suspend, Toggle
Return

$~*ScrollLock::
Reload
Return

Alt & z::
ExitApp
Return

$Numpad2::
$NumpadDown::
SayToAll("Go")
Return

$Numpad7::
$NumpadHome::
SayToAll("rAzOr v1")
Return

$Numpad8::
$NumpadUp::
SayToAll("Ready")
Return

$Numpad9::
$NumpadPgUp::
SayToConsole("pb_sleep 500{Enter}pb_writecfg{Enter}game.lockfps 0{Enter}")
Return

#IfWinActive BF2
Critical, On
Thread, NoTimers
Thread, Priority, 2147483647
Thread, Interrupt, 2147483647
~LButton::
Loop
{
	Click(0x0002)
	Click(0x0004)
	KeyWait, LButton, D T0
	If ErrorLevel
	Break
}
Return

Click(a)
{
Global
VarSetCapacity(mouseinput, 28) 
SleepProc := DllCall("GetProcAddress", uint, DllCall("GetModuleHandle", str, "kernel32"), str, "Sleep")
SendProc := DllCall("GetProcAddress", uint, DllCall("GetModuleHandle", str, "user32"), str, "SendInput")
		NumPut(a, mouseinput, 16, UInt)
		DllCall(SendProc, UInt, 1, UInt, &mouseinput, Int, 28)
		DllCall(SleepProc, Uint, 33)
VarSetCapacity(mouseinput, 0) 
}

SayToAll(a_szmessage)
{
SetKeyDelay, 25.00, 5.00
SendInput {j Down}
Sleep, 50
SendInput {j Up}
Sleep, 50
Send %a_szMessage%{Enter}
}

SayToConsole(a_szmessage)
{
SetKeyDelay, 5.00, 5.00
SendInput {~ Down}
Sleep, 50
SendInput {~ Up}
Sleep, 50
Send %a_szMessage%{Enter}
}

FixMem(PID="%programName%")
{
    pid:=(pid="%programName%") ? DllCall("GetCurrentProcessId") : pid
    h:=DllCall("OpenProcess", "UInt", 0x001F0FFF, "Int", 0, "Int", pid)
    DllCall("SetProcessWorkingSetSize", "UInt", h, "Int", -1, "Int", -1)
    DllCall("CloseHandle", "Int", h)
}

Reload:
Reload
Return

Exit:
ExitApp
Return


RunBF2:
IfWinExist BF2
{
MsgBox, 4,Razor//,  Bf2 is already open.`nSwitch to it now?, 10
	IfMsgBox Yes
	{
	WinActivate, BF2
	}
	Else IfMsgBox No
	{
	Return
	}
	Else IfMsgBox Timeout
	{
	Return
	}
}
Else
{
MsgBox, 4, BoBomb //, Would you like to switch to open BF2?, 10
IfMsgBox Yes
{
Run %BF2Path%\%BF2Filename% %Parameters%, %BF2Path%
}
Else
{
Return
}
}
Return

CleanBF2:
   v_BattleRecorderLines := 0
   if (ProfileSelect = 1)
   {
      Loop, %NumberOfProfiles%
      {  
         Temp01 := A_Index
         if (Temp01 < 10)
            Temp01 := "0" . Temp01

         Loop, Read, %A_MyDocuments%\Battlefield 2\Profiles\00%Temp01%\DemoBookmarks.con
         {
            ++v_BattleRecorderLines
         }
      }
   }
   else
   {
      Temp01 := ItemPosition%ProfileSelect%
      ;===COUNT BR LINES
      Loop, Read, %A_MyDocuments%\Battlefield 2\Profiles\00%Temp01%\DemoBookmarks.con
      {
         ++v_BattleRecorderLines
      }
   }

Sleep, 100
Loop, %A_MyDocuments%\Battlefield 2\mods\*, 2, 0
FileRecycle, %A_LoopFileLongPath%
Sleep, 15.625
FileRecycle, %A_MyDocuments%\Battlefield 2\Profiles\00%Temp01%\DemoBookmarks.con
Sleep, 15.625
FileRecycle, %A_MyDocuments%\Battlefield 2\LogoCache
Sleep, 15.625
FileRecycle, %A_MyDocuments%\Battlefield 2\dmp
Sleep, 15.625
SoundPlay, *48
MsgBox, BF2 was Cleaned.
Return

NormalPriority:
Process, Priority, , Normal
Menu, Tray, Disable, Normal Priority
Menu, Tray, Enable, RealTime Priority
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