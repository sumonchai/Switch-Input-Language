; Window functions *****************************************************

GetWindowPosition(hWnd) {
    VarSetCapacity(WINDOWPLACEMENT, 44, 0)
    NumPut(44, WINDOWPLACEMENT)
    DllCall("GetWindowPlacement", "UInt", hWnd, "UInt", &WINDOWPLACEMENT)
    Result := {}
    Result.x := NumGet(WINDOWPLACEMENT, 7 * 4, "UInt")
    Result.y := NumGet(WINDOWPLACEMENT, 8 * 4, "UInt")
    Result.w := NumGet(WINDOWPLACEMENT, 9 * 4, "UInt") - Result.x
    Result.h := NumGet(WINDOWPLACEMENT, 10 * 4, "UInt") - Result.y
    Result.showCmd := NumGet(WINDOWPLACEMENT, 8, "UInt")
    ; 1 = normal, 2 = minimized, 3 = maximized
    Return Result
}

SetWindowPosition(hWnd, x, y, w, h, showCmd) {
    VarSetCapacity(WINDOWPLACEMENT, 44, 0)
    NumPut(44, WINDOWPLACEMENT)
    NumPut(x, WINDOWPLACEMENT, 7 * 4, "UInt")
    NumPut(y, WINDOWPLACEMENT, 8 * 4, "UInt")
    NumPut(w + x, WINDOWPLACEMENT, 9 * 4, "UInt")
    NumPut(h + y, WINDOWPLACEMENT, 10 * 4, "UInt")
    NumPut(showCmd, WINDOWPLACEMENT, 8, "UInt")
    Return DllCall("SetWindowPlacement", "UInt", hWnd, "UInt", &WINDOWPLACEMENT)
}

GetWindowInfo(hWnd) {
    VarSetCapacity(WINDOWINFO, 60)
    DllCall("GetWindowInfo", "UInt", hWnd, "UInt", &WINDOWINFO)
    wi := Object(), wi.rcWindow := {}, wi.rcClient := {}
    wi.cbSize := NumGet(WINDOWINFO, 0)
    wi.rcWindow.left := NumGet(WINDOWINFO, 4)
    wi.rcWindow.top := NumGet(WINDOWINFO, 8)
    wi.rcWindow.right := NumGet(WINDOWINFO, 12)
    wi.rcWindow.bottom := NumGet(WINDOWINFO, 16)
    wi.rcClient.left := NumGet(WINDOWINFO, 20)
    wi.rcClient.top := NumGet(WINDOWINFO, 24)
    wi.rcClient.right := NumGet(WINDOWINFO, 28)
    wi.rcClient.bottom := NumGet(WINDOWINFO, 32)
    wi.dwStyle := NumGet(WINDOWINFO, 36)
    wi.dwExStyle := NumGet(WINDOWINFO, 40)
    wi.dwWindowStatus := NumGet(WINDOWINFO, 44)
    wi.cxWindowBorders := NumGet(WINDOWINFO, 48)
    wi.cyWindowBorders := NumGet(WINDOWINFO, 52)
    wi.atomWindowType := NumGet(WINDOWINFO, 56)
    wi.wCreatorVersion := NumGet(WINDOWINFO, 58)
    Return wi
}

GetClientSize(hWnd, ByRef w, ByRef h) { 
    VarSetCapacity(RECT, 16) 
    DllCall("GetClientRect", "UInt", hWnd, "Ptr", &RECT)
    w := NumGet(RECT, 8, "int")
    h := NumGet(RECT, 12, "int")
    Return RECT
} 

GetWindowSize(hWnd, ByRef x, ByRef y, ByRef w, ByRef h) { 
    WinGetPos x, y,,, ahk_id %hWnd%
    VarSetCapacity(RECT, 16)
    DllCall("GetClientRect", "UInt", hWnd, "Ptr", &RECT)
    w := NumGet(RECT, 8, "int")
    h := NumGet(RECT, 12, "int")
} 

SetWindowPos(hWnd, x, y, w, h, hWndInsertAfter := 0, uFlags := 0x40) { ; SWP_SHOWWINDOW
    Return DllCall("SetWindowPos", "UInt", hWnd, "UInt", hWndInsertAfter, "UInt", x, "UInt", y, "UInt", w, "UInt", h, "UInt", uFlags)
}

IsWindow(hWnd) {
    Return DllCall("IsWindow", "UInt", hWnd)
}

IsWindowVisible(hWnd) {
    Return DllCall("IsWindowVisible", "UInt", hWnd)
}

ShowWindow(hWnd, nCmdShow := 1) {
    DllCall("ShowWindow", "UInt", hWnd, "UInt", nCmdShow)
}

UpdateWindow(hWnd) {
    DllCall("UpdateWindow", "UInt", hWnd)
}

