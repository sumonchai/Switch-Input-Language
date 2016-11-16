; AutoGUI v1.2.0a
; Tested on AHK v1.1.24.00 Unicode 32-bit, Windows XP/7/10

EnsureU32AHK()

; Script options
#NoEnv
#Warn All, Off
#SingleInstance Off
SetTitleMatchMode Slow
SetControlDelay -1
SetWinDelay -1
SetWorkingDir %A_ScriptDir%
DetectHiddenWindows On
SetBatchLines -1
ListLines Off

/*
If (InStr(DllCall("Kernel32.dll\GetCommandLineW", "WStr"), "y.exe"" /r")) {
    OutputDebug DBGVIEWCLEAR
}
*/

; Libraries
#Include %A_ScriptDir%\Lib\AuxLib.ahk
#Include %A_ScriptDir%\Lib\GuiTabEx.ahk
#Include %A_ScriptDir%\Lib\Toolbar.ahk
#Include %A_ScriptDir%\Lib\Scintilla.ahk
#Include %A_ScriptDir%\Lib\CommonDialogs.ahk
#Include %A_ScriptDir%\Lib\GuiButtonIcon.ahk
#Include %A_ScriptDir%\Lib\ExecScript.ahk
#Include %A_ScriptDir%\Lib\AutoXYWH.ahk
;#Include %A_ScriptDir%\Lib\CmdLineArgs.ahk
#Include %A_ScriptDir%\Lib\InputBoxEx.ahk
#Include %A_ScriptDir%\Include\Keywords.ahk

; Global variables
Global Version := "1.2.0a"
, AppName := "AutoGUI"
, hAutoWnd
, hChildWnd
, Child := 1
, hSelWnd := 0
, hToolbar
, hEditorTB
, hChildToolbar := 0
, TB_CHECKBUTTON := 0x402
, hSearchDlg
, hReplaceDlg
, SearchString := ""
, hFontDlg
, hCloneDlg
, hToolbarDlg := 0
, m := New MenuBar
, hMenuEditor := 0
, hAddMenuItemDlg := 0
, g := New GuiClass
, g_X := 0
, g_Y := 0
, g_Control := 0
, g_TabIndex := 1
, cxFrame
, cyCaption
, TopBorder
, cxVScroll
, OpenDir
, SaveDir
, CodePage
, Indent
, TabSize
, Insert := True
, DesignMode
, ShowGrid
, SnapToGrid
, GridSize
, WordWrap
, SyntaxHighlighting
, LineNumbers
, AutoBrackets
, SysTrayIcon
, hToolbox
, hTab := 0
, TabEx
, Tab := 1
, Sci := []
, RecentFiles := []
, hPropWnd := 0
, hCbxClassNN := 0
, Color
, hOptionsBtn
, SciLexer := A_ScriptDir . "\SciLexer.dll"
, IniFile
, IconLib := A_ScriptDir . "\Icons\AutoGUI.icl"
, hTile
, HelpFile := A_AhkPath . "\..\AutoHotkey.chm"
, hCross := DllCall("LoadCursor", "UInt", 0, "UInt", 32515)
, Cross := False
, Parameters := ""
, Backup
, BkpDir
, Delimiter := "; End of the GUI section"
, NoGrippers
, Grippers := []
, hGripper1
, hGripper2
, hGripper3
, hGripper4
, hGripper5
, hGripper6
, hGripper7
, hGripper8
, hGrippedWnd
, GripperSize := 6
, GripperColor := DllCall("User32.dll\GetSysColor", "Int", 13, "UInt")
, GripperBrush := DllCall("Gdi32.dll\CreateSolidBrush", "UInt", GripperColor, "UPtr")
, Cursors := {}
, Adding := False
, NoReturn := False
, NT6 := DllCall("GetVersion") & 0xFF > 5
, g_IconPath := "shell32.dll"
, g_PicturePath := A_MyDocuments
, g_GuiTab := 0
, g_GuiSB := False
, CRLF := "`r`n"
, AltAhkPath
, ShowSymbols := False

SysGet cxFrame, 32  ; Border width/height (8)
SysGet cyCaption, 4 ; Caption height (22)
SysGet cxVScroll, 2 ; Width of a vertical scroll bar
Global TopBorder := cxFrame + cyCaption ; 30

g.Window := New g.Window

Global Script := {0:0
,   NoEnv: True
,   Warn: "MsgBox"
,   SingleInstance: "Force"
,   NoTrayIcon: False
,   WorkingDir: "%A_ScriptDir%"
,   SendMode: ""
,   NoBatchLines: False
,   ListLinesOff: False
,   Persistent: False
,   IgnoreMenuErrors: False}

;Menu Tray, UseErrorLevel ; Suppress menu warnings
Menu Tray, Icon, %IconLib%

If (FileExist(A_AppData . "\AutoGUI\AutoGUI.ini")) {
    IniFile := A_AppData . "\AutoGUI\AutoGUI.ini"
} Else {
    IniFile := A_ScriptDir . "\AutoGUI.ini"
}

LoadSettings()

Gui Auto: New, LabelAuto hWndhAutoWnd Resize MinSize702 -DPIScale, % AppName . " v" . Version
Gui Auto: Default

#Include %A_ScriptDir%\Include\Menu.ahk
Gui Menu, AutoMenuBar

CreateToolbox()

Gui Add, CheckBox, x0 y0 w0 h0
Gui Add, Tab2, hWndhTab vTab gTabHandler x164 y29 w594 h300 AltSubmit Theme, Untitled 1
SendMessage 0x1329, 0, 0x00150055,, ahk_id %hTab% ; TCM_SETITEMSIZE

TabEx := New GuiTabEx(hTab)
    TabExIL := IL_Create(1)
    IL_Add(TabExIL, IconLib, 3)   ; Unsaved file
    IL_Add(TabExIL, A_AhkPath, 2) ; AHK default icon
    IL_Add(TabExIL, IconLib, 5)   ; GUI icon
    TabEx.SetImageList(TabExIL)
    TabEx.SetIcon(1, 1)
    TabEx.SetPadding(5, 4)

    Sci[1] := New Scintilla
    Sci[1].Add(hAutoWnd, 169, 56, 576, 420, SciLexer, 0x50010000, 0)
    SetSci(1)
    ControlFocus,, % "ahk_id " . Sci[1].hWnd

Gui Font, s9, Segoe UI
Gui Add, StatusBar
Gui Font
SetStatusBar()

IniRead ax, %IniFile%, Auto, x
IniRead ay, %IniFile%, Auto, y
IniRead aw, %IniFile%, Auto, w
IniRead ah, %IniFile%, Auto, h
IniRead Show, %IniFile%, Auto, Show
If (FileExist(IniFile)) {
    SetWindowPosition(hAutoWnd, ax, ay, aw, ah, Show)
} Else {
    Gui Show, w841 h561, % AppName . " v" . Version
}

GoSub CreateToolbar
GoSub CreateEditorToolbar
ApplySettings()

; Dispatch messages
OnMessage(0x136, "OnWM_CTLCOLORDLG")
OnMessage(0x3,   "OnWM_MOVE")
OnMessage(0x201, "OnWM_LBUTTONDOWN")
OnMessage(0x204, "OnWM_RBUTTONDOWN")
OnMessage(0x207, "OnWM_MBUTTONDOWN")
OnMessage(0x200, "OnWM_MOUSEMOVE")
OnMessage(0x100, "OnWM_KEYDOWN")
OnMessage(0x101, "OnWM_KEYUP")
OnMessage(0x104, "OnWM_SYSKEYDOWN") ; For F10
OnMessage(0x203, "OnWM_LBUTTONDBLCLK")
OnMessage(0x232, "OnWM_EXITSIZEMOVE")
OnMessage(0xA0,  "OnWM_NCMOUSEMOVE")
OnMessage(0x138, "OnWM_CTLCOLORSTATIC")
OnMessage(0x20,  "OnWM_SETCURSOR")
OnMessage(0x202, "OnWM_LBUTTONUP")
OnMessage(0x16,  "SaveSettings") ; WM_ENDSESSION

hTile := DllCall("LoadImage", "Int", 0
    , "Str", A_ScriptDir . "\Icons\8x8.bmp"
    , "Int", 0 ; IMAGE_BITMAP
    , "Int", GridSize, "Int", GridSize
    , "UInt", 0x10) ; LR_LOADFROMFILE

/*
If (DesignMode) {
    GoSub CreateChildWindow
} Else {
    GoSub SwitchToEditorMode
}
*/

WinActivate ahk_id %hAutoWnd%

If (NT6) {
    DllCall("UxTheme.dll\SetWindowTheme", "Ptr", hToolbox, "WStr", "Explorer", "Ptr", 0)
}

LoadRecentFiles()

#Include %A_ScriptDir%\Include\Controls.ahk

/*
Files := []
Loop % (Args := GetArgs())[0] {
    FileName := GetLongPathName(Args[A_Index])
    OutputDebug %FileName%
    If (FileName != A_ScriptFullPath && FileExist(FileName)) {
        Files.Insert(FileName)
    }
}
If (Files.MaxIndex()) {
    Open(Files)
}
*/

DeleteOldBackups()

#If IsWindowVisible(hCloneDlg)
    F8::GoSub CloneWindow
Return ; End of the auto-execute section.

CreateToolbox() {
    Gui Add, ListView
    , hWndhToolbox gToolboxHandler x0 y30 w160 h512 AltSubmit -Multi +LV0x10000 Background0xFEFEFE, Control Types

    ; Toolbox ImageList
    Global TboxIL := IL_Create(32)
    IL_Add(TboxIL, IconLib, 47) ; Button
    IL_Add(TboxIL, IconLib, 48) ; CheckBox
    IL_Add(TboxIL, IconLib, 49) ; ComboBox
    IL_Add(TboxIL, IconLib, 51) ; DateTime
    IL_Add(TboxIL, IconLib, 50) ; DropDownList
    IL_Add(TboxIL, IconLib, 52) ; Edit
    IL_Add(TboxIL, IconLib, 53) ; GroupBox
    IL_Add(TboxIL, IconLib, 54) ; Hotkey
    IL_Add(TboxIL, IconLib, 55) ; Link
    IL_Add(TboxIL, IconLib, 56) ; ListBox
    IL_Add(TboxIL, IconLib, 57) ; ListView
    IL_Add(TboxIL, IconLib, 58) ; Menu
    IL_Add(TboxIL, IconLib, 59) ; MonthCal
    IL_Add(TboxIL, IconLib, 60) ; Picture
    IL_Add(TboxIL, IconLib, 61) ; Progress
    IL_Add(TboxIL, IconLib, 62) ; Radio
    IL_Add(TboxIL, IconLib, 63) ; Separator
    IL_Add(TboxIL, IconLib, 64) ; Slider
    IL_Add(TboxIL, IconLib, 65) ; StatusBar
    IL_Add(TboxIL, IconLib, 66) ; Tab
    IL_Add(TboxIL, IconLib, 67) ; Text
    IL_Add(TboxIL, IconLib, 69) ; Toolbar
    IL_Add(TboxIL, IconLib, 68) ; TreeView
    IL_Add(TboxIL, IconLib, 70) ; UpDown
    IL_Add(TboxIL, IconLib, 46) ; ActiveX
    IL_Add(TboxIL, IconLib, 71) ; Custom
    IL_Add(TboxIL, "Icons\CommandLink.ico")
    LV_SetImageList(TboxIL)

    ; Toolbox items
    LV_Add("Icon1", "Button")
    LV_Add("Icon2", "CheckBox")
    LV_Add("Icon3", "ComboBox")
    LV_Add("Icon4", "Date Time Picker")
    LV_Add("Icon5", "DropDownList")
    LV_Add("Icon6", "Edit Box")
    LV_Add("Icon7", "GroupBox")
    LV_Add("Icon8", "Hotkey Box")
    LV_Add("Icon9", "Link")
    LV_Add("Icon10", "ListBox")
    LV_Add("Icon11", "ListView")
    LV_Add("Icon12", "Menu Bar")
    LV_Add("Icon13", "Month Calendar")
    LV_Add("Icon14", "Picture")
    LV_Add("Icon15", "Progress Bar")
    LV_Add("Icon16", "Radio Button")
    LV_Add("Icon17", "Separator")
    LV_Add("Icon18", "Slider")
    LV_Add("Icon19", "Status Bar")
    LV_Add("Icon20", "Tab")
    LV_Add("Icon21", "Text")
    LV_Add("Icon22", "Toolbar")
    LV_Add("Icon23", "TreeView")
    LV_Add("Icon24", "UpDown")
    LV_Add("Icon25", "ActiveX")
    LV_Add("Icon26", "Custom Class")
    If (NT6) {
        LV_Add("Icon27", "Command Link")
    }

    LV_Size := LV_CalcViewSize(hToolBox, LV_GetCount() + 1)
    ControlMove,,,,, % LV_Size.h, ahk_id %hToolBox%
}

ToolboxHandler:
    If (A_GuiEvent == "Normal") {
        Cross := False

        LV_GetText(Type, A_EventInfo)

        If (Type == "Menu Bar") {
            Gosub AddMenuBar
            Return
        }
        If (Type == "Toolbar") {
            Gosub ShowToolbarDialog
            Return
        }
        If (Type == "Status Bar") {
            AddStatusBar()
            Return
        }
        If (Type == "ActiveX") {
            ShowActiveXDialog()
            Return
        }
        If (Type == "Custom Class") {
            ShowCustomClassDialog()
            Return
        }

        If (TabEx.GetSel() > 1) {
            TabEx.SetSel(g_GuiTab)
        }

        If (WinExist("ahk_id " . hChildWnd)) {
            ShowChildWindow(4)        
        } Else {
            GoSub NewGUI        
        }

        Cross := True
    }
Return

