; Properties dialog
ShowProperties:
    If (!WinExist("ahk_id " . hPropWnd)) {
    Gui Properties: New, LabelProperties hWndhPropWnd -MinimizeBox OwnerAuto
    SetIconEx(hPropWnd, IconLib, 24)

    ClassNNList := ""
    For Each, Item In g.ControlList {
        ClassNNList .= g[Item].ClassNN . "|"
    }

    Gui Add, Picture, gBlinkControlBorder x12 y13 w16 h16 Icon5, % IconLib
    Gui Add, DropDownList, hWndhCbxClassNN vCbxClassNN gOnDropDownChange x40 y12 w203, % "Window||" . ClassNNList
    Gui Add, Button, hWndhReloadBtn gReloadSub x248 y11 w23 h23
    GuiButtonIcon(hReloadBtn, IconLib, 90, "L1 T1")

    Try {
        Gui Add, % "Tab3", hWndhPropTab vCurrentTab x6 y41 w270 h303 AltSubmit, General|Options|Window|Events|Script
    } Catch {
        Gui Add, Tab2, hWndhPropTab vCurrentTab x6 y41 w270 h303 AltSubmit, General|Options|Window|Events|Script
        Control Style, 0x54010040,, ahk_id %hPropTab%
    }

    Gui Tab, 1 ; General
        Gui Add, GroupBox, vGrpText x15 y65 w250 h48, Text
        Gui Add, Edit, vEdtText x26 y82 w230 h21

        Gui Add, GroupBox, x15 y116 w250 h99, Variables
        Gui Add, Text, x26 y132 w60 h21 +0x200, h&Wnd var:
        Gui Add, Edit, vEdtHWndVar x95 y132 w160 h21
        Gui Add, Text, vTxtVVar x26 y158 w60 h21 +0x200, v-Var:
        Gui Add, Edit, vEdtvVar x95 y158 w160 h21
        Gui Add, Text, vTxtGLabel x26 y184 w60 h21 +0x200, gLabel:
        Gui Add, Edit, vEdtgLabel x95 y184 w160 h21

        Gui Add, GroupBox, x15 y217 w250 h74, Position
        Gui Add, Text, x57 y232 w16 h22 +0x200, &X:
        Gui Add, Edit, vEdtX x75 y232 w50 h21
        Gui Add, UpDown, gAdjustPosition Range-65536-65536, 1
        Gui Add, Text, x157 y232 w16 h22 +0x200, &Y:
        Gui Add, Edit, vEdtY x175 y232 w50 h21
        Gui Add, UpDown, gAdjustPosition Range-65536-65536, 1
        Gui Add, Text, x57 y260 w16 h22 +0x200, &W:
        Gui Add, Edit, vEdtW x75 y260 w50 h21
        Gui Add, UpDown, gAdjustPosition Range-65536-65536, 1
        Gui Add, Text, x157 y260 w16 h22 +0x200, &H:
        Gui Add, Edit, vEdtH x175 y260 w50 h21
        Gui Add, UpDown, gAdjustPosition Range-65536-65536, 1

        Gui Add, GroupBox, x15 y293 w250 h40, Anchor
        Gui Add, CheckBox, vChkAnchorX gRequireHWndVar x75 y305 w40 h23, X
        Gui Add, CheckBox, vChkAnchorY gRequireHWndVar x115 y305 w40 h23, Y
        Gui Add, CheckBox, vChkAnchorW gRequireHWndVar x155 y305 w40 h23, W
        Gui Add, CheckBox, vChkAnchorH gRequireHWndVar x195 y305 w40 h23, H

    Gui Tab, 2 ; Options
        Gui Add, GroupBox, vGrpOptions x15 y71 w250 h60, Options
        Gui Add, Button, hWndhOptionsBtn x28 y92 w24 h24 gShowContextMenu, ...
        GuiButtonIcon(hOptionsBtn, IconLib, 91, "L1 T1")
        Gui Add, Edit, vEdtOptions x54 y94 w200 h21

        Gui Add, GroupBox, x15 y144 w250 h84, Styles
        Gui Add, Text, x33 y165 w60 h23 +0x200, &Style:
        Gui Add, Edit, hWndhEdtStyle vEdtStyle x96 y166 w82 h22
        SendMessage 0x1501, True, "Default",, ahk_id %hEdtStyle%
        Gui Add, Button, vBtnChangeStyle gShowStylesDialog x184 y165 w75 h23, Change...
        Gui Add, Text, x33 y193 w60 h23 +0x200, E&xtended:
        Gui Add, Edit, hWndhEdtExStyle vEdtExStyle x96 y193 w82 h22
        SendMessage 0x1501, True, "Default",, ahk_id %hEdtExStyle%
        Gui Add, Button, vBtnChangeExStyle gShowStylesDialog x184 y193 w75 h23, Change...

        Gui Add, GroupBox, x15 y242 w250 h84, Font
        Gui Add, Edit, vEdtFont x27 y264 w227 h23 Center ReadOnly, Default
        Gui Add, Button, gShowFontDialog x180 y296 w75 h23, Change...

    Gui Tab, 3 ; Window
        Gui Add, CheckBox, vChkResizable x20 y72 w110 h23, Can be &resized
        Gui Add, CheckBox, vChkNoMinimize x20 y97 w110 h24, No mi&nimize box
        Gui Add, CheckBox, vChkNoMaximize x20 y122 w111 h22, No ma&ximize box
        Gui Add, CheckBox, vChkNoSysMenu x20 y147 w111 h23, No system &menu
        Gui Add, CheckBox, vChkNoTheme x20 y172 w110 h23, No t&heme

        Gui Add, CheckBox, vChkCenter x144 y72 w120 h23 Checked, Center on &screen
        Gui Add, CheckBox, vChkAlwaysOnTop x144 y97 w120 h23, &Always on top
        Gui Add, CheckBox, vChkOwnDialogs x144 y122 w120 h23, &Own dialogs
        Gui Add, CheckBox, vChkToolWindow x144 y147 w120 h23, &Tool window
        Gui Add, CheckBox, vChkNoDPIScale x144 y172 w120 h23, No &DPI scale

        Gui Add, CheckBox, vChkBGColor x20 y200 w111 h24, &Background color:
        Gui Add, ListView, vColorPreview x144 y201 w20 h20 -Hdr Border
        Color := DllCall("GetSysColor", "UInt", 15) ; COLOR_3DFACE
        Color := ToHex((Color & 0xFF00) + ((Color & 0xFF0000) >> 16) + ((Color & 0xFF) << 16))
        GuiControl % "+Background" . Color, ColorPreview
        Gui Add, Button, gChooseBGColor x172 y199 w90 h23, Chan&ge Color
        
        Gui Add, CheckBox, vChkTrayIcon x20 y228 w111 h23, &Window/tray icon:
        Gui Add, Text, x144 y230 w20 h20 +0x1000
        Gui Add, Picture, vTrayIcon gShowIconPath x146 y232 w16 h16 , % A_AhkPath
        Gui Add, Button, gChooseTrayIcon x172 y228 w90 h23, Change &Icon

    Gui Tab, 4 ; Events
        Gui Add, GroupBox, x15 y71 w250 h100, Standard Events
        Gui Add, CheckBox, vChkGuiClose x30 y90 w100 h23 Checked, Gui&Close
        Gui Add, CheckBox, vChkGuiEscape x30 y115 w100 h23 Checked, Gui&Escape
        Gui Add, CheckBox, vChkGuiSize x30 y140 w100 h23, Gui&Size
        Gui Add, CheckBox, vChkGuiContextMenu x140 y90 w100 h23, GuiContext&Menu
        Gui Add, CheckBox, vChkGuiDropFiles x140 y115 w100 h23, Gui&DropFiles
        Gui Add, CheckBox, vChkOnClipboardChange x140 y140 w120 h23, &OnClipboardChange
        Gui Add, GroupBox, x15 y176 w250 h50, Auto-Execute Section
        Gui Add, CheckBox, vNoReturn gReset x30 y193 w220 h23, No "&Return" statement after "Gui Show"

    Gui Tab, 5 ; Script
        Gui Add, CheckBox, vChkNoEnv x20 y72 w113 h23 Checked, #No&Env
        Gui Add, CheckBox, vChkNoTrayIcon x144 y72 w113 h23, #No&TrayIcon
        Gui Add, CheckBox, vChkWarn x20 y98 w113 h23 Checked, #&Warn
        Gui Add, DropDownList, vCbxWarn x144 y98 w120, Off|MsgBox||StdOut|OutputDebug
        Gui Add, CheckBox, vChkSingleInstance x20 y126 w113 h23, #Single&Instance
        Gui Add, DropDownList, vCbxSingleInstance x144 y124 w120, Force||Ignore|Off
        Gui Add, CheckBox, vChkSetWorkingDir x20 y153 w113 h23 Checked, SetWorking&Dir
        Gui Add, Edit, vEdtSetWorkingDir x144 y153 w121 h21, `%A_ScriptDir`%
        Gui Add, CheckBox, vChkSendMode x20 y179 w113 h23, &SendMode
        Gui Add, DropDownList, vCbxSendMode x144 y180 w120, Input||Play|Event|InputThenPlay
        Gui Add, CheckBox, vChkSetBatchLines x20 y207 w113 h23, Set&BatchLines -1
        Gui Add, CheckBox, vChkListLines x144 y207 w113 h23, &ListLines Off
        Gui Add, CheckBox, vChkPersistent x20 y233 w113 h23, #&Persistent
        Gui Add, CheckBox, vChkIgnoreMenuErrors x144 y233 w113 h23, Ignore &Menu Errors
    Gui Tab

    Gui Add, Button, hWndhHelpBtn x8 y350 w24 h23 gMenuHandler
    GuiButtonIcon(hHelpBtn, "shell32.dll", 24, "L1 T1")
    Gui Add, Button, gReset x38 y350 w75 h23, &Reset
    Gui Add, Button, gPropertiesClose x118 y350 w75 h23, &Close
    Gui Add, Button, gApplyProperties x198 y350 w75 h23 Default, &Apply

    WinGetPos ax, ay, aw,, ahk_id %hAutoWnd%
    IniRead px, %IniFile%, Properties, x, % (ax + aw - 281 - 40)
    IniRead py, %IniFile%, Properties, y, % ay + 40
    Gui Properties: Show, % "x" . px . " y" . py . " w281 h382", Properties    
    } Else {
        NA := (A_ThisFunc != "" && A_ThisFunc != "OnToolbar") ? "NA" : ""
        Gui Properties: Show, % NA
    }

    ClassNN := g[g_Control].ClassNN
    If (ClassNN = "") {
        ClassNN := "Window"
    }
    GuiControl Properties: ChooseString, CbxClassNN, % ClassNN
    Gosub OnDropDownChange
