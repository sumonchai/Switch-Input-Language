;Scan code KB https://www.win.tue.nl/~aeb/linux/kbd/scancodes-10.html
Sleep, 2000
;Send Enter

;dllcall("keybd_event", int, 0x0D, int, 0x01C, int, 0, int, 0)
;dllcall("keybd_event", int, 0x0D, int, 0x01C, int, 2, int, 0)

;Left Windows key (Natural keyboard)
;dllcall("keybd_event", int, 0x5B, int, 0x05B, int, 0, int, 0) ;key down
;Sleep, 1000
;dllcall("keybd_event", int, 0x5B, int, 0x05B, int, 2, int, 0) ;key Up

;Right Windows key (Natural keyboard)
;dllcall("keybd_event", int, 0x5C, int, 0x05C, int, 0, int, 0)
;dllcall("keybd_event", int, 0x5C, int, 0x05C, int, 2, int, 0)

;SPACEBAR
;dllcall("keybd_event", int, 0x20, int, 0x039, int, 0, int, 0)
;Sleep, 100
;dllcall("keybd_event", int, 0x20, int, 0x039, int, 2, int, 0)
;Sleep, 20
;Left Windows key (Natural keyboard)
;dllcall("keybd_event", int, 0x5B, int, 0x05B, int, 2, int, 0) ;key Up

;Left SHIFT key 0xA0 
;Left CONTROL key  0x11 0x01D
;CAPS LOCK key 0x14 0x03A
;For the US standard keyboard, the '`~' key 0xC0 , 0x029

; ALT DOWN
dllcall("keybd_event", int, 0x12, int, 0x038, int, 0, int, 0)
Sleep, 100
;L SHIP DOWN
dllcall("keybd_event", int, 0xA0, int, 0x02A, int, 0, int, 0)
Sleep, 100
;L SHIP UP
dllcall("keybd_event", int, 0xA0, int, 0x02A, int, 2, int, 2)
Sleep, 100
; ALT UP
dllcall("keybd_event", int, 0x12, int, 0x038, int, 2, int, 2)
