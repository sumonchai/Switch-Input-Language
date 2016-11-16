ShowFontDialog:
    If !(IsWindowVisible(hFontDlg)) {
        Gui FontDlg: New, LabelFontDlg hWndhFontDlg -MinimizeBox OwnerAuto
        Gui Color, 0xFEFEFE
    
        Gui Add, CheckBox, vChkFontName gPreviewFont x12 y12 w120 h23, Font name:
        Gui Add, Edit, vEdtFontName gDisplayFontName x12 y38 w120 h23, Ms Shell Dlg
        Gui Add, ListBox, vLbxFontName gDisplayFontName x12 y66 w120 h160 -HScroll
        LoadFonts()

        Gui Add, CheckBox, vChkFontWeight gPreviewFont x142 y12 w100 h23, Weight:
        Gui Add, Edit, vEdtFontWeight gDisplayFontWeight x142 y38 w100 h23, Norm
        Gui Add, ListBox, vLbxFontWeight gDisplayFontWeight x142 y66 w100 h43, Regular|Semibold|Bold
        
        Gui Add, CheckBox, vChkFontSize gPreviewFont x250 y12 w60 h23, Size:
        Gui Add, Edit, vEdtFontSize gDisplayFontSize x250 y38 w60 h23, 8
        Gui Add, ListBox, vLbxFontSize gDisplayFontSize x250 y66 w60 h160, 8|9|10|11|12|13|14|15|16|17|18|20
        
        Gui Add, CheckBox, vChkFontColor gPreviewFont x316 y12 w60 h23, Color:
        Gui Add, ListView, vFontColorPreview gChooseFontColor x404 y14 w16 h16 -Hdr +Border +BackgroundBlack AltSubmit
        Gui Add, ComboBox, vCbxFontColor gDisplayFontColor x316 y38 w106, Black||0x003399
        Gui Add, ListBox, vLbxFontColor gDisplayFontColor x316 y66 w107 h160, Black|Blue|Navy|Green|Teal|Olive|Maroon|Red|Purple|Fuchsia|Lime|Yellow|Aqua|Gray|Silver|White
    
        Gui Add, CheckBox, vChkItalic gPreviewFont x142 y112 w100 h23, Italic
        Gui Add, CheckBox, vChkUnderline gPreviewFont x142 y134 w100 h23, Underline
        Gui Add, CheckBox, vChkStrikeout gPreviewFont x142 y156 w100 h23, Strikeout
        Gui Add, CheckBox, vChkQuality gPreviewFont x142 y180 w100 h21, Quality:
        Gui Add, DropDownList, vCbxQuality gCheckQuality x142 y205 w100 AltSubmit, Default||Draft|Proof|Non-antialiased|Antialiased|Cleartype
        
        Gui Add, Text, vSampleText x12 y234 w413 h44 +0x201 +E0x200, Automation. Hotkeys. Scripting
        
        Gui Add, ListView, x-1 y286 w437 h49 -Hdr Disabled
        Gui Add, Button, gFontDlgOK x140 y298 w75 h23 Default, OK
        Gui Add, Button, gFontDlgClose x220 y298 w75 h23, Cancel
        
        Gui Show, w435 h334, Font
        SetIconEx(hFontDlg, IconLib, 19)
    } Else {
        Gui FontDlg: Show
    }
    SetModalWindow(True)

    If (A_Gui == "Properties") {
        GuiControlGet g_Control, %Child%: hWnd, % Properties_GetClassNN()
    }

    GoSub PopulateDialogFields
Return

FontDlgEscape:
FontDlgClose:
    SetModalWindow(False)
    Gui FontDlg: Cancel
Return