Return

PropertiesEscape:
PropertiesClose:
    WinActivate ahk_id %hAutoWnd%
    Gui Properties: Cancel
Return

LoadProperties:
    Gui Properties: Default
    ClassNN := Properties_GetClassNN()

    Reset(1), Reset(2)

    GuiControl ChooseString, CbxWarn, % Script.Warn

    ; Window properties
    If (ClassNN = "Window") {
        If (g.Window.Title != "") {
            GuiControl,, EdtText, % g.Window.Title
        }
        
        If (g.Window.hWndVar != "") {
            GuiControl,, EdthWndVar, % g.Window.hWndVar
        }

        If (g.Window.Name != "") {
            GuiControl,, EdtvVar, % g.Window.Name
        }

        If (g.Window.Label != "") {
            GuiControl,, EdtgLabel, % g.Window.Label
        }
        
        GuiControl,, EdtX, % g.Window.x
        GuiControl,, EdtY, % g.Window.y
        GuiControl,, EdtW, % g.Window.w
        GuiControl,, EdtH, % g.Window.h

        If (g.Window.Extra != "") {
            GuiControl,, EdtOptions, % g.Window.Extra
        }

        If (g.Window.Style != "") {
            GuiControl,, EdtStyle, % g.Window.Style
        }
        If (g.Window.ExStyle != "") {
            GuiControl,, EdtExStyle, % g.Window.ExStyle
        }

        FontName := g.Window.FontName
        FontOptions := g.Window.FontOptions
        If (FontName != "" || FontOptions != "") {
            Separator := (FontName != "" && FontOptions != "") ? ", " : ""
            GuiControl,, EdtFont, % FontName . Separator . FontOptions
        } Else {
            GuiControl,, EdtFont, Default
        }

        If (g.Window.GuiEscape) {
            GuiControl,, ChkGuiEscape, 1
        }
        If (g.Window.GuiSize) {
            GuiControl,, ChkGuiSize, 1
        }
        If (g.Window.GuiContextMenu) {
            GuiControl,, ChkGuiContextMenu, 1    
        }
        If (g.Window.GuiDropFiles) {
            GuiControl,, ChkGuiDropFiles, 1
        }

        Return
    }
    
    GuiControlGet c, %Child%: Pos, %g_Control%

    ; Control properties
    If (g[g_Control].Text != "") {
        GuiControl,, EdtText, % g[g_Control].Text
    }

    If (g[g_Control].hWndVar != "") {
        GuiControl,, EdtHWNDVar, % g[g_Control].hWndVar
    }
    If (g[g_Control].vVar != "") {
        GuiControl,, EdtvVar, % g[g_Control].vVar
    }
    If (g[g_Control].gLabel != "") {
        GuiControl,, EdtgLabel, % g[g_Control].gLabel
    }

    ; Size/position
    GuiControl,, EdtX, % cx
    GuiControl,, EdtY, % cy
    GuiControl,, EdtW, % cw
    GuiControl,, EdtH, % ch

    Anchor := g[g_Control].Anchor
    If (Anchor != "") {
        If (InStr(Anchor, "x")) {
            GuiControl,, ChkAnchorX, 1
        }
        If (InStr(Anchor, "y")) {
            GuiControl,, ChkAnchorY, 1
        }
        If (InStr(Anchor, "w")) {
            GuiControl,, ChkAnchorW, 1
        }
        If (InStr(Anchor, "h")) {
            GuiControl,, ChkAnchorH, 1
        }
    }

    GuiControl, Properties:, EdtOptions, % g[g_Control].Options

    If (g[g_Control].Style != "") {
        GuiControl,, EdtStyle, % g[g_Control].Style
    }
    If (g[g_Control].ExStyle != "") {
        GuiControl,, EdtExStyle, % g[g_Control].ExStyle
    }

    FontName := g[g_Control].FontName
    FontOptions := g[g_Control].FontOptions
    If (FontName != "" || FontOptions != "") {
        Separator := (FontName != "" && FontOptions != "") ? ", " : ""
        GuiControl,, EdtFont, % FontName . Separator . FontOptions
    } Else {
        GuiControl,, EdtFont, Default
    }

    ; Script properties
    If (Script.SingleInstance != "") {
        GuiControl,, ChkSingleInstance, 1
        SingleInstance := Script.SingleInstance
        GuiControl ChooseString, CbxSingleInstance, % Script.SingleInstance
    }
