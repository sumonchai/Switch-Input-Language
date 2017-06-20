;@Ahk2Exe-SetName         Ahk2Exe
;@Ahk2Exe-SetDescription  AutoHotkey Script Compiler
;@Ahk2Exe-SetCopyright    Copyright (c) since 2004
;@Ahk2Exe-SetCompanyName  AutoHotkey
;@Ahk2Exe-SetOrigFilename Ahk2Exe.ahk
;@Ahk2Exe-SetMainIcon     Ahk2Exe.ico
#NoTrayIcon
CapsLock::
    KeyWait, CapsLock, T0.3 
    if ErrorLevel  {   
        SetCapsLockState, % GetKeyState("CapsLock","T") ? "Off" : "On"
        KeyWait, CapsLock 
        }
    else
        Send {LWIN down}{space}
		Send {LWIN up}
return