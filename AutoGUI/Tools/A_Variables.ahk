; A_Variables - AutoHotkey Built-in Variables v1.1

#NoEnv
;#Warn,, OutputDebug
#Warn
#SingleInstance Force
#NoTrayIcon
SetWorkingDir %A_ScriptDir%

Global A := Array()
     , G := Array()
     , hLV
     , NT6 := DllCall("GetVersion") & 0xFF > 5
     , Indent := (NT6) ? "    " : ""

; AutoHotkey Information
G.Insert([10, "AutoHotkey Information"])
A.Insert(["A_AhkPath", A_AhkPath, 10])
A.Insert(["A_AhkVersion", A_AhkVersion, 10])
A.Insert(["A_IsUnicode", A_IsUnicode, 10])

; Operating System and User Information
G.Insert([20, "Operating System and User Information"])
A.Insert(["A_OSType", A_OSType, 20])
A.Insert(["A_OSVersion", A_OSVersion, 20])
A.Insert(["A_Is64bitOS", A_Is64bitOS, 20])
A.Insert(["A_PtrSize", A_PtrSize, 20])
A.Insert(["A_Language", A_Language, 20])
A.Insert(["A_ComputerName", A_ComputerName, 20])
A.Insert(["A_UserName", A_UserName, 20])
A.Insert(["A_IsAdmin", A_IsAdmin, 20])

; Screen Resolution
G.Insert([30, "Screen Resolution"])
A.Insert(["A_ScreenWidth", A_ScreenWidth, 30])
A.Insert(["A_ScreenHeight", A_ScreenHeight, 30])
A.Insert(["A_ScreenDPI", A_ScreenDPI, 30])

; Script Properties
G.Insert([40, "Script Properties"])
A.Insert(["A_WorkingDir", A_WorkingDir, 40])
A.Insert(["A_ScriptDir", A_ScriptDir, 40])
A.Insert(["A_ScriptName", A_ScriptName, 40])
A.Insert(["A_ScriptFullPath", A_ScriptFullPath, 40])
A.Insert(["A_ScriptHwnd", A_ScriptHwnd, 40])
A.Insert(["A_LineNumber", A_LineNumber, 40])
A.Insert(["A_LineFile", A_LineFile, 40])
A.Insert(["A_ThisFunc", A_ThisFunc, 40])
A.Insert(["A_ThisLabel", A_ThisLabel, 40])
A.Insert(["A_IsCompiled", A_IsCompiled, 40])
A.Insert(["A_IsSuspended", A_IsSuspended, 40])
A.Insert(["A_IsPaused", A_IsPaused, 40])
A.Insert(["A_ExitReason", A_ExitReason, 40])

; Date and Time
G.Insert([50, "Date and Time"])
A.Insert(["A_Year", A_Year, 50])
A.Insert(["A_Mon", A_Mon, 50])
A.Insert(["A_DD", A_DD, 50])
A.Insert(["A_YYYY", A_YYYY, 50])
A.Insert(["A_MMMM", A_MMMM, 50])
A.Insert(["A_MMM", A_MMM, 50])
A.Insert(["A_MM", A_MM, 50])
A.Insert(["A_DDDD", A_DDDD, 50])
A.Insert(["A_DDD", A_DDD, 50])
A.Insert(["A_MDAY", A_MDAY, 50])
A.Insert(["A_WDay", A_WDay, 50])
A.Insert(["A_YDay", A_YDay, 50])
A.Insert(["A_YWeek", A_YWeek, 50])
A.Insert(["A_Hour", A_Hour, 50])
A.Insert(["A_Min", A_Min, 50])
A.Insert(["A_Sec", A_Sec, 50])
A.Insert(["A_MSec", A_MSec, 50])
A.Insert(["A_Now", A_Now, 50])
A.Insert(["A_NowUTC", A_NowUTC, 50])
A.Insert(["A_TickCount", A_TickCount, 50])