Return

OnDropDownChange:
    Gui Properties: Default
    GuiControlGet ClassNN,, %hCbxClassNN%

    If (ClassNN = "Window") {
        GuiControl Properties:, Static1, % "*Icon5 " . IconLib
        GuiControl,, GrpText, Title
        GuiControl,, TxtVVar, &Name:
        GuiControl,, TxtGLabel, &Label:
        GuiControl Disable, ChkAnchorX
        GuiControl Disable, ChkAnchorY
        GuiControl Disable, ChkAnchorW
        GuiControl Disable, ChkAnchorH
    } Else {
        GuiControl,, GrpText, Text
        GuiControl,, TxtVVar, &v-Var:
        GuiControl,, TxtGLabel, &g-Label:
        GuiControl Enable, ChkAnchorX
        GuiControl Enable, ChkAnchorY
        GuiControl Enable, ChkAnchorW
        GuiControl Enable, ChkAnchorH

        For Each, Item In g.ControlList {
            If (g[Item].ClassNN = ClassNN) {
                Type := g[Item].Type
                g_Control := Item
                Break
            }
        }
        Icon := "*Icon" . Default[Type].IconIndex . " " . Default[Type].Icon
        GuiControl Properties:, Static1, % Icon
    }

    GoSub LoadProperties
