; Win32 Error Codes Lookup/Listing Tool v1.0

#NoEnv
#Warn
#SingleInstance Force
#NoTrayIcon
SetWorkingDir %A_ScriptDir%
SetBatchLines -1
FileEncoding UTF-8

#Include ..\Lib\AutoXYWH.ahk

Menu Tray, Icon, ..\Icons\ErrorView.ico

Global Total
     , Items := []
     , Lang := 0 ; English: 0x409
     , Version := 1.0

Gui +Resize
Gui Color, F1F5FB

Menu FileMenu, Add, &Save`tCtrl+S, Save
Menu FileMenu, Add
Menu FileMenu, Add, E&xit`tAlt+Q, GuiClose
Menu MenuBar, Add, &File, :FileMenu
Menu EditMenu, Add, &Copy`tCtrl+C, Copy
Menu EditMenu, Add
Menu EditMenu, Add, Select &All`tCtrl+A, SelectAll
Menu MenuBar, Add, &Edit, :EditMenu
Menu ViewMenu, Add, &Random Balloon`tF2, RandomBalloon
Menu MenuBar, Add, &View, :ViewMenu
Menu HelpMenu, Add, &Online Reference, OnlineRef
Menu HelpMenu, Add
Menu HelpMenu, Add, &About, ShowAbout
Menu MenuBar, Add, &Help, :HelpMenu
Gui Menu, MenuBar

Menu ContextMenu, Add, Message Box, ShowMsgBox
Menu ContextMenu, Default, Message Box
Menu ContextMenu, Add
Menu ContextMenu, Add, &Copy`tCtrl+C, Copy
Menu ContextMenu, Add
Menu ContextMenu, Add, Select &All`tCtrl+A, SelectAll

Gui Font, s9, Segoe UI

Gui Add, ListView, hWndhLV vLV gLVHandler x-1 y-1 w690 h371 +LV0x14000, ID|Message
    LV_ModifyCol(1, "48 Integer")
    LV_ModifyCol(2, 618)
    DllCall("UxTheme.dll\SetWindowTheme", "Ptr", hLV, "WStr", "Explorer", "Ptr", 0)
Gui Add, Edit, hWndhHiddenEdit x20 y20 w0 h0

Gui Add, Picture, hWndhPic x207 y1 w16 h16, ..\Icons\Search.ico
Gui Add, Edit, hWndhEdit vFilter x9 y380 w230 h23 +0x2000000 ; WS_CLIPCHILDREN
DllCall("SendMessage", "Ptr", hEdit, "UInt", 0x1501, "Ptr", 1, "WStr", "Enter search here")
DllCall("SetParent", "UInt", hPic, "UInt", hEdit)
WinSet Style, -0x40000000, ahk_id %hPic% ; -WS_CHILD
GuiControl Focus, %hEdit%

Gui Add, Text, hWndhCounter x555 y380 w120 h23 +0x202, Loading Messages...

Gui Show, w688 h412, ErrorView - System Error Messages

GoSub Start

OnMessage(0x100, "OnWM_KEYDOWN")
Return

GuiEscape:
    Gui Submit, NoHide
    If (Filter != "") {
        GuiControl,, %hEdit%
        Search()
        Return
    }
Return

GuiClose:
    ExitApp

GuiSize:
    If (A_EventInfo == 1) {
        Return
    }
    AutoXYWH("wh", hLV)
    AutoXYWH("y", hEdit)
    AutoXYWH("xy", hCounter)

    LV_ModifyCol(2, A_GuiWidth - 70)
Return

GuiContextMenu:
    If (A_GuiControl != "LV") {
        Return
    }

    Menu ContextMenu, Show
Return

Start:
    Loop 18000 {
        Index := A_Index - 1
        If (Message := GetErrorMessage(Index, Lang)) {
            LV_Add("", Index, Message)
            Items.Push([index, Message])
        }
    }

    Total := Items.Length()
    GuiControl,, Static2, %Total% Items
Return

GetErrorMessage(ErrorCode, LanguageId := 0) {
    Static ErrorMsg
    VarSetCapacity(ErrorMsg, 8192)
    DllCall("Kernel32.dll\FormatMessage"
        , "UInt", 0x1200 ; FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS
        , "UInt", 0
        , "UInt", ErrorCode
        , "UInt", LanguageId
        , "Str" , ErrorMsg
        , "UInt", 8192)
    Return StrGet(&ErrorMsg)
}

ShowMsgBox:    
LVHandler:
    If (A_GuiEvent == "DoubleClick") {
        Row := A_EventInfo
    } Else {
        Row := LV_GetNext()
    }

    LV_GetText(ErrorCode, Row)
    LV_GetText(ErrorMsg, Row, 2)

    Gui +OwnDialogs
    MsgBox 0x0, Error %ErrorCode%, %ErrorMsg%
Return

Search:
    Gui Submit, NoHide
    Search(Filter)
Return

Search(Filter := "") {
    Global

    If Filter is Integer
    {
        LV_Delete()
        Loop % Items.MaxIndex() {
            If (Items[A_Index][1] == Filter) {
                LV_Add("", Items[A_Index][1], Items[A_Index][2])
                GuiControl,, Static2, 1 Item
                Break
            }
        }

        If (!LV_GetCount()) {
            GuiControl,, Static2, Not found
        }

        Return
    }

    LV_Delete()
    GuiControl -Redraw, SysListView321

    Total := 0
    Loop % Items.MaxIndex() {
        If (InStr(Items[A_Index][1], Filter) || InStr(Items[A_Index][2], Filter)) {
            LV_Add("", Items[A_Index][1], Items[A_Index][2])
            Total++
        }
    }

    GuiControl +Redraw, SysListView321
    LV_ModifyCol(1, 48)
    LV_ModifyCol(2, 618)

    GuiControl,, Static2, %Total% Items
}

Save:
    Gui +OwnDialogs
    FileSelectFile SelectedFile, S16, Errors.txt, Save
    If (ErrorLevel) {
        Return
    }

    ;ControlGet Output, List,, SysListView321
    Output := ""
    Loop % LV_GetCount() {
        LV_GetText(ID, A_Index)
        LV_GetText(Message, A_Index, 2)
        Output .= ID . "`t" . Message . "`n"
    }

    FileDelete %SelectedFile%
    FileAppend % RTrim(Output, "`n"), %SelectedFile%
