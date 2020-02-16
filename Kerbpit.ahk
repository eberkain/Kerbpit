#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force

;define the index of the controller 
;FCID = 1
;use the controller index to execute commands
;Hotkey, %FCID%joy1, ResetMFD1

SetKeyDelay,1,-1

myjoy:= 1
mynumber := 10
mymfd := 3
mykey := "P"
amfd := 3

mfd1w := 788			
mfd1h := 730
mfd1x := -778
mfd1y := -38

mfd2w := 788			
mfd2h := 730
mfd2x := 1915
mfd2y := -38

mfd3w := 788			
mfd3h := 730
mfd3x := -778
mfd3y := 650

mfd4w := 788			
mfd4h := 730
mfd4x := 1915
mfd4y := 650

Hotkey,^Numpad0,ResetMFD0
Hotkey,^NumpadDot,ResetMFDALL
Hotkey,^NumpadEnter,RelogMFDALL
Hotkey,^Numpad7,ListMFD%amfd%
Hotkey,^Numpad8,AutopilotNode
Hotkey,^Numpad9,AutopilotLaunch
Hotkey,^Numpad5,AutopilotLand
Hotkey,^Numpad6,AutopilotAircraft
Hotkey,^NumpadAdd,AutopilotStop
Hotkey,^Numpad1,ResetMFD1
Hotkey,^Numpad2,ResetMFD2
Hotkey,^Numpad3,ResetMFD3
Hotkey,^Numpad4,ResetMFD4
Hotkey,^Left,AutopilotHeadDown
Hotkey,^Right,AutopilotHeadUp
Hotkey,^Up,AutopilotAltUp
Hotkey,^Down,AutopilotAltDown

;alt to test remote numpad
Hotkey,!Numpad0,FCSEND0
Hotkey,!Numpad1,FCSEND1
Hotkey,!Numpad2,FCSEND2
Hotkey,!Numpad3,FCSEND3
Hotkey,!Numpad4,FCSEND4
Hotkey,!Numpad5,FCSEND5
Hotkey,!Numpad6,FCSEND6
Hotkey,!Numpad7,FCSEND7
Hotkey,!Numpad8,FCSEND8
Hotkey,!Numpad9,FCSEND9
Hotkey,!NumpadEnter,FCSENDENTER

Hotkey,^1,MFD3B1
Hotkey,^2,MFD3B2
Hotkey,^3,MFD3B3
Hotkey,^4,MFD3B4
Hotkey,^5,MFD3B5
Hotkey,^6,MFD3B6

	Return

;G710 GKEYS 
;Hotkey,^sc002,MFD3B1
;Hotkey,sc003,25
;Hotkey,sc004,5432113456654321
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

MFD3B1:
	ControlSend,,toggle{Space}ag239.{Enter},kOS MFD0 
	Return
MFD3B2:
	ControlSend,,toggle{Space}ag240.{Enter},kOS MFD0 
	Return
MFD3B3:
	ControlSend,,toggle{Space}ag241.{Enter},kOS MFD0 
	Return
MFD3B4:
	ControlSend,,toggle{Space}ag242.{Enter},kOS MFD0 
	Return
MFD3B5:
	ControlSend,,toggle{Space}ag243.{Enter},kOS MFD0 
	Return
MFD3B6:
	ControlSend,,toggle{Space}ag244.{Enter},kOS MFD0 
	Return

AutopilotNode:
	ControlSend,,run{Space}F2.{Enter},kOS MFD3 
	Return

AutopilotLaunch:
	ControlSend,,run{Space}F1(100000`,0`).{Enter},kOS MFD3 
	Return

AutopilotLand:
	ControlSend,,run{Space}F3.{Enter},kOS MFD3 
	Return
	
AutopilotAircraft:
	ControlSend,,run{Space}F4.{Enter},kOS MFD3 
	Return
	
AutopilotStop:
	ControlSend,,^c,kOS MFD3
	Return 
	
