GenerateCode() {
    Local Item

    If (!WinExist("ahk_id" . hChildWnd)) {
        GoSub NewGUI
    }

    Header := ""
    Code := ""

    If (Script.NoEnv) {
        Header .= "#NoEnv" . CRLF
    }
    If (Script.Warn != "") {
        Header .= (Script.Warn == "MsgBox") ? "#Warn" . CRLF : "#Warn,, " . Script.Warn . CRLF
    }
    If (Script.SingleInstance != "") {
        Header .= "#SingleInstance " . Script.SingleInstance . CRLF
    }
    If (Script.NoTrayIcon) {
        Header .= "#NoTrayIcon" . CRLF
    }
    If (Script.Persistent) {
        Header .= "#Persistent" . CRLF
    }
    If (Script.WorkingDir != "") {
        Header .= "SetWorkingDir " . Script.WorkingDir . CRLF
    }
    If (Script.SendMode != "") {
        Header .= "SendMode " . Script.SendMode . CRLF
    }
    If (Script.NoBatchLines) {
        Header .= "SetBatchLines -1" . CRLF
    }
    If (Script.ListLinesOff) {
        Header .= "ListLines Off" . CRLF
    }
    If (Script.IgnoreMenuErrors) {
        Header .= "Menu Tray, UseErrorLevel" . CRLF
    }
    If (g.Anchor) {
        Header .= "#Include %A_ScriptDir%\AutoXYWH.ahk" . CRLF
    }
    If (ToolbarExist()) {
        Header .= "#Include %A_ScriptDir%\Toolbar.ahk" . CRLF
        If (g.Window.hWndVar == "") {
            g.Window.hWndVar := "hGui"
        }
    }
    If (Header != "") {
        Header .= CRLF
    }

    If (g.Window.Icon != "") {
        Code .= "Menu Tray, Icon, " . g.Window.Icon . ((g.Window.IconIndex > 1) ? ", " . g.Window.IconIndex : "") . CRLF
    }

    GuiOptions := "", ows := False, owxs := False
    GuiOptions .= (g.Window.Label != "") ? " Label" . g.Window.Label : ""
    GuiOptions .= (g.Window.hWndVar != "") ? " hWnd" . g.Window.hWndVar : ""
    GuiOptions .= (g.Window.Options != "") ? " " . g.Window.Options : ""
    GuiOptions .= (g.Window.Extra != "") ? " " . g.Window.Extra : ""

    If (SubStr(g.Window.Style, 1, 1) == "0") {
        ows := True
    } Else {
        GuiOptions .= (g.Window.Style != "") ? " " . g.Window.Style : ""
    }
    If (SubStr(g.Window.ExStyle, 1, 1) == "E") {
        owxs := True
    } Else {
        GuiOptions .= (g.Window.ExStyle != "") ? " " . g.Window.ExStyle : ""
    }

    If (GuiOptions != "") {
        GuiOptions := "," . GuiOptions
    }

    GuiName := (g.Window.Name != "") ? g.Window.Name . ": " : ""

    If (GuiName != "" || GuiOptions != "") {
        Code .= "Gui " . GuiName . "New" . GuiOptions . CRLF
    }

    Spc := Space(g.Window.FontOptions)
    Sep := (g.Window.FontName != "") ? ", " : ""
    If (g.Window.FontOptions != "" || g.Window.FontName != "") {
        GuiFont := "Gui Font," . Spc . g.Window.FontOptions . Sep . g.Window.FontName . CRLF
        Code .= GuiFont
    } Else {
        GuiFont := ""
    }

    If (g.Window.Color != "") {
        Code .= "Gui Color, " . g.Window.Color . CRLF
    }

    If (m.Code != "") {
        Code .= m.Code
    }

    OrderTabItems()

    For Each, Item in g.ControlList {
        If (g[Item].Deleted == False) {
            If (g[Item].Text == "") {
                ControlGetText Text,, ahk_id %Item%
            } Else {
                Text := g[Item].Text
            }

            Gui %Child%: Default

            GuiControlGet c, %Child%: Pos, %Item%

            If (g[Item].Tab[1] != "") {
                If (g[Item].Tab[1] != PreviousTab[1] || g[Item].Tab[2] != PreviousTab[2]) {
                    If (g[Item].Tab[2] == 1) {
                        Code .= "Gui Tab, " . g[Item].Tab[1] . CRLF
                    } Else {
                        Code .= "Gui Tab, " . g[Item].Tab[1] . ", " . g[Item].Tab[2] . CRLF
                    }
                }
            }

            PreviousTab := g[Item].Tab

            fFont := False
            Spc := Space(g[Item].FontOptions)
            Sep := (g[Item].FontName != "") ? ", " : ""
            If (g[Item].FontOptions != "" || g[Item].FontName != "") {
                fFont := True
                If (GuiFont != "") {
                    Code .= "Gui Font" . CRLF
                }
                Code .= "Gui Font," . Spc . g[Item].FontOptions . Sep . g[Item].FontName . CRLF
            }

            Code .= "Gui Add, " . g[Item].Type . ", "

            If (g[Item].hWndVar != "") {
                Code .= "hWnd" . g[Item].hWndVar . " "
            }

            If (g[Item].vVar != "") {
                Code .= "v" . g[Item].vVar . " "
            }

            If (g[Item].gLabel != "") {
                Code .= "g" . g[Item].gLabel . " "
            }

            Code .= "x" . cX . " y" . cY . " w" . cW

            If !(g[Item].Type == "ComboBox" || g[Item].Type == "DropDownList") {
                Code .= " h" . cH
            }

            If (g[Item].Style != "") {
                Code .= " " . g[Item].Style
            }

            If (g[Item].ExStyle != "") {
                Code .= " " . g[Item].ExStyle
            }

            If (g[Item].Options) {
                Code .= " " . Trim(g[Item].Options)
            }

            If (Text != "") {
                Code .= ", " . Text
            }

            Code .= CRLF

            If (fFont) {
                Code .= "Gui Font" . CRLF
                If (GuiFont != "" && A_Index != g.ControlList.MaxIndex()) {
                    Code .= GuiFont
                }
            }

            If (g[Item].Extra == "Explorer") {
                Code .= "DllCall(""UxTheme.dll\SetWindowTheme"", ""Ptr"", "
                     . g[Item].hWndVar . ", ""WStr"", ""Explorer"", ""Ptr"", 0)" . CRLF
            }
        }
    }

    GetWindowSize(hChildWnd, wx, wy, ww, wh)
    Position := (g.Window.Center) ? "" : "x" . wX . " y" . wY . " "
    Code .= "Gui Show, " . Position . "w" . ww . " h" . wh

    If (g.Window.Title != "") {
        Code .= ", " . g.Window.Title
    }
    Code .= CRLF

    If (ows) {
        Code .= "WinSet Style, " . g.Window.Style . ", " . g.Window.Title . CRLF
        Code .= "WinSet Redraw,, " . g.Window.Title . CRLF
    }
    If (owxs) {
        Code .= "WinSet ExStyle, " . SubStr(g.Window.ExStyle, 2) . ", " . g.Window.Title . CRLF
        Code .= "WinSet Redraw,, " . g.Window.Title . CRLF
    }

    If (ToolbarExist()) {
        Code .= "GuiAddToolBar(hGui)" . CRLF
    }

    If (NoReturn == False) {
        Code .= "Return" . CRLF
    }

    If (m.Code != "" && !NoReturn) {
        Code .= CRLF . "MenuHandler:`nReturn" . CRLF
    }

    If (g.Window.Label == "") {
        Label := (g.Window.Name != "") ? g.Window.Name . "Gui" : "Gui"
    } Else {
        Label := g.Window.Label
    }

    Minimized := CRLF . "    If (A_EventInfo == 1) {" . CRLF . "        Return" . CRLF . "    }"

    If (g.Anchor) {
        Code .= CRLF . Label . "Size:" . Minimized
        For Each, hCtrl In g.ControlList {
            If (g[hCtrl].Anchor != "" && !g[hCtrl].Deleted) {
                Code .= CRLF . CRLF . Indent . "AutoXYWH(""" . g[hCtrl].Anchor . """, " . g[hCtrl].hWndVar . ")"
            }
        }
        Code .= CRLF . "Return" . CRLF
    } Else If (g.Window.GuiSize && !g.Anchor) {
        Code .= CRLF . Label . "Size:" . Minimized . CRLF . "Return" . CRLF
    }

    If (g.Window.GuiContextMenu) {
        Code .= CRLF . Label . "ContextMenu:" . CRLF
            If (m.Context != "") {
                Code .= "`tMenu " . m[ContextMenuId].Command . ", Show" . CRLF
            }
        Code .= "Return" . CRLF
    }

    If (g.Window.GuiDropFiles) {
        Code .= CRLF . Label . "DropFiles:" . CRLF . "Return" . CRLF
    }

    If (g.Window.OnClipboardChange) {
        Code .= CRLF . "OnClipboardChange:" . CRLF . "Return" . CRLF
    }

    If (g.Window.GuiEscape) {
        Code .= CRLF . Label . "Escape:"
    }

    If (g.Window.GuiClose) {
        Code .= CRLF . Label . "Close:" . CRLF . Indent . "ExitApp" . CRLF
    }

    If (g.Window.GuiEscape && !g.Window.GuiClose) {
        Code .= CRLF . "Return" . CRLF
    }

    If (ToolbarExist()) {
        Code .= CRLF . "GuiAddToolbar(hWnd) {" . CRLF
        Code .= Indent . "ImageList := IL_Create(" . g.ToolbarIcons.MaxIndex() . ")" . CRLF
        For Each, Icon In g.ToolbarIcons {
            Code .= Indent . "IL_Add(ImageList, """ . Icon[1] . """, " . Icon[2] . ")" . CRLF
        }
        Code .= Indent . "hToolbar := Toolbar_Add(hWnd, ""OnToolbar"", """ . g.ToolbarOptions . """, ImageList)" . CRLF
        ToolbarItems := ""
        TempVar := g.ToolbarItems
        Loop Parse, TempVar, `n
        {
            If (A_LoopField == "") {
                Continue
            }

            ToolbarItems .= Indent . Indent . A_LoopField . CRLF
        }
        Code .= Indent . "Buttons = " . CRLF . Indent . "(LTrim" . CRLF . ToolbarItems . Indent . ")" . CRLF
        Code .= Indent . "Toolbar_Insert(hToolbar, Buttons)" . CRLF . "}" . CRLF . CRLF
        Code .= "OnToolbar(hWnd, Event, Text, Pos, Id) {" . CRLF
        Code .= Indent . "If (Event = ""Hot"") {" . CRLF . "`t`tReturn" . CRLF . Indent . "}" . CRLF . "}" . CRLF
    }

    Code .= CRLF . Delimiter

    Sci[g_GuiTab].GetText(Sci[g_GuiTab].GetLength() + 1, SciText)
    If (StartingPos := InStr(SciText, Delimiter)) {
        Code .= SubStr(SciText, StartingPos + StrLen(Delimiter))
    }

    Sci[g_GuiTab].BeginUndoAction()
    Sci[g_GuiTab].ClearAll()
    Sci[g_GuiTab].SetText("", Header . Code)
    Sci[g_GuiTab].EndUndoAction()

    Header := ""
    Code := ""
    SciText := ""
}
