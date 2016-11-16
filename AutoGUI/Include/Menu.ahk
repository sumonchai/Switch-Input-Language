; File Menu
AppendMenu("AutoFileMenu", "New &GUI`tCtrl+P", "NewGUI", IconLib, 6)
Loop Samples\*.ahk {
    AppendMenu("SamplesMenu", A_LoopFileName, "OpenSample", A_AhkPath, 2)
}
Menu SamplesMenu, Add
AppendMenu("SamplesMenu", "&Open Samples Folder", "OpenSamplesFolder", IconLib, 9)
AppendMenu("AutoFileMenu", "Sa&mples", ":SamplesMenu")
Menu AutoFileMenu, Add
AppendMenu("AutoFileMenu", "&New File`tCtrl+N", "NewTab", IconLib, 7)
AppendMenu("AutoFileMenu", "&Close File`tCtrl+W", "CloseTab", IconLib, 8)
Menu AutoFileMenu, Add
AppendMenu("AutoFileMenu", "&Open File...`tCtrl+O", "OpenFile", IconLib, 9)
Menu AutoFileMenu, Add, Recent &Files, MenuHandler
Menu AutoFileMenu, Disable, Recent &Files
Menu AutoFileMenu, Icon, Recent &Files, Icons\Recent.ico
Menu AutoFileMenu, Add
AppendMenu("AutoFileMenu", "Import G&UI...`tCtrl+I", "ImportGUI", IconLib, 40)
Menu AutoFileMenu, Add
AppendMenu("AutoFileMenu", "&Save`tCtrl+S", "Save", IconLib, 10)
AppendMenu("AutoFileMenu", "Save &As...`tCtrl+Shift+S", "SaveAs")
;AppendMenu("AutoFileMenu", "Copy to Clip&board", "CopyToClipboard", IconLib, 11)
Menu AutoFileMenu, Add
AppendMenu("AutoFileMenu", "Com&pile...", "Compile", IconLib, 13)
Menu AutoFileMenu, Add
AppendMenu("AutoFileMenu", "E&xit`tAlt+Q", "AutoClose")

; Edit Menu
Menu AutoEditMenu, Add, &Undo`tCtrl+Z, SciUndo
Menu AutoEditMenu, Add, R&edo`tCtrl+Y, SciRedo
Menu AutoEditMenu, Add
Menu AutoEditMenu, Add, Cu&t`tCtrl+X, SciCut
Menu AutoEditMenu, Add, &Copy`tCtrl+C, SciCopy
Menu AutoEditMenu, Add, &Paste`tCtrl+V, SciPaste
Menu AutoEditMenu, Add, &Delete`tDel, SciClear
Menu AutoEditMenu, Add, Select &All`tCtrl+A, SciSelectAll
Menu AutoEditMenu, Add
Menu AutoEditMenu, Add, &Find...`tCtrl+F, ShowSearchDialog
Menu AutoEditMenu, Add, Find &Next`tF3, FindNext
Menu AutoEditMenu, Add, &Replace...`tCtrl+H, ShowReplaceDialog
Menu AutoEditMenu, Add, &Go to Line...`tCtrl+G, ShowGoToLineDialog
Menu AutoEditMenu, Add
Menu AutoEditMenu, Add, &Insert Date and Time`tCtrl+D, InsertDateTime

