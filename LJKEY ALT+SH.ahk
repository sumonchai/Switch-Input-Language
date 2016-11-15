;Sleep, 2000

; ALT DOWN
dllcall("keybd_event", int, 0x12, int, 0x038, int, 0, int, 0)
Sleep, 50
;L SHIP DOWN
dllcall("keybd_event", int, 0xA0, int, 0x02A, int, 0, int, 0)
;Sleep, 100
;L SHIP UP
dllcall("keybd_event", int, 0xA0, int, 0x02A, int, 2, int, 2)
;Sleep, 100
; ALT UP
dllcall("keybd_event", int, 0x12, int, 0x038, int, 2, int, 2)