MoveWindow(hWnd, x, y, w, h, bRepaint) {
    DllCall("MoveWindow", "UInt", hWnd, "UInt", x, "UInt", y, "UInt", w, "UInt", h, "UInt", bRepaint)
}

GetActiveWindow() {
    Return DllCall("GetActiveWindow")
}

/*
IsWindowActive(hWnd) {
    Return (DllCall("GetActiveWindow") == hWnd)
}
*/

SetActiveWindow(hWnd) {
    Return DllCall("SetActiveWindow", "UInt", hWnd)
}

DestroyWindow(hWnd) {
    Return DllCall("DestroyWindow", "UInt", hWnd)
}

GetParent(hWnd) {
    Return DllCall("GetParent", "UInt", hWnd)
}

SetParent(hWndChild, hWndNewParent) {
    Return DllCall("SetParent", "UInt", hWndChild, "UInt", hWndNewParent)
}

GetOwner(hWnd) {
    Return DllCall("GetWindow", "UInt", hWnd, "UInt", 4) ; GW_OWNER
}

SetOwner(hWnd, hOwner) {
    Return DllCall("SetWindowLong", "UInt", hWnd, "UInt", -8, "UInt", hOwner) ; GWL_HWNDPARENT
}

GetFocus() {
    Return DllCall("GetFocus")
}

SetFocus(hWnd) {
    Return DllCall("SetFocus", "UInt", hWnd)
}

SetIcon(hWnd, FileName, Width := 16) {
    hIcon := DllCall("LoadImage", "UInt", 0
        , "Str", FileName
        , "UInt", 1 ; Type of image: IMAGE_ICON
        , "UInt", Width, "UInt", width
        , "UInt", 0x10) ; Flags: LR_LOADFROMFILE
    Size := (width = 16) ? 0 : 1 ; 0 = ICON_SMALL, 1 = ICON_BIG
    SendMessage 0x80, Size, hIcon,, ahk_id %hWnd% ; 0x80 = WM_SETICON
}

SetIconEx(hWnd, FileName, Index := 0, Width := 16) {
    hIcon := 0
    RetVal := DllCall("PrivateExtractIcons"
        , "Str", FileName
        , "UInt", Index
        , "UInt", Width, "UInt", Width
        , "UIntP", hIcon
        , "UInt", 0, "UInt", 1, "UInt", 0)
    Size := (width = 16) ? 0 : 1 ; 0 = ICON_SMALL, 1 = ICON_BIG
    SendMessage 0x80, Size, hIcon,, ahk_id %hWnd% ; WM_SETICON
    Return RetVal
}

GetWindowText(hWnd, nMaxCount := 2000){
    VarSetCapacity(lpString, 2000)
    DllCall("GetWindowText", "UInt", hWnd, "Str", lpString, "UInt", nMaxCount)
    Return lpString
}

GetWindowTextLength(hWnd) {
    Return DllCall("GetWindowTextLength", "UInt", hWnd)
}

SetWindowText(hWnd, lpString) {
    Return DllCall("SetWindowText", "UInt", hWnd, "Str", lpString)
}

; Menu functions *******************************************************

GetMenu(hWnd) {
    Return DllCall("GetMenu", "UInt", hWnd)
}

GetSubMenu(hMenu, nPos) {
    Return DllCall("GetSubMenu", "UInt", hMenu, "UInt", nPos)
}

GetMenuItemID(hMenu, nPos) {
    Return DllCall("GetMenuItemID", "UInt", hMenu, "UInt", nPos)
}

GetMenuItemCount(hMenu) {
    Return DllCall("GetMenuItemCount", "UInt", hMenu)
}

GetMenuString(hMenu, uIDItem) {
    ; uIDItem: the zero-based relative position of the menu item
    Local lpString, MenuItemID
    VarSetCapacity(lpString, 2000)
    If !(DllCall("GetMenuString", "Ptr", hMenu, "UInt", uIDItem, "Str", lpString, "UInt", 1000, "UInt", 0x400)) {
        MenuItemID := GetMenuItemID(hMenu, uIDItem)
        If (MenuItemID > -1) {
            Return "SEPARATOR"
        } Else {
            Return (GetSubMenu(hMenu, uIDItem)) ? "SUBMENU" : "ERROR"
        }
    }
    Return lpString
}

CheckMenuRadioItem(hMenu, nPos, nFirst := 0, nLast := 0) {
    Return DllCall("CheckMenuRadioItem", "UInt", hMenu, "UInt", nFirst , "UInt", nLast, "UInt", nPos, "UInt", 0x400)
}

DeleteMenu(hMenu, uPosition, uFlags := 0x400) { ; By position
    Return DllCall("DeleteMenu", "UInt", hMenu, "UInt", uPosition, "UInt", uFlags)
}

DrawMenuBar(hWnd) {
    Return DllCall("DrawMenuBar", "UInt", hWnd)
}