; Convert Menu
Menu AutoConvertMenu, Add, &UPPERCASE`tCtrl+Shift+U, SciUppercase
Menu AutoConvertMenu, Add, &lowercase`tCtrl+Shift+L, SciLowercase
Menu AutoConvertMenu, Add, &Title Case`tCtrl+Shift+T, SciTitleCase
Menu AutoConvertMenu, Add
Menu AutoConvertMenu, Add, Decimal to &Hexadecimal`tCtrl+Shift+X, Dec2Hex
Menu AutoConvertMenu, Add, Hexadecimal to &Decimal`tCtrl+Shift+D, Hex2Dec
Menu AutoConvertMenu, Add
Menu AutoConvertMenu, Add, Constant: Declare`tCtrl+M, ReplaceConstant
Menu AutoConvertMenu, Add, Constant: SendMessage`tCtrl+Shift+M, ReplaceConstant
Menu AutoConvertMenu, Add, Constant: OnMessage`tAlt+M, ReplaceConstant
Menu AutoConvertMenu, Add
Menu AutoConvertMenu, Add, Comment/Uncomment`tCtrl+K, ToggleComment
Menu AutoConvertMenu, Add
Menu AutoConvertMenu, Add, Enclose in Forum [code] Tags, InsertCodeTags

; Control Menu (menu bar)
AppendMenu("AutoControlMenu", "Change Text...", "ChangeText", IconLib, 14)
Menu AutoControlMenu, Add
AppendMenu("AutoControlMenu", "Cut", "Cut", IconLib, 15)
AppendMenu("AutoControlMenu", "Copy", "Copy", IconLib, 16)
AppendMenu("AutoControlMenu", "Paste", "Paste", IconLib, 17)
AppendMenu("AutoControlMenu", "Delete", "DeleteSelectedControls", IconLib, 18)
AppendMenu("AutoControlMenu", "Select &All", "SelectAll", IconLib, 41)
Menu AutoControlMenu, Add
AppendMenu("AutoControlMenu", "Position and Size...", "ShowAdjustPositionDialog", IconLib, 75)
AppendMenu("AutoControlMenu", "Font...", "ShowFontDialog", IconLib, 20)
AppendMenu("AutoControlMenu", "Styles...", "ShowStylesDialog", IconLib, 19)
AppendMenu("AutoControlMenu", "Options...", "ShowOptionsTab", IconLib, 91)
Menu AutoControlMenu, Add
AppendMenu("AutoControlMenu", "Properties", "ShowProperties", IconLib, 25)

; Layout Menu
AppendMenu("AutoLayoutMenu", "Align &Lefts", "AlignLefts", IconLib, 26)
AppendMenu("AutoLayoutMenu", "Align &Rights", "AlignRights", IconLib, 27)
AppendMenu("AutoLayoutMenu", "Align &Tops", "AlignTops", IconLib, 28)
AppendMenu("AutoLayoutMenu", "Align &Bottoms", "AlignBottoms", IconLib, 29)
Menu AutoLayoutMenu, Add
AppendMenu("AutoLayoutMenu", "&Center Horizontally", "CenterHorizontally", IconLib, 30)
AppendMenu("AutoLayoutMenu", "Center &Vertically", "CenterVertically", IconLib, 31)
Menu AutoLayoutMenu, Add
AppendMenu("AutoLayoutMenu", "Hori&zontally Space", "HorizontallySpace", IconLib, 33)
AppendMenu("AutoLayoutMenu", "V&ertically Space", "VerticallySpace", IconLib, 32)
Menu AutoLayoutMenu, Add
AppendMenu("AutoLayoutMenu", "Make Same &Width", "MakeSameWidth", IconLib, 34)
AppendMenu("AutoLayoutMenu", "Make Same &Height", "MakeSameHeight", IconLib, 35)
AppendMenu("AutoLayoutMenu", "Make Same &Size", "MakeSameSize", IconLib, 36)

; Window Menu (menu bar)
AppendMenu("AutoWindowMenu", "Change &Title...", "ChangeTitle", IconLib, 37)
Menu AutoWindowMenu, Add
AppendMenu("AutoWindowMenu", "Font...", "ShowFontDialog", IconLib, 20)
AppendMenu("AutoWindowMenu", "Styles...", "ShowStylesDialog", IconLib, 19)
AppendMenu("AutoWindowMenu", "&Properties...", "ShowWindowProperties", IconLib, 25)
Menu AutoWindowMenu, Add
AppendMenu("AutoWindowMenu", "&Show/Hide Preview Window`tF11", "ShowChildWindow", IconLib, 38)
AppendMenu("AutoWindowMenu", "&Repaint", "RedrawWindow", IconLib, 39)
Menu AutoWindowMenu, Add
AppendMenu("AutoWindowMenu", "Re&create From Script", "RecreateFromSource", IconLib, 40)

; Run Menu
AppendMenu("AutoRunMenu", "&AutoHotkey 32-bit`tF9", "RunScript", IconLib, 12)
AppendMenu("AutoRunMenu", "AutoHotkey 64-&bit`tShift+F9", "RunScript", IconLib, 92)
AppendMenu("AutoRunMenu", "From the Saved &Location`tCtrl+F9", "RunScript", IconLib, 93)
;AppendMenu("AutoRunMenu", "&Through a Named Pipe`tAlt+F9", "RunScript", IconLib, 94)
AppendMenu("AutoRunMenu", "Run to &Cursor`tCtrl+F5", "RunToCursor", IconLib, 96)
AppendMenu("AutoRunMenu", "Run &Selected Text`tF5", "RunSelectedText", IconLib, 95)
Menu AutoRunMenu, Add
AppendMenu("AutoRunMenu", "Command Line &Parameters...", "ShowParamsDlg", IconLib, 91)
Menu AutoRunMenu, Add
AppendMenu("AutoRunMenu", "Run &External Application...", "RunFileDlg", "shell32.dll", 25)