TabHandler:
    GuiControlGet TabIndex, %A_Gui%:, %hTab%
    Tab := TabIndex

    Loop % Sci.MaxIndex() {
        If (A_Index != TabIndex) {
            Control Hide,,, % "ahk_id " . Sci[A_Index].hWnd
        }
    }
    Control Show,,, % "ahk_id " Sci[TabIndex].hWnd
    Sci[TabIndex].GrabFocus()
    GoSub AutoSize

    If (TabIndex != g_GuiTab) {
        ShowChildWindow(0)
    }

    WrapMode := Sci[TabIndex].GetWrapMode()
    SendMessage TB_CHECKBUTTON, 2160, WrapMode,, ahk_id %hEditorTB%
    If (WrapMode) {
        Menu AutoOptionsMenu, Check, &Word Wrap
    } Else {
        Menu AutoOptionsMenu, Uncheck, &Word Wrap
    }

    ReadOnly := Sci[TabIndex].GetReadOnly()
    SendMessage TB_CHECKBUTTON, 2170, ReadOnly,, ahk_id %hEditorTB%
    If (ReadOnly) {
        Menu AutoOptionsMenu, Check, &Read Only
    } Else {
        Menu AutoOptionsMenu, Uncheck, &Read Only
    }

    Styled := Sci[TabIndex].Styled
    SendMessage TB_CHECKBUTTON, 2180, Styled,, ahk_id %hEditorTB%
    If (Styled) {
        Menu AutoOptionsMenu, Check, Syntax &Highlighting
    } Else {
        Menu AutoOptionsMenu, Uncheck, Syntax &Highlighting
    }

    If (!g_GuiSB) {
        GoSub UpdateStatusBar
    }

    SetWindowTitle(Sci[TabIndex].FullFileName)
Return

CreateToolbar:
    TbarIL := IL_Create(32)
    IL_Add(TbarIL, IconLib, 6)  ; New GUI
    IL_Add(TbarIL, IconLib, 7)  ; New File
    IL_Add(TbarIL, IconLib, 9)  ; Open
    IL_Add(TbarIL, IconLib, 10) ; Save
    IL_Add(TbarIL, IconLib, 11) ; Copy to Clipboard
    IL_Add(TbarIL, IconLib, 2)  ; Editor Mode
    IL_Add(TbarIL, IconLib, 4)  ; Design Mode
    IL_Add(TbarIL, IconLib, 38) ; Show/Hide Preview Window
    IL_Add(TbarIL, IconLib, 72) ; Show Grid
    IL_Add(TbarIL, IconLib, 73) ; Snap to Grid
    IL_Add(TbarIL, IconLib, 26) ; Align Lefts
    IL_Add(TbarIL, IconLib, 27) ; Align Rights
    IL_Add(TbarIL, IconLib, 28) ; Align Tops
    IL_Add(TbarIL, IconLib, 29) ; Align Bottoms
    IL_Add(TbarIL, IconLib, 30) ; Center Horizontally
    IL_Add(TbarIL, IconLib, 31) ; Center Vertically
    IL_Add(TbarIL, IconLib, 33) ; Horizontally Space
    IL_Add(TbarIL, IconLib, 32) ; Vertically Space
    IL_Add(TbarIL, IconLib, 34) ; Make Same Width
    IL_Add(TbarIL, IconLib, 35) ; Make Same Height
    IL_Add(TbarIL, IconLib, 36) ; Make Same Size
    IL_Add(TbarIL, IconLib, 44) ; Window Cloning Tool
    IL_Add(TbarIL, IconLib, 12) ; Test
    IL_Add(TbarIL, IconLib, 25) ; Properties

    hToolbar := Toolbar_Add(hAutoWnd, "OnToolbar", "flat list tabstop tooltips", TbarIL)

    TbarButtons = 
        (LTrim
            New GUI
            -
            New File
            Open
            Save
            Copy to Clipboard
            -
            Editor Mode
            Design Mode,,,, 1060
            Show/Hide Preview Window,,,, 1070
            -
            Show Grid,,,, 1080
            Snap to Grid,,,, 1090
            -
            Align Lefts
            Align Rights
            Align Tops
            Align Bottoms
            -
            Center Horizontally
            Center Vertically
            -
            Horizontally Space
            Vertically Space
            -
            Make Same Width
            Make Same Height
            Make Same Size
            -
            Window Cloning Tool
            -
            Test,,, SHOWTEXT
            -
            Properties
        )

    Toolbar_Insert(hToolbar, TbarButtons)
Return

OnToolbar(Handle, Event, Text, Pos, Id) {
    If (Event == "hot") {
        If (GetActiveWindow() != hAutoWnd && Text != "Test") {
            Tooltip %Text%
            SetTimer RemoveToolTip, 3000
        }
        Return
    }

    If (Text = "New GUI") {
        GoSub NewGUI
    } Else If (Text = "New File") {
        GoSub NewTab
    } Else If (Text = "Open") {
        GoSub OpenFile
    } Else If (Text = "Save") {
        GoSub Save
    } Else If (Text = "Copy to Clipboard") {
        GoSub CopyToClipboard
    } Else If (Text = "Editor Mode") {
        GoSub SwitchToEditorMode
    } Else If (Text = "Show/Hide Preview Window") {
        ShowChildWindow()
    } Else If (Text = "Show Grid") {
        GoSub ToggleGrid
    } Else If (Text = "Snap to Grid") {
        GoSub ToggleSnapToGrid
    } Else If (Text = "Align Lefts") {
        GoSub AlignLefts
    } Else If (Text = "Align Rights") {
        AlignRights()
    } Else If (Text = "Align Tops") {
        AlignTops()
    } Else If (Text = "Align Bottoms") {
        AlignBottoms()
    } Else If (Text = "Center Horizontally") {
        CenterHorizontally()
    } Else If (Text = "Center Vertically") {
        CenterVertically()
    } Else If (Text = "Horizontally Space") {
        HorizontallySpace()
    } Else If (Text = "Vertically Space") {
        VerticallySpace()
    } Else If (Text = "Make Same Width") {
        MakeSame("w")
    } Else If (Text = "Make Same Height") {
        MakeSame("h")
    } Else If (Text = "Make Same Size") {
        MakeSame("wh")
    } Else If (Text = "Window Cloning Tool") {
        GoSub ShowCloneDialog
    } Else If (Text = "Test") {
        RunScript()
    } Else If (Text = "Properties") {
        GoSub ShowProperties
    }

    Tooltip
}

RemoveToolTip:
    SetTimer RemoveToolTip, Off
    ToolTip
Return

OnWM_NCMOUSEMOVE() {
    Tooltip
}

CreateEditorToolbar:
    EditorTBIL := IL_Create(30)
    IL_Add(EditorTBIL, IconLib, 6)  ; New GUI
    IL_Add(EditorTBIL, IconLib, 7)  ; New Tab
    IL_Add(EditorTBIL, IconLib, 9)  ; Open
    IL_Add(EditorTBIL, IconLib, 10) ; Save
    IL_Add(EditorTBIL, IconLib, 11) ; Copy to Clipboard
    IL_Add(EditorTBIL, IconLib, 2)  ; Editor Mode
    IL_Add(EditorTBIL, IconLib, 4)  ; Design Mode
    IL_Add(EditorTBIL, IconLib, 38) ; Show/Hide Preview Window
    IL_Add(EditorTBIL, IconLib, 15) ; Cut
    IL_Add(EditorTBIL, IconLib, 16) ; Copy
    IL_Add(EditorTBIL, IconLib, 17) ; Paste
    IL_Add(EditorTBIL, IconLib, 18) ; Delete
    IL_Add(EditorTBIL, IconLib, 81) ; Undo
    IL_Add(EditorTBIL, IconLib, 82) ; Redo
    IL_Add(EditorTBIL, IconLib, 83) ; Find
    IL_Add(EditorTBIL, IconLib, 84) ; Replace
    IL_Add(EditorTBIL, IconLib, 85) ; Word Wrap
    IL_Add(EditorTBIL, IconLib, 87) ; Read Only
    IL_Add(EditorTBIL, IconLib, 86) ; Syntax Highlighting
    IL_Add(EditorTBIL, IconLib, 88) ; Zoom In
    IL_Add(EditorTBIL, IconLib, 89) ; Zoom Out
    IL_Add(EditorTBIL, IconLib, 12) ; Test
    IL_Add(EditorTBIL, IconLib, 78) ; Help

    hEditorTB := Toolbar_Add(hAutoWnd, "OnEditorToolbar", "flat list tabstop tooltips", EditorTBIL)

    EditorTBBtns = 
    (LTrim
        New GUI
        -
        New File
        Open
        Save
        Copy to Clipboard
        -
        Editor Mode,,,, 2050
        Design Mode
        Show/Hide Preview Window
        -
        Cut
        Copy
        Paste
        Delete
        -
        Undo
        Redo
        -
        Find
        Replace
        -
        Word Wrap,,,, 2160
        Read Only,,,, 2170
        Syntax Highlighting,,,, 2180
        -
        Zoom In
        Zoom Out
        -
        Test,,, SHOWTEXT
        -
        Help
    )

    Toolbar_Insert(hEditorTB, EditorTBBtns)
    WinSet ExStyle, +0x20000, ahk_id %hEditorTB%
    ShowWindow(hEditorTB, 0)
Return

OnEditorToolbar(h, Event, Text, p, i) {
    If (Event == "hot") {
        Return
    }

    If (Text = "New GUI") {
        GoSub NewGUI
    } Else If (Text = "New File") {
        GoSub NewTab
    } Else If (Text = "Open") {
        GoSub OpenFile
    } Else If (Text = "Save") {
        GoSub Save
    } Else If (Text = "Copy to Clipboard") {
        GoSub CopyToClipboard
    } Else If (Text = "Undo") {
        GoSub SciUndo
    } Else If (Text = "Redo") {
        GoSub SciRedo
    } Else If (Text = "Design Mode") {
        GoSub SwitchToDesignMode
    } Else If (Text = "Show/Hide Preview Window") {
        ShowChildWindow()
    } Else If (Text = "Cut") {
        GoSub SciCut
    } Else If (Text = "Copy") {
        GoSub SciCopy
    } Else If (Text = "Paste") {
        GoSub SciPaste
    } Else If (Text = "Delete") {
        GoSub SciClear
    } Else If (Text = "Find") {
        GoSub ShowSearchDialog
    } Else If (Text = "Replace") {
        GoSub ShowReplaceDialog
    } Else If (Text = "Word Wrap") {
        ToggleWrapMode()
    } Else If (Text = "Read Only") {
        ToggleReadOnly()
    } Else If (Text = "Syntax Highlighting") {
        ToggleSyntaxHighlighting(TabEx.GetSel())
    } Else If (Text = "Zoom In") {
        GoSub ZoomIn
    } Else If (Text = "Zoom Out") {
        GoSub ZoomOut
    } Else If (Text = "Test") {
        RunScript()
    } Else If (Text = "Help") {
        OpenHelpFile(GetSelectedText())
    }
}

SetStatusBar() {
    Gui Auto: Default
    If (g_GuiSB) {
        SB_SetParts(162, 170, 170, 170)

        SB_SetIcon(IconLib, 75, 2) ; Position
        SB_SetIcon(IconLib, 76, 3) ; Size
        SB_SetIcon(IconLib, 77, 4) ; Cursor
        ;SB_SetIcon(IconLib,  4, 5) ; Mode

        Loop 4 {
            SB_SetText("", A_Index)
        }

        ;SB_SetText("Design Mode", 5)
    } Else {
        SB_SetParts(162, 200, 200, 62) ; Mode, Line:Pos, Status, INS, Save Encoding

        ; Remove StatusBar icons
        Loop 3 {
            SendMessage 0x040F, %A_Index%, 0, msctls_statusbar321, AutoGUI ; SB_SETICON
        }

        Loop 4 {
            SB_SetText("", A_Index)
        }

        If (Insert) {
            SB_SetText("    Insert", 4)
        } Else {
            SB_SetText("Overstrike", 4)
        }

        SB_SetText(CodePage, 5)

        ;SB_SetIcon(IconLib, 2, 1)
        ;SB_SetText("Editor Mode", 1)
        GoSub UpdateStatusBar
    }
}

NewGUI:
    If (g_GuiTab) {
        MsgBox 0x2031, AutoGUI, Only one GUI can be designed at a time. Proceed?
        IfMsgBox Cancel, {
            Return
        }

        If (Sci[g_GuiTab].FileName != "") {
            TabEx.SetIcon(g_GuiTab, 2)
        } Else {
            TabEx.SetIcon(g_GuiTab, 1)
        }
    }

    GoSub NewWindow
/*
    If (Sci[g_GuiTab].GetModify()) {
        MsgBox 0x2023, AutoGUI, Save the script before creating a new GUI?
        IfMsgBox Yes, {
            GoSub Save

            Gosub NewWindow
        }
        IfMsgBox No, {
            TabEx.SetIcon(g_GuiTab, 2)
            GoSub NewWindow
        } 
        IfMsgBox Cancel, Return
    } Else {
        Gosub NewWindow
    }
*/
Return

NewWindow:
    g.ControlList := []
    ResetMenu()
    g.Window := New g.Window
    g.Anchor := False
    Gui %Child%: Destroy
    Child++

    n := TabEx.GetSel()
    If (Sci[n].FileName == "" && !Sci[n].GetModify()) {
        g_GuiTab := n    
    } Else {
        g_GuiTab := NewTab()    
    }
    TabEx.SetIcon(g_GuiTab, 3)

    GoSub CreateChildWindow
    GenerateCode()
    SetDocumentStatus(n)
Return

CreateChildWindow:
    WinGetPos ax, ay,,, ahk_id %hAutoWnd%
    x := ax + 240
    y := ay + 120
    w := 481
    h := 381
    Title := "Window"

    Gui %Child%: New, LabelChild hWndhChildWnd Resize OwnerAuto -DPIScale
    Gui %Child%: Show, x%x% y%y% w%w% h%h%, %Title%
    SetIconEx(hChildWnd, IconLib, 4)

    g.Window.x := x
    g.Window.y := y
    g.Window.w := w
    g.Window.h := h
    g.Window.Title := Title

    CreateResizingGrippers()
Return

Class GuiClass {
    ControlList := []
    Selection := []
    ToolbarItems := ""
    ToolbarIcons := []
    ToolbarIL := ""
    ToolbarOptions := ""
    Anchor := False
    Clipboard := ""
    LastControl := 0

    Class Window {
        Title := "Window"
        x := ""
        y := ""
        w := 481
        h := 381
        Options := ""
        hWndVar := ""
        Name := ""
        Label := ""
        Style := ""
        ExStyle := ""
        FontName := ""
        FontOptions := ""
        Color := ""
        GuiClose := True
        GuiEscape := True
        GuiSize := False
        GuiContextMenu := False
        GuiDropFiles := False
        OnClipboardChange := False
        Icon := ""
        IconIndex := 1
        Center := True
        Extra := ""
    }

    Class Control {
        Handle := -1
        Class := ""
        ClassNN := ""
        Text := ""
        x := 0
        y := 0
        w := 0
        h := 0
        hWndVar := ""
        vVar := ""
        gLabel := ""
        Anchor := ""
        Options := ""
        Style := ""
        ExStyle := ""
        FontName := ""
        FontOptions := ""
    }
}

