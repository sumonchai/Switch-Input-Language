; http://www.autohotkey.com/board/topic/104539-controlcol-set-background-and-text-color-gui-controls/

ControlColor(Control, Window, bc := "", tc := "", Redraw := 1) {
    a := {}
    a["c"]  := Control
    a["g"]  := Window
    a["bc"] := (bc = "") ? "" : (((bc & 255) << 16) + (((bc >> 8) & 255) << 8) + (bc >> 16))
    a["tc"] := (tc = "") ? "" : (((tc & 255) << 16) + (((tc >> 8) & 255) << 8) + (tc >> 16))
    WindowProc("Set", a, "", "")
    If (Redraw) {
        SizeOfWINDOWINFO := 60
        VarSetCapacity(WINDOWINFO, SizeOfWINDOWINFO, 0)
        NumPut(SizeOfWINDOWINFO, WINDOWINFO, "UInt")
        DllCall("GetWindowInfo",  "Ptr", Control, "Ptr", &WINDOWINFO)
        DllCall("ScreenToClient", "Ptr", Window,  "Ptr", &WINDOWINFO+20) ; x1, y1 of client area
        DllCall("ScreenToClient", "Ptr", Window,  "Ptr", &WINDOWINFO+28) ; x2, y2 of client area
        DllCall("RedrawWindow", "Ptr",  Window, "UInt", &WINDOWINFO+20, "UInt", 0, "UInt", 0x101)
    }
}

WindowProc(hWnd, uMsg, wParam, lParam) {
    Static Win := {}
    Critical
    If uMsg Between 0x132 And 0x138
    If (Win[hWnd].HasKey(lParam)) {
        If (tc := Win[hWnd, lParam, "tc"]) {
            DllCall("SetTextColor", "UInt", wParam, "UInt", tc)
        }
        If (bc := Win[hWnd, lParam, "bc"]) {
            DllCall("SetBkColor",   "UInt", wParam, "UInt", bc)
        }
        Return Win[hWnd, lParam, "Brush"] ; Return the HBRUSH to notify the OS that we altered the HDC.
    }

    If (hWnd = "Set") {
        a := uMsg
        Win[a.g, a.c] := a
        If (Win[a.g, a.c, "tc"] = "") And (Win[a.g, a.c, "bc"] = "")
            Win[a.g].Remove(a.c, "")
        If Not Win[a.g, "WindowProcOld"]
            Win[a.g,"WindowProcOld"] := DllCall("SetWindowLong", "Ptr", a.g, "Int", -4, "Int", RegisterCallback("WindowProc", "", 4), "UInt")
        If Win[a.g, a.c, "Brush"]
            DllCall("DeleteObject", "Ptr", Brush)
        If (Win[a.g, a.c, "bc"] != "")
            Win[a.g, a.c, "Brush"] := DllCall("CreateSolidBrush", "UInt", a.bc)
        Return
    }
    Return DllCall("CallWindowProcA", "UInt", Win[hWnd, "WindowProcOld"], "UInt", hWnd, "UInt", uMsg, "UInt", wParam, "UInt", lParam)
}
