;ต้นฉบับ
;https://priabroy.com/2014/01/09/%E0%B9%80%E0%B8%82%E0%B8%B5%E0%B8%A2%E0%B8%99%E0%B9%82%E0%B8%9B%E0%B8%A3%E0%B9%81%E0%B8%81%E0%B8%A3%E0%B8%A1%E0%B9%80%E0%B8%9B%E0%B8%A5%E0%B8%B5%E0%B9%88%E0%B8%A2%E0%B8%99%E0%B8%A0%E0%B8%B2%E0%B8%A9/

;^ = Ctrl
;! = Alt
;# = WinKey (Meta)
;+ = Shift</code>

HotKeySet("`", "change") ;Registers Alt + Space

;Main loop
While 1
  Sleep(100)
WEnd

;At Input language settings on windows
;Please select Alt + Shift
;Changes Keyboard Layout

Func change()
  Send ("{ALTDOWN}") ;Hold down Alt
  Sleep(50) ;Wait 100 milliseconds
  Send("{LSHIFT}{ALTUP}") ;Press Left-Shift and release Alt
EndFunc