AddControl(ControlType) {
    Gui %Child%: Default

    ; ControlType is the display name in the toolbox.
    ; Type is the AHK name (except Separator, Toolbar and CommandLink)

    Type := GetControlType(ControlType)

    If Type Not In Edit,Hotkey,ListBox,ListView,TreeView
        Adding := True

    If Type Not In TreeView,Hotkey,DateTime
        Text := Default[Type].Text

    Options := Default[Type].Options
    Size := " w" . Default[Type].Width . " h" . Default[Type].Height
    Position := " x" (g_X - cxFrame) " y" (g_Y - TopBorder)

    If (Type == "Picture") {
        Icon := 0
        If (ChoosePicture(g_PicturePath, Icon)) {
            Text := g_PicturePath
            If (Icon) {
                Options := " Icon" . Icon
            }
        }

        Size := ""
    } Else If (Type == "Separator") {
        Type := "Text"
    } Else If (Type == "UpDown") {
        If (g[g.LastControl].Type != "Edit") {
            Options .= " -16"
        }
    } Else If (Type == "StatusBar") {
        Size := Position := ""
    } Else If (Type == "CommandLink") {
        Type := "Custom"
    }

    TabPos := IsInTab(g_X, g_Y)
    If (TabPos[1]) {
        Gui Tab, % TabPos[1], % TabPos[2]
    }

    _Options := ""
    If (Type == "Tab2") {
        _Options := " AltSubmit"
    } Else If (Type == "Text" || Type == "Picture") {
        _Options := " +0x100" ; SS_NOTIFY (for WM_SETCURSOR)
    }

    Gui %Child%: Add, %Type%, % "hWndhWnd " . Options . Size . Position . _Options, %Text%

    If (TabPos[1] || Type == "Tab2") {
        Gui %Child%: Tab
    }

    If (Type == "TreeView") {
        Gui %Child%: Default
        Parent := TV_Add("TreeView")
        TV_Add("Child", Parent)
    }

    g.ControlList.Insert(hWnd)
    ClassNN := GetClassNN(hWnd)
    GuiControlGet c, %Child%:Pos, %hWnd%

    If (ControlType == "Command Link") {
        Extra := ControlType
    } Else {
        Extra := ""
    }

    Register(hWnd, Type, ClassNN, Text, cx, cy, cw, ch, "", "", "", Options, "", "", "", "", TabPos, Extra)
    GenerateCode()

    Properties_AddItem(ClassNN)
    If (IsWindowVisible(hPropWnd)) {
        GoSub ShowProperties
    }

    DestroySelection()
    Return %hWnd%
}

Register(hWnd, Type, ClassNN, Text, x, y, w, h, hWndVar, vVar, gLabel, Options, Style, ExStyle, Font, Anchor, TabPos, Extra := "") {
    g[hWnd] := New g.Control
    g[hWnd].Handle := hWnd
    g[hWnd].Class := GetClassName(hWnd)
    g[hWnd].Type := Type
    g[hWnd].ClassNN := ClassNN
    g[hWnd].Text := Text
    g[hWnd].x := x
    g[hWnd].y := y
    g[hWnd].w := w
    g[hWnd].h := h
    g[hWnd].hWndVar := hWndVar
    g[hWnd].vVar := vVar
    g[hWnd].gLabel := gLabel
    g[hWnd].Options := Options
    g[hWnd].Style := Style
    g[hWnd].ExStyle := ExStyle
    g[hWnd].Font := Font
    g[hWnd].Anchor := Anchor
    g[hWnd].Tab := TabPos
    g[hWnd].Deleted := False
    g[hWnd].Extra := Extra
    g.LastControl := hWnd
    g_Control := hWnd
}

MoveControl() {
    If (Adding) {
        Return
    }

    Gui %Child%: Default

    CoordMode Mouse, Screen
    MouseGetPos mx1, my1,, g_Control, 2

    Selection := GetSelectedItems()

    For Each, Item in Grippers {
        Selection.Insert(Item)
    }

    Controls := []
    For Each, Item In Selection {
        GuiControlGet c, Pos, %Item%
        Controls.Insert({x: cx, y: cy})
    }

    While (GetKeyState("LButton", "P")) {
        MouseGetPos mx2, my2

        If (mx2 == PrevX && my2 == PrevY) {
            Continue
        }

        PrevX := mx2
        PrevY := my2

        For Index, Item In Selection {
            GuiControlGet c, Pos, % Item
            If (SnapToGrid) {
                PosX := RoundTo(Controls[Index].x + (mx2 - mx1), GridSize)
                PosY := RoundTo(Controls[Index].y + (my2 - my1), GridSize)
            } Else {
                PosX := Controls[Index].x + (mx2 - mx1)
                PosY := Controls[Index].y + (my2 - my1)
            }
            GuiControl MoveDraw, %Item%, % "x" . PosX . " " . "y" . PosY
        }

        If (g_GuiSB) {
            Gui Auto: Default
            SB_SetText("Position: " . (g[Selection[1]].x + (mx2 - mx1)) . ", " . g[Selection[1]].y + (my2 - my1), 2)
            Gui %Child%: Default
        }

        Sleep 1
    }

    If (mx2 == mx1 && my2 == my1) {
        Return
    }

    For Each, Item In Selection {
        GuiControlGet c, Pos, % Item
        g[Item].x := cx
        g[Item].y := cy
    }

    GoSub LoadProperties
    GenerateCode()
    UpdateSelection()
    Return
}

ResizeControl(hCtrl) {
    HideResizingGrippers()

    MouseGetPos mx, my
    ControlGetPos,,, w, h,, ahk_id %hCtrl%
    xOffset := w - mx
    yOffset := h - my

    Gui %Child%: Default
    Selection := GetSelectedItems()

    While (GetKeyState("LButton", "P")) {
        MouseGetPos mx, my

        h := my + yOffset
        w := mx + xOffset

        If (SnapToGrid) {
            w := RoundTo(w, GridSize)
            h := RoundTo(h, GridSize)
        }

        For Each, Item In Selection {
            GuiControl MoveDraw, %Item%, w%w% h%h%
        }

        If (g_GuiSB) {
            Gui Auto: Default
            SB_SetText("Size: " . w . " x " . h, 3)
            Gui %Child%: Default
        }

        Sleep 1
    }

    For Each, Item In Selection {
        GuiControlGet cPos, Pos, % Item
        g[Item].w := cPosW
        g[Item].h := cPosH
    }

    GoSub LoadProperties
    GenerateCode()
    UpdateSelection()
}

RemoveControl(hCtrl) {
    If (hCtrl == hChildWnd) {
        Return
    }

    If (g[hCtrl].Type == "StatusBar") {
        GuiControl Hide, %hCtrl%
        g[hCtrl].Deleted := True
        GoSub ReloadSub
        GenerateCode()
        Return
    }

    If (g[hCtrl].Type == "Tab2") {
        Gui %Child%: Tab
    }

    hParent := GetParent(hCtrl)
    If (hParent != hChildWnd) {
        hCtrl := hParent
    }

    g[hCtrl].Deleted := DestroyWindow(hCtrl)

    For Each, Item in g.ControlList {
        If (g.ControlList[A_Index] == hCtrl) {
            g.ControlList.Remove(A_Index)
            Break
        }
    }
}

GetSelectedItems() {
    If (g.Selection.MaxIndex() != "") {
        Return g.Selection
    } Else {
        If (g[g_Control].Handle == "") {
            g_Control := GetParent(g_Control)
        }
        SelectedItems := []
        SelectedItems.Insert(g_Control)
        Return SelectedItems
    }
}

CutControl(hCtrl) {
    g.Clipboard := hCtrl
    GuiControl Hide, %hCtrl%
    g[hCtrl].Deleted := True
    Menu WindowContextMenu, Enable, Paste
    GenerateCode()
    DestroySelection()
    If (hCtrl == hGrippedWnd) {
        HideResizingGrippers()
    }
}

CopyControl(hCtrl) {
    g.Clipboard := g[hCtrl].Clone()
    Menu WindowContextMenu, Enable, Paste
}

PasteControl() {
    If (g.Clipboard.HasKey("Handle")) { ; Copy
        Type := g.Clipboard.Type
        x := g_x - cxFrame
        y := g_y - TopBorder
        w := g.Clipboard.w
        h := g.Clipboard.h
        Text := g.Clipboard.Text
        Options := g.Clipboard.Options
        Style := g.Clipboard.Style
        ExStyle := g.Clipboard.ExStyle

        Gui %Child%: Add, % Type, % "hWndhWnd x" . x . " y" . Y . " w" . w . " h" . h . " " . Options, % Text
        ClassNN := GetClassNN(hWnd)
        Register(hWnd, Type, ClassNN, Text, x, y, w, h, "", "", "", Options, Style, ExStyle,"","","")
        g.ControlList.Insert(hWnd)
        Properties_AddItem(ClassNN)
    } Else { ; Cut
        g[g.Clipboard].x := g_X - cxFrame
        g[g.Clipboard].y := g_Y - TopBorder
        GuiControl Move, % g.Clipboard, % "x" . g[g.Clipboard].x . " y" . g[g.Clipboard].y
        GuiControl Show, % g.Clipboard
        g[g.Clipboard].Deleted := false
    }

    GenerateCode()
}

AddMenuBar:
    GoSub ShowMenuEditor
Return

ResetMenu() {
    m.Code := ""

    hMenu := GetMenu(hChildWnd)
    TopMenuCount := GetMenuItemCount(hMenu)
    Loop % TopMenuCount {
        hSubMenu := GetSubMenu(hMenu, A_Index - 1)
        SubMenuCount := GetMenuItemCount(hSubMenu)
        Loop % SubMenuCount {
            DeleteMenu(hSubMenu, 0)
        }
    }
    Try {
        Menu MenuBar, Delete
    }
}

AddToolbar(IL, Buttons, Options) {
    hChildToolbar := Toolbar_Add(hChildWnd, "OnToolbarDummy", Options, IL)
    Toolbar_Insert(hChildToolbar, Buttons)
}

OnToolbarDummy(Handle, Event, Text, Pid, Id) {
    If (Event = "hot") {
        Return
    }
}

DeleteToolbar:
    DestroyWindow(hChildToolbar)
    g.ToolbarIcons := []
    GenerateCode()
    Gui ToolbarDlg: Destroy
Return

AddStatusBar() {
    If (StatusBarExist()) {
        Gui %Child%: Default
        GuiControlGet SBVis, Visible, msctls_statusbar321
        GuiControl Hide%SBVis%, msctls_statusbar321
        GuiControlGet hStatusBar, Hwnd, msctls_statusbar321
        g[hStatusBar].Deleted := SBVis
        GenerateCode()
        GoSub ReloadSub
    } Else {
        AddControl("Status Bar")
    }
}

StatusBarExist() {
    GuiControlGet SBExist, %Child%: hWnd, msctls_statusbar321
    Return SBExist
}

MenuBarExist() {
    Return GetMenu(hCHildWnd)
}

ToolbarExist() {
    Return IsWindow(hChildToolbar)
}

Select(SelectedControls) {
    If (SelectedControls.MaxIndex() == "") {
        Return
    }

    If (!WinExist("ahk_id " . hSelWnd)) {
        Gui New, hWndhSelWnd ToolWindow -Border -Caption +E0x20 +OwnerAuto +LastFound -DPIScale
        Gui %hSelWnd%: Color, 0xF0F0F0
        WinSet TransColor, 0xF0F0F0 100
        WinGetPos wX, wY, wW, wH, ahk_id %hChildWnd%
        Gui %hSelWnd%: Show, % "NA x" . wX . " y" . wY . " w" . wW . " h" . wH
    }

    For Each, Item In SelectedControls {
        ControlGetPos cX, cY, cW, cH,, ahk_id %Item%
        Gui %hSelWnd%: Add, Progress, c1BCDEF x%cX% y%cY% w%cW% h%cH%, 100
    }
}

SelectAll:
    g.Selection := []
    For Each, Item In g.ControlList {
        If (g[Item].Deleted == False) {
            g.Selection.Insert(Item)
        }
    }
    Select(g.Selection)
Return

SelectTabItems(hTabControl) {
    g.Selection.Insert(hTabControl)
    ControlGetPos tx, ty, tw, th,, ahk_id %hTabControl%
    TabItems := GetControlsFromRegion(tx + 1, ty + 1, (tx + tw), (ty + th))
    For Each, Item In TabItems {
        g.Selection.Insert(Item)
    }
    Select(g.Selection)
}

DestroySelection() {
    DestroyWindow(hSelWnd)
    g.Selection := []
}

UpdateSelection() {
    DestroyWindow(hSelWnd)
    Select(g.Selection)
}

GetControlsFromRegion(x1, y1, x2, y2) {
    ControlsFromRegion := []

    If (x1 > x2) { ; Selection is from right to left
        x1 ^= x2, x2 ^= x1, x1 ^= x2
    }

    If (y1 > y2) { ; Selection is from bottom to top
        y1 ^= y2, y2 ^= y1, y1 ^= y2
    }

    WinGet Children, ControlListHwnd, ahk_id %hChildWnd%
    Loop Parse, Children, `n
    {
        If (g[A_LoopField].Class == "") {
            Continue
        }

        ControlGetPos CtrlX, CtrlY,,,, ahk_id %A_LoopField%

        If (IfBetween(CtrlX, x1, x2) And (IfBetween(CtrlY, y1, y2))) {
            ControlsFromRegion.Insert(A_LoopField)
        }
    }

    Return ControlsFromRegion
}

IsInTab(x, y) {
    TabControls := []
    WinGet Controls, ControlList, ahk_id %hChildWnd%
    Loop Parse, Controls, `n
    {
        If (InStr(A_LoopField, "Tab")) {
            TabControls.Insert(A_LoopField)
        }
    }

    For TabControl, Item In TabControls {
        ControlGetPos tx, ty, tw, th, %Item%, ahk_id %hChildWnd%
        If (IfBetween(x, tx, (tx + tw)) && (IfBetween(y, (ty + 1), (ty + th)))) {
            GuiControlGet TabIndex, %Child%:, %Item%
            Return [TabIndex, TabControl]
        }
    }
}