; Script Settings (Performance, Detection and Reliability)
G.Insert([60, "Script Settings (Performance, Detection and Reliability)"])
A.Insert(["A_BatchLines", A_BatchLines, 60])
A.Insert(["A_NumBatchLines", A_NumBatchLines, 60])
A.Insert(["A_IsCritical", A_IsCritical, 60])
A.Insert(["A_TitleMatchMode", A_TitleMatchMode, 60])
A.Insert(["A_TitleMatchModeSpeed", A_TitleMatchModeSpeed, 60])
A.Insert(["A_DetectHiddenWindows", A_DetectHiddenWindows, 60])
A.Insert(["A_DetectHiddenText", A_DetectHiddenText, 60])
A.Insert(["A_WinDelay", A_WinDelay, 60])
A.Insert(["A_ControlDelay", A_ControlDelay, 60])
A.Insert(["A_KeyDelay", A_KeyDelay, 60])
A.Insert(["A_KeyDelayPlay", A_KeyDelayPlay, 60])
A.Insert(["A_KeyDuration", A_KeyDelayPlay, 60])
A.Insert(["A_KeyDurationPlay", A_KeyDelayPlay, 60])
A.Insert(["A_SendMode", A_SendLevel, 60])
A.Insert(["A_SendLevel", A_SendLevel, 60])
A.Insert(["A_MouseDelay", A_MouseDelay, 60])
A.Insert(["A_MouseDelayPlay", A_MouseDelayPlay, 60])
A.Insert(["A_DefaultMouseSpeed", A_DefaultMouseSpeed, 60])

; Script Settings (Misc.)
G.Insert([70, "Script Settings (Misc.)"])
A.Insert(["A_FileEncoding", A_FileEncoding, 70])
A.Insert(["A_StringCaseSense", A_StringCaseSense, 70])
A.Insert(["A_AutoTrim", A_AutoTrim, 70])
A.Insert(["A_FormatInteger", A_FormatInteger, 70])
A.Insert(["A_FormatFloat", A_FormatFloat, 70])
A.Insert(["A_StoreCapslockMode", A_StoreCapslockMode, 70])

; Coordinate Mode
G.Insert([80, "Coordinate Mode"])
A.Insert(["A_CoordModeToolTip", A_CoordModeToolTip, 80])
A.Insert(["A_CoordModePixel", A_CoordModePixel, 80])
A.Insert(["A_CoordModeMouse", A_CoordModeMouse, 80])
A.Insert(["A_CoordModeCaret", A_CoordModeCaret, 80])
A.Insert(["A_CoordModeMenu", A_CoordModeMenu, 80])

; GUI (Windows and Controls)
G.Insert([90, "GUI (Windows and Controls)"])
A.Insert(["A_Gui", A_Gui, 90])
A.Insert(["A_GuiX", A_GuiX, 90])
A.Insert(["A_GuiY", A_GuiY, 90])
A.Insert(["A_GuiWidth", A_GuiWidth, 90])
A.Insert(["A_GuiHeight", A_GuiHeight, 90])
A.Insert(["A_GuiEvent", A_GuiEvent, 90])
A.Insert(["A_GuiControl", A_GuiControl, 90])
A.Insert(["A_GuiControlEvent", A_GuiControlEvent, 90])
A.Insert(["A_EventInfo", A_EventInfo, 90])
A.Insert(["A_DefaultGui", A_DefaultGui, 90])
A.Insert(["A_DefaultListView", A_DefaultListView, 90])
A.Insert(["A_DefaultTreeView", A_DefaultTreeView, 90])

; Menu Identification
G.Insert([100, "Menu Identification"])
A.Insert(["A_ThisMenuItem", A_ThisMenuItem, 100])
A.Insert(["A_ThisMenu", A_ThisMenu, 100])
A.Insert(["A_ThisMenuItemPos", A_ThisMenuItemPos, 100])

; Tray Icon Settings
G.Insert([110, "Tray Icon Settings"])
A.Insert(["A_IconHidden", A_IconHidden, 110])
A.Insert(["A_IconTip", A_IconTip, 110])
A.Insert(["A_IconFile", A_IconFile, 110])
A.Insert(["A_IconNumber", A_IconNumber, 110])

