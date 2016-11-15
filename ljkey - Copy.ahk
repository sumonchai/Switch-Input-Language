Sleep, 2000
;Send Enter
;dllcall("keybd_event", int, 0x0D, int, 0x01C, int, 0, int, 0)
;dllcall("keybd_event", int, 0x0D, int, 0x01C, int, 2, int, 0)

;Left Windows key (Natural keyboard)
dllcall("keybd_event", int, 0x5B, int, 0x00E, int, 0, int, 0) ;key down
Sleep, 1000
;dllcall("keybd_event", int, 0x5B, int, 0x00E, int, 2, int, 0) ;key Up

;Right Windows key (Natural keyboard)
;dllcall("keybd_event", int, 0x5C, int, 0x00E, int, 0, int, 0)
;dllcall("keybd_event", int, 0x5C, int, 0x00E, int, 2, int, 0)

;SPACEBAR
dllcall("keybd_event", int, 0x20, int, 0x00E, int, 0, int, 0)
Sleep, 100
dllcall("keybd_event", int, 0x20, int, 0x00E, int, 2, int, 0)
Sleep, 20
;Left Windows key (Natural keyboard)
dllcall("keybd_event", int, 0x5B, int, 0x00E, int, 2, int, 0) ;key Up
;Left SHIFT key 0xA0
;Left CONTROL key  0xA2
;CAPS LOCK key 0x14
;For the US standard keyboard, the '`~' key 0xC0 0x029

