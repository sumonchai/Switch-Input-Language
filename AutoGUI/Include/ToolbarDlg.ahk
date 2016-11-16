ShowToolbarDialog:
    If !(WinExist("ahk_id " . hToolbarDlg)) {
        TBarDlgIL := IL_Create(100) ; ListView ImageList
        IL_Add(TbarDlgIL, IconLib, 63)
        ImageList := IL_Create(100) ; Toolbar ImageList
        ILIndex := 0
    
        Gui ToolbarDlg: New, LabelToolbarDlg hWndhToolbarDlg -MinimizeBox OwnerAuto
        SetIconEx(hToolbarDlg, IconLib, 68)
        Gui Color, 0xFEFEFE
        Gui Add, Button, gShowToolbarAddItemDlg x8 y10 w82 h23 Default, &Add Item
        Gui Add, Button, gToolbarDlgAddSeparator x8 y40 w82 h23, &Separator
        Gui Add, Button, gMenuHandler x8 y70 w82 h23, &Edit
        Gui Add, Button, gToolbarDlgDelete x8 y100 w82 h23, &Delete
        Gui Add, Button, gToolbarDlgDeleteAll x8 y130 w82 h23, De&lete All
        Gui Add, ListView, x100 y9 w200 h220 NoSortHdr -Multi, Items
        LV_SetImageList(TbarDlgIL)
        Gui Add, GroupBox, x310 y3 w97 h227, Options
        Gui Add, CheckBox, vChkAdjustable x321 y21 w80 h20, Adjustable
        Gui Add, CheckBox, vChkBorder x321 y41 w80 h20, Border
        Gui Add, CheckBox, vChkBottom x321 y61 w80 h20, Bottom
        Gui Add, CheckBox, vChkFlat x321 y81 w80 h20 Checked, Flat
        Gui Add, CheckBox, vChkList x321 y101 w80 h20 Checked, List
        Gui Add, CheckBox, vChkMenu x321 y121 w80 h20, Menu
        Gui Add, CheckBox, vChkNoDivider x321 y141 w80 h20, No Divider
        Gui Add, CheckBox, vChkTabstop x321 y161 w80 h20, Tabstop
        Gui Add, CheckBox, vChkTooltips x321 y181 w80 h20 Checked, Tooltips
        Gui Add, CheckBox, vChkVertical x321 y201 w80 h20, Vertical
        Gui Add, ListView, x-1 y238 w418 h49 Disabled -Hdr
        Gui Add, Button, gToolbarDlgOK x128 y252 w75 h23, &OK
        Gui Add, Button, gToolbarDlgCancel x209 y252 w75 h23, &Cancel
        Gui Show, w416 h286, Toolbar Items and Options
    } Else {
        Gui ToolbarDlg: Show
    }
    Return

    ShowToolbarAddItemDlg:
        Gui ToolbarAddItemDlg: New, LabelToolbarAddItemDlg -MinimizeBox OwnerToolbarDlg
        Gui Color, White
        Gui Add, GroupBox, x10 y5 w335 h80
        Gui Add, Text, x21 y21 w54 h24 +0x200, Caption:
        Gui Add, Edit, vEdtCaption x79 y21 w252 h22
        Gui Add, Text, x21 y50 w55 h22 +0x200, Icon:
        Gui Add, ComboBox, vCbxIcon x79 y50 w197, % ""
            . A_WinDir . "\System32\shell32.dll||"
            . A_WinDir . "\System32\imageres.dll|"
            . A_WinDir . "\System32\mmcndmgr.dll"
        Gui Add, Edit, vEdtIconIndex x280 y50 w27 h21, 1
        Gui Add, Button, gToolbarItemChooseIcon x310 y49 w23 h23, ...
        Gui Add, ListView, x-1 y94 w356 h50 -Hdr Disabled
        Gui Add, Button, gToolbarAddItemDlgOK x97 y105 w75 h23 Default, OK
        Gui Add, Button, gToolbarAddItemDlgClose x182 y105 w75 h23, Cancel
        Gui Show, w354 h142, Add Toolbar Item
        Return

        ToolbarItemChooseIcon:
            Gui ToolbarAddItemDlg: Submit, NoHide
            IconResource := CbxIcon
            IconIndex := 1
            
            If (ChooseIcon(IconResource, IconIndex, hToolbarDlg)) {
                Gui ToolbarAddItemDlg: Default
                GuiControl,, CbxIcon, % IconResource . "||"
                GuiControl,, EdtIconIndex, % IconIndex
            }
        Return

        ToolbarAddItemDlgOK:
            Gui ToolbarAddItemDlg: Submit
            Gui ToolbarDlg: Default
            Gui ListView, SysListView321
            StringReplace IconResource, CbxIcon, %A_WinDir%\System32\
            IL_Add(ImageList, IconResource, EdtIconIndex)
            IL_Add(TBarDlgIL, IconResource, EdtIconIndex)
            g.ToolbarIcons.Insert([IconResource, EdtIconIndex])
            ILIndex += 1
            g.ToolbarIL := ImageList
            If (EdtCaption = "") {
                EdtCaption := "..."
            }
            LV_Add("Icon" . ILIndex + 1, EdtCaption)
        Return

        ToolbarAddItemDlgEscape:
        ToolbarAddItemDlgClose:
            Gui ToolbarAddItemDlg: Cancel
        Return
    Return

    ToolbarDlgAddSeparator:
        LV_Add("Icon1", "<separator>")
    Return
    
    ToolbarDlgDelete:
        RowNumber := LV_GetNext()
        LV_GetText(Text, RowNumber)
        LV_Delete(RowNumber)
        If (Text != "<separator>") {
            Separators := 0
            If (RowNumber > 1) {
                Loop % (RowNumber - 1) {
                    LV_GetText(Text, A_Index)
                    If (Text = "<separator>") {
                        Separators++
                    }
                }
            }
            g.ToolbarIcons.Remove(RowNumber - Separators)
    
            ; Recreate the ImageList
            IL_Destroy(ImageList)
            ImageList := IL_Create(100)
            For Each, Icon In g.ToolbarIcons {
                IL_Add(ImageList, Icon[1], Icon[2])
            }
        }
    Return

    ToolbarDlgDeleteAll:
        g.ToolbarIcons := []
        IL_Destroy(ImageList)
        ImageList := IL_Create(100)
        LV_Delete()
    Return

    ToolbarDlgOK:
        Gui ToolbarDlg: Submit, NoHide
        ToolbarOptions := ""
        If (ChkAdjustable) {
            ToolbarOptions .= " adjustable"
        }
        If (ChkBorder) {
            ToolbarOptions .= " border"
        }
        If (ChkBottom) {
            ToolbarOptions .= " bottom"
        }
        If (ChkFlat) {
            ToolbarOptions .= " flat"
        }
        If (ChkList) {
            ToolbarOptions .= " list"
        }
        If (ChkMenu) {
            ToolbarOptions .= " menu"
        }
        If (ChkNoDivider) {
            ToolbarOptions .= " nodivider"
        }
        If (ChkTabstop) {
            ToolbarOptions .= " tabstop"
        }
        If (ChkTooltips) {
            ToolbarOptions .= " tooltips"
        }
        If (ChkVertical) {
            ToolbarOptions .= " vertical"
        }
        g.ToolbarOptions := LTrim(ToolbarOptions)

        g.ToolbarItems := ""
        Loop % LV_GetCount() {
            LV_GetText(RetrievedText, A_Index)
            If (RetrievedText = "<separator>") {
                RetrievedText := "-"
            }
            g.ToolbarItems .= RetrievedText . "`n"
        }

        DestroyWindow(hChildToolbar)
        If (g.ToolbarItems != "") {
            AddToolbar(ImageList, g.ToolbarItems, ToolbarOptions)
    
            If (Script.Warn = "MsgBox") {
                Script.Warn := "OutputDebug"
                GuiControl, Properties: ChooseString, CbxWarn, OutputDebug
            }
        }
        Gui ToolbarDlg: Cancel
        GenerateCode()
    Return
    
    ToolbarDlgEscape:
    ToolbarDlgCancel:
        Gui ToolbarDlg: Cancel
    Return
Return
