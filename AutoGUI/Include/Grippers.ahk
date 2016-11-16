; Contribution made by MJs
CreateResizingGrippers() {
    If (NoGrippers) {
        Return
    }

    Gui %Child%: Default
    Grippers := []
    Loop 8 {
        Gui Add, Text, x0 y0 w%GripperSize% h%GripperSize% hWndhGripper%A_Index% +0x100 Hidden
        Grippers.Insert(hGripper%A_Index%)
    }

    Cursors := {(hGripper1): 32642, (hGripper2): 32645, (hGripper3): 32643, (hGripper4): 32643, (hGripper5): 32645, (hGripper6): 32642, (hGripper7): 32644, (hGripper8): 32644}
}

ShowResizingGrippers() {
    If (NoGrippers) {
        Return
    }

    Gui %Child%: Default
    GuiControlGet p, Pos, %g_Control%

    GuiControl Movedraw, %hGripper1%, % "x" . (px - GripperSize) . "y" . (py - GripperSize)
    GuiControl MoveDraw, %hGripper2%, % "x" . (px + ((pw - GripperSize) / 2)) . "y" . (py - GripperSize)
    GuiControl MoveDraw, %hGripper3%, % "x" . (px + pw) . "y" . (py - GripperSize)
     
    GuiControl MoveDraw, %hGripper4%, % "x" . (px - GripperSize) . "y" . (py + ph)
    GuiControl MoveDraw, %hGripper5%, % "x" . (px + ((pw - GripperSize) / 2)) . "y" . (py + ph)
    GuiControl MoveDraw, %hGripper6%, % "x" . (px + pw) . "y" . (py + ph)
     
    GuiControl MoveDraw, %hGripper7%, % "x" . (px - GripperSize) . "y" . (py + ((ph - GripperSize) / 2))
    GuiControl MoveDraw, %hGripper8%, % "x" . (px + pw) . "y" . (py + ((ph - GripperSize) / 2))

    For Each, Item in Grippers {
        GuiControl Show, %Item%
    }

    Global hGrippedWnd := g_Control
}

HideResizingGrippers() {
    If (NoGrippers) {
        Return
    }

    Gui %Child%: Default
    For Each, Item in Grippers {
        GuiControl Hide, %Item%
    }
}

IsGripper(hWnd) {
    Loop 8 {
        If (hWnd == Grippers[A_Index]) {
            Return True
        }
    }
    Return False
}

