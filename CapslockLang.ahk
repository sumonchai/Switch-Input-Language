#NoTrayIcon
CapsLock::
    KeyWait, CapsLock, T0.3 
    if ErrorLevel  {   
        SetCapsLockState, % GetKeyState("CapsLock","T") ? "Off" : "On"
        KeyWait, CapsLock 
        }
    else
        Send {ALT down}{shift}
        Send {ALT up}
return