Return

ReloadSub:
    CurClassNN := Properties_GetClassNN()
    Properties_Reload()
    GuiControl Properties: ChooseString, CbxClassNN, % CurClassNN
    GoSub OnDropDownChange
Return

RequireHWndVar:
    Gui Properties: Default
    Gui Submit, NoHide
    If (EdtHWndVar == "") {
        GuiControl,, EdtHWndVar, % "h" . Properties_GetClassNN()
    }
Return

AdjustPosition:
    Gui Properties: Submit, NoHide
    If (CbxClassNN != "Window") {
        GuiControl %Child%: MoveDraw, % g_Control, x%EdtX% y%EdtY% w%EdtW% h%EdtH%
    } Else {
        ww := EdtW + (cxFrame * 2)
        wh := EdtH + (cxFrame * 2) + cyCaption
        WinMove ahk_id %hChildWnd%,, %EdtX%, %EdtY%, %ww%, %wh%
    }
Return

ApplyProperties:
    Gui Properties: Submit, NoHide

    Gui %Child%: Default
    GuiControlGet hCtrl, hWnd, % CbxClassNN

    ; Script tab
    Script.NoEnv := (ChkNoEnv) ? True : False
    Script.Warn := (ChkWarn) ? CbxWarn : ""
    Script.SingleInstance := (ChkSingleInstance) ? CbxSingleInstance : ""
    Script.NoTrayIcon := (ChkNoTrayIcon) ? True : False    
    Script.WorkingDir := (ChkSetWorkingDir) ? EdtSetWorkingDir : ""
    Script.SendMode := (ChkSendMode) ? CbxSendMode : ""
    Script.NoBatchLines := (ChkSetBatchLines) ? True : False
    Script.ListLinesOff := (ChkListLines) ? True : False
    Script.Persistent := (ChkPersistent) ? True : False
    Script.IgnoreMenuErrors := (ChkIgnoreMenuErrors) ? True : False
    
    ; Window tab
    Options := ""
    If (ChkResizable) {
        Options .= " +Resize"
    }
    If (ChkNoMinimize) {
        Options .= " -MinimizeBox"
    }
    If (ChkNoMaximize) {
        Options .= " -MaximizeBox"
    }
    If (ChkNoSysMenu) {
        Options .= " -SysMenu"
    }
    If (ChkAlwaysOnTop) {
        Options .= " +AlwaysOnTop"
    }
    If (ChkOwnDialogs) {
        Options .= " +OwnDialogs"
    }
    If (ChkToolWindow) {
        Options .= " +ToolWindow"
    }
    If (ChkNoTheme) {
        Options .= " -Theme"
    }
    If (ChkNoDPIScale) {
        Options .= " -DPIScale"
    }
    g.Window.Options := LTrim(Options)

    g.Window.Center := (ChkCenter) ? True : False

    g.Window.Color := (ChkBGColor) ? "" . Color : ""

    If (!ChkTrayIcon) {
        g.Window.Icon := ""
        g.Window.IconIndex := 0
        GuiControl, Properties:, TrayIcon, % A_AhkPath
    }

    ; Events
    g.Window.GuiClose := (ChkGuiClose) ? True : False
    g.Window.GuiEscape := (ChkGuiEscape) ? True : False
    g.Window.GuiSize := (ChkGuiSize) ? True : False
    g.Window.GuiContextMenu := (ChkGuiContextMenu) ? True : False
    g.Window.GuiDropFiles := (ChkGuiDropFiles) ? True : False
    g.Window.OnClipboardChange := (ChkOnClipboardChange) ? True : False

    ; General and Options tab (for window)
    If (CbxClassNN = "Window") {
        If (EdtText != g.Window.Title) {
            Title := EscapeChars(EdtText)
            WinSetTitle ahk_id %hChildWnd%,, %Title%
            g.Window.Title := Title
        }

        g.Window.hWndVar := EdthWndVar
        g.Window.Name := EdtvVar
        g.Window.Label := EdtgLabel

        ww := EdtW + (cxFrame * 2)
        wh := EdtH + (cxFrame * 2) + cyCaption
        WinMove ahk_id %hChildWnd%,,,, %ww%, %wh%

        g.Window.Extra := EdtOptions
        If (EdtOptions != "") {
            Try {
                Gui %Child%: %EdtOptions%
            }
        }

        g.Window.Style := (EdtStyle != "") ? EdtStyle : ""
        g.Window.ExStyle := (EdtExStyle != "") ? EdtExStyle : ""

        If (EdtFont == "Default" || EdtFont == "") {
            g.Window.FontName := ""
            g.Window.FontOptions := ""
        }

        GenerateCode()
        Return
    }
    
    ; General tab (for controls)
    If (EdtText != g[hCtrl].Text) {
        SetControlText(hCtrl, EdtText)
    }

    g[hCtrl].hWndVar := EdtHWndVar
    g[hCtrl].vVar := EdtvVar
    g[hCtrl].gLabel := EdtgLabel

    g[hCtrl].Anchor := ""
    If (ChkAnchorX) {
        g[hCtrl].Anchor .= "x"
    }
    If (ChkAnchorY) {
        g[hCtrl].Anchor .= "y"
    }
    If (ChkAnchorW) {
        g[hCtrl].Anchor .= "w"
    }
    If (ChkAnchorH) {
        g[hCtrl].Anchor .= "h"
    }

    ; Check if there is any control using Anchor
    g.Anchor := False
    For Each, Item In g.ControlList {
        If (g[Item].Anchor != "") {
            g.Anchor := True
            If (!InStr(g.Window.Options, "+Resize")) {
                g.Window.Options .= " +Resize"
                GuiControl Properties:, ChkResizable, 1
            }
            Break
        }
    }

    If (EdtX != g[hCtrl].x || EdtY != g[hCtrl].y || EdtW != g[hCtrl].w || EdtH != g[hCtrl].h) {
        GuiControl MoveDraw, %hCtrl%, x%EdtX% y%EdtY% w%EdtW% h%EdtH%
        g[hCtrl].x := EdtX
        g[hCtrl].y := EdtY
        g[hCtrl].w := EdtW
        g[hCtrl].h := EdtH

        If (hGrippedWnd == hCtrl) {
            HideResizingGrippers()
        }
    }

    ; Options tab
    Options := EdtOptions

    If (g[hCtrl].Type = "Picture") {
        RegExMatch(Options, "O)Icon(?P<Index>\d+)", Rx)
        GuiControl %Child%:, %hCtrl%, % "*Icon" . Rx.Value("Index") . " " . EdtText
    }

    g[hCtrl].Options := Trim(Options)

    If (Options != "") {
        GuiControl %Child%: %Options%, %hCtrl%
    }

    If (EdtStyle != "") {
        Control Style, % EdtStyle,, ahk_id %hCtrl%
        WinSet Redraw,, ahk_id %hChildWnd%
        g[hCtrl].Style := EdtStyle
    } Else {
        g[hCtrl].Style := ""
    }
    If (EdtExStyle != "") {
        Control ExStyle, % EdtExStyle,, ahk_id %hCtrl%
        WinSet Redraw,, ahk_id %hChildWnd%
        g[hCtrl].ExStyle := EdtExStyle
    } Else {
        g[hCtrl].ExStyle := ""
    }

    If (EdtFont == "Default" || EdtFont == "") {
        g[hCtrl].FontName := ""
        g[hCtrl].FontOptions := ""
        Gui %Child%: Font
        GuiControl Font, % hCtrl
    }

    GenerateCode()