; Hotkeys and Hotstrings
G.Insert([120, "Hotkeys and Hotstrings"])
A.Insert(["A_ThisHotkey", A_ThisHotkey, 120])
A.Insert(["A_PriorHotkey", A_PriorHotkey, 120])
A.Insert(["A_PriorKey", A_PriorKey, 120])
A.Insert(["A_TimeSinceThisHotkey", A_TimeSinceThisHotkey, 120])
A.Insert(["A_TimeSincePriorHotkey", A_TimeSincePriorHotkey, 120])
A.Insert(["A_EndChar", A_EndChar, 120])

; User Idle Time
G.Insert([130, "User Idle Time"])
A.Insert(["A_TimeIdle", A_TimeIdle, 130])
A.Insert(["A_TimeIdlePhysical", A_TimeIdlePhysical, 130])

; Special Paths
G.Insert([140, "Special Paths"])
A.Insert(["A_Temp", A_Temp, 140])
A.Insert(["A_WinDir", A_WinDir, 140])
A.Insert(["ProgramFiles", ProgramFiles, 140])
A.Insert(["A_ProgramFiles", A_ProgramFiles, 140])
A.Insert(["A_AppData", A_AppData, 140])
A.Insert(["A_AppDataCommon", A_AppDataCommon, 140])
A.Insert(["A_Desktop", A_Desktop, 140])
A.Insert(["A_DesktopCommon", A_DesktopCommon, 140])
A.Insert(["A_StartMenu", A_StartMenu, 140])
A.Insert(["A_StartMenuCommon", A_StartMenuCommon, 140])
A.Insert(["A_Programs", A_Programs, 140])
A.Insert(["A_ProgramsCommon", A_ProgramsCommon, 140])
A.Insert(["A_Startup", A_Startup, 140])
A.Insert(["A_StartupCommon", A_StartupCommon, 140])
A.Insert(["A_MyDocuments", A_MyDocuments, 140])
A.Insert(["ComSpec", ComSpec, 140])

; IP Address
G.Insert([150, "IP Address"])
A.Insert(["A_IPAddress1", A_IPAddress1, 150])
A.Insert(["A_IPAddress2", A_IPAddress2, 150])
A.Insert(["A_IPAddress3", A_IPAddress3, 150])
A.Insert(["A_IPAddress4", A_IPAddress4, 150])

; Cursor
G.Insert([160, "Cursor"])
A.Insert(["A_Cursor", A_Cursor, 160])
A.Insert(["A_CaretX", A_CaretX, 160])
A.Insert(["A_CaretY", A_CaretY, 160])

; Clipboard
G.Insert([170, "Clipboard"])
A.Insert(["Clipboard", Clipboard, 170])
A.Insert(["ClipboardAll", ClipboardAll, 170])

; Loops
G.Insert([180, "Loops"])
A.Insert(["A_Index", A_Index, 180])
A.Insert(["A_LoopField", A_LoopField, 180])

; Loop Files
G.Insert([190, "Loop Files"])
A.Insert(["A_LoopReadLine", A_LoopReadLine, 190])
A.Insert(["A_LoopFileFullPath", A_LoopFileFullPath, 190])
A.Insert(["A_LoopFileDir", A_LoopFileDir, 190])
A.Insert(["A_LoopFileName", A_LoopFileName, 190])
A.Insert(["A_LoopFileExt", A_LoopFileExt, 190])
A.Insert(["A_LoopFileLongPath", A_LoopFileLongPath, 190])
A.Insert(["A_LoopFileShortPath", A_LoopFileShortPath, 190])
A.Insert(["A_LoopFileShortName", A_LoopFileShortName, 190])
A.Insert(["A_LoopFileAttrib", A_LoopFileAttrib, 190])
A.Insert(["A_LoopFileSize", A_LoopFileSize, 190])
A.Insert(["A_LoopFileSizeKB", A_LoopFileSizeKB, 190])
A.Insert(["A_LoopFileSizeMB", A_LoopFileSizeMB, 190])
A.Insert(["A_LoopFileTimeCreated", A_LoopFileTimeCreated, 190])
A.Insert(["A_LoopFileTimeModified", A_LoopFileTimeModified, 190])
A.Insert(["A_LoopFileTimeAccessed", A_LoopFileTimeAccessed, 190])