LoadFonts() {
    Fonts := ["Ms Shell Dlg"
    , "Ms Shell Dlg 2"
    , "Segoe UI"
    , "Tahoma"
    , "Microsft Sans Serif"
    , "Verdana"
    , "Trebuchet MS"
    , "Arial"
    , "Lucida Console"
    , "Consolas"
    , "Courier New"
    , "Comic Sans MS"
    , "Segoe Print"
    , "Segoe Script"
    , "Georgia"
    , "FixedSys"
    , "MS Sans Serif"
    , "Impact"
    , "Palatino Linotype"
    , "Times New Roman"
    , "Source Code Pro"
    , "Calibri"
    , "Meiryo"
    , "Webdings"
    , "Wingdings"]
    Loop % Fonts.MaxIndex() {
        GuiControl,, LbxFontName, % Fonts[A_Index]
    }
}

PreviewFont:
    Gui FontDlg: Default

    Gui Font ; Reset
    GuiControl Font, SampleText

    GetFontOptions(FontName, Options)

    Separator := ""
    If (Options != "" && FontName != "") {
        Separator := ", "
    }

    Gui +LastFound
    WinSetTitle % "Font: " . FontName . Separator . Options

    If (Options != "" || FontName != "") {
        Gui Font, %Options%, %FontName%
        GuiControl Font, SampleText
    }
Return

DisplayFontName:
    Gui FontDlg: Submit, NoHide
    GuiControl,, ChkFontName, 1
    If (A_GuiControl != "EdtFontName") {
        GuiControl,, EdtFontName, % LbxFontName
    } Else {
        GuiControl ChooseString, LbxFontName, % EdtFontName
    }
    GoSub PreviewFont
Return

DisplayFontWeight:
    Gui FontDlg: Submit, NoHide
    GuiControl,, ChkFontWeight, 1
    If (A_GuiControl != "EdtFontWeight") {
        Weight := LbxFontWeight
        If (Weight == "Regular") {
            Weight := "Norm"
        } Else If (Weight == "Semibold") {
            Weight := "600"
        } Else {
            Weight := "Bold"
        }
        GuiControl,, EdtFontWeight, % Weight
    } Else {
        Weight := EdtFontWeight
        If Weight is Integer
        {
            If (Weight < 551) {
                Weight := "Regular"
            } Else If (Weight > 550 && Weight < 612) {
                Weight := "Semibold"
            } Else {
                Weight := "Bold"
            }
        }
        GuiControl ChooseString, LbxFontWeight, % Weight
    }
    GoSub PreviewFont
Return

CheckQuality:
    GuiControl,, ChkQuality, 1
    GoSub PreviewFont
Return

DisplayFontSize:
    Gui FontDlg: Submit, NoHide
    GuiControl,, ChkFontSize, 1
    If (A_GuiControl != "EdtFontSize") {
        GuiControl,, EdtFontSize, % LbxFontSize
    } Else {
        GuiControl ChooseString, LbxFontSize, % EdtFontSize
    }
    GoSub PreviewFont
Return

DisplayFontColor:
    Gui FontDlg: Submit, NoHide
    GuiControl,, ChkFontColor, 1
    If (A_GuiControl != "CbxFontColor") {
        GuiControl Text, CbxFontColor, %LbxFontColor%
    }
    GoSub PreviewFont
Return

ChooseFontColor:
    If (A_GuiEvent == "Normal") {
        FontColor := "0x0080C0"
        If (ChooseColor(FontColor, hFontDlg)) {
            Gui FontDlg: Default
            GuiControl +Background%FontColor%, FontColorPreview
            GuiControl Text, CbxFontColor, %FontColor%
            GuiControl,, ChkFontColor, 1
            GoSub PreviewFont
        }
    }
Return

GetFontOptions(ByRef FontName, ByRef Options) {
    Global

    Gui FontDlg: Default
    Gui Submit, NoHide

    FontName := "", Options := ""

    If (ChkFontName) {
        FontName := EdtFontName
    }
    If (ChkFontSize) {
        If (EdtFontSize != "") {
            Options .= "s" . EdtFontSize . " "
        }
    }
    If (ChkFontWeight) {
        If EdtFontWeight is Integer
            Options .= "w"
        Options .= EdtFontWeight . " "
    }
    If (ChkItalic) {
        Options .= "Italic "
    }
    If (ChkUnderline) {
        Options .= "Underline "
    }
    If (ChkStrikeout) {
        Options .= "Strike "
    }
    If (ChkQuality) {
        Options .= "q" . (CbxQuality - 1) . " "
    }
    If (ChkFontColor) {
        If (CbxFontColor != "") {
            Options .= "c" . CbxFontColor
            GuiControl +Background%CbxFontColor%, FontColorPreview
        }
    }
    Options := RTrim(Options)
}

