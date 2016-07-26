;ต้นฉบับ
;https://priabroy.com/2014/01/09/%E0%B9%80%E0%B8%82%E0%B8%B5%E0%B8%A2%E0%B8%99%E0%B9%82%E0%B8%9B%E0%B8%A3%E0%B9%81%E0%B8%81%E0%B8%A3%E0%B8%A1%E0%B9%80%E0%B8%9B%E0%B8%A5%E0%B8%B5%E0%B9%88%E0%B8%A2%E0%B8%99%E0%B8%A0%E0%B8%B2%E0%B8%A9/

;^ = Ctrl
;! = Alt
;# = WinKey (Meta)
;+ = Shift</code>
HotKeySet("`", "change") ;Registers Alt + Space
HotKeySet("_", "change") ;Registers Alt + Space
ToolTip("This is a tooltip", 0, 0)
#NoTrayIcon
Opt("TrayMenuMode",1)   ; Default tray menu items (Script Paused/Exit) will not be shown.
Opt("TrayAutoPause", 0 )
TraySetState()
TraySetToolTip("Switch Input Language")

$aboutitem  = TrayCreateItem("เกี่ยวกับโปรแกรม")
TrayCreateItem("")
$exititem   = TrayCreateItem("ออก")
TraySetState()
While 1
    $msg = TrayGetMsg()
    Select
        Case $msg = 0
            ContinueLoop
        Case $msg = $aboutitem
            ShellExecute("https://github.com/sumonchai/Switch-Input-Language/releases")
        Case $msg = $exititem
            ExitLoop
    EndSelect
WEnd

Exit
While 1
  Sleep(100) ; An idle loop.
WEnd

Func change()
  Send ("{ALTDOWN}") ;Hold down Alt
  Sleep(50) ;Wait 100 milliseconds
  Send("{LSHIFT}{ALTUP}")
EndFunc