; Registry
G.Insert([200, "Registry"])
A.Insert(["A_LoopRegName", A_LoopRegName, 200])
A.Insert(["A_LoopRegType", A_LoopRegType, 200])
A.Insert(["A_LoopRegKey", A_LoopRegKey, 200])
A.Insert(["A_LoopRegSubkey", A_LoopRegSubkey, 200])
A.Insert(["A_LoopRegTimeModified", A_LoopRegTimeModified, 200])
A.Insert(["A_RegView", A_RegView, 200])

; Special Characters
G.Insert([210, "Special Characters"])
A.Insert(["A_Space", A_Space, 210])
A.Insert(["A_Tab", A_Tab, 210])

; Error Codes
G.Insert([220, "Error Codes"])
A.Insert(["ErrorLevel", ErrorLevel, 220])
A.Insert(["A_LastError", A_LastError, 220])

Menu Tray, Icon, ..\Icons\A_Variables.ico

Gui Color, FEFEFE

Gui Add, Picture, x10 y10 w32 h32, ..\Icons\A_Variables.ico

Gui Font, c0x003399, MS Shell Dlg 2
Gui Add, Text, x45 y11 w630 h26, The following variables are built into the program and can be referenced by any script. With the exception of Clipboard, ErrorLevel, and command line parameters, these variables are read-only`; that is, their contents cannot be directly altered by the script. 

If (NT6) {
    Gui Font, s9 cBlack, Segoe UI
} Else {
    Gui Font, s10 cBlack, Lucida Console
}

Gui Add, ListView, hWndhLV x4 y48 w680 h339 LV0x4000, Variable|Value
If (!NT6) {
    ; Increase row height on Windows XP
    LV_SetImageList(DllCall("ImageList_Create", Int, 2, Int, 20, Int, 0x18, Int, 1, Int, 1), 1)
    GuiControl +Grid, SysListView321
}
Gui Font

; Footer area
Gui Add, TreeView, x-1 y386 w690 h48 BackgroundF1F5FB Disabled 
Gui Font, s9, Segoe UI
Gui Add, Edit, hWndhSearchField vSearch gSearch x10 y398 w186 h23 +0x2000000 ; WS_CLIPCHILDREN
; Search field grey hint text
DllCall("SendMessage", "Ptr", hSearchField, "UInt", 0x1501, "Ptr", 1, "WStr", "Search", "Ptr")
; Search icon
Gui Add, Picture, hWndhPic x165 y1 w16 h16, ..\Icons\Search.ico
DllCall("SetParent", "UInt", hPic, "UInt", hSearchField)
WinSet Style, -0x40000000, ahk_id %hPic% ; -WS_CHILD
ControlFocus,, ahk_id %hSearchField%

Gui Show, w688 h432, A_Variables - AutoHotkey Built-in Variables

Menu ContextMenu, Add, Copy`tCtrl+C, MenuHandler
Menu ContextMenu, Icon, 1&, shell32.dll, 135
Menu ContextMenu, Add, Copy Variable, MenuHandler
Menu ContextMenu, Add, Copy Value, MenuHandler
Menu ContextMenu, Add
Menu ContextMenu, Add, Select All`tCtrl+A, SelectAll

If (NT6) {
    Loop % G.Length() {
        LV_InsertGroup(hLV, G[A_Index][1], G[A_Index][2]) ; Define LV Groups
    }

    SendMessage 0x109D, 1, 0,, ahk_id %hLV% ; LVM_ENABLEGROUPVIEW

    DllCall("UxTheme.dll\SetWindowTheme", "Ptr", hLV, "WStr", "Explorer", "Ptr", 0)
}

ShowVariables()

OnMessage(0x100, "OnWM_KEYDOWN")
Return

Search:
    Gui Submit, NoHide
    ShowVariables(Search)
Return

ShowVariables(Filter:= "") {
    Static Row

    LV_Delete()
    GuiControl -Redraw, SysListView321

    For Index, Value in A {
        If (InStr(A[Index][1], Filter) || InStr(A[Index][2], Filter)) {
            Row := LV_Add("", Indent . A[Index][1], A[Index][2])
            If (NT6 && A[Index][3] != "") {
                LV_SetGroup(hLV, Row, A[Index][3])
            }
        }
    }

    GuiControl +Redraw, SysListView321
    LV_ModifyCol(1, 186)
    LV_ModifyCol(2, 472)
}

GuiContextMenu:
    Menu ContextMenu, Show
Return

MenuHandler:
    Copy(A_ThisMenuItemPos)
Return

Copy(Param) {
    Global

    Gui +LastFound
    ControlGetFocus Focus
    If (Focus == "Edit1") {
        Send ^C
        Return
    }

    Output := ""

    If (Param != 1) {
        Row := 0
        Col := (Param == 2) ? 1 : 2

        While(Row := LV_GetNext(Row)) {
            LV_GetText(Text, Row, Col)
            Output .= Text . "`n"
        }

        Clipboard := Output
    } Else {
        ControlGet Output, List, Selected, SysListView321
    }

    If (Output != "") {
        Output := RegExReplace(Output, "m`n)^\s+")
        Clipboard := RTrim(Output, " `t`r`n")
    }
}

