;^ = Ctrl
;! = Alt
;# = WinKey (Meta)
;+ = Shift</code>
HotKeySet("`", "change")
HotKeySet("_", "change")
ToolTip("This is a tooltip", 0, 0)
#NoTrayIcon
Opt("TrayMenuMode",1)   
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
  Send ("#{SPACE}")
EndFunc