OnResize(hWnd) {
    Gui %Child%: Default
    CoordMode Mouse, Client
    MouseGetPos omx, omy
    GuiControlGet oc, %Child%: Pos, %hGrippedWnd%
    ncx := ncy := ncw := nch := 0

    hDC := DllCall("User32.dll\GetDC", "Ptr", hChildWnd, "UPtr")
    VarSetCapacity(RECT, 16, 0)

    If (hWnd == hGripper1) { ; x+y+w+h (NW)
        While (GetKeyState("LButton", "P")) {
            MouseGetPos mx, my
            nch := och - (my - ocy)
            ncw := ocw - (mx - ocx)
            If (mx = omx) ; Prevent flicker while redrawing the focus rect
                Continue
            DllCall("User32.dll\DrawFocusRect", "Ptr", hDC, "Ptr", &RECT)
            SetRect(RECT, mx, my, ncw + mx, nch + my)
            DllCall("User32.dll\DrawFocusRect", "Ptr", hDC, "Ptr", &RECT)
            omx := mx
        }
        ncx := mx, ncy := my
    } Else If (hWnd == hGripper2) { ; y+h (N)
        While (GetKeyState("LButton", "P")) {
            MouseGetPos mx, my
            nch := och - (my - ocy)
            If (oldmy = my)
                Continue
            DllCall("User32.dll\DrawFocusRect", "Ptr", hDC, "Ptr", &RECT)
            SetRect(RECT, ocx - 1, my, ocw + ocx + 1, my + nch + 1)
            DllCall("User32.dll\DrawFocusRect", "Ptr", hDC, "Ptr", &RECT)
            oldmy := my
        }
        ncx := ocx, ncy := my, ncw := ocw
    } Else If (hWnd == hGripper3) { ; y+w+h (NE)
        While (GetKeyState("LButton", "P")) {
            MouseGetPos mx, my
            nch := och - (my - ocy)
            ncw := mx - ocx + GripperSize
            If (mx = omx)
                Continue
            DllCall("User32.dll\DrawFocusRect", "Ptr", hDC, "Ptr", &RECT)
            SetRect(RECT, ocx - 1, my - 1, ncw + ocx + 1, nch + my + 1)
            DllCall("User32.dll\DrawFocusRect", "Ptr", hDC, "Ptr", &RECT)
            omx := mx
        }
        ncx := ocx, ncy := my
    } Else If (hWnd == hGripper4) { ; x+w+h (SW)
        While (GetKeyState("LButton", "P")) {
            MouseGetPos mx, my
            nch := ocy + (my - ocy)
            ncw := ocw - (mx - ocx)
            If (mx = omx)
                Continue
            DllCall("User32.dll\DrawFocusRect", "Ptr", hDC, "Ptr", &RECT)
            SetRect(RECT, mx, ocy, ncw + mx, nch)
            DllCall("User32.dll\DrawFocusRect", "Ptr", hDC, "Ptr", &RECT)
            omx := mx
        }
        ncx := mx, ncy := ocy, nch := nch - ocy
    } Else If (hWnd == hGripper5) { ; h (S)
        While (GetKeyState("LButton", "P")) {
            MouseGetPos mx, my
            nch := ocy + (my - ocy)
            If (oldmy = my)
                Continue
            DllCall("User32.dll\DrawFocusRect", "Ptr", hDC, "Ptr", &RECT)
            SetRect(RECT, ocx, ocy, ocw + ocx - 2, nch)
            DllCall("User32.dll\DrawFocusRect", "Ptr", hDC, "Ptr", &RECT)
            oldmy := my
        }
        ncx := ocx, ncy := ocy,  ncw := ocw, nch := nch - ocy
    } Else If (hWnd == hGripper6) { ; w+h (SE)
        While (GetKeyState("LButton", "P")) {
            MouseGetPos mx, my
            nch := ocy + (my - ocy)
            ncw := ocx + (mx - ocx)
            If ((nch = och) && (ncw = ocw))
                Continue
            DllCall("User32.dll\DrawFocusRect", "Ptr", hDC, "Ptr", &RECT)
            SetRect(RECT, ocx, ocy, ncw, nch)
            DllCall("User32.dll\DrawFocusRect", "Ptr", hDC, "Ptr", &RECT)
            och := nch, ocw := ncw
        }
        ncx := ocx, ncy := ocy, nch := nch - ocy, ncw := ncw - ocx
    } Else If (hWnd == hGripper7) { ; x+w (W)
        While (GetKeyState("LButton", "P")) {
            MouseGetPos mx
            ncw := ocw - (mx - ocx)
            If (mx = oldmx)
                Continue
            DllCall("User32.dll\DrawFocusRect", "Ptr", hDC, "Ptr", &RECT)
            SetRect(RECT, mx, ocy, ncw + mx, och + ocy)
            DllCall("User32.dll\DrawFocusRect", "Ptr", hDC, "Ptr", &RECT)
            oldmx := mx
        }
        ncx := mx, ncy := ocy, nch := och
    } Else If (hWnd == hGripper8) { ; w (E)
        While (GetKeyState("LButton", "P")) {
            MouseGetPos mx
            ncw := ocw - (omx - mx)
            If (ncw = oldncw)
                Continue
            DllCall("User32.dll\DrawFocusRect", "Ptr", hDC, "Ptr", &RECT)
            SetRect(RECT, ocx, ocy, ncw + ocx, och + ocy)
            DllCall("User32.dll\DrawFocusRect", "Ptr", hDC, "Ptr", &RECT)
            oldncw := ncw
        }
       ncx := ocx, ncy := ocy, nch := och
    }

    DllCall("User32.dll\DrawFocusRect", "Ptr", hDC, "Ptr", &RECT) ; Remove the focus rect
    DllCall("User32.dll\ReleaseDC", "Ptr", hChildWin, "Ptr", hDC)

    MouseGetPos mx, my
    If ((mx != omx) || (my != omy)) {
        NewPos := "x" . ncx . "y" . ncy . "w" . ncw . "h" . nch
        GuiControl MoveDraw, %hGrippedWnd%, % NewPos
        g_Control := hGrippedWnd
        g[g_Control].x := ncx
        g[g_Control].y := ncy
        g[g_Control].w := ncw
        g[g_Control].h := nch
        GenerateCode()
        ShowResizingGrippers()
        GoSub LoadProperties
    }
}

SetRect(ByRef RECT, x, y, w, h) {
    DllCall("SetRect", "Ptr", &RECT, "UInt", x, "UInt", y, "UInt", w, "UInt", h)
}