SelectAll:
    Gui +LastFound
    ControlGetFocus Focus
    If (Focus == "Edit1") {
        Send ^A
        Return
    }

    ControlFocus, SysListView321
    LV_Modify(0, "Select")
Return

GuiEscape:
GuiClose:
    ExitApp

LV_InsertGroup(hLV, GroupID, Header, Index := -1) {
    Static iGroupId := (A_PtrSize == 8) ? 36 : 24
    NumPut(VarSetCapacity(LVGROUP, 56, 0), LVGROUP, 0)
    NumPut(0x15, LVGROUP, 4, "UInt") ; mask: LVGF_HEADER|LVGF_STATE|LVGF_GROUPID
    NumPut((A_IsUnicode) ? &Header : UTF16(Header, _), LVGROUP, 8, "Ptr") ; pszHeader
    NumPut(GroupID, LVGROUP, iGroupId, "Int") ; iGroupId
    NumPut(0x8, LVGROUP, iGroupId + 8, "Int") ; state: LVGS_COLLAPSIBLE
    SendMessage 0x1091, %Index%, % &LVGROUP,, ahk_id %hLV% ; LVM_INSERTGROUP
    Return ErrorLevel
}

LV_SetGroup(hLV, Row, GroupID) {
    Static iGroupId := (A_PtrSize == 8) ? 52 : 40
    VarSetCapacity(LVITEM, 58, 0)
    NumPut(0x100, LVITEM, 0, "UInt")  ; mask: LVIF_GROUPID
    NumPut(Row - 1, LVITEM, 4, "Int") ; iItem
    NumPut(GroupID, LVITEM, iGroupId, "Int")
    SendMessage 0x1006, 0, &LVITEM,, ahk_id %HLV% ; LVM_SETITEMA
    Return ErrorLevel
}

UTF16(String, ByRef Var) {
    VarSetCapacity(Var, StrPut(String, "UTF-16") * 2, 0)
    StrPut(String, &Var, "UTF-16")
    Return &Var
}

OnWM_KEYDOWN(wParam, lParam, msg, hWnd) {
    CtrlP := GetKeyState("Ctrl", "P")

    If (wParam == 65 && CtrlP) {
        GoSub SelectAll
        Return False
    }

    If (wParam == 67 && CtrlP) {
        Copy(1)
        Return False    
    }
}