OrderTabItems() {
    TabControls := []
    TabItems := []
    Items := []

    For Index, Item In g.ControlList {
        If (g[Item].Type == "Tab2") {
            TabControls.Insert(Item)
        } Else If (g[Item].Tab[1] != "") {
            TabItems[g[Item].Tab[2], g[Item].Tab[1], Index] := Item
        } Else {
            Items.Insert(Item)
        }
    }

    OrderedList := []
    For i, TabControl In TabControls {
        OrderedList.Insert(TabControl)
        For j, TabPage In TabItems[i] {
            For k, TabItem In TabItems[i][j] {
                OrderedList.Insert(TabItems[i][j][k])
            }
        }
    }

    g.ControlList := Items

    For Each, Item In OrderedList {
        g.ControlList.Insert(Item)
    }
}

DeleteSelectedControls() {
    DeleteSelectedControls:
    Selection := GetSelectedItems()

    For Each, Item In Selection {
        RemoveControl(Item)
        If (Item == hGrippedWnd) {
            HideResizingGrippers()
        }
    }

    GoSub ReloadSub
    GenerateCode()
    g.Selection := []
    DestroySelection()
    Return
}

DestroyAllControls() {
    HideResizingGrippers()
    WinGet ControlList, ControlListHwnd, ahk_id %hChildWnd%
    Loop Parse, ControlList, `n
    {
        If (GetClassName(A_LoopField) == "msctls_statusbar32") {
            hStatusBar := GetHandle("msctls_statusbar321")
            GuiControl %Child%: Hide, %hStatusBar%
            g.ControlList.Insert(hStatusBar)
            g[hStatusBar].Deleted := True
            Continue
        }
        If (!IsGripper(A_LoopField)) {
            DestroyWindow(A_LoopField)
        }
    }
}

AlignTops:
AlignLefts:
AlignRights:
AlignBottoms:
HorizontallySpace:
VerticallySpace:
    %A_ThisLabel%()
Return

AlignLefts() {
    Gui %Child%: Default
    GuiControlGet p, Pos, % g.Selection[1]
    For Each, Item In g.Selection {
        GuiControl Move, % Item, % "x" . px
        g[Item].x := px
    }
    GenerateCode()
    UpdateSelection()
    HideResizingGrippers()
}

AlignRights() {
    Gui %Child%: Default
    GuiControlGet p, Pos, % g.Selection[1]
    For Each, Item In g.Selection {
        ControlGetPos,,, w,,, ahk_id %Item%
        x := (px + pw) - w
        GuiControl Move, % Item, % "x" . x
        g[Item].x := x
    }
    GenerateCode()
    UpdateSelection()
    HideResizingGrippers()
}

AlignTops() {
    Gui %Child%: Default
    GuiControlGet p, Pos, % g.Selection[1]
    For Each, Item In g.Selection {
        GuiControl Move, % Item, % "y" . py
        g[Item].y := py
    }
    GenerateCode()
    UpdateSelection()
    HideResizingGrippers()
}

AlignBottoms() {
    Gui %Child%: Default
    GuiControlGet p, Pos, % g.Selection[1]
    For Each, Item In g.Selection {
        ControlGetPos, ,,, h,, ahk_id %Item%
        y := (py + ph) - h
        GuiControl Move, % Item, % "y" . y
        g[Item].y := y
    }
    GenerateCode()
    UpdateSelection()
    HideResizingGrippers()
}

CenterHorizontally() {
    CenterHorizontally:
    WinGetPos,,, ww,, ahk_id %hChildWnd%

    Selection := GetSelectedItems()

    If (Selection.MaxIndex() > 1) {
        x1 := 100000
        For Each, Item In Selection {
            ControlGetPos cx,,,,, ahk_id %Item%
            If (cx < x1) {
                x1 := cx
            }
        }
        x2 := 0
        For Each, Item In Selection {
            ControlGetPos cx,, cw,,, ahk_id %Item%
            If ((cx + cw) > x2) {
                x2 := cx + cw
            }
        }
        cw := x1 + x2
    } Else {
        ControlGetPos,,, cw,,, % "ahk_id " . Selection[1]
    }

    ww -= cw
    ww /= 2

    If (Selection.MaxIndex() > 1) {
        For Each, Item In Selection {
            ControlGetPos, cx,,,,, ahk_id %Item%
            ControlMove,, % ww + cx,,,, ahk_id %Item%
        }
    } Else {
        ControlMove,, % ww,,,, % "ahk_id " . Selection[1]
    }

    Repaint(hChildWnd)
    GoSub LoadProperties
    GenerateCode()
    UpdateSelection()
    HideResizingGrippers()
    Return
}

CenterVertically:
    CenterVertically()
Return

CenterVertically() {
    GetWindowSize(hChildWnd, wx, wy, ww, wh)
    Gui %Child%: Default

    Selection := GetSelectedItems()

    If (Selection.MaxIndex() > 1) {
        Min := 100000
        For Each, Item In Selection {
            GuiControlGet c, Pos, %Item%
            If (cy < Min) {
                Min := cy
            }
        }
        Max := 0
        For Each, Item In Selection {
            GuiControlGet c, Pos, %Item%
            If ((cy + ch) > Max) {
                Max := cy + ch
            }
        }
        ch := Min + Max
    } Else {
        GuiControlGet c, Pos, % Selection[1]
    }

    wh := (wh - ch) / 2

    If (Selection.MaxIndex() > 1) {
        For Each, Item In Selection {
            GuiControlGet c, Pos, %Item%
            GuiControl Move, %Item%, % "y" . (wh + cy)
        }
    } Else {
        GuiControl Move, % Selection[1], y%wh%
    }

    Repaint(hChildWnd)
    GoSub LoadProperties
    GenerateCode()
    UpdateSelection()
    HideResizingGrippers()
}

HorizontallySpace() {
    Gui %Child%: Default
    MaxIndex := g.Selection.MaxIndex()

    Start := 100000, End := 0, ControlList := ""
    For Index, Item in g.Selection {
        ControlGetPos, x,, w,,, ahk_id %Item%
        If ((x + w) < Start) {
            Start := x + w
            FirstItem := Item
        }
        If (x > End) {
            End := x
            LastItem := Item
        }
        ControlList .= (Index != MaxIndex) ? Item . "|" : Item
    }

    InternalWidth := End - Start
    InternalItemsWidth := 0
    For Each, Item in g.Selection {
        If ((Item != FirstItem) && (Item != LastItem)) {
            ControlGetPos,,, w,,, ahk_id %Item%
            InternalItemsWidth += w
        }
    }
    EmptySpace := InternalWidth - InternalItemsWidth
    Quotient := EmptySpace // (MaxIndex - 1)

    Sort ControlList, D| F SortByX
    Controls := []
    Loop Parse, ControlList, `|
    {
        Controls.Insert(A_LoopField)
    }

    For Index, Control in Controls {
        If ((Index != 1) && (Index != MaxIndex)) {
            GuiControlGet p, Pos, % Controls[(Index - 1)]
            GuiControl MoveDraw, % Control, % "x" . (px + pw) + Quotient
        }
    }

    GenerateCode()
    UpdateSelection()
    HideResizingGrippers()
}

VerticallySpace() {
    Gui %Child%: Default
    MaxIndex := g.Selection.MaxIndex()

    Start := 100000, End := 0, ControlList := ""
    For Index, Item in g.Selection {
        ControlGetPos,, y,, h,, ahk_id %Item%
        If ((y + h) < Start) {
            Start := y + h
            FirstItem := Item
        }
        If (y > End) {
            End := y
            LastItem := Item
        }
        ControlList .= (Index != MaxIndex) ? Item . "|" : Item
    }

    InternalHeight := End - Start
    InternalItemsHeight := 0
    For Each, Item in g.Selection {
        If ((Item != FirstItem) && (Item != LastItem)) {
            ControlGetPos,,,, h,, ahk_id %Item%
            InternalItemsHeight += h
        }
    }
    EmptySpace := InternalHeight - InternalItemsHeight
    Quotient := EmptySpace // (MaxIndex - 1)

    Sort ControlList, D| F SortByY
    Controls := []
    Loop Parse, ControlList, `|
    {
        Controls.Insert(A_LoopField)
    }

    For Index, Control in Controls {
        If ((Index != 1) && (Index != MaxIndex)) {
            GuiControlGet p, Pos, % Controls[(Index - 1)]
            GuiControl MoveDraw, % Control, % "y" . (py + ph) + Quotient
        }
    }

    GenerateCode()
    UpdateSelection()
    HideResizingGrippers()
}

SortByX(hCtrl1, hCtrl2) {
    ControlGetPos, x1,,,,, ahk_id %hCtrl1%
    ControlGetPos, x2,,,,, ahk_id %hCtrl2%
    Return (x1 > x2) ? 1 : 0
}

SortByY(hCtrl1, hCtrl2) {
    ControlGetPos,, y1,,,, ahk_id %hCtrl1%
    ControlGetPos,, y2,,,, ahk_id %hCtrl2%
    Return (y1 > y2) ? 1 : 0
}

MakeSameWidth:
    MakeSame("w")
Return

MakeSameHeight:
    MakeSame("h")
Return

MakeSameSize:
    MakeSame("wh")
Return

MakeSame(m) {
    Gui %Child%: Default
    ControlGetPos,,, w, h,, % "ahk_id " . g.Selection[1]
    Expression := ""
    If (InStr(m, "w")) {
        Expression .= "w" . w
    }
    If (InStr(m, "h")) {
        Expression .= "h" . h
    }
    For Each, Item In g.Selection {
        GuiControl Move, % Item, % Expression
    }
    GenerateCode()
    UpdateSelection()
    HideResizingGrippers()
}

ShowAdjustPositionDialog:
    GuiControlGet p, %Child%: Pos, %g_Control%

    Gui Adjust: New, LabelAdjust -MinimizeBox OwnerAuto
    Gui Adjust: Default
    Gui Add, GroupBox, x6 y6 w192 h102, Position
    Gui Add, Text, x19 y41 w12 h13, &X:
    Gui Add, Edit, vEdtX x34 y36 w50 h21 
    Gui Add, UpDown, gAdjustPos x76 y36 w18 h21 Range-65536-65536, %px%
    Gui Add, Text, x103 y41 w12 h13, &Y:
    Gui Add, Edit, vEdtY x118 y36 w50 h21
    Gui Add, UpDown, gAdjustPos x160 y36 w18 h21 Range-65536-65536, %py%
    Gui Add, Text, x18 y76 w15 h13, &W:
    Gui Add, Edit, vEdtW x34 y71 w50 h21
    Gui Add, UpDown, gAdjustPos x76 y71 w18 h21 Range-65536-65536, %pw%
    Gui Add, Text, x103 y76 w12 h13, &H:
    Gui Add, Edit, vEdtH x118 y71 w50 h21
    Gui Add, UpDown, gAdjustPos x160 y71 w18 h21 Range-65536-65536, %ph%
    Gui Add, Button, gAdjustPos x217 y6 w75 h23 Default, &Adjust
    Gui Add, Button, gAdjustClose x217 y34 w75 h23, &Close
    Gui Add, Button, gAdjustReset x217 y84 w75 h23, &Reset
    Gui Adjust: Show, w302 h119, Adjust Control Position
    SetIconEx(WinExist("A"), IconLib, 74)
    SetModalWindow(True)
Return

AdjustPos:
    Gui Adjust: Submit, NoHide
    GuiControl %Child%: MoveDraw, % g_Control, x%EdtX% y%EdtY% w%EdtW% h%EdtH%
    HideResizingGrippers()
Return

AdjustReset:
    Gui Adjust: Default
    GuiControl,, EdtX, %px%
    GuiControl,, EdtY, %py%
    GuiControl,, EdtW, %pw%
    GuiControl,, EdtH, %ph%
    GoSub AdjustPos
Return

AdjustClose:
    Gui Adjust: Submit, NoHide
    
    g[g_Control].x := EdtX
    g[g_Control].y := EdtY
    g[g_Control].w := EdtW
    g[g_Control].h := EdtH
    GenerateCode()

    If (IsWindowVisible(hPropWnd)) {
        GoSub ShowProperties
    }
AdjustEscape:
    SetModalWindow(False)
    Gui Adjust: Destroy
Return

Cut:
    CutControl(g_Control)
Return

Copy:
    CopyControl(g_Control)
Return

Paste:
    PasteControl()
Return

ChangeTitle:
    SetModalWindow(True)

    NewTitle := InputBoxEx("Window Title", "", "Change Title", g.Window.Title,,,,,, hAutoWnd, IconLib, 37)

    If (!ErrorLevel) {
        WinSetTitle ahk_id %hChildWnd%,, %NewTitle%
        g.Window.Title := EscapeChars(NewTitle)
        GenerateCode()
    
        If (Properties_GetClassNN() == "Window") {
            GuiControl, Properties:, EdtText, %NewTitle%
        }
    }

    SetModalWindow(False)
Return

ChangeText:
    ControlType := g[g_Control].Type

    If (ControlType ~= "TreeView|ActiveX") {
        MsgBox 0x2040, Change Text, Not available for %ControlType%.
        Return
    } Else If (ControlType == "Picture") {
        ImagePath    := g[g_Control].Text
        ImageOptions := g[g_Control].Options
        ImageType    := RegExMatch(ImageOptions, "i)Icon(\d+)", IconIndex)

        If (ChoosePicture(ImagePath, IconIndex, ImageType)) {
            g[g_Control].Text := ImagePath

            If (ImageType) {
                If (InStr(ImageOptions, "Icon")) {
                   g[g_Control].Options := RegExReplace(ImageOptions, "Icon\d+", "Icon" . IconIndex)
                } Else {
                    g[g_Control].Options .= Space(ImageOptions) . "Icon" . IconIndex
                }
            } Else {
                g[g_Control].Options := RegExReplace(ImageOptions, "Icon\d+")
            }

            Icon := (ImageType) ? "*Icon" . IconIndex . " " : ""
            GuiControl %Child%:, %g_Control%, % Icon . ImagePath
            GenerateCode()
        }
        Return
    }

    hParent := GetParent(g_Control)
    If (g[hParent].Type == "ComboBox") {
        g_Control := hParent
    }

    Instruction := Default[ControlType].DisplayName . " Text"
    Content := ""
    PreDefItems := g[g_Control].Text
    InputControl := "Edit"
    InputOptions := ""

    If (ControlType == "Text") {
        Instruction := "Text:"

    } Else If (ControlType ~= "ComboBox|DropDownList|ListBox") {
        Instruction := ControlType . " Items"
        Content := "Pipe-delimited list of items. To have one of the entries pre-selected, include two pipes after it (e.g. Red|Green||Blue)."

    } Else If (ControlType == "ListView") {
        Instruction := "ListView Columns"
        Content := "Pipe-delimited list of column names (e.g. ID|Name|Value):"

    } Else If (ControlType == "Tab2") {
        Instruction := "Tabs"
        Content := "Separate each tab item with a pipe character (|)."

    } Else If (ControlType ~= "Progress|Slider|UpDown") {
        Instruction := Default[ControlType].DisplayName . " Position"

    } Else If (ControlType == "Hotkey") {
        Instruction := "Hotkey"
        Content := "Modifiers: ^ = Control, + = Shift, ! = Alt.`nSee the <a href=""https://autohotkey.com/docs/KeyList.htm"">key list</a> for available key names."

    } Else If (ControlType == "DateTime") {
        Instruction := "Date Time Picker"
        Content := "Format: (e.g.: LongDate, Time, dd-MM-yyyy)"
        InputControl := "ComboBox"
        PreDefItems := "LongDate|Time"

    } Else If (ControlType == "MonthCal") {
        Instruction := "Month Calendar"
        Content := "To have a date other than today pre-selected, specify it in YYYYMMDD format."

    } Else If (g[g_Control].Extra == "Command Link") {
        Instruction := "Command Link Text"
        InputOptions := "r2 Multi"
    }

    SetModalWindow(True)

    NewText := InputBoxEx(Instruction
        , Content
        , "Change Text"
        , PreDefItems
        , InputControl
        , InputOptions
        , 430
        , "", ""
        , hAutoWnd
        , IconLib, 14)

    If (!ErrorLevel) {
        SetControlText(g_Control, NewText)
        GenerateCode()
    }

    SetModalWindow(False)
