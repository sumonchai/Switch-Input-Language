If (DllCall("kernel32.dll\GetVersion") & 0xFF < 6) {
    MsgBox 0x10, Error, This script requires Windows Vista or higher.
    Return
}

Instruction := "LJ Switch Lang Control"
Title := "LJ Switch Lang V 2.0"
MainIcon := LoadPicture("dxptasksync.dll", "w32 Icon5", ImageType)
Flags := 0x52
Buttons := 0x8
CustomButtons := []
CustomButtons.Push([101, "CAPsLOCK"])
CustomButtons.Push([102, "~"])
CustomButtons.Push([103, "ALT + Shift"])
CustomButtons.Push([104, "Virtuose"])
cButtons := CustomButtons.MaxIndex()
VarSetCapacity(pButtons, 4 * cButtons + A_PtrSize * cButtons, 0)
Loop % cButtons {
    iButtonID := CustomButtons[A_Index][1]
    iButtonText := &(b%A_Index% := CustomButtons[A_Index][2])
    NumPut(iButtonID,   pButtons, (4 + A_PtrSize) * (A_Index - 1))
    NumPut(iButtonText, pButtons, (4 + A_PtrSize) * A_Index - A_PtrSize)
}
Width := 268
Callback := RegisterCallback("Callback", "Fast")

; TASKDIALOGCONFIG structure
x64 := A_PtrSize == 8
NumPut(VarSetCapacity(TDC, (x64) ? 160 : 96, 0), TDC, 0) ; cbSize
NumPut(0x10010, TDC, 4) ; hwndParent
NumPut(Flags, TDC, (x64) ? 20 : 12) ; dwFlags
NumPut(Buttons, TDC, (x64) ? 24 : 16) ; dwCommonButtons
NumPut(&Title, TDC, (x64) ? 28 : 20) ; pszWindowTitle
NumPut(MainIcon, TDC, (x64) ? 36 : 24) ; pszMainIcon
NumPut(&Instruction, TDC, (x64) ? 44 : 28) ; pszMainInstruction
NumPut(cButtons, TDC, (x64) ? 60 : 36) ; cButtons
NumPut(&pButtons, TDC, (x64) ? 64 : 40) ; pButtons
NumPut(Callback, TDC, (x64) ? 140 : 84) ; pfCallback
NumPut(Width, TDC, (x64) ? 156 : 92, "UInt") ; cxWidth

DllCall("Comctl32.dll\TaskDialogIndirect", "UInt", &TDC
    , "Int*", Button := 0
    , "Int*", Radio := 0
    , "Int*", Checked := 0)

Callback(hWnd, Notification, wParam, lParam, RefData) {
    If (Notification == 2) {
        If (wParam == 2) {
            ExitApp
        } Else If (wParam == 103) {
            hIcon := LoadPicture("ieframe.dll", "w32 Icon41", _)
        } Else {
            hIcon := LoadPicture("user32.dll", "w32 Icon4", _)
        }
        SendMessage 0x474, 0, %hIcon%,, ahk_id %hWnd% ; TDM_UPDATE_ICON
        Return True
    }
}
OGui Add, Button, gShowAbout x8 y430 w76 h23, A&bout