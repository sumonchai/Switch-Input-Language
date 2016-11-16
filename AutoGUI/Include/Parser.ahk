ParseScript(Source) {
    m.Code := ""

    Loop Parse, Source, `n
    {
        ; Menu item
        If (RegExMatch(A_LoopField, "iO)^Menu\s*\,?\s*(?P<MenuName>([\w]+)),\s?Add(,\s?(?P<MenuItem>.*),\s?(?P<GoSub>([\w\:]+)))?", Rex)) {
            m.Code .= "Menu " . Rex.MenuName . ", Add, " . Rex.MenuItem . ", " . Rex.GoSub . "`n"
            Menu % Rex.MenuName, Add, % Rex.MenuItem, % Rex.GoSub
        } Else If (RegExMatch(A_LoopField, "iO)^Menu\s*\,?\s*(?P<MenuName>([\w]+)),\s?Add", Rex)) {
            m.Code .= "Menu " . Rex.MenuName . ", Add`n"
            Menu % Rex.MenuName, Add
        }

        ; Control
        If (RegExMatch(A_LoopField, "iO)^\s*?Gui\s*\,?\s*(\w+\:)?\s?Add,\s?(?P<Type>([A-Za-z]+)\d?),\s?(?P<Options>([\w\+\-\s]+))(,\s?(?P<Text>(.+)))?", Rex)) {
            Options := RegExReplace(Rex.Options, "([\,\s]?g\w+|[\,\s]?v\w+)")

            If (Rex.Type = "StatusBar" && StatusBarExist()) {
                GuiControl %Child%: Show, msctls_statusbar321
            } Else {
                Gui %Child%: Add, % Rex.Type, % "hWndhWnd " . Options, % Rex.Text
            }

            If (Rex.Type = "TreeView") {
                Parent := TV_Add("TreeView")
                TV_Add("Child", Parent)
            }

            GuiControlGet c, %Child%: Pos, %hWnd%
            Register(hWnd, Rex.Type, "", Rex.Text, cx, cy, cw, ch, "", "", "", "", "", "", "", "", "")
            g.ControlList.Insert(hWnd)
        }

        If (RegExMatch(A_LoopField, "iO)^Gui\s?\,?\s?Show,\s?(?P<Options>([\w\s]+)),\s?(?P<Title>(.+))", Rex)) {
            Gui %Child%: Show, % Rex.Options, % Rex.Title
        }
    }

    If (m.Code != "") {
        m.Code .= "Gui Menu, MenuBar`n"
        Gui %Child%: Menu, MenuBar
    }

    If (g.ToolbarIcons.MaxIndex()) {
        AddToolbar(g.ToolbarIL, g.ToolbarItems, g.ToolbarOptions)
    }

    GenerateCode()
    Properties_Reload()
}