Return

Reset:
    Gui Properties: Submit, NoHide
    Reset(CurrentTab)
Return

Reset(TabIndex) {
    If (TabIndex = 1) {
        GuiControl,, EdtText
        GuiControl,, EdthWndVar
        GuiControl,, EdtvVar
        GuiControl,, EdtgLabel
        GuiControl,, ChkAnchorX, 0
        GuiControl,, ChkAnchorY, 0
        GuiControl,, ChkAnchorW, 0
        GuiControl,, ChkAnchorH, 0
    } Else If (TabIndex = 2) {
        GuiControl,, EdtOptions
        GuiControl,, EdtStyle
        GuiControl,, EdtExStyle
        GuiControl,, EdtFont, Default
    } Else If (TabIndex = 3) {
        GuiControl,, ChkResizable, 0
        GuiControl,, ChkNoMinimize, 0
        GuiControl,, ChkNoMaximize, 0
        GuiControl,, ChkNoSysMenu, 0
        GuiControl,, ChkAlwaysOnTop, 0
        GuiControl,, ChkOwnDialogs, 0
        GuiControl,, ChkToolWindow, 0
        GuiControl,, ChkCenter, 0
        GuiControl,, ChkNoDPIScale, 0
        GuiControl,, ChkNoTheme, 0
        GuiControl,, ChkBGColor, 0
        GuiControl,, ChkTrayIcon, 0
        GuiControl,, TrayIcon, % A_AhkPath
    } Else If (TabIndex = 4) {
        GuiControl,, ChkGuiClose, 0
        GuiControl,, ChkGuiEscape, 0
        GuiControl,, ChkGuiSize, 0
        GuiControl,, ChkGuiContextMenu, 0
        GuiControl,, ChkGuiDropFiles, 0
        GuiControl,, ChkOnClipboardChange, 0
    } Else If (TabIndex = 5) {
        GuiControl,, ChkNoEnv, 0
        GuiControl,, ChkWarn, 0
        GuiControl ChooseString, CbxWarn, MsgBox
        GuiControl,, ChkSingleInstance, 0
        GuiControl ChooseString, CbxSingleInstance, Force
        GuiControl,, ChkNoTrayIcon, 0
        GuiControl,, ChkSetWorkingDir, 0
        GuiControl,, ChkSendMode, 0
        GuiControl ChooseString, CbxSendMode, Input
        GuiControl,, ChkSetBatchLines, 0
        GuiControl,, ChkListLines, 0
        GuiControl,, ChkPersistent, 0
        GuiControl,, ChkIgnoreMenuErrors, 0
    }
}

