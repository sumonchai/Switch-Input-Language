OpenHelpFile(Keyword := "") {
    Global HelpFile

    ; Functions that doesn't have a corresponding html page
    Static Functions := ["FileExist", "InStr", "SubStr", "StrLen", "StrSplit", "Asc", "Chr", "GetKeyName", "IsByRef", "IsFunc", "IsLabel", "IsObject", "Ord", "Abs", "Ceil", "Exp", "Floor", "Log", "Ln", "Mod", "Round", "Sqrt", "Sin", "Cos", "Tan", "ASin", "ACos", "ATan"]

    ; Object methods
    Static Methods := ["InsertAt", "RemoveAt", "Push", "Pop", "Delete", "MinIndex", "MaxIndex", "Length", "SetCapacity", "GetCapacity", "GetAddress", "NewEnum", "HasKey", "Clone", "ObjRawSet"]

    ; GUI control types
    Static Controls := ["ActiveX", "Button", "CheckBox", "ComboBox", "Custom", "DateTime", "DropDownList", "Edit", "GroupBox", "Hotkey", "Link", "ListBox", "MonthCal", "Picture", "Progress", "Radio", "Slider", "StatusBar", "Tab", "Text", "UpDown"]

    If (Keyword == "" || StrLen(Keyword) > 50) {
        HTMLPath := "AutoHotkey.htm"
        GoTo Help
    }

    VarSetCapacity(LineText, 100)
    Sci[TabEx.GetSel()].GetCurLine(100, LineText)

    StringReplace Keyword, Keyword, #, _             ; Replace # with _ in directives
    StringReplace Keyword, Keyword, %A_Space%,, All  ; Remove spaces
    StringReplace Keyword, Keyword, `,, All          ; Remove commas

    HTMLPage := Keyword . ".htm"

    Prefix := SubStr(Keyword, 1, 3)
    If (Prefix = "LV_" || Prefix = "IL_") {
        HTMLPage := "ListView.htm#" . Keyword
    } Else If (Prefix = "TV_") {
        HTMLPage := "TreeView.htm#" . Keyword
    } Else If (Prefix = "SB_") {
        HTMLPage := "GuiControls.htm#" . Keyword
    } Else If (Keyword = "StrPut" || Keyword = "StrGet") {
        HTMLPage := "StrPutGet.htm"
    } Else If (Keyword = "SendMessage") {
        HTMLPage := "PostMessage.htm"
    } Else If (Keyword = "If") {
        HTMLPage := "IfExpression.htm"
    } Else If (Keyword ~= "i)GuiClose|GuiEscape|GuiSize|GuiContextMenu|GuiDropFiles") {
        HTMLPage := "Gui.htm#" . Keyword
    } Else {
        Loop % Functions.MaxIndex() {
            If (Functions[A_Index] = Keyword) {
                HTMLPage := "Functions.htm#" . Keyword
                Keyword := "Functions"
                Break
            }
        }

        Loop % Methods.MaxIndex() {
            If (Methods[A_Index] = Keyword) {

                If (Keyword = "MinIndex" || Keyword = "MaxIndex") {
                    Keyword := "MinMaxIndex"
                }

                HTMLPage := "Object.htm#" . Keyword
                Keyword := "Object"
                Break
            }
        }

        Loop % Controls.MaxIndex() {
            If (Controls[A_Index] = Keyword) {

                If ((Keyword = "Hotkey" || Keyword = "Progress")
                    && !RegExMatch(LineText, "i)\s*Gui")) {
                    Break
                }

                If (Keyword = "Tab2" || Keyword = "Tab3") {
                    Keyword := "Tab"
                } Else If (Keyword = "DDL") {
                    Keyword := "DropDownList"
                }

                HTMLPage := "GuiControls.htm#" . Keyword
                Break
            }
        }
    }

    If (Keyword = "Functions"
        || Keyword = "Objects"
        || Keyword = "FAQ"
        || Keyword = "Hotkeys"
        || Keyword = "Hotstrings"
        || Keyword = "KeyList"
        || Keyword = "Scripts"
        || Keyword = "Tutorial"
        || Keyword = "Variables") {
        Path := ""
    } Else If (Keyword = "Object" || Keyword = "Func" || Keyword = "File") {
        Path := "objects/"
    } Else If (Keyword = "Clipboard"
            || Keyword = "WinTitle"
            || Keyword = "Arrays"
            || Keyword = "ErrorLevel"
            || Keyword = "Labels"
            || Keyword = "Styles"
            || Keyword = "Threads") {
        Path := "misc/"
    } Else {
        Path := "commands/"
    }

    HTMLPath := Path . HTMLPage
    Help:
    Run hh mk:@MSITStore:%HelpFile%::/docs/%HTMLPath%
}

; Unrealiable on Windows 7 and doesn't work on Windows 10
/*
OpenHelpFile(Keyword := "") {
    Global HelpFile
    Static WinTitle := "AutoHotkey Help ahk_class HH Parent"

    If (!WinExist(WinTitle)) {
        Run HH %HelpFile%
        WinWait %WinTitle%
    }
    WinActivate %WinTitle%
    WinWaitActive %WinTitle%

    If ((Keyword := SubStr(Trim(Keyword), 1, 50)) != "") {
        SendMessage, 0x1330, 1,, SysTabControl321
        sleep, 0 
        SendMessage, 0x130C, 1,, SysTabControl321
        SendInput +{Home}%Keyword%{Enter}
    } Else {    
        WinMenuSelectItem, %WinTitle%,, 4&, 5& ; Go > Home Page
    }
}
*/
