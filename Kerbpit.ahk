#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force

;define the index of the controller 
;FCID = 1
;use the controller index to execute commands
;Hotkey, %FCID%joy1, ResetMFD1

SetKeyDelay,1

myjoy:= 1
mynumber := 10
mymfd := 3
mykey := "P"
amfd := 4

Hotkey,^Numpad0,ResetMFD0
Hotkey,^NumpadDot,ResetMFDALL
Hotkey,^NumpadEnter,RelogMFDALL
Hotkey,^Numpad7,ListMFD%amfd%
Hotkey,^Numpad8,AutopilotNode
Hotkey,^Numpad9,AutopilotLaunch
Hotkey,^Numpad5,AutopilotLand
Hotkey,^Numpad6,AutopilotAircraft
Hotkey,^Left,AutopilotHeadDown
Hotkey,^Right,AutopilotHeadUp
Hotkey,^Up,AutopilotAltUp
Hotkey,^Down,AutopilotAltDown
	Return

;G710 GKEYS 
;Hotkey,sc002,
;Hotkey,sc003,
;Hotkey,sc004,
;Hotkey,sc005,
;Hotkey,sc006,
;Hotkey,sc007,

;^A::
;	ControlSend,,A,kOS MFD%amfd% ;log into the kOS CPU
;	Return
	
;^B::
;	ControlSend,,B,kOS MFD%amfd% ;log into the kOS CPU
;	Return

;^C::
;	ControlSend,,C,kOS MFD%amfd% ;log into the kOS CPU
;	Return

;^1::
;	ControlSend,,1,kOS MFD%amfd% ;log into the kOS CPU
;	Return

;^2::
;	ControlSend,,2,kOS MFD%amfd% ;log into the kOS CPU
;	Return

;^3::
;	ControlSend,,3,kOS MFD%amfd% ;log into the kOS CPU
;	Return

AutopilotNode:
	ControlSend,,run{Space}F2.{Enter}, kOS MFD2 
	Return

