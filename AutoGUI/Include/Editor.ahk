SetSci(n, Lexer := 200) { ; SCLEX_AHKL
    Sci[n].SetLexer(Lexer)
    Sci[n].SetCodePage(65001)
    Sci[n].SetIndent(TabSize)
    Sci[n].SetTabWidth(TabSize)
    Sci[n].SetWrapMode(1)
    Sci[n].MarginLength := 2
    SciSetStyle(n, Sci.FontName, Sci.FontSize)    
    Sci[n].Notify := "OnWM_NOTIFY"
    Sci[n].2525(2) ; SCI_SETEXTRAASCENT

    If (ShowSymbols) {
        ShowSymbols := False
        GoSub ToggleSymbols
    }
}

SciSetStyle(n, FontName := "Lucida Console", FontSize := 10) {
    If (LineNumbers) {
        MarginWidth := CalculateMarginWidth(Sci[n].GetLineCount(), FontName, FontSize)
    } Else {
        MarginWidth := 0
    }

    Sci[n].StyleSetFont(STYLE_DEFAULT, FontName)
    Sci[n].StyleSetSize(STYLE_DEFAULT, FontSize)

    Sci[n].StyleClearAll()

    ; Background color
    Loop % 33 {
        Sci[n].StyleSetBack(A_Index - 1, 0xFAFAFA)
    }

    ; Active line background color
    Sci[n].SetCaretLineBack(0xFFFFFF)
    ;Sci[n].SetCaretLineBack(0xEFF8FE) ; Light blue
    Sci[n].SetCaretLineVisible(True)

    ; Margin settings
    Sci[n].SetMarginTypeN(0, 1)
    Sci[n].SetMarginWidthN(0, MarginWidth) ; Line number width
    Sci[n].SetMarginWidthN(1, 2)           ; Line number right margin
    Sci[n].SetMarginLeft(0, 2)             ; Left padding
    Sci[n].StyleSetFore(33, "0xCFD2CA")    ; Margin foreground color
    Sci[n].StyleSetBack(33, "0xFFFFFF")    ; Margin background color

    ; Selection
    Sci[n].SetSelFore(1, "0xFFFFFF")
    Sci[n].SetSelBack(1, "0x3399FF")

    ; Matching braces
    Sci[n].StyleSetFore(STYLE_BRACELIGHT, 0x3399FF)
    Sci[n].StyleSetBold(STYLE_BRACELIGHT, True)
    Sci[n].StyleSetFore(STYLE_BRACEBAD  , 0x00EE00)

    ; AHK syntax elements
    Sci[n].StyleSetFore(SCE_AHKL_IDENTIFIER     , 0x000000)
    Sci[n].StyleSetFore(SCE_AHKL_COMMENTDOC     , 0x008888)
    Sci[n].StyleSetFore(SCE_AHKL_COMMENTLINE    , 0x969896)
    Sci[n].StyleSetFore(SCE_AHKL_COMMENTBLOCK   , 0x969896)
    Sci[n].StyleSetFore(SCE_AHKL_COMMENTKEYWORD , 0xA50000)
    Sci[n].StyleSetFore(SCE_AHKL_STRING         , 0x183691)
    Sci[n].StyleSetFore(SCE_AHKL_STRINGOPTS     , 0x0000EE)
    Sci[n].StyleSetFore(SCE_AHKL_STRINGBLOCK    , 0x183691)
    Sci[n].StyleSetFore(SCE_AHKL_STRINGCOMMENT  , 0xFF0000)
    Sci[n].StyleSetFore(SCE_AHKL_LABEL          , 0x0000DD)
    Sci[n].StyleSetFore(SCE_AHKL_HOTKEY         , 0x00AADD)
    Sci[n].StyleSetFore(SCE_AHKL_HOTSTRING      , 0x00BBBB)
    Sci[n].StyleSetFore(SCE_AHKL_HOTSTRINGOPT   , 0x990099)
    Sci[n].StyleSetFore(SCE_AHKL_HEXNUMBER      , 0x880088)
    Sci[n].StyleSetFore(SCE_AHKL_DECNUMBER      , 0x606870)
    Sci[n].StyleSetFore(SCE_AHKL_VAR            , 0x9F1F6F)
    Sci[n].StyleSetFore(SCE_AHKL_VARREF         , 0x990055)
    Sci[n].StyleSetFore(SCE_AHKL_OBJECT         , 0x008888)
    Sci[n].StyleSetFore(SCE_AHKL_USERFUNCTION   , 0x0000DD)
    Sci[n].StyleSetFore(SCE_AHKL_DIRECTIVE      , 0x0000CF)
    Sci[n].StyleSetFore(SCE_AHKL_COMMAND        , 0x0080C0)
    Sci[n].StyleSetFore(SCE_AHKL_PARAM          , 0x0080C0)
    Sci[n].StyleSetFore(SCE_AHKL_CONTROLFLOW    , 0x0000DD)
    Sci[n].StyleSetFore(SCE_AHKL_BUILTINFUNCTION, 0x0F707F)
    Sci[n].StyleSetFore(SCE_AHKL_BUILTINVAR     , 0x9F1F6F)
    Sci[n].StyleSetFore(SCE_AHKL_KEY            , 0xA2A2A2)
    Sci[n].StyleSetFore(SCE_AHKL_USERDEFINED1   , 0x000000)
    Sci[n].StyleSetFore(SCE_AHKL_USERDEFINED2   , 0x000000)
    Sci[n].StyleSetFore(SCE_AHKL_ESCAPESEQ      , 0x660000)
    ;Sci[n].StyleSetFore(SCE_AHKL_ERROR          , 0xFF0000)

    ; Keywords
    Sci[n].SetKeywords(0, Keywords.Directives)
    Sci[n].SetKeywords(1, Keywords.Commands)
    Sci[n].SetKeywords(2, Keywords.Parameters)
    Sci[n].SetKeywords(3, Keywords.ControlFlow)
    Sci[n].SetKeywords(4, Keywords.Functions)
    Sci[n].SetKeywords(5, Keywords.BuiltinVariables)
    Sci[n].SetKeywords(6, Keywords.Keys)
    Sci[n].SetKeywords(7, Keywords.UserDefined1)
    Sci[n].SetKeywords(8, Keywords.UserDefined2)

    Sci[n].Styled := True
}

