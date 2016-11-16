LoadSettings() {
    ;OutputDebug Loading settings from: %IniFile%

    IniRead OpenDir, %IniFile%, Options, OpenDir, %A_MyDocuments%
    IniRead SaveDir, %IniFile%, Options, SaveDir, %A_MyDocuments%
    IniRead CodePage, %IniFile%, Options, CodePage, UTF-8
    FileEncoding % (CodePage = "ANSI") ? "CP1252" : CodePage

    IniRead DesignMode, %IniFile%, Options, DesignMode, 1
    IniRead ShowGrid, %IniFile%, Options, ShowGrid, 1
    IniRead SnapToGrid, %IniFile%, Options, SnapToGrid, 0
    IniRead GridSize, %IniFile%, Options, GridSize, 8
    IniRead NoGrippers, %IniFile%, Options, NoGrippers, 0

    IniRead AltAhkPath, %IniFile%, Options, AltRun, Undefined
    IniRead SysTrayIcon, %IniFile%, Options, TrayIcon, 0
    If (SysTrayIcon) {
        Menu Tray, Tip, % AppName . " v" . Version
    } Else {
        Menu Tray, NoIcon
    }

    IniRead FontName, %IniFile%, Editor, FontName, Lucida Console
    Sci.FontName := FontName
    IniRead FontSize, %IniFile%, Editor, FontSize, 10
    Sci.FontSize := FontSize

    IniRead TabSize, %IniFile%, Editor, TabSize, 4
    Loop % TabSize {
        Indent .= " "
    }

    IniRead LineNumbers, %IniFile%, Editor, LineNumbers, 1
    IniRead WordWrap, %IniFile%, Editor, WordWrap, 1
    IniRead SyntaxHighlighting, %IniFile%, Editor, SyntaxHighlighting, 1
    IniRead AutoBrackets, %IniFile%, Editor, AutoBrackets, 1

    IniRead Backup, %IniFile%, Backup, Enabled, 1
    IniRead BkpDir, %IniFile%, Backup, Dir, %A_Temp%\AutoGUI
}

ApplySettings() {
    If (DesignMode) {
        hMenu := GetSubMenu(GetMenu(hAutoWnd), 7)    ; Options Menu
        CheckMenuRadioItem(hMenu, !DesignMode, 0, 1) ; Design Mode checked
        SendMessage TB_CHECKBUTTON, 1060, %DesignMode%,, ahk_id %hToolbar%
    }

    If (ShowGrid) {
        Menu AutoOptionsMenu, Check, Show &Grid
        SendMessage TB_CHECKBUTTON, 1080, 1,, ahk_id %hToolbar%
    }

    If (SnapToGrid) {
        Menu AutoOptionsMenu, Check, S&nap to Grid
        SendMessage TB_CHECKBUTTON, 1090, 1,, ahk_id %hToolbar%
    }

    If (WordWrap) {
        Menu AutoOptionsMenu, Check, &Word Wrap
        SendMessage TB_CHECKBUTTON, 2160, 1,, ahk_id %hEditorTB%
    }

    If (SyntaxHighlighting) {
        Menu AutoOptionsMenu, Check, Syntax &Highlighting
        SendMessage TB_CHECKBUTTON, 2180, 1,, ahk_id %hEditorTB%
    }

    If (LineNumbers) {
        Menu AutoOptionsMenu, Check, &Line Numbers
    }
}

SaveSettings() {
    If (!FileExist(IniFile)) {
        Sections := "[Options]`n`n[Auto]`n`n[Properties]`n`n[Editor]`n`n[Backup]`n`n[Recent]`n"
        FileAppend %Sections%, %IniFile%, UTF-16
    }

    IniWrite %OpenDir%, %IniFile%, Options, OpenDir
    IniWrite %SaveDir%, %IniFile%, Options, SaveDir
    IniWrite %CodePage%, %IniFile%, Options, CodePage
    IniWrite %SysTrayIcon%, %IniFile%, Options, TrayIcon

    ; GUI designer options
    IniWrite %DesignMode%, %IniFile%, Options, DesignMode
    IniWrite %ShowGrid%, %IniFile%, Options, ShowGrid
    IniWrite %SnapToGrid%, %IniFile%, Options, SnapToGrid
    IniWrite %GridSize%, %IniFile%, Options, GridSize
    IniWrite %NoGrippers%, %IniFile%, Options, NoGrippers

    If (AltAhkPath != "") {
        IniWrite %AltAhkPath%, %IniFile%, Options, AltRun
    }

    ; Main window position and size
    Pos := GetWindowPosition(hAutoWnd)
    IniWrite % Pos.x, %IniFile%, Auto, x
    IniWrite % Pos.y, %IniFile%, Auto, y
    IniWrite % Pos.w, %IniFile%, Auto, w
    IniWrite % Pos.h, %IniFile%, Auto, h
    IniWrite % Pos.showCmd, %IniFile%, Auto, Show

    ; Properties dialog position
    If (WinExist("ahk_id " . hPropWnd)) {
        WinGetPos px, py,,, ahk_id %hPropWnd%
        IniWrite %px%, %IniFile%, Properties, x
        IniWrite %py%, %IniFile%, Properties, y
    }

    ; Editor options
    IniWrite % Sci.FontName, %IniFile%, Editor, FontName
    IniWrite % Sci.FontSize, %IniFile%, Editor, FontSize
    IniWrite %TabSize%, %IniFile%, Editor, TabSize
    IniWrite %WordWrap%, %IniFile%, Editor, WordWrap
    IniWrite %SyntaxHighlighting%, %IniFile%, Editor, SyntaxHighlighting
    IniWrite %AutoBrackets%, %IniFile%, Editor, AutoBrackets
    IniWrite %LineNumbers%, %IniFile%, Editor, LineNumbers

    ; Backup
    IniWrite %Backup%, %IniFile%, Backup, Enabled
    IniWrite %BkpDir%, %IniFile%, Backup, Dir

    ; Recent files
    If (RecentFiles.MaxIndex() > 0) {
        For Index, Filename In RecentFiles {
            IniWrite %Filename%, %IniFile%, Recent, %Index%
        }
    }
}
