/*

Click and Send Test Tool V06.0 Beta Stage
Made By Snow Flake ©  

http://www.autohotkey.com/board/user/21149-snow-flake/

http://www.autohotkey.com/board/topic/95653-clicksend-tester/


*/

if not A_IsAdmin
{
    Run *RunAs "%A_ScriptFullPath%"
    ExitApp
}

#SingleInstance, force
SetWorkingDir, %A_ScriptDir%
#Persistent
#NoEnv
#MaxThreadsPerHotkey 1
DetectHiddenWindows,On
SetTitleMatchMode 2
Main:
OnMessage(0x0133, "Control_Colors") ;WM_CTLCOLOREDIT = 0x0133, WM_CTLCOLORLISTBOX = 0x0134, ;WM_CTLCOLORSTATIC = 0x0138
Gui, Margin, 10, 10
Gui, Add, Text,   xm     ym, Sleep Time (ms) (2000 is recommended):
Gui, Add, Edit,   xm     ym+17 vWaitTime, 2000
Gui, Add, Text,   xm     ym+55, Keys (Key inside {}) or Text to send:
Gui, Add, Edit,   xm     ym+72  w250 h20 vKex, {W} Testing!
Gui, Add, Text,   xm     ym+110 w15 h20 0x200, X:
Gui, Add, Edit,   xm+20  ym+110 w30 h20 vXX, 100
Gui, Add, Text,   xm     ym+135 w15 h20 0x200, Y:
Gui, Add, Edit,   xm+20  ym+135 w30 h20 vYY, 100
Gui, Add, Button, xm     ym+170 w80, Save
Gui, Add, GroupBox, xm+260 ym     w330 h193, About
Gui, Add, Text,     xm+270 ym+25  w310 h20, Welcome to my Send and Click Tool
Gui, Add, Text,     xm+270 ym+55  w310 h30, This Will test Different Click and Send Commands to see which commands that works best in different games.
Gui, Add, Text,     xm+270 ym+95  w310 h30, It's highly recommended that you use this tool on a window mode of the Game or program.
Gui, Font, cWhite,
Gui, Add, Text,     xm+270 ym+170 w310 h20 0x202, 2013, Snow Flake
Title1 = Welcome to my Send and Click Tool
Title2 = Made by: Snow Flake
SetTimer, AnimateTitle, 100
Gui, +HWndGUI_ID
Gui, Font,
Gui, Show, AutoSize, Send and Click Tool

Gui, color, c0c0c0
loop 4
 Control_Colors( "Edit" A_index, "Set", "0xcecece", "0x000000")
WinSet,redraw,,A

return

;Control_Colors--------------------------------------------------------
;Thanks to derRaphael & JustMe for the Color Controls code from http://www.autohotkey.com/forum/topic33777.html and here http://www.autohotkey.com/board/topic/90401-control-colors-by-derraphael/
Control_Colors(wParam, lParam, Msg, Hwnd) {
    Static Controls := {}
   If (lParam = "Set") {
      If !(CtlHwnd := wParam + 0)
         GuiControlGet, CtlHwnd, Hwnd, %wParam%
      If !(CtlHwnd + 0)
         Return False
      Controls[CtlHwnd, "CBG"] := Msg + 0
      Controls[CtlHwnd, "CTX"] := Hwnd + 0
      Return True
   }
   ; Critical
   If (Msg = 0x0133 Or Msg = 0x0134 Or Msg = 0x0138) {
      If Controls.HasKey(lParam) {
         If (Controls[lParam].CTX >= 0)
            DllCall("Gdi32.dll\SetTextColor", "Ptr", wParam, "UInt", Controls[lParam].CTX)
         DllCall("Gdi32.dll\SetBkColor", "Ptr", wParam, "UInt", Controls[lParam].CBG)
         Return DllCall("Gdi32.dll\CreateSolidBrush", "UInt", Controls[lParam].CBG)
      }
   }
 }
;----------------------------------------------------------------------

AnimateTitle:
TextX := ""
Loop,Parse,Title1,
{
TextX = % TextX . A_LoopField
WinSetTitle, ahk_id %GUI_ID%, , %TextX%
sleep, 100
}
sleep, 700

TextX := ""
Loop,Parse,Title2,
{
TextX = % TextX . A_LoopField
WinSetTitle, ahk_id %GUI_ID%, , %TextX%
sleep, 100
}
sleep, 700
return

save:
Gui, Submit

Start:
MsgBox, 262208, Select the Game or Program Window, Place the mouse cursor over the window you want to Select.`nThen press the middle mouse button to get the Title.
IfMsgBox OK
keywait, MButton, D
keywait, MButton
mousegetpos, winX, winY, winid
wingettitle, wintext, ahk_id %winid%

MsgBox, 262180, Selected Game/Program Window, Are you sure that this is the Game/Program window? `n`n%wintext%
IfMsgBox No
goto, Start
IfMsgBox Yes
   
MsgBox, 262196, Info, Are you sure that this is right?`n`nKey/Text to Send:  %wintext%`n`nSleep Time:  %WaitTime%
IfMsgBox No
goto, Main
IfMsgBox Yes
   
MsgBox, 4160, Click and Send Test Tool, Running This Will Test different Click and Send types to confirm which commands that are working.`n`nPress F1 in the Game/Progam to test diffirent Mouse Commands.`n`nPress F3 in the Game/Progam to test diffirent Keys/Text Commands. `n`nPress Ctrl + Escape will Exit the Progam.`n`nPress Shift + Escape will Restart the Progam.`n