NewTab:
    NewTab()
Return

NewTab() {
    Static TabCounter := 1
    TabCounter++
    TabIndex := TabEx.GetCount() + 1
    Sci[TabIndex] := New Scintilla
    x := (DesignMode) ? 169 : 7
    Sci[TabIndex].Add(hAutoWnd, x, 56, 576, 420, SciLexer, 0x50010000, 0)
    SetSci(TabIndex)
    TabEx.SetIcon(TabEx.Add("Untitled " . TabCounter), 1)
    TabEx.SetSel(TabIndex)
    GoSub AutoSize
    Return TabIndex
}

DuplicateTab:
    Sci[g_TabIndex].GetText(Sci[g_TabIndex].GetLength() + 1, SciText)
    Sci[NewTab()].SetText("", SciText)
Return

CloseTab:
    CloseTab(TabEx.GetSel())
Return

CloseTabN:
    CloseTab(g_TabIndex)
Return

CloseTab(TabIndex) {
    If (Sci[TabIndex].GetModify()) {
        TabEx.SetSel(TabIndex)
        TabCaption := TabEx.GetText(TabIndex)
        Gui Auto: +OwnDialogs
        MsgBox 0x33, %TabCaption%, The file was modified. Do you want to save it?
        IfMsgBox Yes, {
            If (!Save()) {
                Return
            }
        } Else IfMsgBox Cancel, {
            Return
        }
    }

    If (TabIndex == g_GuiTab) {
        g_GuiTab := 0
    }

    If (TabEx.GetCount() > 1) {
        SendMessage 0x1308, % TabIndex - 1, 0,, ahk_id %hTab% ; TCM_DELETEITEM
        DestroyWindow(Sci[TabIndex].hWnd)
        Sci.Remove(TabIndex)
        If (TabIndex > 1) {
            TabIndex -= 1    
        }
    } Else {
        ClearFile(1)
    }

    TabEx.SetSel(TabIndex)
}

ClearFile(n) {
    Sci[n].FullFileName := ""
    Sci[n].FileName := ""
    Sci[n].ClearAll()
    Sci[n].SetSavePoint()
    TabEx.SetIcon(n, 1)
}

