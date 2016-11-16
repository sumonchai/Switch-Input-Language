Class DefControl {
    __New(DisplayName, Width, Height, Options := "", Text := "", Icon := "", IconIndex := 1) {
        this.DisplayName  := DisplayName
        this.Text         := (Text == "=") ? this.DisplayName : Text
        this.Width        := Width
        this.Height       := Height
        this.Options      := Options
        this.icon         := Icon
        this.IconIndex    := IconIndex
        this.Menu         := ["None"]
    }
}

Global Default := {}
Default.ActiveX      := New DefControl("ActiveX", 200, 100, "", "HTMLFile", IconLib, 46)
Default.Button       := New DefControl("Button", 80, 23, "", "&OK", IconLib, 47)
Default.CheckBox     := New DefControl("CheckBox", 120, 23, "", "=", IconLib, 48)
Default.ComboBox     := New DefControl("ComboBox", 120, 21, "", "=", IconLib, 49)
Default.DateTime     := New DefControl("Date Time Picker", 100, 24, "", "", IconLib, 51)
Default.DropDownList := New DefControl("DropDownList", 120, 21, "", "DropDownList||", IconLib, 50)
Default.Edit         := New DefControl("Edit", 120, 21, "", "=", IconLib, 52)
Default.GroupBox     := New DefControl("GroupBox", 120, 80, "", "=", IconLib, 53)
Default.Hotkey       := New DefControl("Hotkey", 120, 21, "", "", IconLib, 54)
Default.Link         := New DefControl("Link", 120, 23, "", "<a href=""https://autohotkey.com"">autohotkey.com</a>", IconLib, 55)
Default.ListBox      := New DefControl("ListBox", 120, 160, "", "=", IconLib, 56)
Default.ListView     := New DefControl("ListView", 200, 150, "", "=", IconLib, 57)
Default.MonthCal     := New DefControl("Month Calendar", 225, 160, "", "", IconLib, 59)
Default.Picture      := New DefControl("Picture", 32, 32, "", "mspaint.exe", IconLib, 60)
Default.Progress     := New DefControl("Progress Bar", 120, 20, "-Smooth", "33", IconLib, 61)
Default.Radio        := New DefControl("Radio Button", 120, 23, "", "=", IconLib, 62)
Default.Separator    := New DefControl("Text", 200, 2, "0x10", "", IconLib, 63)
Default.Slider       := New DefControl("Slider", 120, 32, "", "50", IconLib, 64)
Default.StatusBar    := New DefControl("Status Bar", 0, 0, "", "=", IconLib, 65)
Default.Tab2         := New DefControl("Tab", 225, 160, "", "Tab 1|Tab 2", IconLib, 66)
Default.Text         := New DefControl("Text", 120, 23, "+0x200", "=", IconLib, 67)
Default.ToolBar      := New DefControl("Toolbar", 225, 160, "", "=", IconLib, 69)
Default.TreeView     := New DefControl("TreeView", 160, 160, "", "", IconLib, 68)
Default.UpDown       := New DefControl("UpDown", 16, 21, "", "1", IconLib, 70)
Default.Custom       := New DefControl("Custom", 100, 23, "", "Custom", IconLib, 71)
Default.CommandLink  := New DefControl("Command Link", 200, 42, "ClassButton +0x200E", "Command Link")