F1:: ; Press F3 to run Click test.
{
 KeyWait, F1, D
 SoundBeep
Goto, ClickTest
}
return

F3:: ; Press F1 to run Send test.
{
KeyWait, F3, D
SoundBeep
Goto, SendTest
}
return

ClickTest: ; ========================================================================================
{
sleep, %WaitTime%
ToolTip, Running Click Test,0,0
WinActivate,%wintext%
 
ToolTip, Testing Click,0,0
Click, %XX%, 100
sleep, %WaitTime%

ToolTip, Testing MouseClick,0,0
MouseClick, Left, %XX%, %YY%
sleep, %WaitTime%

ToolTip, Testing MouseClickDrag,0,0
MouseClickDrag, left, 0, %XX%, %YY%, 200, 50
sleep, %WaitTime%
 
ToolTip, Testing ControlClick,0,0
ControlClick, x%XX% y%YY%, %wintext%, Left
sleep, %WaitTime%

ToolTip, Testing Send Click,0,0
Send, {Click %XX%, %YY%}
sleep, %WaitTime%
 
ToolTip, Testing SendRaw Click,0,0
sleep, %WaitTime%
SendRaw, {LButton}
 
ToolTip, Testing SendPlay Click,0,0
sleep, %WaitTime%
SendPlay, {LButton}
 
ToolTip, Testing SendEvent Click,0,0
sleep, %WaitTime%
SendEvent, {LButton}
 
ToolTip, Testing SendInput Click,0,0
sleep, %WaitTime%
SendInput, {LButton}

ToolTip, Testing ControlSend Click,0,0
sleep, %WaitTime%
ControlSend,,{Click %XX%, %YY%},%wintext%

ToolTip, Testing ControlSendRaw Click,0,0
sleep, %WaitTime%
ControlSendRaw,,{Click %XX%, %YY%},%wintext%

ToolTip, Testing PostMessage Click,0,0
sleep, %WaitTime%
PostMessage, 0x201, 0x00000000, 0x01f0010f, ,%wintext% ; Down
sleep, 500
PostMessage, 0x202, 0x00000000, 0x01f0010f, ,%wintext% ; UP

ToolTip, Testing SendMessage Click,0,0
sleep, %WaitTime%
SendMessage, 0x201, 0x00000000, 0x01f0010f, , %wintext% ; Down
sleep, 500
SendMessage, 0x202, 0x00000000, 0x01f0010f, , %wintext% ; UP

ToolTip, Testing ControlFocus Click,0,0
sleep, %WaitTime%
ControlFocus, x%XX% y%YY%, %wintext%

ToolTip, Testing Dll Call Mouse_event,0,0
sleep, %WaitTime%
DllCall("mouse_event", uint, 2, int, x, int, y, uint, 0, int, 0)  ; Down
sleep, 500
DllCall("mouse_event", uint, 4, int, x, int, y, uint, 0, int, 0)  ; UP
 
ToolTip, Click Test Done,0,0
sleep, %WaitTime%
ToolTip,
}
return
 
SendTest: ; ========================================================================================
{
sleep, %WaitTime%
ToolTip, Running Send Test,0,0
WinActivate,%wintext%
 
ToolTip, Testing %Kex% With Send,0,0
Send, %Kex%
sleep, %WaitTime%
 
ToolTip, Testing %Kex% With SendRaw,0,0
sleep, %WaitTime%
SendRaw, %Kex%
 
ToolTip, Testing %Kex% With SendInput,0,0
sleep, %WaitTime%
SendInput, %Kex%
 
ToolTip, Testing %Kex% With SendPlay,0,0
sleep, %WaitTime%
SendPlay, %Kex%
 
ToolTip, Testing %Kex% With SendEvent,0,0
sleep, %WaitTime%
SendEvent, %Kex%
 
ToolTip, Testing %Kex% With ControlSend,0,0
sleep, %WaitTime%
ControlSend,,%Kex%, %wintext%
 
ToolTip, Testing %Kex% With ControlSendRaw,0,0
sleep, %WaitTime%
ControlSendRaw,,%Kex%, %wintext%

ToolTip, Testing Dll call keybd_event (will send 9),0,0
sleep, %WaitTime%
dllcall("keybd_event", int, 57, int, 0x049, int, 0, int, 0)
sleep, 500
dllcall("keybd_event", int, 57, int, 0x049, int, 2, int, 0)
 
 ToolTip, Testing %Kex% With Wscript,0,0
sleep, %WaitTime%
ComObjCreate("wscript.shell").SendKeys("%Kex%")
 
ToolTip, Send Test Done
sleep, %WaitTime%
ToolTip,
}
 
return

GuiClose:
ExitApp

^esc::ExitApp

+esc::Reload