ToggleReadOnly() {
    ToggleReadOnly:
    n := TabEx.GetSel()
    ReadOnly := !Sci[n].GetReadOnly()
    sci[n].SetReadOnly(ReadOnly)
    Menu AutoOptionsMenu, ToggleCheck, &Read Only
    SendMessage TB_CHECKBUTTON, 2170, ReadOnly,, ahk_id %hEditorTB%
    If (WinActive("ahk_id" . hAutoWnd)) {
        If (ReadOnly) {
            SB_SetText("Read only", 3)
        } Else {
            If (Sci[n].GetModify()) {
                SB_SetText("Modified", 3)
            } Else {
                SB_SetText("", 3)
            }
        }
    }
    Return
}

ToggleWrapMode() {
    ToggleWordWrap:
    n := TabEx.GetSel()
    WrapMode := Sci[n].GetWrapMode()
    sci[n].SetWrapMode(!WrapMode)
    Menu AutoOptionsMenu, ToggleCheck, &Word Wrap
    SendMessage TB_CHECKBUTTON, 2160, !WrapMode,, ahk_id %hEditorTB%
    Return
}

/*
ToggleLineNumbers() {
    ToggleLineNumbers:
    n := TabEx.GetSel()

    If (Sci[n].GetMarginWidthN(0)) {
        MarginWidth := 0
        MarginColor := 0xFAFAFA
        LineNumbers := False
    } Else {
        MarginWidth := CalculateMarginWidth(Sci[n].GetLineCount(), Sci.FontName, Sci.FontSize)
        MarginColor := 0xE8E4E0
        LineNumbers := True
    }

    Loop % Sci.MaxIndex() {
        Sci[A_Index].SetMarginWidthN(0, MarginWidth)
        Sci[A_Index].StyleSetBack(33, MarginColor)
    }

    ;LineNumbers := !LineNumbers
    Menu AutoOptionsMenu, ToggleCheck, &Line Numbers
    Return
}
*/

ToggleLineNumbers:
    LineNumbers := !LineNumbers
    SetLineNumbersMargin(LineNumbers)
    ;Menu AutoOptionsMenu, ToggleCheck, &Line Numbers
Return

SetLineNumbersMargin(bVisible) {
    Loop % Sci.MaxIndex() {
        If (bVisible) {
            Width := CalculateMarginWidth(Sci[A_Index].GetLineCount(), Sci.FontName, Sci.FontSize)
        } Else {
            Width := 0
        }
        Sci[A_Index].SetMarginWidthN(0, Width)
        ;Sci[A_Index].StyleSetBack(33, BGColor) 
        ;Sci[A_Index].StyleSetFore(33, FGColor)
    }

    If (LineNumbers := bVisible) {
        Menu AutoOptionsMenu, Check, &Line Numbers
    } Else {
        Menu AutoOptionsMenu, Uncheck, &Line Numbers
    }
}

ToggleSyntaxHighlighting:
    ToggleSyntaxHighlighting(TabEx.GetSel())
Return

ToggleSyntaxHighlighting(n) {
    If (Sci[n].Styled) {
        Sci[n].StyleClearAll()
        Sci[n].StyleSetFore(33, "0xCFD2CA") ; Margin foreground color
        Sci[n].StyleSetBack(33, "0xFFFFFF") ; Margin background color
        Sci[n].Styled := False
        If (!LineNumbers) {
            Loop % Sci.MaxIndex() {
                Sci[A_Index].SetMarginWidthN(0, 0)
            }
        }
    } Else {
        SciSetStyle(n, Sci.FontName, Sci.FontSize)
    }

    Menu AutoOptionsMenu, ToggleCheck, Syntax &Highlighting
    SendMessage TB_CHECKBUTTON, 2180, % Sci[n].Styled,, ahk_id %hEditorTB%
    Return
}

ToggleAutoBrackets() {
    ToggleAutoBrackets:
    AutoBrackets := !AutoBrackets
    Menu AutoOptionsMenu, ToggleCheck, Autocomplete &Brackets
    Return
}

SciUndo:
    Sci[TabEx.GetSel()].Undo()
Return

SciRedo:
    Sci[TabEx.GetSel()].Redo()
Return

SciCut:
    Sci[TabEx.GetSel()].Cut()
Return

SciCopy:
    Sci[TabEx.GetSel()].Copy()
Return

SciPaste:
    Sci[TabEx.GetSel()].Paste()
Return

SciClear:
    Sci[TabEx.GetSel()].Clear()
Return

SciSelectAll:
    Sci[TabEx.GetSel()].SelectAll()
Return

SciLowercase:
    Sci[TabEx.GetSel()].LowerCase()
Return