; Options Menu
AppendMenu("AutoOptionsMenu", "&Design Mode", "SwitchToDesignMode")
AppendMenu("AutoOptionsMenu", "&Editor Mode", "SwitchToEditorMode")
Menu AutoOptionsMenu, Add
AppendMenu("AutoOptionsMenu", "Show &Grid", "ToggleGrid")
AppendMenu("AutoOptionsMenu", "S&nap to Grid", "ToggleSnapToGrid")
Menu AutoOptionsMenu, Add
AppendMenu("AutoOptionsMenu", "Syntax &Highlighting", "ToggleSyntaxHighlighting")
AppendMenu("AutoOptionsMenu", "&Line Numbers", "ToggleLineNumbers")
AppendMenu("AutoOptionsMenu", "&Word Wrap", "ToggleWordWrap")
AppendMenu("AutoOptionsMenu", "Autoclose &Brackets", "ToggleAutoBrackets", "+")
AppendMenu("AutoOptionsMenu", "&Read Only", "ToggleReadOnly")
Menu AutoOptionsMenu, Add, Show Symbols, ToggleSymbols
If (SysTrayIcon) {
    Menu AutoOptionsMenu, Add, Save Settings Now, SaveSettings
}
Menu AutoOptionsMenu, Add
AppendMenu("AutoOptionsMenu", "Change Editor &Font...", "SciChangeFont", IconLib, 20)
;Menu AutoOptionsMenu, Add
;AppendMenu("AutoOptionsMenu", "&Settings...", "ShowSettings", IconLib, 43)

; Tools Menu
AppendMenu("AutoToolsMenu", "&Window Cloning Tool", "ShowCloneDialog", IconLib, 44)
Menu AutoToolsMenu, Add
AppendMenu("AutoToolsMenu", "&A_Variables", "A_Variables", "A_Variables.ico")
AppendMenu("AutoToolsMenu", "&Constantine", "Constantine", "Constantine.icl", 1)
AppendMenu("AutoToolsMenu", "&Expressive", "Expressive", "Expressive.icl", 1)

; Help Menu
AppendMenu("AutoHelpMenu", "AutoHotkey &Help File`tF1", "OpenHelpFile", IconLib, 78)
Menu AutoHelpMenu, Add
AppendMenu("AutoHelpMenu", "GUI Control Types", "OpenHelpFile", IconLib, 79)
AppendMenu("AutoHelpMenu", "GUI Styles", "OpenHelpFile", IconLib, 79)
AppendMenu("AutoHelpMenu", "Gui Command", "OpenHelpFile", IconLib, 79)
AppendMenu("AutoHelpMenu", "Commands and Functions", "OpenHelpFile", IconLib, 79)
AppendMenu("AutoHelpMenu", "Variables and Expressions", "OpenHelpFile", IconLib, 79)
Menu AutoHelpMenu, Add
AppendMenu("AutoHelpMenu", "&About", "ShowAbout", IconLib, 80)

; Preview Window: Insert: Context Menu
AppendMenu("InsertMenu", "Button", "InsertControl", IconLib, 47)
AppendMenu("InsertMenu", "CheckBox", "InsertControl", IconLib, 48)
AppendMenu("InsertMenu", "ComboBox", "InsertControl", IconLib, 49)
AppendMenu("InsertMenu", "Date Time Picker", "InsertControl", IconLib, 51)
AppendMenu("InsertMenu", "DropDownList", "InsertControl", IconLib, 50)
AppendMenu("InsertMenu", "Edit Box", "InsertControl", IconLib, 52)
AppendMenu("InsertMenu", "GroupBox", "InsertControl", IconLib, 53)
AppendMenu("InsertMenu", "Hotkey Box", "InsertControl", IconLib, 54)
AppendMenu("InsertMenu", "Link", "InsertControl", IconLib, 55)
AppendMenu("InsertMenu", "ListBox", "InsertControl", IconLib, 56)
AppendMenu("InsertMenu", "ListView", "InsertControl", IconLib, 57)
AppendMenu("InsertMenu", "Month Calendar", "InsertControl", IconLib, 59)
AppendMenu("InsertMenu", "Picture", "InsertControl", IconLib, 60)
AppendMenu("InsertMenu", "Progress Bar", "InsertControl", IconLib, 61)
AppendMenu("InsertMenu", "Radio Button", "InsertControl", IconLib, 62)
AppendMenu("InsertMenu", "Separator", "InsertControl", IconLib, 63)
AppendMenu("InsertMenu", "Slider", "InsertControl", IconLib, 64)
AppendMenu("InsertMenu", "Tab", "InsertControl", IconLib, 66)
AppendMenu("InsertMenu", "Text", "InsertControl", IconLib, 67)
AppendMenu("InsertMenu", "TreeView", "InsertControl", IconLib, 68)
AppendMenu("InsertMenu", "UpDown", "InsertControl", IconLib, 70)