Return

SetControlText(hWnd, Text) {
    If (g[hWnd].Type == "Button" && Text = "...") {
        GuiControl %Child%: Move, %hWnd%, w23 h23
        g[hWnd].w := 23
        g[hWnd].h := 23
    }

    If (g[hWnd].Type == "ListView") {
        Gui %Child%: Default
        While (LV_GetText(foo, 0, 1)) {
            LV_DeleteCol(1)
        }
        Loop Parse, Text, |
        {
            LV_InsertCol(A_Index, "AutoHdr", A_LoopField)
        }
        LV_ModifyCol(1, "AutoHdr")
    } Else If (g[hWnd].Type ~= "Tab2|ListBox") {
        GuiControl %Child%:, %hWnd%, |%Text%
    } Else If (g[hWnd].Type == "DateTime") {
        If (Text == "") { ; Short date
            WinSet Style, 0x5201000C, ahk_id %hWnd%
        } Else If (Text == "LongDate") {
            WinSet Style, 0x52010004, ahk_id %hWnd%
        } Else If (Text == "Time") {
            WinSet Style, 0x52010009, ahk_id %hWnd%
        }
    } Else {
        GuiControl %Child%:, %hWnd%, %Text%
    }

    If (Properties_GetClassNN() == g[hWnd].ClassNN) {
        GuiControl, Properties:, EdtText, %Text%
    }

    g[hWnd].Text := EscapeChars(Text)
}

EscapeChars(String) {
    StringReplace String, String, ``, ````, A
    StringReplace String, String, `n, ``n, A
    StringReplace String, String, `t, ``t, A
    StringReplace String, String, `%, ```%, A
    StringReplace String, String, `;, ```;, A
    StringReplace String, String, `,, ```,, A
    Return String
}

