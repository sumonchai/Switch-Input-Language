ShowStylesDialog:
    If (A_GuiControl == "BtnChangeStyle" || A_GuiControl == "BtnChangeExStyle") {
        g_Control := Properties_GetHandle()
    }
    Type := g[g_Control].Type

    Gui StylesDlg: New, LabelStylesDlg hWndhStylesDlg -MinimizeBox OwnerAuto
    Try {
        Gui Add, % "Tab3", hWndhStylesTab vStylesTab x7 y7 w284 h285 AltSubmit, Styles|Extended Styles
    } Catch {
        Gui Add, Tab2, hWndhStylesTab vStylesTab x7 y7 w284 h285 0x54012200 AltSubmit +Theme, Styles|Extended Styles
        Control Style, 0x54010040,, ahk_id %hStylesTab%
    }
    Gui Tab, 1
        Gui Add, Text, x21 y42 w36 h19 +BackgroundTrans +E0x20, Mode:
        Gui Add, DropDownList, vCbxStyleMode gChangeStyleMode x57 y37 w80, Add||Remove|Overwrite
        Gui Add, Edit, vEdtStyle x195 y37 w86 h23 ReadOnly
        Gui Add, ListBox, hWndhLbxStyles gSumStyles x16 y68 w265 h212 T90 +0x8
    Gui Tab, 2
        Gui Add, Text, x21 y42 w36 h19 +BackgroundTrans +E0x20, Mode:
        Gui Add, DropDownList, vCbxExStyleMode gChangeStyleMode x57 y37 w80, Add||Remove|Overwrite
        If (Type == "ListView") {
            ; CheckBox for extended ListView styles
            Gui Add, CheckBox, vChkLVEX gLoadExStyles x150 y35 w30 h23 Checked, LV
        }
        Gui Add, Edit, vEdtExStyle x195 y37 w86 h23 ReadOnly
        Gui Add, ListBox, hWndhLbxExStyles gSumExStyles x16 y68 w265 h212 T90 +0x8
    Gui Tab

    Gui Add, Button, gResetStyles x8 y303 w90 h23, &Reset
    Gui Add, Button, gStylesDlgClose x104 y303 w90 h23, &Close
    Gui Add, Button, gApplyStyle x200 y303 w90 h23 Default, &Apply

    Gui Show, w298 h336, % ((Type != "") ? Type : "Window") . " Styles"
    SetIconEx(hStylesDlg, IconLib, 18)
    SetModalWindow(True)

    If (Type != "") {
        If (g[g_Control].Class == "Button") {
            Type := "Button"
        } Else If (Type == "Picture") {
            Type := "Text"
        } Else If (Type == "DropDownList") {
            Type := "ComboBox"
        }

        IniRead Styles, %A_ScriptDir%\Include\styles.ini, %Type%
        Loop Parse, Styles, `n
        {
            StringSplit Field, A_LoopField, `=
            If (StrLen(Field1) > 22) {
                Field1 := SubStr(Field1, 1, 22) . "..."
            }
            GuiControl,, %hLbxStyles%, % Field1 . "`t" . Field2
        }
    }

    ; Common window styles
    IniRead Window, %A_ScriptDir%\Include\styles.ini, Window
    Loop Parse, Window, `n
    {
        StringSplit Field, A_LoopField, `=
        GuiControl,, %hLbxStyles%, % Field1 . "`t" . Field2
    }

    GoSub LoadExStyles

    If (A_GuiControl == "BtnChangeExStyle") {
        GuiControl Choose, %hStylesTab%, 2
    }
Return

StylesDlgEscape:
StylesDlgClose:
    SetModalWindow(False)
    Gui StylesDlg: Destroy
Return

SumStyles:
    GuiControlGet Items,, %hLbxStyles%
    SetFormat Integer, H
    Sum := 0
    Loop Parse, Items, |
    {
        StringSplit Field, A_LoopField, `t
        Sum |= Field2
    }
    SetFormat Integer, D
    GuiControl,, EdtStyle, % Sum
Return

SumExStyles:
    GuiControlGet Items,, %hLbxExStyles%
    SetFormat Integer, H
    Sum := 0
    Loop Parse, Items, |
    {
        StringSplit Field, A_LoopField, `t
        Sum |= Field2
    }
    SetFormat Integer, D
    GuiControl,, EdtExStyle, % Sum
Return

