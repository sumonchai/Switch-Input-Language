;Sleep, 2000

;Left Windows key (Natural keyboard) DOWN
dllcall("keybd_event", int, 0x5B, int, 0x05B, int, 0, int, 0)
Sleep, 100
;SPACEBAR DOWN
dllcall("keybd_event", int, 0x20, int, 0x039, int, 0, int, 0)
Sleep, 100
;SPACEBAR UP
dllcall("keybd_event", int, 0x20, int, 0x039, int, 2, int, 2)
;Sleep, 100
;Left Windows key (Natural keyboard) UP
dllcall("keybd_event", int, 0x5B, int, 0x05B, int, 2, int, 2) 

