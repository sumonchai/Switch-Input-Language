	if not A_IsAdmin
	{
		Run *RunAs "%A_ScriptFullPath%"
		ExitApp
	}
	; ========================
	#SingleInstance, force
	#InstallKeybdHook
	#InstallMouseHook
	DetectHiddenWindows, On
	CoordMode, Mouse, Relative ; needed for mouseclickdrag
	CoordMode, Tooltip, Screen
	SetTitleMatchMode, 2
	SetKeyDelay, 200,200
	SetWinDelay, 300
	SetControlDelay, 300
	SetBatchLines, 300ms
	Version := "v4.1"
	RunHotkey := 0 ; Hotkeys disabled until run button pressed.
	; ========================================================================================
	Gui, Main:Add, Tab2, x5  y5 w510 h520, Info | Config
	; Info Tab
	Gui, Main:Add, Text, x170 y35  w180 h20, Send And Click Test Tool %Version%
	Gui, Main:Add, Text, x25  y67  w400 h20, Make sure that Click and Send Tool is running as Administrator or it will NOT work!
	Gui, Main:Add, Text, x25  y97  w470 h20, Also make sure that the game or program is running in Window mode to get the best results.
	Gui, Main:Add, Text, x25  y127 w470 h20, Around 2000 and 4000 is recommended for Time delay between the commands.
	Gui, Main:Add, Text, x25  y157 w470 h20, Note that F1 or F3 can NOT be used as test keys.
	Gui, Main:Add, Text, x15  y447 w180 h20, Autohtokey Forum Links:
	Gui, Main:Add, Link, x15  y467      h20, <a href="http://www.autohotkey.com/board/topic/95653--/">Send and Click Tool %Version%</a>
	Gui, Main:Add, Link, x15  y487      h20, <a href="http://www.autohotkey.com/board/user/21149--/">SnowFlake Profile Page</a>
	Gui, Main:Add, Text, x380 y427 h20, AHK Version %A_AhkVersion%
	Gui, Main:Add, Text, x380 y447 h20, System:  %A_OSVersion%
	Gui, Main:Add, Text, x380 y467 h20, Version: %Version%
	Gui, Main:Add, Text, x380 y487 h20, Date: %A_DD%/%A_MM%/%A_YYYY%
	; ========================================================================================
	Gui, Main:Tab,2
	; Config Tab
	Gui, Main:Add, Button, x15  y37  w100 h30 gStart            , Select a Window
	Gui, Main:Add,   Text, x20  y77  w90  h20                   , Selected Window :
	Gui, Main:Add,   Edit, x115 yp-2 w250 h20 vwinid
	Gui, Main:Add,   Text, x50  y117 w60  h20                   , Time Delay :
	Gui, Main:Add,   Edit, x115 yp-2 w70  h20 vWaitTime Number  , 2000
	Gui, Main:Add,   Text, x30  y157 w80  h20                   , Enter Test Key :
	Gui, Main:Add, Hotkey, x115 yp-2 w20  h20 vkex              , Q
	Gui, Main:Add, Button, x15  y187 w100 h30 gCord             , Select Mouse Coordinates
	Gui, Main:Add,   Text, x60  y227 w50  h20                   , Mouse X :
	Gui, Main:Add,   Edit, x115 yp-2 w50  h20 Vxx Number
	Gui, Main:Add,   Text, x60  y257 w50  h20                   , Mouse Y :
	Gui, Main:Add,   Edit, x115 yp-2 w50  h20 Vyy Number
	Gui, Main:Add,  Radio, x15  y300 w110 h30 Checked vRadio_all, Test all send/click commands
	Gui, Main:Add,  Radio, x136 y300 w110 h30 gRadio_advanced   , Select Commands (Advanced Mode)
	Gui, Main:Add, Button, x15  y350 w100 h30 gsave             , Run
	; ========================================================================================
	Gui, AdvanceClick:Add, Text,     x165  y10  w170 h20     , Click Advanced Mode Settings
	Gui, AdvanceClick:Add, GroupBox, x5   y35  w470 h515     , Click Commands
	Gui, AdvanceClick:Add, CheckBox, x15  y67  w100 h30      , Test click
	Gui, AdvanceClick:Add, CheckBox, x15  y107 w100 h30 vMC1 , Test MouseClick
	Gui, AdvanceClick:Add, CheckBox, x15  y147 w150 h30 vMC2 , Test MouseClickDrag Fast
	Gui, AdvanceClick:Add, CheckBox, x15  y187 w170 h30 vMC3 , Test MouseClickDrag Slow
	Gui, AdvanceClick:Add, CheckBox, x15  y227 w130 h30 vMC4 , Test ControlClick
	Gui, AdvanceClick:Add, CheckBox, x15  y267 w130 h30 vMC5 , Test Send Click
	Gui, AdvanceClick:Add, CheckBox, x15  y307 w130 h30 vMC6 , Test SendRaw Click
	Gui, AdvanceClick:Add, CheckBox, x15  y347 w130 h30 vMC7 , Test SendPlay Click
	Gui, AdvanceClick:Add, CheckBox, x15  y387 w130 h30 vMC8 , Test SendEvent Click
	Gui, AdvanceClick:Add, CheckBox, x15  y427 w130 h30 vMC9 , Test SendInput Click
	Gui, AdvanceClick:Add, CheckBox, x15  y467 w130 h30 vMC10, Test ControlSend Click
	Gui, AdvanceClick:Add, CheckBox, x15  y507 w160 h30 vMC12, Test ControlSendRaw Click
	Gui, AdvanceClick:Add, CheckBox, x235 y67  w160 h30 vMC13, Test ControlClick v2
	Gui, AdvanceClick:Add, CheckBox, x235 y107 w160 h30 vMC14, Test PostMessage Click
	Gui, AdvanceClick:Add, CheckBox, x235 y147 w160 h30 vMC15, Test SendMessage Click
	Gui, AdvanceClick:Add, CheckBox, x235 y187 w160 h30 vMC16, Test DllCall Mouse_event
	; ========================================================================================
	Gui, AdvanceSend:Add, Text,     x95 y10  w170 h20     , Send Advanced Mode Settings
	Gui, AdvanceSend:Add, GroupBox, x5  y35  w330 h400    , Send Commands
	Gui, AdvanceSend:Add, Checkbox, x15 y65  w100 h30 vKS1, Test Send
	Gui, AdvanceSend:Add, Checkbox, x15 y+10 w100 h30 vKS2, Test SendRaw
	Gui, AdvanceSend:Add, Checkbox, x15 y+10 w150 h30 vKS3, Test SendInput
	Gui, AdvanceSend:Add, Checkbox, x15 y+10 w170 h30 vKS4, Test SendPlay
	Gui, AdvanceSend:Add, Checkbox, x15 y+10 w130 h30 vKS5, Test SendEvent
	Gui, AdvanceSend:Add, Checkbox, x15 y+10 w130 h30 vKS6, Test ControlSend
	Gui, AdvanceSend:Add, Checkbox, x15 y+10 w130 h30 vKS7, Test ControlSendRaw
	Gui, AdvanceSend:Add, Checkbox, x15 y+10 w260 h30 vKS8, Test Dllcall keybd_event
	Gui, AdvanceSend:Add, Checkbox, x15 y+10 w160 h30 vKS9, Test Send Wscript(COM)
	; ========================================================================================
	Gui, Main:Show, w520 h530 Center, Send And Click Tool %Version%
	return

	Radio_advanced:
		MsgBox, 4160, Select a the Commands, Select the Commands you want Send and Click Tool %Version% to test.
		IfMsgBox OK
		{
			Gui, AdvanceClick:Show, w480 h555, Click Advanced Mode
			Gui, AdvanceSend:Show, w340 h440, Send Advanced Mode
		}
		RunHotkey := 0    ; Reset to prevent hotkey use until Run Button pressed.
	return

	Start:
		gui,hide
		MsgBox, 4160, Select a Window, To start Press OK then`nPlace your cursor over the window you want to select. then press Space key to get the Title.
		IfMsgBox No
			goto, Start    
		keywait, MButton, D
		keywait, MButton
		WinGetActiveTitle, winidX
		MsgBox, 4132, A Window have been selected, You have selected the following Window: `n`n %winidX% `n`nAre you satisfied with it?
		IfMsgBox No
			goto, Start    
		GuiControl,, winid, %winidX%
		Gui, Submit   
		Gui,Show, w520 h530 Center, Send and Click Tool %Version%
		RunHotkey := 0    ; Reset to prevent hotkey use until Run Button pressed.
	return

	Cord:
		gui,hide
		MsgBox, 4160, Select Coordination, Press OK then`nPress Space key to select the mouse X and Y coordination you want the test the Clicks on.
		keywait, Space, D
		keywait, Space
		mousegetpos, XXX, YYY
		MsgBox, 4132,Coordination have been set, You have set the following X and Y Coordinations`n`nX = %XXX%`n`nY = %YYY%`n`nAre you satisfied with it?
		IfMsgBox No
			goto, Cord
		GuiControl,, xx, %XXX%
		GuiControl,, yy, %YYY%
		Gui, Submit   
		Gui, Show, w520 h530 Center, Send and Click Tool %Version%
		RunHotkey := 0    ; Reset to prevent hotkey use until Run Button pressed.
	return

	save:    ; Run Button, Do all Checks here since we have hotkeys disabled until Run is clicked.
		Gui, Submit
		Gui, AdvanceSend:Submit
		Gui, AdvanceClick:Submit
		if (winid = "")            ; Check Window
		{
			MsgBox, 16, A Window is not selected!, Please select a window to use Send and Click Tool.
			Gui, Main:Show, w520 h530 Center, Send and Click Tool %Version%
			return
		}
		if (xx = "")               ; Check Coords
		{
			MsgBox, 16, Coords not selected!, Please select Mouse Coords to use Click Test.
			Gui, Main:Show, w520 h530 Center, Send and Click Tool %Version%
			return
		}
		if (radio_all)             ; Check Radio Button
		{
			MC1 := MC2 := MC3 := MC4 := MC5 := MC6 := MC7 := MC8 := MC9 := MC10 := MC11 := MC12 := MC13 := MC14 := MC15 := MC16 := MC17 := 1
			KS1 := KS2 := KS3 := KS4 := KS5 := KS6 := KS7 := KS8 := KS9 := 1
		}
		if !(WaitTime >= 10)       ; Check Delay
		{
			GuiControl,, WaitTime, 10
			Gui, Submit
		}
		if (Kex = "")  ; Check kex value because using backspace will set hotkey to nothing!
		{
			GuiControl,, Kex, Q    ;set to default
			Gui, Submit 
		}
		MsgBox, 4148, Final Information, Window Selected = %winid%`n`n Key to send = %kex% `n`nWait time between send commands = %WaitTime%`n`nMouse X coordinate = %XXX%`n`nMouse Y coordinate = %YYY%
		IfMsgBox No
		{
			Gui,Show, w520 h530 Center, Send and Click Tool %Version%
			return
		}
		MsgBox, 4160, Select option, Select if you want to send the key or click the coordinates`n`nF1 = Tests the mouse click commands`n`nF3 = Tests the Send commands`n`nEscape will exit/quit Send and Click Tool %Version%
		RunHotkey := 1
	return

	$F1::             ; Press F1 to run Click test.
		KeyWait, F1
		if !RunHotkey
			return
		RunHotkey := 0
		SoundBeep
	ClickTest: ; ========================================================================================
		sleep, WaitTime
		ToolTip, Running Click Test,0,0
		WinActivate, %winid%
		WinSet, AlwaysOnTop, ON, %winid%
		IF (MC1)
		{
			ToolTip, Testing Click,0,0
			sleep, WaitTime
			Click, %XX%, %YY%
		}
		IF (MC2)
		{
			ToolTip, Testing MouseClick,0,0
			sleep, WaitTime	
			MouseClick, Left, %XX%, %YY%
		}
		IF (MC3)
		{
			ToolTip, Testing MouseClickDrag Fast,0,0
			sleep, WaitTime
			MouseClickDrag, left, 0, XX, YY, 0, 20
		}
		IF (MC4)
		{
			ToolTip, Testing MouseClickDrag Slow,0,0
			sleep, WaitTime
			MouseClickDrag, left, 0, XX, YY, 0, 30
		}
		IF (MC5)
		{
			ToolTip, Testing ControlClick,0,0
			sleep, WaitTime	
			ControlClick, x%XX% y%YY%, %winid%, Left
		}
		IF (MC6)
		{
			ToolTip, Testing Send Click,0,0
			sleep, WaitTime	
			Send, {Click %XX%, %YY%}
		}
		IF (MC7)
		{
			ToolTip, Testing SendRaw Click,0,0
			sleep, WaitTime
			SendRaw, {LButton}
		}
		IF (MC8)
		{
			ToolTip, Testing SendPlay Click,0,0
			sleep, WaitTime
			SendPlay, {LButton}
		}
		IF (MC9)
		{
			ToolTip, Testing SendEvent Click,0,0
			sleep, WaitTime
			SendEvent, {LButton}
		}
		IF (MC10)
		{
			ToolTip, Testing SendInput Click,0,0
			sleep, WaitTime
			SendInput, {LButton}
		}
		IF (MC11)
		{
			ToolTip, Testing ControlSend Click,0,0
			sleep, WaitTime
			ControlSend,,{Click %XX%, %YY%},%winid%
		}
		IF (MC12)
		{
			ToolTip, Testing ControlSendRaw Click,0,0
			sleep, WaitTime
			ControlSendRaw,,{Click %XX%, %YY%},%winid%
		}
		IF (MC13)
		{
			ToolTip, Testing ControlClick v2 Left Mouse,0,0
			AFK_Click(XX,YY, winid)
			sleep, 500
		}
		IF (MC14)
		{
			ToolTip, Testing PostMessage Click,0,0
			sleep, WaitTime
			PostMessage, 0x201, 0x00000000, 0x01f0010f, , %winid% ; Down
			sleep, 500
			PostMessage, 0x202, 0x00000000, 0x01f0010f, , %winid% ; UP
		}
		IF (MC15)
		{
			ToolTip, Testing SendMessage Click,0,0
			sleep, WaitTime
			SendMessage, 0x201, 0x00000000, 0x01f0010f, , %winid% ; Down
			sleep, 500
			SendMessage, 0x202, 0x00000000, 0x01f0010f, , %winid% ; UP
		}
		IF (MC16)
		{
			ToolTip, Testing DllCall Mouse_event,0,0
			sleep, WaitTime
		MouseMove, XX, YY
		dllcall("mouse_event", Uint, 0x02, Uint, 0, Uint, 0, Uint, 0, UPtr, 0) ; Down
		sleep, 500
		dllcall("mouse_event", Uint, 0x04, Uint, 0, Uint, 0, Uint, 0, UPtr, 0) ; UP
		}
		ToolTip, Click Test Done,0,0
		sleep, WaitTime
		SoundBeep
		ToolTip
		WinSet, AlwaysOnTop, OFF, %winid%
		MsgBox, 4160, Select option, Select if you want to send the key or click the coordinates`n`nF1 = Tests the mouse clicks`n`nF3 = Tests the Send commands`n`nCtrl + Escape will show the Send And Click Tool %Version% Gui`n`n
		RunHotkey := 1
	return
	; ========================================================================================
	$F3::              ; Press F3 to run Send test.
		KeyWait, F3
		if !RunHotkey
			return
		RunHotkey := 0
		SoundBeep
	SendTest:
		sleep, WaitTime
		ToolTip, Running Send Test,0,0
		WinActivate, %winid%
		WinSet, AlwaysOnTop, ON, %winid%
		IF (KS1)
		{
			ToolTip, Testing %Kex% With Send,0,0
			sleep, WaitTime	
			Send, %Kex%
		}
		IF (KS2)
		{
			ToolTip, Testing %Kex% With SendRaw,0,0
			sleep, WaitTime
			SendRaw, %Kex%
		}
		IF (KS3)
		{
			ToolTip, Testing %Kex% With SendInput,0,0
			sleep, WaitTime
			SendInput, %Kex%
		}
		IF (KS4)
		{
			ToolTip, Testing %Kex% With SendPlay,0,0
			sleep, WaitTime
			SendPlay, %Kex%
		}
		IF (KS5)
		{
			ToolTip, Testing %Kex% With SendEvent,0,0
			sleep, WaitTime
			SendEvent, %Kex%
		}
		IF (KS6)
		{
			ToolTip, Testing %Kex% With ControlSend,0,0
			sleep, WaitTime
			ControlSend,,%Kex%, %winid%
		}
		IF (KS7)
		{
			ToolTip, Testing %Kex% With ControlSendRaw,0,0
			sleep, WaitTime
			ControlSendRaw,,%Kex%, %winid%
		}
		IF (KS8)
		{
			ToolTip, Testing %Kex% With Dllcall keybd_event,0,0
			VK := Format("0x{:02X}", GetKeyVK(Kex))
			SC := Format("0x{:03X}", GetKeySC(Kex))
			sleep, WaitTime
			dllcall("keybd_event", UChar, VK, UChar, SC, Uint, 0, UPtr, 0) ; Down
			sleep, 500
			dllcall("keybd_event", UChar, VK, UChar, SC, Uint, 2, UPtr, 0) ; UP
		}
		IF (KS9)
		{
			ToolTip, Testing %Kex% With Wscript will send 1,0,0
			sleep, WaitTime
			ComObjCreate("wscript.shell").SendKeys(Chr(49))
		}

		ToolTip, Send Test Done
		sleep, WaitTime
		SoundBeep
		ToolTip
		WinSet, AlwaysOnTop, OFF, %winid%
		MsgBox, 4160, Select option, Select if you want to send the key or click the coordinates`n`nF1 = Tests the mouse clicks`n`nF3 = Tests the Send commands`n`nCtrl + Escape will show the Send And Click Tool %Version% Gui`n`n
		RunHotkey := 1
	return

	AFK_Click(X, Y, WinTitle="", WinText="", ExcludeTitle="", ExcludeText=""){
		SetControlDelay -1
		hwnd:=ControlFromPoint(X, Y, WinTitle, WinText, cX, cY, ExcludeTitle, ExcludeText)
		PostMessage, 0x201, 0, cX&0xFFFF | cY<<16,, ahk_id %hwnd% ; WM_LBUTTONDOWN
		PostMessage, 0x202, 0, cX&0xFFFF | cY<<16,, ahk_id %hwnd% ; WM_LBUTTONUP
		PostMessage, 0x203, 0, cX&0xFFFF | cY<<16,, ahk_id %hwnd% ; WM_LBUTTONDBLCLCK
		PostMessage, 0x202, 0, cX&0xFFFF | cY<<16,, ahk_id %hwnd% ; WM_LBUTTONUP
	}

	ControlFromPoint(X, Y, WinTitle="", WinText="", ByRef cX="", ByRef cY="", ExcludeTitle="", ExcludeText=""){
		static EnumChildFindPointProc=0
		if !EnumChildFindPointProc
			EnumChildFindPointProc := RegisterCallback("EnumChildFindPoint","Fast")
	  
		if !(target_window := WinExist(WinTitle, WinText, ExcludeTitle, ExcludeText))
			return false
	  
		VarSetCapacity(rect, 16)
		DllCall("GetWindowRect","uint",target_window,"uint",&rect)
		VarSetCapacity(pah, 36, 0)
		NumPut(X + NumGet(rect,0,"int"), pah,0,"int")
		NumPut(Y + NumGet(rect,4,"int"), pah,4,"int")
		DllCall("EnumChildWindows","uint",target_window,"uint",EnumChildFindPointProc,"uint",&pah)
		control_window := NumGet(pah,24) ? NumGet(pah,24) : target_window
		DllCall("ScreenToClient","uint",control_window,"uint",&pah)
		cX:=NumGet(pah,0,"int"), cY:=NumGet(pah,4,"int")
		return control_window
	}

	^Esc::Gui, Main:Show, w520 h530 Center, Send and Click Tool %Version%

	Esc::
	MainGuiClose:
		if (winid !="")   ; Turn off AllwaysOnTop in case script is closed while test is running.
			WinSet, AlwaysOnTop, OFF, %winid%
		ExitApp