AutopilotHeadDown:
	ControlSend,,run{Space}ap_adj(-1`,0`,0`,0`,0`).{Enter}, kOS MFD0 
	Return

AutopilotHeadUp:
	ControlSend,,run{Space}ap_adj(1`,0`,0`,0`,0`).{Enter}, kOS MFD0 
	Return

AutopilotAltUp:
	ControlSend,,run{Space}ap_adj(0`,1000`,0`,0`,0`).{Enter}, kOS MFD0 
	Return

AutopilotAltDown:
	ControlSend,,run{Space}ap_adj(0`,-1`,0`,0`,0`).{Enter}, kOS MFD0 
	Return

;Flight Computer Buttons
FCSEND0:
	ControlSend,,0,kOS MFD%amfd% 
	Return
FCSEND1:
	ControlSend,,1,kOS MFD%amfd% 
	Return
FCSEND2:
	ControlSend,,2,kOS MFD%amfd% 
	Return
FCSEND3:
	ControlSend,,3,kOS MFD%amfd% 
	Return
FCSEND4:
	ControlSend,,4,kOS MFD%amfd% 
	Return
FCSEND5:
	ControlSend,,5,kOS MFD%amfd% 
	Return
FCSEND6:
	ControlSend,,6,kOS MFD%amfd% 
	Return
FCSEND7:
	ControlSend,,7,kOS MFD%amfd% 
	Return
FCSEND8:
	ControlSend,,8,kOS MFD%amfd% 
	Return
FCSEND9:
	ControlSend,,9,kOS MFD%amfd% 
	Return
FCSENDENTER:
	ControlSend,,{Enter},kOS MFD%amfd% 
	Return

;^NumpadAdd::
;	ControlSend,,run{Space},kOS MFD%amfd% 
;	Return

;^NumpadEnter::
;	ControlSend,,.{Enter},kOS MFD%amfd% 
;	Return

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
	WinKill, kOS MFD0 ;in case something went wrong, close the last version of the window
	WinKill, kOS MFD1 ;in case something went wrong, close the last version of the window
	WinKill, kOS MFD2 ;in case something went wrong, close the last version of the window
	WinKill, kOS MFD3 ;in case something went wrong, close the last version of the window
	WinKill, kOS MFD4 ;in case something went wrong, close the last version of the window
	Sleep 100 ;give the window time to terminate
	Run, C:\Program Files\PuTTY\putty.exe -load ""MFD0"" ;load the saved session
	Run, C:\Program Files\PuTTY\putty.exe -load ""MFD1"" ;load the saved session
	Run, C:\Program Files\PuTTY\putty.exe -load ""MFD2"" ;load the saved session
	Run, C:\Program Files\PuTTY\putty.exe -load ""MFD3"" ;load the saved session
	Run, C:\Program Files\PuTTY\putty.exe -load ""MFD4"" ;load the saved session
	Sleep 1000 ; give the window time to load and handshake
	WinMove, kOS MFD0,, 0, 0, 500,500 ;relocated to the proper screen
	WinMove, kOS MFD3,, mfd3x, mfd3y, mfd3w, mfd3h ;relocated to the proper screen
	WinMove, kOS MFD4,, mfd4x, mfd4y, mfd4w, mfd4h ;relocated to the proper screen
	WinMove, kOS MFD1,, mfd1x, mfd1y, mfd1w, mfd1h ;relocated to the proper screen
	WinMove, kOS MFD2,, mfd2x, mfd2y, mfd2w, mfd2h ;relocated to the proper screen
	Sleep 500
	ControlSend,,5{Enter}, kOS MFD0 ;log into the kOS CPU
	ControlSend,,3{Enter}, kOS MFD3 ;log into the kOS CPU
	ControlSend,,4{Enter}, kOS MFD4 ;log into the kOS CPU
	ControlSend,,1{Enter}, kOS MFD1 ;log into the kOS CPU
	ControlSend,,2{Enter}, kOS MFD2 ;log into the kOS CPU
	Sleep 500
	ControlSend,,switch to archive.{Enter}, kOS MFD0 ;log into the kOS CPU
	ControlSend,,switch to archive.{Enter}, kOS MFD3 ;log into the kOS CPU
	ControlSend,,switch to archive.{Enter}, kOS MFD4 ;log into the kOS CPU
	ControlSend,,switch to archive.{Enter}, kOS MFD1 ;log into the kOS CPU
	ControlSend,,switch to archive.{Enter}, kOS MFD2 ;log into the kOS CPU
	Sleep 500
	ControlSend,,run list3.{enter}, kOS MFD3 ;run the list script
	ControlSend,,run list4.{enter}, kOS MFD4 ;run the list script
	ControlSend,,run e1.{enter}, kOS MFD1 ;run the status script
	ControlSend,,run d1.{enter}, kOS MFD2 ;run the status script
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
	Sleep 100
	ControlSend,,run e1.{enter}, kOS MFD1 ;run the status script
	ControlSend,,run d1.{enter}, kOS MFD2 ;run the status script
	ControlSend,,run list3.{enter}, kOS MFD3 ;run the list script
	ControlSend,,run list4.{enter}, kOS MFD4 ;run the list script
	Return
	