Return

SelectAll:
    Gui +LastFound
    ControlGetFocus Focus
    GuiControlGet Text,, Edit1
    If (Focus == "Edit1" && Text != "") {
        Send ^A
        Return
    }

    ControlFocus, SysListView321
    LV_Modify(0, "Select")
Return

Copy:
    Gui +LastFound
    ControlGetFocus Focus
    GuiControlGet Text,, Edit1
    If (Focus == "Edit1" && Text != "") {
        Send ^C
        Return    
    }

    ;ControlGet Selection, List, Selected, SysListView321 ; Truncates long messages
    Row := 0, Output := ""

    While (Row := LV_GetNext(Row)) {
        LV_GetText(ID, Row)
        LV_GetText(Message, Row, 2)

        Output .= ID . "`t" . Message . "`n"
    }

    If (Output != "") {
        Clipboard := RTrim(Output, "`n")
    }
Return

RandomBalloon:
    If (LV_GetCount() != Items.Length()) {
        Search()
    }

    Random Number, 0, %Total%
    LV_GetText(ErrorCode, Number)
    LV_GetText(ErrorMsg, Number, 2)
    GuiControl -Redraw, SysListView321
    LV_Modify(Total, "Vis")
    LV_Modify(Number, "Vis Select")
    GuiControl +Redraw, SysListView321
    ShowBalloonTip(hHiddenEdit, "Error " . ErrorCode, ErrorMsg, Number)
Return

ShowBalloonTip(hEdit, Title, Text, Icon := 0) {
    NumPut(VarSetCapacity(EDITBALLOONTIP, 4 * A_PtrSize, 0), EDITBALLOONTIP)
    NumPut((A_IsUnicode) ? &Title : UTF16(Title, T), EDITBALLOONTIP, A_PtrSize, "Ptr")
    NumPut((A_IsUnicode) ? &Text : UTF16(Text, M), EDITBALLOONTIP, A_PtrSize * 2, "Ptr")
    NumPut(Icon, EDITBALLOONTIP, A_PtrSize * 3, "UInt")
    SendMessage 0x1503, 0, &EDITBALLOONTIP,, ahk_id %hEdit% ; EM_SHOWBALLOONTIP
    Return ErrorLevel
}

UTF16(String, ByRef Var) {
    VarSetCapacity(Var, StrPut(String, "UTF-16") * 2, 0)
    StrPut(String, &Var, "UTF-16")
    Return &Var
}

Speak:
    LV_GetText(ErrorMsg, LV_GetNext(), 2)
    ComObjCreate("SAPI.SpVoice").Speak(ErrorMsg)
Return

OnlineRef:
    Try {
        Run https://msdn.microsoft.com/en-us/library/windows/desktop/ms681381(v=vs.85).aspx
    }
Return

OnWM_KEYDOWN(wParam, lParam, msg, hWnd) {
    Global

    If (wParam == 13 && hWnd == hEdit) {
        GoSub Search
    } Else If (wParam == 32 && hWnd == hLV) {
        GoSub Speak
    }
}

ShowAbout:
    Gui 1: +Disabled
    Gui About: New, -SysMenu Owner1
    Gui Color, White
    Gui Add, Picture, x15 y16 w32 h32, ..\Icons\ErrorView.ico
    Gui Font, s12 c0x003399, Segoe UI
    Gui Add, Text, x56 y11 w120 h23 +0x200, ErrorView
    Gui Font, s9 cDefault, Segoe UI
    Gui Add, Text, x56 y34 w280 h18 +0x200, System Error Messages Lookup/Listing Tool v%Version%
    Gui Add, Text, x1 y72 w391 h48 -Background
    Gui Add, Button, gAboutGuiClose x299 y85 w80 h23 Default, &OK
    Gui Font
    Gui Show, w392 h120, About
Return

AboutGuiEscape:
AboutGuiClose:
    Gui 1: -Disabled
    Gui About: Destroy
Return
