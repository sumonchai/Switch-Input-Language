#NoEnv
#Warn
SetWorkingDir %A_ScriptDir%

Menu Tray, Icon, Notepad.exe

Menu, FileMenu, Add, &New`tCtrl+N, MenuHandler
Menu, FileMenu, Add, &Open...`tCtrl+O, MenuHandler
Menu, FileMenu, Add, &Save`tCtrl+S, MenuHandler
Menu, FileMenu, Add, Save &As..., MenuHandler
Menu, FileMenu, Add
Menu, FileMenu, Add, Page Set&up..., MenuHandler
Menu, FileMenu, Add, &Print...`tCtrl+P, MenuHandler
Menu, FileMenu, Add
Menu, FileMenu, Add, E&xit, MenuHandler

Menu, EditMenu, Add, &Undo`tCtrl+Z, MenuHandler
Menu, EditMenu, Disable, &Undo`tCtrl+Z
Menu, EditMenu, Add
Menu, EditMenu, Add, Cut&`tCtrl+X, MenuHandler
Menu, EditMenu, Disable, Cut&`tCtrl+X
Menu, EditMenu, Add, &Copy`tCtrl+C, MenuHandler
Menu, EditMenu, Disable, &Copy`tCtrl+C
Menu, EditMenu, Add, &Paste`tCtrl+V, MenuHandler
Menu, EditMenu, Add, De&lete`tDel, MenuHandler
Menu, EditMenu, Disable, De&lete`tDel
Menu, EditMenu, Add
Menu, EditMenu, Add, &Find...`tCtrl+F, MenuHandler
Menu, EditMenu, Disable, &Find...`tCtrl+F
Menu, EditMenu, Add, Find &Next`tF3, MenuHandler
Menu, EditMenu, Disable, Find &Next`tF3
Menu, EditMenu, Add, &Replace...`tCtrl+H, MenuHandler
Menu, EditMenu, Add, &Go To...`tCtrl+G, MenuHandler
Menu, EditMenu, Disable, &Go To...`tCtrl+G
Menu, EditMenu, Add
Menu, EditMenu, Add, Select &All`tCtrl+A, MenuHandler
Menu, EditMenu, Add, Time/&Date`tF5, MenuHandler

Menu, FormatMenu, Add, &Word Wrap, MenuHandler
Menu, FormatMenu, Check, &Word Wrap
Menu, FormatMenu, Add, &Font..., MenuHandler

Menu, ViewMenu, Add, &Status Bar, MenuHandler
Menu, ViewMenu, Check, &Status Bar
Menu, ViewMenu, Disable, &Status Bar

Menu, HelpMenu, Add, View &Help, MenuHandler
Menu, HelpMenu, Add
Menu, HelpMenu, Add, &About Notepad, MenuHandler

Menu MenuBar, Add, File, :FileMenu
Menu MenuBar, Add, Edit, :EditMenu
Menu MenuBar, Add, Format, :FormatMenu
Menu MenuBar, Add, View, :ViewMenu
Menu MenuBar, Add, Help, :HelpMenu
Gui Menu, MenuBar

Gui Font, s10, Lucida Console
Gui Add, Edit, x0 y0 w797 h445 0x50200104
Gui Font

Gui Font, s9, Ms Shell Dlg 2
Gui Add, StatusBar, x0 y445 w797 h23 0x54000000
SB_SetParts(598)
SB_SetText("  Ln 1, Col 1", 2)
Gui Show, w797 h468, Untitled - Notepad - Sample GUI
Return

MenuHandler:
Return

GuiEscape:
GuiClose:
    ExitApp
