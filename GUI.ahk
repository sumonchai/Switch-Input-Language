#NoEnv
#Warn
#SingleInstance Force
SetWorkingDir %A_ScriptDir%

Gui New, +Resize -MaximizeBox
Gui Color, White
Gui Font, s13 q5 cSilver, Segoe UI
Gui Add, Button, hWndhButton1 x352 y320 w113 h43, &OK
Gui Font
Gui Show, w481 h381, LJ Switch Lang
Return

GuiEscape:
GuiClose:
    ExitApp

; End of the GUI section