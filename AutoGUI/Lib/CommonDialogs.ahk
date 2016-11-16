ChooseFont(ByRef FontName, ByRef Size, ByRef Style, ByRef Color, Effects := True, hOwner := 0) {
    ; FontName: Typeface name (input/output).
    ; Size: Font size (input/output).
    ; Style: Font options: bold, italic, underline, strikeout (input/output).
    ; Color: Font color in hexadecimal format (input/output)
    ; Effects: If True, the dialog box will display the controls that allow the user to specify strikeout, underline, and text color options.
    ; hOwner: A handle to the window that owns the dialog box. Affects position.
    ; Return value: Nonzero if the user clicks the OK button.

    LogPixels := DllCall("GetDeviceCaps", "UInt", DllCall("GetDC", "UInt", hOwner), "UInt", 90)

    VarSetCapacity(LOGFONT, (A_IsUnicode) ? 92 : 60, 0)
    
    ; Initial name
    StrPut(FontName, &LOGFONT + 28, 32)

    ; Initial size
    lfHeight := (Size) ? -DllCall("MulDiv", "Int", Size, "Int", LogPixels, "int", 72) : 16
    NumPut(lfHeight, LOGFONT, 0, "Int")
    
    ; Initial style
    If InStr(Style, "bold") {
        NumPut(700, LOGFONT, 16, "UInt")
    }
    If InStr(Style, "italic") {
        NumPut(255, LOGFONT, 20, "Char")
    }
    If InStr(Style, "underline") {
        NumPut(1, LOGFONT, 21, "Char")
    }
    If InStr(Style, "strikeout") {
        NumPut(1, LOGFONT, 22, "Char")
    }

    ; Convert from RGB
    rgbColors := ((Color & 0xFF) << 16) + (Color & 0xFF00) + ((Color >> 16) & 0xFF)

    ; CF_SCREENFONTS = 1, CF_INITTOLOGFONTSTRUCT = 0x40
    Effects := 0x041 + (Effects ? 0x100 : 0) ; CF_EFFECTS = 0x100, 

    lStructSize := (A_PtrSize = 8) ? 104 : 60
    VarSetCapacity(CHOOSEFONT, lStructSize, 0)
    NumPut(lStructSize, CHOOSEFONT, 0, "UInt")
    NumPut(hOwner, CHOOSEFONT, 4, "UInt")
    NumPut(&LOGFONT,CHOOSEFONT, 4 + 2 * A_PtrSize, "UInt")
    NumPut(Effects, CHOOSEFONT, 8 + 3 * A_PtrSize, "UInt")
    NumPut(rgbColors, CHOOSEFONT, 12 + 3 * A_PtrSize, "UInt")

    If !(DllCall("comdlg32\ChooseFont" . (A_IsUnicode ? "W" : "A"), "UInt", &CHOOSEFONT)) {
        Return False
    }

    FontName := StrGet(&LOGFONT + 28, 32)
    ;Size := NumGet(CHOOSEFONT, 4 + 3 * A_PtrSize, "UInt") // 10
    Size := DllCall("MulDiv", "Int", Abs(NumGet(LOGFONT, 0, "Int")), "Int", 72, "Int", LogPixels)

    Style := ""
    If (NumGet(LOGFONT, 16) >= 700) {
        Style .= "bold "
    }
    If (NumGet(LOGFONT, 20, "UChar")) {
        Style .= "italic "
    }
    If (NumGet(LOGFONT, 21, "UChar")) {
        Style .= "underline "
    }
    If (NumGet(LOGFONT, 22, "UChar")) {
        Style .= "strikeout "
    }

    OldFormat := A_FormatInteger
    SetFormat Integer, Hex
    Color := NumGet(CHOOSEFONT, 12 + 3 * A_PtrSize, "UInt")
    ; Convert to RGB
    Color := (Color & 0xFF00) + ((Color & 0xFF0000) >> 16) + ((Color & 0xFF) << 16) 
    StringTrimLeft, Color, Color, 2 
    Loop % (6 - StrLen(Color)) {
        Color := "0" . Color
    }
    Color := "0x" . Color
    SetFormat Integer, %OldFormat% 

    Return True
}

ChooseColor(ByRef Color, hOwner := 0) {
    ; Color: specifies the color initially selected when the dialog box is created.
    ; hOwner: Optional handle to the window that owns the dialog. Affects dialog position.
    ; Return value: Nonzero if the user clicks the OK button.

    rgbResult := ((Color & 0xFF) << 16) + (Color & 0xFF00) + ((Color >> 16) & 0xFF)

    VarSetCapacity(CHOOSECOLOR, 36, 0)
    VarSetCapacity(CUSTOM, 64, 0)
    NumPut(36, CHOOSECOLOR, 0) ; DWORD lStructSize
    NumPut(hOwner, CHOOSECOLOR, 4)
    NumPut(rgbResult, CHOOSECOLOR, 12)
    NumPut(&CUSTOM,	CHOOSECOLOR, 16) ; COLORREF *lpCustColors
    NumPut(0x103, CHOOSECOLOR, 20) ; Flags: CC_ANYCOLOR || CC_RGBINIT

    RetVal := DllCall("comdlg32\ChooseColorA", "Str", CHOOSECOLOR)
    If (ErrorLevel != 0) || (RetVal = 0) {
        Return False
    }

    rgbResult := NumGet(CHOOSECOLOR, 12)
    
    OldFormat := A_FormatInteger
    SetFormat Integer, Hex
    Color := (rgbResult & 0xFF00) + ((rgbResult & 0xFF0000) >> 16) + ((rgbResult & 0xFF) << 16)
    StringTrimLeft Color, Color, 2
    Loop % 6 - StrLen(Color) {
        Color := "0" . Color
    }
    Color := "0x" . Color
    SetFormat Integer, %OldFormat%
    Return True
}

ChooseIcon(ByRef Icon, ByRef Index, hOwner := 0) {
    ; Icon: Icon resource (input/output).
    ; Index: Icon index (input/output).
    ; hOwner: Optional handle to the window that owns the dialog. Affects dialog position.
    ; Return value: Nonzero if the user clicks the OK button.

	PtrType := A_PtrSize ? "Ptr" : "UInt"

	VarSetCapacity(wIcon, 1025, 0)
	If (Icon && !StrPut(Icon, &wIcon, StrLen(Icon) + 1, "UTF-16")) {
		Return False
    }

	r := DllCall(DllCall("GetProcAddress", PtrType, DllCall("LoadLibrary", "Str", "shell32.dll"), "Uint", 62, PtrType), PtrType, hOwner, PtrType, &wIcon, "UInt", 1025, "IntP", --Index)
	Index++
	IfEqual r, 0, Return False

	Len := DllCall("lstrlenW", "UInt", &wIcon)
	If (A_IsUnicode) {
		Return True, VarSetCapacity(wIcon, -1), Icon := wIcon
    }

	If (!Icon := StrGet(&wIcon, Len + 1, "UTF-16")) {
		Return False
    }

    Return True 
}