FontDlgOK:
    GetFontOptions(FontName, FontOptions)

    Gui %Child%: Default
    Gui Font, %FontOptions%, %FontName%

    Separator := ""
    If (FontOptions != "" && FontName != "") {
        Separator := ", "
    }

    ClassNN := Properties_GetClassNN()
    If (g_Control == "") {
        g.Window.FontName := FontName
        g.Window.FontOptions := FontOptions

        For Each, Item in g.ControlList {
            If (g[Item].FontName == "" && g[Item].FontOptions == "") {
                GuiControl Font, %Item%
            }
        }

        If (ClassNN == "Window") {
            GuiControl, Properties:, EdtFont, % FontName . Separator . FontOptions
        }
    } Else {
        GuiControl Font, %g_Control%

        g[g_Control].FontName := FontName
        g[g_Control].FontOptions := FontOptions

        If (ClassNN == g[g_Control].ClassNN) {
            GuiControl, Properties:, EdtFont, % FontName . Separator . FontOptions
        }
    }

    Gui Font
    GenerateCode()
    GoSub FontDlgClose
Return

PopulateDialogFields:
    FontName := (g_Control != "") ? g[g_Control].FontName : g.Window.FontName
    If (FontName != "") {
        GuiControl,, ChkFontName, 1
        GuiControl,, EdtFontName, % FontName
        GuiControl ChooseString, LbxFontName, % FontName
    }
    Options := (g_Control != "") ? g[g_Control].FontOptions : g.Window.FontOptions
    If (Options != "") {
        Options := StrSplit(Options, " ")
        Loop % Options.MaxIndex() {
            If (Options[A_Index] ~= "^w") {
                FontWeight := SubStr(Options[A_Index], 2)
                GuiControl,, ChkFontWeight, 1
                GuiControl,, EdtFontWeight, % FontWeight
                If (FontWeight < 551) {
                    GuiControl ChooseString, LbxFontWeight, Regular
                } Else If (FontWeight > 550 && FontWeight < 612) {
                    GuiControl ChooseString, LbxFontWeight, Semibold
                } Else {
                    GuiControl ChooseString, LbxFontWeight, Bold
                }
            }
            If (Options[A_Index] = "Bold") {
                GuiControl,, ChkFontWeight, 1
                GuiControl,, EdtFontWeight, Bold
                GuiControl ChooseString, LbxFontWeight, Bold
            }
            If (Options[A_Index] = "Italic") {
                GuiControl,, ChkItalic, 1
            }
            If (Options[A_Index] = "Underline") {
                GuiControl,, ChkUnderline, 1
            }
            If (Options[A_Index] = "Strike") {
                GuiControl,, ChkStrikeout, 1
            }
            If (Options[A_Index] ~= "^q") {
                FontQuality := SubStr(Options[A_Index], 2)
                GuiControl,, ChkQuality, 1
                GuiControl Choose, CbxQuality, % (FontQuality + 1)
            }
            If (Options[A_Index] ~= "^s") {
                FontSize := SubStr(Options[A_Index], 2)
                GuiControl,, ChkFontSize, 1
                GuiControl,, EdtFontSize, % FontSize
                GuiControl ChooseString, LbxFontSize, % FontSize
            }
            If (Options[A_Index] ~= "^c") {
                FontColor := SubStr(Options[A_Index], 2)
                GuiControl,, ChkFontColor, 1
                GuiControl ChooseString, LbxFontColor, % FontColor
                GuiControl Text, CbxFontColor, %FontColor%
            }
        }
    }
    GoSub PreviewFont
Return