SciUppercase:
    Sci[TabEx.GetSel()].UpperCase()
Return

SciTitleCase:
    n := TabEx.GetSel()
    Start := Sci[n].GetSelectionStart()
    End := Sci[n].GetSelectionEnd()
    Sci[n].GetTextRange([Start, End], Selection)
    StringUpper Selection, Selection, T
    Sci[n].ReplaceSel("", Selection)
    Sci[n].SetSel(Start, End)
Return

OnWM_NOTIFY(wParam, lParam, msg, hWnd, obj) {

    n := TabEx.GetSel()
    CurPos := Sci[n].GetCurrentPos()

    If (obj.SCNCode == SCN_UPDATEUI) {

        bm := Sci[n].BraceMatch(CurPos - 1, 0)

        If (bm != -1) {
            Sci[n].BraceHighlight(CurPos - 1, bm)
        } Else {
            Sci[n].BraceHighlight(-1, Sci[n].GetLength())
        }

        GoSub UpdateStatusBar

    } Else If (obj.SCNCode == SCN_MODIFIED) {

        GoSub UpdateStatusBar
        AdjustMarginWidth()

    } Else If (obj.SCNCode == SCN_SAVEPOINTREACHED) {

        SetDocumentStatus(n)

    } Else If (obj.SCNCode == SCN_SAVEPOINTLEFT) {

        SetDocumentStatus(n)

    } Else If (obj.SCNCode == SCN_CHARADDED) {
        If (!AutoBrackets) {
            Return
        }

        PrevChar := Sci[n].GetCharAt(CurPos - 2)
        NextChar := Sci[n].GetCharAt(CurPos)

        ; Autocomplete brackets ([{""}])
        If (obj.ch == 40 && NextChar != 41) { ; Parenthesis
            Sci[n].InsertText(CurPos, ")")
        } Else If (obj.ch == 91 && NextChar != 93) { ; Brackets
            Sci[n].InsertText(CurPos, "]")
        } Else If (obj.ch == 123 && NextChar != 125) { ; Braces
            Sci[n].GetTextRange([CurPos - 5, CurPos], PrevChars)
            If (RegExMatch(PrevChars, "\(\)\s?\n?")) {
                Sci[n].InsertText(CurPos, "`n`t`n}")
                Sci[n].GoToPos(CurPos + 2)
            } Else {
                Sci[n].InsertText(CurPos, "}")
            }
        } Else If (obj.ch == 34  ; Quotes
            && (NextChar == 0
            || NextChar == 9     ; Tab
            || NextChar == 32    ; Space
            || NextChar == 33    ; Exclamation mark
            || NextChar == 41    ; Close parenthesis
            || NextChar == 44    ; Comma
            || NextChar == 46    ; Period
            || NextChar == 58    ; Colon
            || NextChar == 59    ; Semicolon
            || NextChar == 63    ; Question mark
            || NextChar == 93    ; Right bracket
            || NextChar == 125)  ; Right brace
            && (PrevChar == 0
            || PrevChar == 9
            || PrevChar == 10    ; New line
            || PrevChar == 32
            || PrevChar == 40    ; Open parenthesis
            || PrevChar == 91    ; Left bracket
            || PrevChar == 123)) ; Left brace
        {
            Sci[n].InsertText(CurPos, """")
        }
    }

    Return
}

ShowSearchDialog:
    If !(WinExist("ahk_id " . hSearchDlg)) {
        Gui Search: New, LabelSearch hWndhSearchDlg -MinimizeBox OwnerAuto
        Gui Search: Default
        Gui Add, Text, x16 y19 w37 h23, What:
        Gui Add, ComboBox, vSearchTerm x61 y16 w224
        Gui Add, Button, gFindNext x292 y15 w81 h23 Default, &Find Next
        Gui Add, Button, gMenuHandler x292 y46 w81 h23 Disabled, Find &All

        Gui Add, CheckBox, vMatchCase x16 y45 w144 h23, Case Sensitive
        Gui Add, CheckBox, vWholeWord x16 y69 w144 h23, Match Whole Word Only
        Gui Add, CheckBox, vRegEx gUncheckBackslash x16 y93 w144 h23, Regular Expression
        Gui Add, CheckBox, vBackslash gUncheckRegex x16 y117 w144 h23, Backslashed Characters

        Gui Add, GroupBox, x176 y47 w109 h95, Direction
        Gui Add, Radio, gSetDirection vSearchDown x188 y65 w88 h23 Checked, Down
        Gui Add, Radio, gSetDirection vSearchUp x188 y88 w88 h22 Disabled, Up
        Gui Add, Radio, gSetDirection vCycleSearch x188 y110 w88 h23 Disabled, Cycle Search

        Gui Add, Button, gSearchClose x292 y78 w81 h23, &Cancel        
        Gui Show, w385 h152, Find
    } Else {
        Gui Search: Show
    }
Return

SciSearch(n, Start, End, String, Flags = "") {
    Sci[n].SetSearchFlags(Flags)
    Sci[n].SetTargetStart(Start)
    Sci[n].SetTargetEnd(End)
    Return Sci[n].SearchInTarget(StrLen(String), String)
}

FindNext:
    If (A_Gui == "Search") {
        Gui Search: Submit, NoHide
        SearchString := SearchTerm
    } Else If (A_Gui = "Replace"){
        Gui Replace: Submit, NoHide
        SearchString := SearchWhat
    }

    If (SearchString == "") {
        Return
    }

    If (Backslash) {
        StringReplace SearchString, SearchString, `\n, `n, All
        StringReplace SearchString, SearchString, `\t, % A_Tab, All
    }

    Flags := 0
    If (MatchCase) {
        Flags = 4
    }
    If (WholeWord) {
        Flags += 2
    }

    n := TabEx.GetSel()

    If (SearchDirection = "Down") {
        Start := Sci[n].GetCurrentPos()
        End := Sci[n].GetLength()
    } Else If (SearchDirection = "Up") {
        Start := Sci[n].GetLength()
        End := 0
    } Else { ; Beginning
        Sci[n].SetCurrentPos(0)
        SearchDirection := "Down"
        GoSub FindNext
    }

    If (RegEx) {
        Sci[n].GetText(Sci[n].GetLength() + 1, SciText)
        FoundPos := RegExMatch(SciText, "P)" . SearchString, Length, Start)
        FoundPos -= 1
    } Else {
        FoundPos := SciSearch(n, Start, End, SearchString, Flags)
        Length := StrLen(SearchString)
    }

    If (FoundPos = -1) {
        MsgBox 0x2040, AutoGUI, Search string not found: "%SearchString%"
        Return
    }

    Sci[n].SetSel(FoundPos, FoundPos + Length)
Return

SearchEscape:
SearchClose:
    Gui Search: Cancel
Return

UncheckBackslash:
    GuiControl, Search:, Backslash, 0
Return

UncheckRegex:
    GuiControl, Search:, Regex, 0
Return

SetDirection:
    Global SearchDirection
    GuiControlGet SearchDirection, %A_Gui%:, % A_GuiControl, Text
Return

ShowReplaceDialog:
    If !(WinExist("ahk_id " . hReplaceDlg)) {
        Gui Replace: New, LabelReplace hWndhReplaceDlg -MinimizeBox OwnerAuto
    
        Gui Add, Text, x16 y19 w37 h23, What:
        Gui Add, ComboBox, vSearchWhat x56 y17 w229
        Gui Add, Text, x15 y49 w37 h23, With:
        Gui Add, ComboBox, vReplaceWith x56 y46 w229
    
        Gui Add, CheckBox, vMatchCase x16 y78 w144 h23, Case Sensitive
        Gui Add, CheckBox, vWholeWord x16 y102 w144 h23, Match Whole Word Only
        Gui Add, CheckBox, vRegEx x16 y126 w144 h23, Regular Expression
        Gui Add, CheckBox, vBackslash x16 y150 w144 h23, Backslashed Characters
    
        Gui Add, GroupBox, x176 y80 w109 h95, Direction
        Gui Add, Radio, gSetDirection vReplaceDown x188 y98 w88 h23 Checked, Down
        Gui Add, Radio, gSetDirection vReplaceUp x188 y121 w88 h22, Up
        Gui Add, Radio, gSetDirection vReplaceFromBeginning x188 y143 w88 h23, Beginning
    
        Gui Add, Button, gFindNext x292 y15 w81 h23 Default, &Find Next
        Gui Add, Button, gReplace x292 y46 w81 h23, &Replace
        Gui Add, Button, gMenuHandler x292 y77 w81 h23, Replace &All
        Gui Add, Button, gReplaceClose x292 y108 w81 h23, &Cancel
        
        Gui Show, w385 h188, Replace
    } Else {
        Gui Replace: Show
    }
Return

ReplaceEscape:
ReplaceClose:
    Gui Replace: Cancel
Return

Replace:
    Gui Replace: Submit, NoHide
    n := TabEx.GetSel()
    If (Sci[n].GetSelText(0, 0) > 1) {
        Sci[n].ReplaceSel(0, ReplaceWith)
    }
    GoSub FindNext
Return

ReplaceAll:
Return

ShowGoToLineDialog:
    Gui GoToDlg: New, LabelGoTo hWndhGoToDlg -MinimizeBox OwnerAuto
    Gui Color, White
    Gui Font, s10 c0552C5 q4, Segoe UI
    Gui Add, Text, x20 y18 w200 h16, Line Number:
    Gui Font
    Gui Add, Edit, vEdtGoTo x20 y40 w200 h23
    Gui Add, ListView, Disabled x0 y80 w240 h48 -E0x200
    Gui Add, Button, gGoTo x40 y94 w75 h23 Default, OK
    Gui Add, Button, gGoToClose x127 y94 w75 h23, Cancel
    Gui Show, w240 h129, Go To
Return

GoTo:
    Gui GoToDlg: Submit
    ShowChildWindow(0)
    n := TabEx.GetSel()
    ControlFocus,, % "ahk_id " . Sci[n].hWnd
    Sci[n].GoToLine(EdtGoTo - 1) ; 0-based index
Return

GoToEscape:
GoToClose:
    Gui GoToDlg: Cancel
Return

SciChangeFont:
    FontName := Sci.FontName
    FontSize := Sci.FontSize
    If (ChooseFont(FontName, FontSize, "", "0x000000", 0, hAutoWnd)) {
        Loop % Sci.MaxIndex() {
            SciSetStyle(A_Index, FontName, FontSize)
            ;Sci[A_Index].StyleSetFont(STYLE_DEFAULT, FontName)
            ;Sci[A_Index].StyleSetSize(STYLE_DEFAULT, FontSize)
        }
        Sci.FontName := FontName
        Sci.FontSize := FontSize
    }
Return

SetFontSize(NewSize) {
    Loop % Sci.MaxIndex() {
        SciSetStyle(A_Index, "", NewSize)
        If (LineNumbers) {
            MarginWidth := CalculateMarginWidth(Sci[A_Index].GetLineCount(), Sci.FontName, NewSize)
            Sci[A_Index].SetMarginWidthN(0, MarginWidth)
        }
    }
}

ZoomIn:
    n := TabEx.GetSel()
    NewSize := Sci[n].StyleGetSize(STYLE_DEFAULT) + 1
    SetFontSize(NewSize)
    Sci.FontSize := NewSize
Return

ZoomOut:
    n := TabEx.GetSel()
    NewSize := Sci[n].StyleGetSize(STYLE_DEFAULT) - 1
    SetFontSize(NewSize)
    Sci.FontSize := NewSize
Return

ResetFontSize:
    IniRead FontSize, %IniFile%, Editor, FontSize, 10
    SetFontSize(FontSize)
    Sci.FontSize := FontSize
Return

; Editor mode
UpdateStatusBar:
    If (!g_GuiSB) {
        n := TabEx.GetSel()
        CurPos := Sci[n].GetCurrentPos()
        Line := Sci[n].LineFromPosition(CurPos) + 1
        Column := Sci[n].GetColumn(CurPos) + 1

        Gui Auto: Default
        SB_SetText(Line . ":" . Column, 2)

        If (Sci[n].GetReadOnly()) {
            SB_SetText("Read only", 3)
        } Else If (Sci[n].GetModify()) {
            SB_SetText("Modified", 3)
        } Else {
            SB_SetText("", 3)
        }
    }
Return

SetDocumentStatus(n) {
    Gui Auto: Default

    If (Sci[n].GetReadOnly()) {
        If (!g_GuiSB) {
            SB_SetText("Read only", 2)
        }
    } Else If (Sci[n].GetModify()) {
        TabCaption := (Sci[n].FileName != "") ? Sci[n].FileName . " *" : "Untitled " . n . " *"
        TabEx.SetText(n, TabCaption)
        If (!g_GuiSB) {
            SB_SetText("Modified", 2)
        }
    } Else {
        TabCaption := (Sci[n].FileName != "") ? Sci[n].FileName : "Untitled " . n
        TabEx.SetText(n, TabCaption)
        If (!g_GuiSB) {
            SB_SetText("", 2)
        }
    }
}

CalculateMarginWidth(LineCount, FontName, FontSize) {
    If (LineCount < 100) {
        String := "99"
    } Else {
        String := ""
        LineCountLen := StrLen(LineCount)
        Loop % LineCountLen {
            String .= "9"
        }
    }
    Gui Auto: Default
    Gui Font, s%FontSize%, %FontName%
    Gui Add, Text, hWndhStatic x-100 y-100, %String%%A_Space%
    Gui Font
    GuiControlGet c, Pos, %hStatic%
    DestroyWindow(hStatic)
    Return cw
}

AdjustMarginWidth() {
    n := TabEx.GetSel()

    LineCount := Sci[n].GetLineCount()
    LineCountLen := StrLen(LineCount)
    If (LineCountLen < 2) {
        LineCountLen := 2
    }

    If (LineCountLen != Sci[n].MarginLength) {
        Sci[n].MarginLength := LineCountLen
        If (LineNumbers) {
            MarginWidth := CalculateMarginWidth(LineCount, Sci.FontName, Sci.FontSize)
            Sci[n].SetMarginWidthN(0, MarginWidth)
        }
    }
}

InsertDateTime:
    n := TabEx.GetSel()
    FormatTime TimeString, D1    
    Sci[n].InsertText(Sci[n].GetCurrentPos(), TimeString)
Return

; Show spaces, tabs and line breaks
ToggleSymbols:
    ShowSymbols := !ShowSymbols

    Loop % Sci.MaxIndex() {
        Sci[A_Index].2086(ShowSymbols ? 2 : 0) ; SCI_SETWHITESPACESIZE
        Sci[A_Index].SetViewWS(ShowSymbols)
        Sci[A_Index].SetViewEOL(ShowSymbols)
    }

    Menu AutoOptionsMenu, % ShowSymbols ? "Check" : "Uncheck", Show Symbols
Return

ToggleComment:
    n := TabEx.GetSel()
    SelText := GetSelectedText()

    If (SelText == "") {
        SelText := GetCurrentLine()
        CurrPos := Sci[n].GetCurrentPos()
        LineNum := Sci[n].LineFromPosition(CurrPos)
        StartPos := Sci[n].PositionFromLine(LineNum) ; Start of the line
        EndPos := Sci[n].GetLineEndPosition(LineNum)
        Sci[n].SetSel(StartPos, EndPos) ; Select current line
        RestorePos := True ; Restore caret position
    } Else {
        RestorePos := False
    }

    Lines := ""
    Loop Parse, SelText, `n, `r
    {
        If (RegExMatch(A_LoopField, "\s*\;")) {
            Line := RegExReplace(A_LoopField, "\;", "", "", 1)
        } Else If (A_LoopField == "") {
            Line := ""
        } Else {
            Line := ";" . A_LoopField
        }
        Lines .= Line . CRLF
    }

    Lines := RegExReplace(Lines, "`r`n$", "", "", 1)
    SetSelectedText(Lines)

    If (RestorePos) {
        Sci[n].GoToPos(CurrPos)
    }
Return

GetCurrentLine() {
    n := TabEx.GetSel()
    LineNum := Sci[n].LineFromPosition(Sci[n].GetCurrentPos())
    LineLen := Sci[n].LineLength(LineNum)
	VarSetCapacity(LineText, LineLen, 0)
    Sci[n].GetCurLine(LineLen + 1, LineText)
    Sci[n].GetCurLine(LineLen + 1, LineText)
    Return RTrim(LineText, CRLF)
}

DuplicateLine:
    Sci[TabEx.GetSel()].LineDuplicate()
Return

TransposeLine:
    Sci[TabEx.GetSel()].LineTranspose()    
Return

InsertCodeTags:
    n := TabEx.GetSel()
    FileName := (Sci[n].FileName != "") ? Sci[n].FileName : "Untitled"
    OpenTag  := "[code filename=" . FileName . "]"
    CloseTag := "[/code]"

    SelText := GetSelectedText()
    If (SelText != "") {
        SetSelectedText(OpenTag . SelText . CloseTag)
    } Else {
        Sci[n].BeginUndoAction()
        Sci[n].InsertText(0, OpenTag)
        Sci[n].AppendText(StrLen(CloseTag), CloseTag)
        Sci[n].EndUndoAction()
    }
Return