ChooseTrayIcon:
    IconResource := (g.Window.Icon != "") ? g.Window.Icon : g_IconPath
    IconIndex := g.Window.IconIndex
    If (ChooseIcon(IconResource, IconIndex, hPropWnd)) {
        StringReplace IconResource, IconResource, % A_WinDir . "\System32\"
        g.Window.Icon := g_IconPath := IconResource
        g.Window.IconIndex := IconIndex
        Gui Properties: Default
        GuiControl,, TrayIcon, % "*Icon" . IconIndex . " " . IconResource
        GuiControl,, ChkTrayIcon, 1
    }
Return

ChooseBGColor:
    Gui Properties: Submit, NoHide
    Color := "0xF0F0F0"
    If (ChooseColor(Color, hPropWnd)) {
        GuiControl +Background%Color%, ColorPreview
        GuiControl,, ChkBGColor, 1
        If (Color = 0XFFFFFF) {
            Color := "White"
        }
        g.Window.Color := "" . Color
    }
Return

; Update the drop-down list
Properties_Reload() {
    Gui Properties: Default
    GuiControl,, CbxClassNN, |Window||

    LastControl := ""
    WinGet ControlList, ControlList, ahk_id %hChildWnd%
    Loop Parse, ControlList, `n
    {
        ; Omit the Edit inside a ComboBox
        If (LastControl ~= "ComboBox" && A_LoopField ~= "^Edit") {
            GuiControlGet hComboBox, %Child%: hWnd, %LastControl%
            GuiControlGet hEdit, %Child%: hWnd, %A_LoopField%
            If (hComboBox = hEdit) {
                Continue
            }
        }

        If (A_LoopField ~= "SysHeader|AtlAxWin") {
            Continue
        }

        If (A_LoopField = "msctls_statusbar321") {
            If !(IsWindowVisible(GetHandle(A_LoopField))) {
                Continue
            }
        }

        GuiControlGet hWnd, %Child%: hWnd, %A_LoopField%

        If (IsGripper(hWnd)) {
            Continue
        }

        g[hWnd].ClassNN := A_LoopField
        Properties_AddItem(A_LoopField)
        LastControl := A_LoopField
    }
    GoSub OnDropDownChange
}

ShowIconPath:
    If (!Icon := g.Window.Icon) {
        Icon := A_AhkPath    
    }
    MsgBox 0x2040, Icon Location, % Icon . ", " . g.Window.IconIndex
Return

SetOption:
    MenuItem := A_ThisMenuItem
    If ((Option := ControlOptions[MenuItem]) == "Explorer") {
        GoSub SetOptionEx
        Return
    }
    Options := g[g_Control].Options

    FoundPos := InStr(Options, Option)
    If (FoundPos) {
        Menu ControlOptionsMenu, Uncheck, %MenuItem%
        StringReplace Options, Options, % (FoundPos > 1) ? " " . Option : Option
        Options := Trim(Options)
        g[g_Control].Options := Options
        Try {
            GuiControl %Child%: -%Option%, %g_Control%
        }
    } Else {
        If (Option == "Uppercase") {
            Options := RegExReplace(Options, "\s?Lowercase")
        } Else If (Option == "Lowercase") {
            Options := RegExReplace(Options, "\s?Uppercase")
        }
        Menu ControlOptionsMenu, Check, %MenuItem%
        Options := Options . Space(Options) . Option
        g[g_Control].Options := Options
        GuiControl %Child%: %Option%, %g_Control%
    }

    If (g[g_Control].ClassNN = Properties_GetClassNN()) {
        GuiControl, Properties:, EdtOptions, % Options
    }
    GenerateCode()
Return

; Windows Explorer Theme for ListViews and TreeViews
SetOptionEx:
    If (!NT6) {
        MsgBox 0x2010, AutoGUI, This option requires Windows Vista or higher.
        Return
    }

    If (InStr(g[g_Control].Extra, "Explorer")) {
        g[g_Control].Extra := ""
    } Else {
        g[g_Control].Extra := "Explorer"
        If (g[g_Control].hWndVar == "") {
            CtlType := (g[g_Control].Type == "ListView") ? "LV" : "TV"
            g[g_Control].hWndVar := "h" . CtlType . SubStr(g[g_Control].ClassNN, 14)
            GuiControl, Properties:, EdtHWndVar, % g[g_Control].hWndVar
        }
    }
    GenerateCode()
Return

SetListViewMode:
    ViewMode := A_ThisMenuItem
    Options := g[g_Control].Options
    RegEx := "(Report|List|IconSmall|Icon|Tile)"
    If (ViewMode = "Icons") {
        ViewMode := "Icon"
    } Else If (ViewMode = "Small Icons") {
        ViewMode := "IconSmall"
    }

    If (RegExMatch(Options, RegEx)) {
        Options := RegExReplace(Options, RegEx, ViewMode)
    } Else {
        Options .= Space(Options) . ViewMode
    }

    g[g_Control].Options := Options
    GenerateCode()

    If (g[g_Control].ClassNN = Properties_GetClassNN()) {
        GuiControl, Properties:, EdtOptions, % Options
    }
Return

AlignText:
    GuiControl %Child%: +%A_ThisMenuItem%, %g_Control%
    GuiControl MoveDraw, %g_Control%

    Options := g[g_Control].Options
    RegEx := "(Left|Center|Right)"
    If (RegExMatch(Options, RegEx)) {
        Options := RegExReplace(Options, RegEx, A_ThisMenuItem)
    } Else {
        Options .= Space(Options) . A_ThisMenuItem
    }

    If (g[g_Control].ClassNN = Properties_GetClassNN()) {
        GuiControl, Properties:, EdtOptions, % Options
    }

    g[g_Control].Options := Options
    GenerateCode()
Return

ShowOptionsTab:
    If (g_Control = "") {
        g_Control := g.LastControl
    }
    GoSub ShowProperties
    GuiControl Choose, %hPropTab%, 2
    Sleep 250
    GoSub ShowContextMenu
Return

ShowWindowOptions:
    GoSub ShowProperties
    GuiControl Choose, %hPropTab%, 3
Return

Space(String) {
    Return (String != "") ? " " : ""
}

Properties_AddItem(ClassNN) {
    GuiControl, Properties:, CbxClassNN, %ClassNN%
}

Properties_GetClassNN() {
    GuiControlGet ClassNN, Properties:, %hCbxClassNN%
    Return ClassNN
}

Properties_GetHandle() {
    GuiControlGet ClassNN, Properties:, %hCbxClassNN%
    GuiControlGet hWnd, %Child%: hWnd, %ClassNN%
    Return hWnd
}

ShowWindowProperties:
    g_Control := ""
    GoSub ShowProperties
Return