; Misc functions *******************************************************

GetSysColor(nIndex) {
    Return DllCall("GetSysColor", "UInt", nIndex)
}

IfBetween(ByRef Var, LowerBound, UpperBound) {
    If Var Between %LowerBound% And %UpperBound%
        Return True
}

IfNotBetween(ByRef Var, LowerBound, UpperBound) {
    If Var Not Between %LowerBound% And %UpperBound%
        Return True
}

GetClassName(hWnd, nMaxCount := 256) {
    VarSetCapacity(lpClassName, 256)
    DllCall("GetClassName", "UInt", hWnd, "Str", lpClassName, "UInt", nMaxCount)
    Return lpClassName
}

GetHandle(ClassNN) {
    GuiControlGet hWnd, %Child%: hWnd, %ClassNN%
    Return hWnd
}

GetClassNN(hCtrl) {
    WinGet ClassNNList, ControlList, ahk_id %hChildWnd%
    Loop Parse, ClassNNList, `n
    {
        GuiControlGet hWnd, %Child%: hWnd, %A_LoopField%
        If (hWnd == hCtrl) {
            ClassNN := A_LoopField
            Return ClassNN
        }
    }
}

ToHex(Num) {
    OldFormat := A_FormatInteger
    SetFormat Integer, H
    Num += 0
    SetFormat Integer, %OldFormat%
    Return Num
}

ToDec(Num) {
    OldFormat := A_FormatInteger
    SetFormat Integer, D
    Num += 0
    SetFormat Integer, %OldFormat%
    Return Num
}

GetTempFileName(lpPathName, lpPrefixString := "ahk", uUnique := 0) {
    VarSetCapacity(lpTempFileName, 255)
    DllCall("GetTempFileName", "Str", lpPathName, "Str", lpPrefixString, "UInt", uUnique, "Str", lpTempFileName)
    Return lpTempFileName
}

LV_GetColumnWidth(hWnd, Column) {
    SendMessage LVM_GETCOLUMNWIDTH := 0x101D, Column - 1, 0,, % "ahk_id " . hWnd
    Return (ErrorLevel = "FAIL" ? -1 : ErrorLevel)
}

LV_CalcViewSize(hWnd, Items := 0) {
    Result := False
    SendMessage LVM_APPROXIMATEVIEWRECT := 0x1040, Items - 1, 0, , % "ahk_id " . hWnd
    If (ErrorLevel != "FAIL") {
        Result := {}
        Result.W := (ErrorLevel & 0xFFFF)
        Result.H := (ErrorLevel >> 16) & 0xFFFF
    }
    Return Result
}

/*
RoundTo(Value, RoundTo) {
    Return (Value + (RoundTo - 1)) & ~(RoundTo - 1)
}
*/

RoundTo(Value, RoundTo) {
    If (Value >= 0) {
        Return (Value + (RoundTo - 1)) & ~(RoundTo - 1)
    } Else {
        Return -((-Value + (RoundTo - 1)) & ~(RoundTo - 1))
    }
}

MessageBoxCheck(Options, Title, Message, RegVal, hOwner := 0) {
    hModule := DllCall("GetModuleHandle", "Str", "shlwapi.dll")
    ; Exported by ordinal for compatibility with Windows XP
    SHMessageBoxCheckW := DllCall("GetProcAddress", "UInt", hModule, "UInt", 191)
    
    DllCall(SHMessageBoxCheckW
        , "UInt", hOwner
        , "Str", Message
        , "Str", Title
        , "UInt", Options
        , "int", 0
        , "Str", RegVal)
}

GetFileIcon(File, Small := 1) {
    VarSetCapacity(SHFILEINFO, cbFileInfo := A_PtrSize + 688)
    If (DllCall("Shell32.dll\SHGetFileInfoW"
        , "WStr", File
        , "UInt", 0
        , "Ptr" , &SHFILEINFO
        , "UInt", cbFileInfo
        , "UInt", 0x100 + Small)) { ; SHGFI_ICON
        Return NumGet(SHFILEINFO, 0, "Ptr")
    }
}

IsFolder(Path) {
    Return InStr(FileExist(Path), "D") 
}

ShowBalloonTip(hEdit, Title, Text, Icon := 0) {
    NumPut(VarSetCapacity(EDITBALLOONTIP, 4 * A_PtrSize, 0), EDITBALLOONTIP)
    NumPut(&Title, EDITBALLOONTIP, A_PtrSize, "Ptr")
    NumPut(&Text, EDITBALLOONTIP, A_PtrSize * 2, "Ptr")
    NumPut(Icon, EDITBALLOONTIP, A_PtrSize * 3, "UInt")
    SendMessage 0x1503, 0, &EDITBALLOONTIP,, ahk_id %hEdit% ; EM_SHOWBALLOONTIP
    Return ErrorLevel
}