; Preview Window: Context Menu
AppendMenu("WindowContextMenu", "Add Control", ":InsertMenu", "Icons\Add.ico", 1)
AppendMenu("WindowContextMenu", "Paste", "Paste", IconLib, 17)
AppendMenu("WindowContextMenu")
AppendMenu("WindowContextMenu", "Change Title...", "ChangeTitle", IconLib, 37)
AppendMenu("WindowContextMenu", "Font...", "ShowFontDialog", IconLib, 20)
AppendMenu("WindowContextMenu", "Styles...", "ShowStylesDialog", IconLib, 19)
AppendMenu("WindowContextMenu", "Options...", "ShowWindowOptions", IconLib, 91)
AppendMenu("WindowContextMenu")
AppendMenu("WindowContextMenu", "Toggle Grid", "ToggleGrid", IconLib, 72)
AppendMenu("WindowContextMenu", "Repaint", "RedrawWindow", IconLib, 39)
AppendMenu("WindowContextMenu")
AppendMenu("WindowContextMenu", "Properties", "ShowProperties", IconLib, 25)
Menu WindowContextMenu, Color, 0xFAFAFA

; Control Context Menu
AppendMenu("ControlContextMenu", "Change &Text...", "ChangeText", IconLib, 14)
Menu ControlContextMenu, Add
AppendMenu("ControlContextMenu", "C&ut", "Cut", IconLib, 15)
AppendMenu("ControlContextMenu", "&Copy", "Copy", IconLib, 16)
AppendMenu("ControlContextMenu", "&Paste", "Paste", IconLib, 17)
AppendMenu("ControlContextMenu", "&Delete", "DeleteSelectedControls", IconLib, 18)
Menu ControlContextMenu, Add
AppendMenu("ControlContextMenu", "Position a&nd Size...", "ShowAdjustPositionDialog", IconLib, 75)
AppendMenu("ControlContextMenu", "&Font...", "ShowFontDialog", IconLib, 20)
AppendMenu("ControlContextMenu", "&Styles...", "ShowStylesDialog", IconLib, 19)
AppendMenu("ControlOptionsMenu", "None", "MenuHandler")
AppendMenu("ControlContextMenu", "&Options", ":ControlOptionsMenu", IconLib, 91)
Menu ControlContextMenu, Add
AppendMenu("ControlContextMenu", "Prop&erties", "ShowProperties", IconLib, 25)

; Tab Context Menu
AppendMenu("TabContextMenu", "Close Tab", "CloseTabN", IconLib, 8)
Menu TabContextMenu, Add
AppendMenu("TabContextMenu", "Duplicate Tab Contents", "DuplicateTab", IconLib, 7)
AppendMenu("TabContextMenu", "Open Folder in Explorer", "OpenFolder", IconLib, 9)
AppendMenu("TabContextMenu", "Copy Path to Clipboard", "CopyFilePath", IconLib, 11)
Menu TabContextMenu, Add
AppendMenu("TabContextMenu", "File Properties", "ShowFileProperties", IconLib, 25)

; AutoGUI Menu
Menu AutoMenuBar, Add, &File, :AutoFileMenu
Menu AutoMenuBar, Add, &Edit, :AutoEditMenu
Menu AutoMenuBar, Add, Con&vert, :AutoConvertMenu
Menu AutoMenuBar, Add, &Control, :AutoControlMenu
Menu AutoMenuBar, Add, &Layout, :AutoLayoutMenu
Menu AutoMenuBar, Add, &Window, :AutoWindowMenu
Menu AutoMenuBar, Add, &Run%A_Space%, :AutoRunMenu
Menu AutoMenuBar, Add, &Options, :AutoOptionsMenu
Menu AutoMenuBar, Add, &Tools, :AutoToolsMenu
Menu AutoMenuBar, Add, &Help, :AutoHelpMenu