Default.Button.Menu   := ["Default", "Disabled", "No Theme"]
Default.CheckBox.Menu := ["Checked", "Disabled"]
Default.ComboBox.Menu := ["Alternate Submit", "Sort Alphabetically", "Uppercase All Items", "Lowercase All Items", "Simple (Edit + ListBox)", "Disabled"]
Default.DateTime.Menu := ["Show Checkbox", "Right Align the Drop-down Calendar", "Disabled"]
Default.DropDownList.Menu := ["Alternate Submit", "Sort Alphabetically", "Uppercase All Items", "Lowercase All Items", "Disabled"]
Default.Edit.Menu     := ["Read Only", "Multiline", "No Scrollbar", "Numbers Only", "Password Field", "Disabled"]
Default.GroupBox.Menu := ["No Theme"]
Default.Hotkey.Menu   := ["Disabled"]
Default.ListBox.Menu  := ["Alternate Submit", "No Integral Height", "Multiple Selection (Extended)", "Multiple Selection (Simplified)", "Sort Alphabetically", "Disabled"]
Default.ListView.Menu := ["Alternate Submit", "No Column Header", "Show Checkboxes", "Show Grid", "Single Row Selection", "Show ToolTips", "Sort Alphabetically", "No Sort Header", "Underline Hot Items", "Prevent Flicker", "Explorer Theme", "Disabled"]
Default.MonthCal.Menu := ["Multiple Selection", "Show Week Numbers", "No Today Circle", "No Bottom Label"]
Default.Picture.Menu  := ["Transparent Background", "Use GDI+", "Show Border", "Sunken", "3D Sunken Edge", "3D Outset Border", "Thick Frame"]
Default.Progress.Menu := ["No Smooth Style", "Show Border", "Vertical", "Disabled"]
Default.Radio.Menu    := ["Checked", "Disabled"]
Default.Slider.Menu   := ["Vertical", "No Ticks", "Blunt", "Thick Thumb", "Show ToolTip", "Disabled"]
Default.Tab2.Menu     := ["Single Row (No Wrap)", "Buttons", "Flat Buttons", "Tabs on the Bottom", "Alternate Submit"]
Default.Text.Menu     := ["Center Vertically", "Show Border", "Sunken", "3D Sunken Edge", "3D Outset Border", "Disabled"]
Default.TreeView.Menu := ["Alternate Submit", "Show Checkboxes", "No Expansion Glyph", "No Dotted Lines", "Explorer Theme", "Disabled"]
Default.UpDown.Menu   := ["No Buddy (Isolated)", "No Thousands Separator", "Left-sided", "Horizontal", "Disabled"]
Default.CommandLink.Menu := ["Default Button", "Disabled", "No Theme"]

Global ControlOptions := {"Default": "Default"
, "Disabled": "Disabled"
, "Checked": "Checked"
, "Multiline": "Multi"
, "No Scrollbar": "-VScroll"
, "Numbers Only": "Number"
, "Password Field": "Password"
, "Read Only": "ReadOnly"
, "No Column Header": "-Hdr"
, "Show Checkboxes": "Checked"
, "Show Grid": "Grid"
, "Single Row Selection": "-Multi"
, "Alternate Submit": "AltSubmit"
, "Show ToolTips": "+LV0x4000"
, "No Integral Height": "+0x100"
, "Multiple Selection (extended)": "Multi"
, "Multiple Selection (simplified)": "+0x8"
, "Sort Alphabetically": "Sort"
, "No Theme": "-Theme"
, "No Smooth Style": "-Smooth"
, "Show Border": "Border"
, "Vertical": "Vertical"
, "Uppercase All Items": "Uppercase"
, "Lowercase All Items": "Lowercase"
, "Simple (Edit + ListBox)": "Simple"
, "Multiple Selection": "Multi"
, "Show Week Numbers": "4"
, "No Today Circle": "8"
, "No Bottom Label": "16"
, "Show Checkbox": "2"
, "Right Align the Drop-down Calendar": "Right"
, "Use GDI+": "AltSubmit"
, "Center Vertically": "+0x200"
, "Sunken": "+0x1000"
, "3D Sunken Edge": "+E0x200"
, "3D Outset Border": "+0x400000"
, "Thick Frame": "+0x40000"
, "Transparent Background": "BackgroundTrans"
, "No Expansion Glyph": "-Buttons"
, "No Dotted Lines": "-Lines"
, "Thick Thumb": "+0x40"
, "No Ticks": "NoTicks"
, "Blunt": "Center"
, "Show ToolTip": "Tooltip"
, "No Buddy (Isolated)": "-16"
, "No Thousands Separator": "+0x80"
, "Left-sided": "Left"
, "Horizontal": "Horz"
, "Buttons": "Buttons"
, "Flat Buttons": "+0x8"
, "Tabs on the Bottom": "Bottom"
, "Single Row (No Wrap)": "-Wrap"
, "Underline Hot Items": "+LV0x840"
, "No Sort Header": "NoSortHdr"
, "Default Button": "+0x1"
, "Prevent Flicker": "+LV0x10000"
, "Explorer Theme": "Explorer"}