ResetMFD0:
	WinKill, kOS MFD0 ;in case something went wrong, close the last version of the window
	Sleep 100 ;give the window time to terminate
	Run, C:\Program Files\PuTTY\putty.exe -load ""MFD0"" ;load the saved session
	Sleep 500 ; give the window time to load and handshake
	WinMove, kOS MFD0,, 0, 0, 500,500 ;relocated to the proper screen
	ControlSend,,5{Enter}, kOS MFD0 ;log into the kOS CPU
	Return

ResetMFD1:
	WinKill, kOS MFD1 ;in case something went wrong, close the last version of the window
	Sleep 100 ;give the window time to terminate
	Run, C:\Program Files\PuTTY\putty.exe -load ""MFD1"" ;load the saved session
	Sleep 1000 ; give the window time to load and handshake
	WinMove, kOS MFD1,, mfd1x, mfd1y, mfd1w, mfd1h ;relocated to the proper screen
	ControlSend,,1{Enter}, kOS MFD1 ;log into the kOS CPU
	Return

ResetMFD2:
	WinKill, kOS MFD2 ;in case something went wrong, close the last version of the window
	Sleep 100 ;give the window time to terminate
	Run, C:\Program Files\PuTTY\putty.exe -load ""MFD2"" ;load the saved session
	Sleep 1000 ; give the window time to load and handshake
	WinMove, kOS MFD2,, mfd2x, mfd2y, mfd2w, mfd2h ;relocated to the proper screen
	ControlSend,,2{Enter}, kOS MFD2 ;log into the kOS CPU
	Return

ResetMFD3:
	WinKill, kOS MFD3 ;in case something went wrong, close the last version of the window
	Sleep 100 ;give the window time to terminate
	Run, C:\Program Files\PuTTY\putty.exe -load ""MFD3"" ;load the saved session
	Sleep 1000 ; give the window time to load and handshake
	WinMove, kOS MFD3,, mfd3x, mfd3y, mfd3w, mfd3h ;relocated to the proper screen
	ControlSend,,3{Enter}, kOS MFD3 ;log into the kOS CPU
	Return

ResetMFD4:
	WinKill, kOS MFD4 ;in case something went wrong, close the last version of the window
	Sleep 100 ;give the window time to terminate
	Run, C:\Program Files\PuTTY\putty.exe -load ""MFD4"" ;load the saved session
	Sleep 1000 ; give the window time to load and handshake
	WinMove, kOS MFD4,, mfd4x, mfd4y, mfd4w, mfd4h ;relocated to the proper screen
	ControlSend,,4{Enter}, kOS MFD4 ;log into the kOS CPU
	Return

ListMFD3:
	ControlSend,,run list3.{Enter},kOS MFD3 
	Return
ListMFD4:
	ControlSend,,run list4.{Enter},kOS MFD4 
	Return
	