ApplyStyle:
    Gui StylesDlg: Submit, NoHide
    
    If (StylesTab == 1) {
        If (EdtStyle) {
            If (CbxStyleMode == "Add") {
                Prefix := "+"
            } Else If (CbxStyleMode == "Remove") {
                Prefix := "-"
            } Else { ; Overwrite
                Prefix := ""
            }
    
            Style := Prefix . EdtStyle
        } Else {
            Style := ""
        }

        If (g_Control == "") {
            g.Window.Style := Style
        } Else {
            g[g_Control].Style := Style
            If (Style) {
                Control Style, %Style%,, ahk_id %g_Control%
            }
        }

        GuiControl, Properties:, EdtStyle, %Style%
    } Else If (StylesTab == 2) {
        If (EdtExStyle) {
            E := (ChkLVEX) ? "LV" : "E"
            If (CbxExStyleMode == "Add") {
                Prefix := "+" . E
            } Else If (CbxExStyleMode == "Remove") {
                Prefix := "-" . E
            } Else {
                Prefix := E
            }
        
            ExStyle := Prefix . EdtExStyle
        } Else {
            ExStyle := ""
        }

        If (g_Control == "") {
            g.Window.ExStyle := ExStyle
        } Else {
            g[g_Control].ExStyle := ExStyle
            If (ExStyle) {
                Control ExStyle, % ExStyle,, ahk_id %g_Control%
            }
        }

        GuiControl, Properties:, EdtExStyle, %ExStyle%
    }

    Repaint(g_Control)
    GenerateCode()
Return

ResetStyles:
    Gui StylesDlg: Submit, NoHide
    If (StylesTab == 1) {
        GuiControl,, EdtStyle, 0
        GuiControl Choose, %hLbxStyles%, 0
    } Else {
        GuiControl,, EdtExStyle, 0
        GuiControl Choose, %hLbxExStyles%, 0
    }
Return

LoadExStyles:
    Gui StylesDlg: Submit, NoHide

/*
LV: Specify the string LV followed immediately by the number of an extended ListView style. These styles are entirely separate from generic extended styles. For example, specifying -E0x200 would remove the generic extended style WS_EX_CLIENTEDGE to eliminate the control's default border. By contrast, specifying -LV0x20 would remove LVS_EX_FULLROWSELECT.
*/

    If (ChkLVEX && Type == "ListView") {
        GuiControl,, %hLbxExStyles%, | ; Empty the list
        IniRead ListViewEx, %A_ScriptDir%\Include\styles.ini, ListViewEx
        Loop Parse, ListViewEx, `n
        {
            StringSplit, Field, A_LoopField, `=
            If (Field1 == "LVS_EX_TRANSPARENTSHADOWTEXT") {
                Field1 := "LVS_EX_TRANSPARENTSHADO..."
            }
            GuiControl,, %hLbxExStyles%, % Field1 . "`t" . Field2
        }
    } Else {
        GuiControl,, %hLbxExStyles%, |
        IniRead WindowEx, %A_ScriptDir%\Include\styles.ini, WindowEx
        Loop Parse, WindowEx, `n
        {
            StringSplit Field, A_LoopField, `=
            GuiControl,, %hLbxExStyles%, % Field1 . "`t" . Field2
        }
    }

    If (Type == "ListView") {
        GoSub ChangeStyleMode
    }
Return

ChangeStyleMode:
    Gui StylesDlg: Default
    Gui Submit, NoHide

    If (A_GuiControl == "CbxStyleMode") {
        If (CbxStyleMode == "Overwrite") {
            s := GetStyle()
            GuiControl,, EdtStyle, % s

            ControlGet Items, List,,, ahk_id %hLbxStyles%
            Loop Parse, Items, `n
            {
                StringSplit Field, A_LoopField, `t
                If (Type == "Button" || Type == "Text" || Type == "ComboBox" || Type == "DateTime") {
                    If (Field2 < 16) {
                        If ((Field2 & 0xF) == (s & 0xF)) {
                            GuiControl Choose, %hLbxStyles%, %A_Index%
                        }
                        Continue
                    }
                }
                If ((s & Field2) || Field2 == 0x00000000) {
                    GuiControl Choose, %hLbxStyles%, %A_Index%
                }
            }
    
            SendMessage 0x115, 6, 0,, ahk_id%hLbxStyles% ; Scroll to top
        }
    } Else {
        If (CbxExStyleMode == "Overwrite") {
            xs := GetExStyle(ChkLVEX)
            GuiControl,, EdtExStyle, % xs
    
            ControlGet Items, List,,, ahk_id %hLbxExStyles%
            Loop Parse, Items, `n
            {
                StringSplit Field, A_LoopField, `t
                If ((xs & Field2) || Field2 == 0x00000000) {
                    GuiControl Choose, %hLbxExStyles%, %A_Index%
                }
            }
    
            SendMessage 0x115, 6, 0,, ahk_id%hLbxStyles% ; Scroll to top
        }
    }
Return

GetStyle() {
    If (g_Control == "" || g_Control == hChildWnd) {
        WinGet Style, Style, ahk_id %hChildWnd%
    } Else {
        ControlGet Style, Style,,, ahk_id %g_Control%
    }

    Return Style
}

GetExStyle(LVEX := False) {
    If (g_Control == "" || g_Control == hChildWnd) {
        WinGet ExStyle, ExStyle, ahk_id %hChildWnd%
    } Else {
        If (LVEX) {
            SendMessage 0x1037, 0, 0,, ahk_id %g_Control% ; LVM_GETEXTENDEDLISTVIEWSTYLE
            ExStyle := ToHex(ErrorLevel)
        } Else {
            ControlGet ExStyle, ExStyle,,, ahk_id %g_Control%
        }
    }

    Return ExStyle
}