AutopilotLaunch:
	ControlSend,,run{Space}F1(100`,25).{Enter}, kOS MFD2 
	Return

AutopilotLand:
	ControlSend,,run{Space}F3.{Enter}, kOS MFD2 
	Return
	
AutopilotAircraft:
	ControlSend,,run{Space}F4.{Enter}, kOS MFD2 
	Return
	
AutopilotHeadDown:
	ControlSend,,run{Space}autopilot_adjust(-1`,0`,0`,0`,0).{Enter}, kOS MFD0 
	Return

AutopilotHeadUp:
	ControlSend,,run{Space}autopilot_adjust(1`,0`,0`,0`,0).{Enter}, kOS MFD0 
	Return

AutopilotAltUp:
	ControlSend,,run{Space}autopilot_adjust(0`,1`,0`,0`,0).{Enter}, kOS MFD0 
	Return

AutopilotAltDown:
	ControlSend,,run{Space}autopilot_adjust(0`,-1`,0`,0`,0).{Enter}, kOS MFD0 
	Return

^NumpadAdd::
	ControlSend,,run{Space},kOS MFD%amfd% 
	Return

^NumpadEnter::
	ControlSend,,.{Enter},kOS MFD%amfd% 
	Return

1joy2::
        WinActivate, Kerbal Space Program
        Send, G
Return

1joy30::
        WinActivate, kOS MFD1
        Send, toggle ag21.{Enter}
Return

1joy6::
	mynumber := 1
Return
1joy7::
	mynumber := 0.1
Return
1joy8::
        WinActivate, kOS MFD%mymfd%
        Send, set nextnode:prograde to nextnode:prograde {+} %mynumber%.{Enter}
		WinActivate, Kerbal Space Program
Return
1joy9::
        WinActivate, kOS MFD%mymfd%
        Send, set nextnode:prograde to nextnode:prograde {-} %mynumber%.{Enter}
		WinActivate, Kerbal Space Program
Return
1joy10::
	mymfd := 3
Return
1joy11::
	mymfd := 4
	Return
	
ResetMFDALL:
	gosub ResetMFD0
	gosub ResetMFD1
	gosub ResetMFD3
	gosub ResetMFD2
	gosub ResetMFD4
	Return
	
RelogMFDALL:
	ControlSend,,5{Enter}, kOS MFD0 ;log into the kOS CPU
	ControlSend,,1{Enter}, kOS MFD1 ;log into the kOS CPU
	ControlSend,,2{Enter}, kOS MFD2 ;log into the kOS CPU
	ControlSend,,3{Enter}, kOS MFD3 ;log into the kOS CPU
	ControlSend,,4{Enter}, kOS MFD4 ;log into the kOS CPU
	Sleep 100
	ControlSend,,switch to archive.{Enter}, kOS MFD0 ;log into the kOS CPU
	ControlSend,,switch to archive.{Enter}, kOS MFD1 ;log into the kOS CPU
	ControlSend,,switch to archive.{Enter}, kOS MFD2 ;log into the kOS CPU
	ControlSend,,switch to archive.{Enter}, kOS MFD3 ;log into the kOS CPU
	ControlSend,,switch to archive.{Enter}, kOS MFD4 ;log into the kOS CPU
	Return
	
ResetMFD0:
	WinKill, kOS MFD0 ;in case something went wrong, close the last version of the window
	Sleep 100 ;give the window time to terminate
	Run, C:\Program Files\PuTTY\putty.exe -load ""MFD0"" ;load the saved session
	Sleep 500 ; give the window time to load and handshake
	WinMove, kOS MFD0,, -500, -900, 500,500 ;relocated to the proper screen
	ControlSend,,5{Enter}, kOS MFD0 ;log into the kOS CPU
	Sleep 100
	ControlSend,,switch to archive.{Enter}, kOS MFD0 ;log into the kOS CPU
	Return

ResetMFD1:
	WinKill, kOS MFD1 ;in case something went wrong, close the last version of the window
	Sleep 100 ;give the window time to terminate
	Run, C:\Program Files\PuTTY\putty.exe -load ""MFD1"" ;load the saved session
	Sleep 1000 ; give the window time to load and handshake
	WinMove, kOS MFD1,, -1000, -100, 500,500 ;relocated to the proper screen
	ControlSend,,1{Enter}, kOS MFD1 ;log into the kOS CPU
	Sleep 100
	ControlSend,,switch to archive.{Enter}, kOS MFD1 ;log into the kOS CPU
	Return

ResetMFD2:
	WinKill, kOS MFD2 ;in case something went wrong, close the last version of the window
	Sleep 100 ;give the window time to terminate
	Run, C:\Program Files\PuTTY\putty.exe -load ""MFD2"" ;load the saved session
	Sleep 1000 ; give the window time to load and handshake
	WinMove, kOS MFD2,, -800, -500, 800,800 ;relocated to the proper screen
	ControlSend,,2{Enter}, kOS MFD2 ;log into the kOS CPU
	Sleep 100
	ControlSend,,switch to archive.{Enter}, kOS MFD2 ;log into the kOS CPU
	Return

ResetMFD3:
	WinKill, kOS MFD3 ;in case something went wrong, close the last version of the window
	Sleep 100 ;give the window time to terminate
	Run, C:\Program Files\PuTTY\putty.exe -load ""MFD3"" ;load the saved session
	Sleep 1000 ; give the window time to load and handshake
	WinMove, kOS MFD3,, -1000, 400, 500,500 ;relocated to the proper screen
	ControlSend,,3{Enter}, kOS MFD3 ;log into the kOS CPU
	Sleep 100
	ControlSend,,switch to archive.{Enter}, kOS MFD3 ;log into the kOS CPU
	Return

ResetMFD4:
	WinKill, kOS MFD4 ;in case something went wrong, close the last version of the window
	Sleep 100 ;give the window time to terminate
	Run, C:\Program Files\PuTTY\putty.exe -load ""MFD4"" ;load the saved session
	Sleep 1000 ; give the window time to load and handshake
	WinMove, kOS MFD4,, -800, 300, 800,800 ;relocated to the proper screen
	ControlSend,,4{Enter}, kOS MFD4 ;log into the kOS CPU
	Sleep 100
	ControlSend,,switch to archive.{Enter}, kOS MFD4 ;log into the kOS CPU
	Return

ListMFD4:
	ControlSend,,run MFD4_LIST.{Enter},kOS MFD4 
	ControlSend,,run MFD3_LIST.{Enter},kOS MFD2  ;for testing 
	Return
	