ChoosePicture(ByRef ImagePath, ByRef IconIndex, ByRef ImageType := 0) {
    If (!ImageType) {
        Filter := "*.jpg; *.png; *.gif; *.bmp; *.ico; *.icl; *.exe; *.dll; *.cpl; *.jpeg"
        Gui Auto: +OwnDialogs
        FileSelectFile SelectedFile, 1, %ImagePath%, Select Picture File, Picture Files (%Filter%)
        If (ErrorLevel) {
            Return
        }

        SplitPath SelectedFile,,, FileExt
        If (FileExt ~= "i)exe|dll|cpl|icl|scr|ocx|ax") {
            ImagePath := SelectedFile
            ImageType := 1
        } Else {
            ImagePath := SelectedFile
        }
    }

    If (ImageType) {
        If (ChooseIcon(ImagePath, IconIndex, hAutoWnd)) {
            ImagePath := IconPath := StrReplace(ImagePath, A_WinDir . "\System32\")
        } Else {
            Return
        }
    }

    Return 1
}

ShowActiveXDialog() {
    ActiveXComponent := InputBoxEx("ActiveX Component"
        , "Enter the identifier of an ActiveX object that can be embedded in a window.`nA folder path or an Internet address is loaded in Explorer."
        , "ActiveX"
        , "Shell.Explorer|C:\|HTMLFile|about:<html></html>|www.autohotkey.com|WMPlayer.OCX"
        , "ComboBox"
        , ""
        , 430
        , "", ""
        , hAutoWnd
        , IconLib, 46)

    If (!ErrorLevel) {
        Default["ActiveX"].Text := ActiveXComponent

        Cross := True
    }
}

ShowCustomClassDialog() {
    ClassName := InputBoxEx("Win32 Control Class Name"
        , "Enter the name of a registered Win32 control class."
        , "Custom Class"
        , "Button|ComboBoxEx32|ReBarWindow32|ScrollBar|SysAnimate32|SysPager"
        , "ComboBox"
        , ""
        , 430, "", ""
        , hAutoWnd
        , IconLib, 71)

    If (!ErrorLevel) {
        Default["Custom"].Options := "Class" . ClassName
    
        If (ClassName == "ComboBoxEx32") {
            Default["Custom"].Options .= " +0x3"
        } Else If (ClassName == "SysPager") {
            Default["Custom"].Options .= " +E0x20000"
        }
    
        Cross := True
    }
}

ToggleGrid:
    ShowGrid := !ShowGrid
    Brush := False
    Repaint(hChildWnd)
    SendMessage TB_CHECKBUTTON, 1080, %ShowGrid%,, ahk_id %hToolbar%
    Menu AutoOptionsMenu, ToggleCheck, Show &Grid
Return

ToggleSnapToGrid:
    SnapToGrid := !SnapToGrid
    If (SnapToGrid) {
        Menu AutoOptionsMenu, Check, S&nap To Grid
    } Else {
        Menu AutoOptionsMenu, Uncheck, S&nap To Grid
    }
    SendMessage TB_CHECKBUTTON, 1090, %SnapToGrid%,, ahk_id %hToolbar%
Return

Repaint(hWnd) {
    WinSet Redraw,, ahk_id %hWnd%
}

RedrawWindow:
    WinSet Redraw,, ahk_id %hChildWnd%
    WinSet Redraw,, ahk_id %hAutoWnd%
Return

; Message handling

AutoSize:
    If (A_EventInfo == 1) { ; The window has been minimized.
        Return
    }

    ControlGetPos, TbxX, TbxY,,,, ahk_id %hToolbox%
    ControlGetPos, TabX, TabY,,,, ahk_id %hTab%
    WinGetPos,,, ww, wh, ahk_id %hAutoWnd%
    ControlMove,,,, % ww,, ahk_id %hToolbar%
    ControlMove,,,, % ww,, ahk_id %hEditorTB%
    ControlMove,,,,, % wh - TbxY - 35, ahk_id %hToolbox%
    ControlMove,,,, % ww - TabX - cxFrame - 2, % wh - TabY - 34, ahk_id %hTab%
    Loop % Sci.MaxIndex() {
        ControlMove,,,, % ww - TabX - cxFrame - 13, % wh - TabY - 68, % "ahk_id " Sci[A_Index].hWnd
    }

    ControlGet ToolBoxStyle, Style,,, ahk_id %hToolBox%
    If (ToolBoxStyle & 0x100000) { ; WS_HSCROLL
        Gui ListView, SysListView322
        LV_ModifyCol(1, (LV_GetColumnWidth(hToolBox, 1) - cxVScroll))
    }
Return

AutoDropFiles:
    Files := StrSplit(A_GuiEvent, "`n")
    Open(Files)
Return

AutoClose:
    IL_Destroy(TabExIL)
    SaveSettings()
    ExitApp
Return

ChildSize:
    If (A_EventInfo == 1) { ; The window has been minimized.
        ShowChildWindow(0)
        Return
    }

    If (g_GuiSB) {
        Gui Auto: Default
        SB_SetText("Size: " . A_GuiWidth . " x " . A_GuiHeight, 3)
    }
Return

ChildEscape:
ChildClose:
    ShowChildWindow(0)
Return

OnWM_CTLCOLORDLG(wParam, lParam, msg, hWnd) {
    Static Brush := 0

    If (A_Gui != Child || !ShowGrid) {
        Return
    }

    If (!Brush) {
        Brush := DllCall("Gdi32.dll\CreatePatternBrush", "UInt", hTile)
    }

    Return Brush
}

OnWM_MOVE(wParam, lParam, msg, hWnd) {
    If (hWnd != hChildWnd) {
        Return
    }

    WinGetPos wx, wy,,, ahk_id %hChildWnd%

    If (WinExist("ahk_id " . hSelWnd)) {
        WinMove ahk_id %hSelWnd%,, %wx%, %wy%
    }

    Gui Auto: Default
    SB_SetText("Position: " . wx . ", " . wy, 2)
/*
    If (IsWindowActive(hChildWnd)) {
        Gui Auto: Default
        SB_SetText("Position: " . wx . ", " . wy, 2)
    }
*/
}

OnWM_EXITSIZEMOVE(wParam, lParam, msg, hWnd) {
    If (hWnd == hChildWnd) {
        GetWindowSize(hChildWnd, wx, wy, ww, wh)

        If (ww != g.Window.w || wh != g.Window.h) {
            g.Window.x := wx
            g.Window.y := wy
            g.Window.w := ww
            g.Window.h := wh
            GenerateCode()
        }

        If (Properties_GetClassNN() == "Window") {
            g.Window.x := wx
            g.Window.y := wy
            g.Window.w := ww
            g.Window.h := wh
            GoSub LoadProperties
        }

        If (ToolbarExist()) {
            Repaint(hChildWnd)
        }
    }
}

OnWM_MOUSEMOVE(wParam, lParam, msg, hWnd) {
    Static hPrevCtrl := 0

    If (GetActiveWindow() != hAutoWnd && hWnd != hToolbar) {
        Tooltip
    }

    MouseGetPos x1, y1, hWindow, hControl, 2
    If (hControl == "") {
        hControl := hWindow
    }

    ; Update status bar info
    If (g_GuiSB) {
        If ((hControl != hPrevCtrl) ) {
            PosX := 0
            If (hControl != hChildWnd) {
                GuiControlGet Pos, Pos, %hControl%
                MouseGetPos,,,, ClassNN

                Gui Auto: Default
                SB_SetText(ClassNN, 5)
                If (PosX) {
                    SB_SetText("Position: " . PosX . ", " . PosY, 2)
                    SB_SetText("Size: " . PosW . " x " . PosH, 3)
                }
            } Else {
                WinGetTitle WinTitle, ahk_id %hWindow%
                w := GetWindowInfo(hWindow)
                wx := w.rcWindow.left
                wy := w.rcWindow.top
                ww := w.rcClient.right - w.rcClient.left
                wh := w.rcClient.bottom - w.rcClient.top

                Gui Auto: Default
                SB_SetText("AutoHotkeyGUI", 5)
                SB_SetText("Position: " . wx . ", " . wy, 2)
                SB_SetText("Size: " . ww . " x " . wh, 3)
            }

            hPrevCtrl := hControl
        }
    }

    If (g_GuiSB) {
        mx := lParam & 0xFFFF
        my := lParam >> 16
        Gui Auto: Default
        SB_SetText("Cursor: " . mx . ", " . my, 4)
    }

    If (hWnd == hChildWnd && Cross) {
        DllCall("SetCursor", "UInt", hCross)
    }

    If (hWindow != hChildWnd) {
        Return
    }

    LButtonP := GetKeyState("LButton", "P")

    If (LButtonP && IsGripper(hControl)) {
        OnResize(hControl)
    } Else If (LButtonP && !(GetKeyState("LCtrl", "P"))) {
        If (hControl == hChildWnd) {
            DestroyWindow(hSelWnd)
            WinGetPos wx, wy, ww, wh, ahk_id %hChildWnd%
            ; Translucid selection rectangle (based on Maestrith's GUI Creator)
            Gui SelRect: New, LabelSelRect hWndhSelRect -Caption AlwaysOnTop ToolWindow
            Gui SelRect: Color, 1BCDEF
            WinSet Transparent, 40, ahk_id %hSelRect%
            Gui SelRect: Show, x%wx% y%wy% w%ww% h%wh% NoActivate Hide
            Gui SelRect: Show, NoActivate

            While GetKeyState("LButton", "P") {
                MouseGetPos x2, y2
                WinSet Region, %x1%-%y1% %x2%-%y1% %x2%-%y2% %x1%-%y2% %x1%-%y1%, ahk_id %hSelRect%
            }
            Gui SelRect: Destroy

            g.Selection := GetControlsFromRegion(x1, y1, x2, y2)
            Select(g.Selection)
        } Else {
            If (GetKeyState("LShift", "P")) {
                DestroyWindow(hSelWnd)
                ResizeControl(hControl)
            } Else {
                DestroyWindow(hSelWnd)
                MoveControl()
                Select(g.Selection)
            }
        }
    }
}

OnWM_LBUTTONDOWN(wParam, lParam, msg, hWnd) {
    If (GetClassName(hWnd) == "Scintilla") {
        ShowChildWindow(0)
    }

    If (GetActiveWindow() != hChildWnd) {
        Return
    }

    If (IsGripper(hWnd)) {
        Return
    }

    MouseGetPos,,, hGui, g_Control, 2

    CtrlP := GetKeyState("Ctrl", "P")

    If (Cross) {
        If (!CtrlP) {
            Cross := False
        }

        g_X := (lParam & 0xFFFF) + cxFrame
        g_Y := (lParam >> 16) + TopBorder

        Gui Auto: Default
        RowNumber := LV_GetNext()
        LV_GetText(Type, RowNumber)
        If (Type != "Toolbox") {
            AddControl(Type)
        }

        Return
    }

    If (g_Control == "") {
        DestroyWindow(hSelWnd)
        HideResizingGrippers()
        If (IsWindowVisible(hPropWnd)) {
            GoSub ShowProperties
        }
        Return
    } Else {
        ShowResizingGrippers()
    }

    If (CtrlP) {
        fSelect := True
        Loop % g.Selection.MaxIndex() {
            If (g_Control == g.Selection[A_Index]) {
                g.Selection.Remove(A_Index)
                fSelect := False
                Break
            }
        }
        If (fSelect) {
            If (g[g_Control].Type == "Tab2") {
                SelectTabItems(g_Control)
            } Else {
                g.Selection.Insert(g_Control)
                Select([g_Control])
            }
        } Else {
            UpdateSelection()
        }
    } Else {
        DestroyWindow(hSelWnd)

        If (g_Control != "" && g[g_Control].ClassNN == "") {
            g_Control := GetParent(g_Control)
        }

        If (IsWindowVisible(hPropWnd)) {
            GoSub ShowProperties
        }
    }

    If (g[g_Control].Type == "Tab2") {
        Return
    }

    Return 0
}

OnWM_LBUTTONDBLCLK(wParam, lParam, msg, hWnd) {
    If (hWnd == hAutoWnd) {
        NewTab()
        Return
    }

    If (GetActiveWindow() != hChildWnd) {
        Return
    }

    MouseGetPos,,,, g_Control, 2
    If (g_Control == "") {
        GoSub ChangeTitle
    } Else If (g_Control == hChildToolbar){
        GoSub ShowToolbarDialog
    } Else {
        GoSub ChangeText
    }

    Return 0
}

OnWM_MBUTTONDOWN(wParam, lParam, msg, hWnd) {
    MouseGetPos,,, hGui, g_Control, 2

    If (hGui != hChildWnd) {
        If (hWnd == hTab) {
            VarSetCapacity(TCHITTESTINFO, 16)
            NumPut(lParam & 0xFFFF, TCHITTESTINFO, 0)
            NumPut(lParam >> 16, TCHITTESTINFO, 4)
            NumPut(6, HITTESTINFO, 8) ; 6 = TCHT_ONITEM
            SendMessage 0x130D, 0, &TCHITTESTINFO,, ahk_id %hTab% ; TCM_HITTEST
            CloseTab(ErrorLevel + 1)
            Return
        } Else {
            Return
        }
    }

    If (g_Control != "" && g[g_Control].ClassNN == "") {
        g_Control := GetParent(g_Control) ; For ComboBox and ActiveX
    }

    GoSub ShowProperties
    Return 0
}

OnWM_RBUTTONDOWN(wParam, lParam, msg, hWnd) {
    g_X := (lParam & 0xFFFF) + cxFrame
    g_Y := (lParam >> 16) + TopBorder

    If (hWnd == hChildToolbar) {
        Menu ChildToolbarMenu, Add, Edit, ShowToolbarDialog
        Menu ChildToolbarMenu, Add, Delete, DeleteToolbar
        Menu ChildToolbarMenu, Show
        Return
    }

    MouseGetPos,,, g_Gui, g_Control, 2
    If (g_Gui != hChildWnd) {
        If (hWnd == hTab) {
            VarSetCapacity(TCHITTESTINFO, 16)
            NumPut(lParam & 0xFFFF, TCHITTESTINFO, 0)
            NumPut(lParam >> 16, TCHITTESTINFO, 4)
            NumPut(6, HITTESTINFO, 8) ; ; 6 = TCHT_ONITEM
            SendMessage 0x130D, 0, &TCHITTESTINFO,, ahk_id %hTab% ; TCM_HITTEST
            g_TabIndex := ErrorLevel + 1
            ShowTabContextMenu()
            Return
        } Else {
            Return
        }
    }

    If (g[g_Control].Type == "Tab2") {
        VarSetCapacity(RECT, 16, 0)
        DllCall("GetClientRect", "Ptr", g_Control, "Ptr", &RECT)
        SendMessage 0x1328, 0, &RECT,, % "ahk_id" . g_Control ; TCM_ADJUSTRECT
        tiy := NumGet(RECT, 4, "Int")
        ControlGetPos,, ty,,,, ahk_id %g_Control%
        If (g_Y > (tiy + ty)) {
            g_Control := ""
        }
    }

    If (g_Control == "") {
        Menu WindowContextMenu, Show
    } Else {
        If (g[g_Control].Handle == "") {
            g_Control := GetParent(g_Control) ; For ComboBox and ActiveX
        }
        ShowContextMenu()
    }
    Return 0
}

OnWM_KEYDOWN(wParam, lParam, msg, hWnd) {
    hActiveWnd := WinExist("A")

    ShiftP := GetKeyState("Shift", "P")
    CtrlP := GetKeyState("Ctrl", "P")

    If (hActiveWnd == hChildWnd) {
        If (ShiftP && wParam == 37) { ; Shift + Left
            ResizeBy1px("Left")
            Return False
        } Else If (ShiftP && wParam == 38) { ; Shift + Up
            ResizeBy1px("Up")
            Return False
        } Else If (ShiftP && wParam == 39) { ; Shift + Right
            ResizeBy1px("Right")
            Return False
        } Else If (ShiftP && wParam == 40) { ; Shift + Down
            ResizeBy1px("Down")
            Return False
        } Else If (wParam == 37) { ; Left
            MoveBy1px("Left")
            Return False
        } Else If (wParam == 38) { ; Up
            MoveBy1px("Up")
            Return False
        } Else If (wParam == 39) { ; Right
            MoveBy1px("Right")
            Return False
        } Else If (wParam == 40) { ; Down
            MoveBy1px("Down")
            Return False
        } Else If (wParam == 46) { ; Del
            DeleteSelectedControls()
        } Else If (CtrlP && wParam == 65) { ; ^A
            GoSub SelectAll
        } Else If (wParam == 113) { ; F2
            Gosub ChangeText
        } Else If (wParam == 114) { ; F3
            BlinkBorder(g_Control)
            Return False
        } Else If (wParam == 93) { ; AppsKey
            Menu WindowContextMenu, Show
        }
    } Else If (hActiveWnd == hAutoWnd) {
        If (CtrlP && wParam == 70) { ; ^F
            GoSub ShowSearchDialog
            Return False
        } Else If (wParam == 113) { ; F2
            Constant := GetSelectedText()
            If (Value := LookupConstant(Constant)) {
                SetSelectedText(Constant . " := " . Value)
            }
            Return False
        } Else If (wParam == 114) { ; F3
            GoSub FindNext
            Return False
        } Else If (CtrlP && wParam == 71) { ; ^G
            GoSub ShowGoToLineDialog
            Return False
        } Else If (CtrlP && wParam == 0x6B) { ; ^Numpad+
            GoSub ZoomIn
            Return False
        } Else If (CtrlP && wParam == 0x6D) { ; ^Numpad-
            GoSub ZoomOut
            Return False
        } Else If (CtrlP && wParam == 0x60) { ; ^Numpad0
            GoSub ResetFontSize
            Return False
        } Else If (CtrlP && wParam == 90) { ; ^Z
            GoSub SciUndo
            Return False
        } Else If (wParam == 0x2D) { ; Insert
            Insert := !Insert
            If (Insert) {
                SB_SetText("Insert", 4)
            } Else {
                SB_SetText("Overstrike", 4)
            }
        } Else If (CtrlP && wParam == 0x28) { ; Ctrl + Down arrow key
            GoSub DuplicateLine
            Return False
        } Else If (CtrlP && wParam == 0x26) { ; Ctrl + Up arrow key
            GoSub TransposeLine
            Return False
        }
    } Else If (hActiveWnd == hAddMenuItemDlg) {
        ControlGetFocus FocusedControl, ahk_id %hAddMenuItemDlg%
        If (FocusedControl == "msctls_hotkey321") {
            Static ReservedKeys := {8: "Backspace", 13: "Enter", 27: "Esc", 32: "Space", 46: "Del"}
            If ReservedKeys.HasKey(wParam) {
                GuiControl,, msctls_hotkey321, % ReservedKeys[wParam]
                Return False
            }
            Return
        }
    }

    If (CtrlP && wParam == 80) { ; ^P
        GoSub NewGUI
        Return False
    } Else If (CtrlP && wParam == 78) { ; ^N
        GoSub NewTab
        Return False
    } Else If (CtrlP && wParam == 87) { ; ^W
        GoSub CloseTab
        Return False
    } Else If (CtrlP && wParam == 79) { ; ^O
        GoSub OpenFile
        Return False
    } Else If (CtrlP && ShiftP && wParam == 85) { ; ^!U
        GoSub SciUppercase
        Return False
    } Else If (CtrlP && ShiftP && wParam == 76) { ; ^!U
        GoSub SciLowercase
        Return False
    } Else If (CtrlP && ShiftP && wParam == 84) { ; ^!T
        GoSub SciTitleCase
        Return False
    } Else If (CtrlP && wParam == 73) { ; ^U
        GoSub ImportGUI
        Return False
    } Else If (CtrlP && ShiftP && wParam == 83) { ; ^+S
        GoSub SaveAs
        Return False
    } Else If (CtrlP && wParam == 83) { ; ^S
        GoSub Save
        Return False
    } Else If (wParam == 0x70) { ; F1
        OpenHelpFile(GetSelectedText())
        Return False
    } Else If (CtrlP && wParam == 0x74) { ; ^F5
        GoSub RunToCursor
        Return False
    } Else If (wParam == 116) { ; F5
        GoSub RunSelectedText
        Return False
    } Else If (wParam == 0x77) { ; F8
        If (!IsWindowVisible(hCloneDlg)) {
            GoSub ShowCloneDialog
        }
    } Else If (wParam == 120) { ; F9
        RunScript()
        Return False
    } Else If (wParam == 0x7A) { ; F11
        ShowChildWindow()
        Return False
    } Else If (wParam == 0x7B) { ; F12
        If (DesignMode) {
            GoSub SwitchToEditorMode
        } Else {
            GoSub SwitchToDesignMode
        }
        Return False
    } Else If (CtrlP && wParam == 9) { ; Ctrl+Tab
        NextTab := TabEx.GetSel()
        If (ShiftP) {
            NextTab := (NextTab == 1) ? TabEx.GetCount() - 1 : NextTab - 2
        } Else If (NextTab == TabEx.GetCount()) {
            NextTab := 0
        }
        SendMessage 0x1330, NextTab,,, ahk_id %hTab% ; TCM_SETCURFOCUS.
        Return False
    }
}

OnWM_SYSKEYDOWN(wParam, lParam, msg, hWnd) {
    If (WinExist() == hAddMenuItemDlg) {
        Return
    }

    If (wParam == 120) { ; Alt+F9
        RunScript(4)
        Return False
    } Else If (wParam == 116) { ; Alt+F5
        RunScript(7)
        Return False
    } Else If (wParam == 0x79) { ; F10
        If (IsWindowVisible(hPropWnd)) {
            ShowWindow(hPropWnd, 0)
        } Else {
            GoSub ShowProperties
        }
        Return False
    }
}

OnWM_KEYUP(wParam) {
    If (WinExist() == hChildWnd) {
        If (wParam == 17) {
            Cross := False
            DllCall("SetCursor", "UInt", DllCall("LoadCursor", "UInt", 0, "UInt", 32512)) ; IDC_ARROW
        }

        ; Restore the selection after moving controls with the arrow keys
        If (wParam >= 37 && wParam <= 40) {
            GenerateCode()
            UpdateSelection()
        }
    }
}

; -1: Toggle, 0: Hide, 1: Show
ShowChildWindow(Param := -1) { 
    If (Param == -1) {
        Param := !IsWindowVisible(hChildWnd)
    }

    ShowWindow(hChildWnd, Param)
    ShowWindow(hSelWnd, Param)

    g_GuiSB := Param
    SetStatusBar()
}

ShowChildWindow:
    ShowChildWindow()
Return

SwitchToEditorMode:
    Gui Auto: Default

    ShowChildWindow(0)
    ShowWindow(hToolbar, 0)
    ShowWindow(hToolBox, 0)
    ShowWindow(hEditorTB, 1)
    SendMessage TB_CHECKBUTTON, 2050, 1,, ahk_id %hEditorTB%

    GuiControl MoveDraw, % hTab, x2
    Loop % Sci.MaxIndex() {
        ControlMove,, % cxFrame + 7,,,, % "ahk_id " Sci[A_Index].hWnd
    }
    GoSub AutoSize

    Repaint(hAutoWnd)

    hMenu := GetSubMenu(GetMenu(hAutoWnd), 7) ; 7 = Options Menu
    CheckMenuRadioItem(hMenu, 1, 0, 1)

    ControlFocus,, % "ahk_id " . Sci[TabEx.GetSel()].hWnd

    DesignMode := False
    SetStatusBar()
Return

SwitchToDesignMode:
    ShowWindow(hChildWnd, 1)

    Gui Auto: Default

    ShowWindow(hEditorTB, 0)
    ShowWindow(hToolbar, 1)
    SendMessage TB_CHECKBUTTON, 1060, 1,, ahk_id %hToolbar%

    ShowWindow(hToolBox, 1)
    GuiControl MoveDraw, % hTab, x164
    Loop % Sci.MaxIndex() {
        ControlMove,, % cxFrame + 169,,,, % "ahk_id " Sci[A_Index].hWnd
    }
    GoSub AutoSize

    Repaint(hAutoWnd)

    hMenu := GetSubMenu(GetMenu(hAutoWnd), 7) ; Options Menu
    CheckMenuRadioItem(hMenu, 0, 0, 1)

    DesignMode := True
    SetStatusBar()
Return

InsertControl:
    AddControl(A_ThisMenuItem)
    Adding := False
Return

BlinkControlBorder:
    BlinkBorder(g_Control)
Return

BlinkBorder(hWnd, Duration := 500, Color := "0x22B14C", Radius := 3) {
    Static wx, wy, ww, wh, x, y, w, h, Index, r

    WinGetPos wx, wy, ww, wh, ahk_id %hChildWnd%
    If (hWnd == "") {
        x := wx, y := wy, w := ww, h := wh
    } Else {
        Gui %Child%: Default
        ControlGetPos x, y, w, h,, ahk_id %hWnd%
        x += wx
        y += wy
    }

    Loop 4 {
        Index := A_Index + 90
        Gui %Index%: -Caption ToolWindow AlwaysOnTop
        Gui %Index%: Color, %Color%
    }

    r := Radius
    Gui 91: Show, % "NA x" (x - r) " y" (y - r) " w" (w + r + r) " h" r
    Gui 92: Show, % "NA x" (x - r) " y" (y + h) " w" (w + r + r) " h" r
    Gui 93: Show, % "NA x" (x - r) " y" y " w" r " h" h
    Gui 94: Show, % "NA x" (x + w) " y" y " w" r " h" h

    Sleep %Duration%

    Loop 4 {
        Index := A_Index + 90
        Gui %Index%: Destroy
    }
}

RecreateFromSource:
    If (!WinExist("ahk_id " . hChildWnd)) {
        GoSub CreateChildWindow
        Repaint(hChildWnd)
    }
    g.ControlList := []
    DestroyAllControls()
    GuiControl, Properties:, %hCbxClassNN%, |Window||
    n := TabEx.GetSel()
    Sci[n].GetText(Sci[n].GetLength() + 1, SciText)
    ParseScript(SciText)
Return

ImportGUI:
    TabEx.SetSel(1)
    Gui %Child%: +Disabled 
    MessageBoxCheck(0
        , "AutoGUI"
        , "The Window Cloning Tool should be preferably used to import a GUI script."
        , "AutoGUI.WCTNotice"
        , hAutoWnd)
    Gui %Child%: -Disabled

    FileSelectFile FileName, 1, %OpenDir%, Open
    If (ErrorLevel) {
        Return
    }

    Open([FileName], 1)
Return

OpenFile:
    Open()
Return

Open(Files := "", ImportGUI := 0) {
    If (!Files.MaxIndex()) {
        Gui Auto: +OwnDialogs
        FileSelectFile Files, M3, %OpenDir%, Open
        If (ErrorLevel) {
            Return
        } Else {
            Temp := StrSplit(Files, "`n")
            Files := []
            Loop % Temp.MaxIndex() {
                If (A_Index == 1) {
                    BasePath := RTrim(Temp[1], "\") ; RTrim for root folders
                } Else {
                    If (!FileExist(File := BasePath . "\" . Temp[A_Index])) {
                        Return
                    }
                    Files.Push(File)
                }
            }
        }
    }

    For Each, File in Files {
        ;OutputDebug %A_ThisFunc%: %File%

        _Open:
        Try {
            fOpen := FileOpen(File, "r")
            ;fSize := fOpen.Length
            fRead := fOpen.Read()
            fEncoding := fOpen.Encoding
            fOpen.Close()
        } Catch e {
            MsgBox 0x2016
            , Error %A_LastError%
            , % ((File != "") ? File . "`n" : "") . e.Message . "`n" . e.Extra
            IfMsgBox TryAgain, {
                GoSub _Open            
            } Else IfMsgBox Continue, {
                Continue
            } Else {
                Return
            }
        }

        SplitPath File, FileName, OpenDir, FileExt

        If (ImportGUI && FileExt = "ahk") {
            Gosub NewGUI
            ParseScript(fRead)
        } Else {
            n := NewTab()
            TabEx.SetText(n, FileName)
    
            If (FileExt = "ahk") {
                TabEx.SetIcon(n, 2)
            } Else {
                ToggleSyntaxHighlighting(n)
            }
    
            Sci[n].FullFileName := File
            Sci[n].FileName := FileName
            Sci[n].SetText("", fRead)
            Sci[n].SetSavePoint()
            Sci[n].Encoding := fEncoding
        }

        AddToRecentFiles(File)
    }
}

SaveAs:
    n := TabEx.GetSel()
    StartPath := (Sci[n].FileName != "") ? Sci[n].FullFileName : SaveDir
    Filter := "AutoHotkey Scripts (*.ahk)"
    Gui Auto: +OwnDialogs
    FileSelectFile SelectedFile, S16, %StartPath%, Save, %Filter%
    If (ErrorLevel) {
        Return
    }

    SplitPath SelectedFile, FileName, Dir, Extension
    If (Extension == "" && !FileExist(SelectedFile . ".ahk")) {
        FileName .= ".ahk"
        SelectedFile .= ".ahk"
    }
    
    Sci[n].FullFileName := SelectedFile
    Sci[n].FileName := FileName

    GoSub Save
Return

Save:
    Save()
Return

Save() {
    n := TabEx.GetSel()

    If (Sci[n].FileName == "") {
        GoSub SaveAs
        Return
    }

    Sci[n].GetText(Sci[n].GetLength() + 1, SciText)
    Sci[n].GetText(Sci[n].GetLength() + 1, SciText)

    If (Backup) {
        If (!FileExist(BkpDir)) {
            FileCreateDir %BkpDir%
        }
        FileAppend %SciText%, % GetTempFileName(BkpDir)
    }

    FullFileName := Sci[n].FullFileName
    FileDelete % FullFileName
    FileAppend %SciText%, % FullFileName
    If (ErrorLevel) {
        MsgBox 0x2010, AutoGUI, % "Error saving " . FullFileName
        Return
    }

    Sci[n].SetSavePoint()
    If (!DesignMode) {
        Gui Auto: Default
        SB_SetText("", 2)
    }

    TabTitle := TabEx.GetText(n)
    If (InStr(TabTitle, "*")) {
        TabEx.SetText(n, Sci[n].FileName)
        Repaint(hAutoWnd)
    }

    SplitPath FullFileName,, SaveDir, FileExt
    If (FileExt = "ahk") {
        TabEx.SetIcon(n, 2)
    } Else If (g_GuiTab != n) {
        TabEx.SetIcon(n, 1)
    }

    If (g_GuiTab == n) {
        CopyLibraries(SaveDir)
    }

    SetWindowTitle(FullFileName)
    AddToRecentFiles(FullFileName)

    Repaint(Sci[Tab].hWnd)
    Return True
}

CopyLibraries(Dir) {
    If (g.Anchor) {
        Source := A_ScriptDir . "\Lib\AutoXYWH.ahk"
        Destination := Dir . "\AutoXYWH.ahk"
        If (!FileExist(Destination)) {
            FileCopy %Source%, %Destination%
        }
    }

    If (ToolbarExist()) {
        Source := A_ScriptDir . "\Lib\Toolbar.ahk"
        Destination := Dir . "\Toolbar.ahk"
        If (!FileExist(Destination)) {
            FileCopy %Source%, %Destination%
        }
    }
}

CopyToClipboard:
    n := TabEx.GetSel()
    Sci[n].GetText(Sci[n].getLength() + 1, SciText)
    Clipboard := SciText
    MsgBox 0x2040, % TabEx.GetText(n), Content copied to the clipboard.
Return

RunScript:
    RunScript(A_ThisMenuItemPos)
Return

RunScript(Mode := 1) {
    n := TabEx.GetSel()
    Size := Sci[n].GetLength()
    If (Size == 0) {
        Return
    }

    If (GetKeyState("Shift", "P") || Mode == 2) {
        AhkPath := A_AhkPath . "\..\AutoHotkeyU64.exe"
    } Else {
        AhkPath := A_AhkPath
    }

    If (Mode == 7) {
        ExecScript("MsgBox 0, AutoGUI, % " . GetSelectedText(), Parameters, AhkPath)
        Return
    }

    If (Mode == 5) { ; Run to Cursor
        Sci[n].GetTextRange([0, Sci[n].GetCurrentPos()], TextToCursor)
        ExecScript(TextToCursor, Parameters, AhkPath)
        Return
    }

    Sci[n].GetText(Size + 1, SciText)

    If (Mode == 6) { ; Run Selected Text (F5)
        ;VarSetCapacity(SelText, Sci[n].GetSelText(0, 0))
        ;Size := Sci[n].GetSelText(0, &SelText)
        ;ExecScript(StrGet(&SelText, Size,"UTF-8"), Parameters, AhkPath)
        Text := GetSelectedText()
        If (Text == "") {
            Text := SciText
        }
        ExecScript(Text, Parameters, AhkPath)
        Return
    }

    ; Alternative run
    If (Mode == 4) {
        If (FileExist(AltAhkPath)) {
            AhkPath := AltAhkPath
        } Else {
            FileSelectFile AltAhkPath, 3, %A_AhkPath%, Browse, Executable Files (*.exe)
            If (ErrorLevel) {
                Return
            }
            AhkPath := AltAhkPath
        }
    }

    ; Run from the saved location
    If (GetKeyState("Ctrl", "P") || Mode == 3 || (Sci[n].FileName != "" && !Sci[n].GetModify())) {
        File := Sci[n].FullFileName
        If (File == "") {
            GoSub Save
            File := Sci[n].FullFileName
        }
        If (FileExist(File)) {
            SplitPath File,, Path
            Run % AhkPath . " """ . File . """ " . Parameters, %Path%
        } Else If (File != "") {
            MsgBox 0x2010, AutoGUI, File not found: %File%
        }
        Return
    } Else {
        File := A_Temp . "\Temp.ahk"
        Path := A_Temp
        If (FileExist(File)) {
            FileDelete %File%
        }
        FileAppend %SciText%, %File%
        CopyLibraries(Path)
    
        If (!ErrorLevel) { ; Default run method
            Run % AhkPath . " """ . File . """ " . Parameters, %Path%
        }
    }
}

RunSelectedText:
    RunScript(6)
Return

RunToCursor:
    RunScript(5)
Return

ShowParamsDlg:
    Info := "Parameters are stored in the variables %1%, %2%, and so on.`n"
         .  "See the online <a href=""https://autohotkey.com/docs/Scripts.htm#cmd"">help topic</a> for details."

    Temp := InputBoxEx("Script Parameters", Info, "Command Line Parameters", Parameters, "", "", 440, "", "", hAutoWnd, IconLib, 91)
    
    If (!ErrorLevel) {
        Parameters := Temp
    }
Return

RunFileDlg() {
    ;Run explorer.exe shell:::{2559a1f3-21d7-11d4-bdaf-00c04f60b9f0}
    ;Run % "rundll32.exe shell32.dll,#61"
    hModule := DllCall("GetModuleHandle", "Str", "shell32.dll", "Ptr")
    RunFileDlg := DllCall("GetProcAddress", "UInt", hModule, "UInt", 61, "Ptr")
    DllCall(RunFileDlg, "Ptr", hAutoWnd, "Ptr", 0, "Ptr", 0, "Ptr", 0, "Ptr", 0, "UInt", 0)
}

Compile:
    SplitPath A_AhkPath,, AhkBasePath
    Ahk2ExePath := AhkBasePath . "\Compiler\Ahk2Exe.exe"

    Try {
        Run %Ahk2ExePath%,,, PID
    } Catch e {
        MsgBox 0x2010, AutoGUI, % Ahk2ExePath . "`n`n" . e.Extra
        Return
    }

    ; Not working on Windows 10
    If (Sci[Tab].FullFileName && !Sci[Tab].GetModify()) {
        SplitPath % Sci[Tab].FullFileName,, Dir,, NameNoExt

        SetBatchLines 20ms
        Sleep 100

        WinWait Ahk2Exe ahk_pid %PID%
        WinGet hWnd, ID, Ahk2Exe ahk_pid %PID%
        WinActivate ahk_id %hWnd%
        WinWaitActive ahk_id %hWnd%

        Control Enable,, Edit1, % "ahk_id " . hWnd
        If (!ErrorLevel) {
            ControlSetText Edit1, % Sci[Tab].FullFileName, ahk_id %hWnd%
        }

        If (!FileExist(ExeFile := Dir . "\" . NameNoExt . ".exe")) {
            Control Enable,, Edit2, % "ahk_id " . hWnd
            If (!ErrorLevel) {
                ControlSetText Edit2, %ExeFile%, ahk_id %hWnd%
            }
        }

        SetBatchLines -1
    }
Return

AppendMenu(MenuName, MenuItemName := "", Subroutine := "MenuHandler", Icon := "", IconIndex := 0) {
    If (MenuItemName == "") {
        Menu, %MenuName%, Add ; Separator
        Return
    }

    Menu, %MenuName%, Add, %MenuItemName%, %Subroutine%

    If (Icon == "=") {
        Icon := MenuItemName . ".ico"
    }

    If (Icon != "") {
        If (Icon == "+") {
            Menu, %MenuName%, Check, %MenuItemName%
        } Else If FileExist(Icon) {
            Menu, %MenuName%, Icon, %MenuItemName%, %Icon%, %IconIndex%
        } Else If FileExist("Icons\" . Icon) {
            Menu, %MenuName%, Icon, %MenuItemName%, Icons\%Icon%, %IconIndex%
        } Else If FileExist(A_WinDir . "\System32\" . Icon) {
            Menu, %MenuName%, Icon, %MenuItemName%, %A_WinDir%\System32\%Icon%, %IconIndex%
        }
    }
}

MenuHandler:
    MsgBox 0x2040, AutoGUI, Not implemented yet.
Return

AddToRecentFiles(FileName) {
    Static RecentFilesMenu := 0, MaxItems := 10

    If !(FileExist(FileName)) {
        Return
    }

    If !(RecentFilesMenu) {
        AutoMenu := GetMenu(hAutoWnd)
        FileMenu := GetSubMenu(AutoMenu, 0)
        FileMenuCount := GetMenuItemCount(FileMenu)
        Loop % FileMenuCount {
            If (GetMenuString(FileMenu, A_Index - 1) = "Recent &Files") {
                RecentFilesMenuPos := A_Index - 1
                Break
            }
        }
        RecentFilesMenu := GetSubMenu(FileMenu, RecentFilesMenuPos)
    }

    ItemCount := GetMenuItemCount(RecentFilesMenu)
    If (ItemCount == MaxItems) {
        DeleteMenu(RecentFilesMenu, 0)
        RecentFiles.Remove(1)
    }

    Menu AutoFileMenu, Enable, Recent &Files
    Menu AutoRecentMenu, Add, %FileName%, OpenRecentFile
    Try {
        Menu AutoRecentMenu, Icon, %FileName%, % "HICON:" . GetFileIcon(FileName)
    }
    Menu AutoFileMenu, Add, Recent &Files, :AutoRecentMenu

    MaxIndex := RecentFiles.MaxIndex()
    Loop % MaxIndex {
        If (FileName = RecentFiles[A_Index]) {
            RecentFiles.Remove(A_Index)
            Break
        }
    }
    RecentFiles.Insert(FileName)
}

OpenRecentFile:
    Open([A_ThisMenuItem])
Return

LoadRecentFiles() {
    IniRead Recent, %IniFile%, Recent
    If (Recent != "ERROR") {
        Loop Parse, Recent, `n
        {
            RecentFile := StrSplit(A_LoopField, "=")
            If (FileExist(RecentFile[2])) {
                AddToRecentFiles(RecentFile[2])
            }
        }
    }
}

OpenSample:
    FileName := A_ScriptDir . "\Samples\" . A_ThisMenuItem
    ;Run %FileName%
    Open([FileName])
Return

OpenSamplesFolder:
    Run %A_ScriptDir%\Samples
Return

A_Variables:
Constantine:
Expressive:
    Run %A_ScriptDir%\Tools\%A_ThisLabel%.ahk, Tools
Return

OpenHelpFile:
    If (A_ThisMenuItem = "Gui Control Types") {
        Doc := "/docs/commands/GuiControls.htm"
    } Else If (A_ThisMenuItem = "GUI Styles") {
        Doc := "/docs/misc/Styles.htm"
    } Else If (A_ThisMenuItem = "Gui Command") {
        Doc := "/docs/commands/Gui.htm"
    } Else If (A_ThisMenuItem = "Commands and Functions") {
        Doc := "/docs/commands/index.htm"
    } Else If (A_ThisMenuItem = "Variables and Expressions") {
        Doc := "/docs/Variables.htm"
    } Else {
        Doc := "/docs/AutoHotkey.htm"
    }
    Run % "hh mk:@MSITStore:" . HelpFile . "::" . Doc

/*
    If (A_ThisMenuItemPos == 1) {
        Topic := ""
    } Else If (A_ThisMenuItem == "Gui Command") {
        Topic := "Gui"
    } Else If (A_ThisMenuItem == "Commands and Functions") {
        Topic := "Commands"
    } Else If (A_ThisMenuItem = "Variables and Expressions") {
        Topic := "Variables, MAIN"
    } Else {
        Topic := A_ThisMenuItem
    }

    OpenHelpFile(Topic)
*/
Return

ShowAbout:
    Gui About: New, LabelAbout -MinimizeBox OwnerAuto
    Gui Color, White
    Gui Add, Picture, x9 y10 w64 h64, %IconLib%
    Gui Font, s20 W700 Q4 c00ADEF, Verdana
    Gui Add, Text, x80 y8 w200, AutoGUI
    Gui Font
    Gui Font, s9, Segoe UI
    Gui Add, Text, x214 y24, v%Version%
    FileGetVersion SciVer, %SciLexer%
    Gui Add, Text, x81 y41, Scintilla %SciVer%
    Gui Add, Text, x81 y58 w200 +0x4000, % "AutoHotkey " . A_AhkVersion . " " . (A_IsUnicode ? "Unicode" : "ANSI") . " " . (A_PtrSize == 8 ? "64-bit" : "32-bit")
    Gui Add, Text, x0 y102 w294 h48 -Background
    Gui Add, Link, x16 y118 -Background, <a href="http://www.ahkscript.org">www.ahkscript.org</a>
    Gui Add, Button, gAboutClose x203 y115 w80 h23 Default, OK
    Gui Show, w294 h150, About
    ControlFocus Button1, About
    smIcon := DllCall("LoadIcon", "UInt", 0, "UInt", 32516) ; OIC_INFORMATION
    Gui +LastFound
    SendMessage 0x80, 0, smIcon ; WM_SETICON, ICON_SMALL
    SetModalWindow(True)
Return

AboutEscape:
AboutClose:
    SetModalWindow(False)
    Gui About: Destroy
Return

ShowContextMenu:
    g_Control := Properties_GetHandle()
    ShowContextMenu()
Return

ShowContextMenu() {
    AhkName := g[g_Control].Type
    Options := StrSplit(g[g_Control].Options, A_Space)

    Try {
        Menu ControlOptionsMenu, DeleteAll
    } Catch {
        Menu ControlOptionsMenu, DeleteAll
    }

    If (g[g_Control].Extra == "Command Link") {
        AhkName := "CommandLink"
    }

    Items := Default[AhkName].Menu

    If (AhkName == "ListView") {
        LVItems := ["Report", "List", "Icons", "Small Icons", "Tile"]
        For Each, Item in LVItems {
            AppendMenu("LVViewMenu", Item, "SetListViewMode")
            If (Item == "Small Icons") {
                ItemValue := "IconSmall"
            } Else If (Item == "Icons") {
                ItemValue := "Icon"
            } Else {
                ItemValue := Item
            }
            Loop % Options.MaxIndex() {
                If (Options[A_Index] = ItemValue) {
                    Menu LVViewMenu, Check, %Item%
                    Break
                }
            }
        }
        AppendMenu("ControlOptionsMenu", "View Mode", ":LVViewMenu")
    }

    If AhkName in Text,GroupBox,Edit
    {
        For Each, Item in ["Left", "Center", "Right"] {
            AppendMenu("AlignMenu", Item, "AlignText")
            Loop % Options.MaxIndex() {
                If (Options[A_Index] = Item) {
                    Menu AlignMenu, Check, %Item%
                }
            }
        }
        AppendMenu("ControlOptionsMenu", "Text Alignment", ":AlignMenu")
    }

    For Each, Item in Items {
        Menu ControlOptionsMenu, Add, %Item%, SetOption
        Loop % Options.MaxIndex() {
            If (Options[A_Index] = ControlOptions[Item]) {
                Menu ControlOptionsMenu, Check, %Item%
            }
        }
    }

    If (g[g_Control].Extra == "Explorer") {
        Menu ControlOptionsMenu, Check, Explorer Theme
    }

    If (Items[1] == "None") {
        Menu ControlOptionsMenu, Uncheck, None
    }

    If (A_Gui == "Properties" || A_Gui == "Auto") {
        ControlGetPos x, y,, h,, ahk_id%hOptionsBtn%
        Menu ControlOptionsMenu, Show, %x%, % (y + h)
    } Else {
        Menu ControlContextMenu, Show
    }

    Try {
        Menu LVViewMenu, Delete
    }

    Try {
        Menu AlignMenu, Delete
    }
}

ShowTabContextMenu() {
    FileName := Sci[g_TabIndex].FullFileName
    If (FileExist(FileName)) {
        Menu TabContextMenu, Enable, Open Folder in Explorer
        Menu TabContextMenu, Enable, Copy Path to Clipboard
        Menu TabContextMenu, Enable, File Properties
    } Else {
        Menu TabContextMenu, Disable, Open Folder in Explorer
        Menu TabContextMenu, Disable, Copy Path to Clipboard
        Menu TabContextMenu, Disable, File Properties
    }
    Menu TabContextMenu, Show
}

OpenFolder:
    SplitPath % Sci[g_TabIndex].FullFileName,, Folder
    If (FileExist(Folder)) {
        Run Explore %Folder%
    }
Return

CopyFilePath:
    Clipboard := Sci[g_TabIndex].FullFileName
Return

ShowFileProperties:
    Run % "Properties " . Sci[g_TabIndex].FullFileName
Return

DeleteOldBackups() {
    Loop %BkpDir%\ahk*.tmp {
        Now := A_Now
        EnvSub Now, %A_LoopFileTimeCreated%, Days
        If (Now > 30) {
            FileDelete %A_LoopFileFullPath%
        }
    }
}

SetWindowTitle(FileName := "") {
    If (FileName != "") {
        WinSetTitle ahk_id%hAutoWnd%,, % AppName . " v" . Version . " - " . FileName
    } Else {
        WinSetTitle ahk_id%hAutoWnd%,, %AppName% v%Version%
    }
}

OnWM_CTLCOLORSTATIC(wParam, lParam) {
    Loop 8 {
        If (lParam == Grippers[A_Index]) {
            DllCall("SetBkColor", "UInt", wParam, "UInt", 0)
            Return GripperBrush
        }
    }
}

OnWM_SETCURSOR(wParam, lParam, Msg, hWnd) {
    If (Cursors[wParam]) {
        hCursor := DllCall("LoadCursor", "UInt", 0, "UInt", Cursors[wParam])
        DllCall("SetCursor", "UInt", hCursor)
        Return True
    }

    If (!Adding) {
        LButtonP := GetKeyState("LButton", "P")
        If (hWnd == hChildWnd && wParam != hChildWnd && LButtonP) {
            hCursor := DllCall("LoadCursor", "UInt", 0, "UInt", 32646) ; IDC_SIZEALL
            DllCall("SetCursor", "UInt", hCursor)
            Return True
        }
    }
}

OnWM_LBUTTONUP() {
    Adding := False
}

MoveBy1px(Direction) {
    DestroyWindow(hSelWnd)
    HideResizingGrippers()

    Selection := GetSelectedItems()

    Inc := (GetKeyState("Ctrl", "P")) ? GridSize : 1

    If (Direction == "Left") {
        For Each, Item in Selection {
            x := g[Item].x - Inc
            GuiControl %Child%: MoveDraw, %Item%, % "x" . x
            g[Item].x := x
        }
    } Else If (Direction == "Up") {
        For Each, Item in Selection {
            y := g[Item].y - Inc
            GuiControl %Child%: MoveDraw, %Item%, % "y" . y
            g[Item].y := y
        }
    } Else If (Direction == "Right") {
        For Each, Item in Selection {
            x := g[Item].x + Inc
            GuiControl %Child%: MoveDraw, %Item%, % "x" . x
            g[Item].x := x
        }
    } Else If (Direction == "Down") {
        For Each, Item in Selection {
            y := g[Item].y + Inc
            GuiControl %Child%: MoveDraw, %Item%, % "y" . y
            g[Item].y := y
        }
    }
}

ResizeBy1px(Direction) {
    DestroyWindow(hSelWnd)
    HideResizingGrippers()

    Selection := GetSelectedItems()

    Inc := (GetKeyState("Ctrl", "P")) ? GridSize : 1

    If (Direction == "Left") {
        For Each, Item in Selection {
            w := g[Item].w - Inc
            GuiControl %Child%: MoveDraw, %Item%, % "w" . w
            g[Item].w := w
        }
    } Else If (Direction == "Up") {
        For Each, Item in Selection {
            h := g[Item].h - Inc
            GuiControl %Child%: MoveDraw, %Item%, % "h" . h
            g[Item].h := h
        }
    } Else If (Direction == "Right") {
        For Each, Item in Selection {
            w := g[Item].w + Inc
            GuiControl %Child%: MoveDraw, %Item%, % "w" . w
            g[Item].w := w
        }
    } Else If (Direction == "Down") {
        For Each, Item in Selection {
            h := g[Item].h + Inc
            GuiControl %Child%: MoveDraw, %Item%, % "h" . h
            g[Item].h := h
        }
    }
}

GetSelectedText() {
    Global
    n := TabEx.GetSel()
    Start := Sci[n].GetSelectionStart()
    End := Sci[n].GetSelectionEnd()
    Sci[n].GetTextRange([Start, End], SelText)
    Return SelText
}

SetSelectedText(Text) {
    Sci[TabEx.GetSel()].ReplaceSel("", Text)
}

SetModalWindow(Modal := True) {
    Global
    If (Modal) {
        Gui Auto: +Disabled
        Gui %Child%: +Disabled
        Gui Properties: +Disabled
        OnMessage(0x100, "")
        OnMessage(0x104, "")
    } Else {
        Gui Auto: -Disabled
        Gui %Child%: -Disabled
        Gui Properties: -Disabled
        OnMessage(0x100, "OnWM_KEYDOWN")
        OnMessage(0x104, "OnWM_SYSKEYDOWN")
    }
}

LookupConstant(ByRef Constant) {
    XML := ComObjCreate("MSXML2.DOMDocument.6.0")
    XML.async := False
    XML.load("Tools\Windows.xml")

    StringUpper Constant, % Trim(Constant)
    Node := XML.selectSingleNode("//item[@const='" . Constant . "']")
    Value := Node.getAttribute("value")

    If (Value != "") {
        SetFormat Integer, H
        Value |= 0
        SetFormat Integer, D
    }

    Return Value
}

ReplaceConstant:
    Constant := GetSelectedText()

    Value := LookupConstant(Constant)
    If (Constant ~= "\d+" || Value == "") {
        Run % A_ScriptDir . "\Tools\Constantine.ahk " . Constant, Tools
        Return
    }

    If (InStr(A_ThisMenuItem, "Declare")) {
        SetSelectedText(Constant . " := " . Value)
    } Else If (InStr(A_ThisMenuItem, "SendMessage")) {
        Output := "SendMessage " . Value . ", wParam, lParam,, ahk_id %hWnd% `; " . Constant
        SetSelectedText(Output)
    } Else If (InStr(A_ThisMenuItem, "OnMessage")) {
        Output := "OnMessage(" . Value . ", ""On" . Constant . """)" . CRLF . CRLF
               .  "On" . Constant . "(wParam, lParam, msg, hWnd) {" . CRLF . CRLF . "}" . CRLF
        SetSelectedText(Output)
    }
Return

Hex2Dec:
    SetSelectedText(ToDec(GetSelectedText()))
Return

Dec2Hex:
    SetSelectedText(ToHex(GetSelectedText()))
Return

EnsureU32AHK() {
    If (A_PtrSize == 8 || !A_IsUnicode) {
        If (FileExist(U32 := A_AhkPath . "\..\AutoHotkeyU32.exe")) {
            Run % U32 . " """ . A_LineFile . ""
        } Else {
            MsgBox 0x10, AutoGUI, AutoHotkey 32-bit Unicode not found.
        }
        ExitApp
    }
}

GetControlType(ControlName) { ; ControlName: display name (as in the toolbox)
    Static Types := {0:0
,   "Date Time Picker": "DateTime"
,   "Edit Box": "Edit"
,   "Hotkey Box": "Hotkey"
,   "Month Calendar": "MonthCal"
,   "Progress Bar": "Progress"
,   "Radio Button": "Radio"
,   "Status Bar": "StatusBar"
,   "Tab": "Tab2"
,   "Custom Class": "Custom"
,   "Command Link": "CommandLink"}
    Return (Types[ControlName] != "") ? Types[ControlName] : ControlName
}

#Include %A_ScriptDir%\Include\Properties.ahk
#Include %A_ScriptDir%\Include\Editor.ahk
#Include %A_ScriptDir%\Include\FontDlg.ahk
#Include %A_ScriptDir%\Include\StylesDlg.ahk
#Include %A_ScriptDir%\Include\MenuEditor.ahk
#Include %A_ScriptDir%\Include\ToolbarDlg.ahk
#Include %A_ScriptDir%\Include\CloneWindow.ahk
#Include %A_ScriptDir%\Include\Grippers.ahk
#Include %A_ScriptDir%\Include\Settings.ahk
#Include %A_ScriptDir%\Include\Parser.ahk
#Include %A_ScriptDir%\Include\ContextHelp.ahk
#Include %A_ScriptDir%\Include\GenerateCode.ahk
