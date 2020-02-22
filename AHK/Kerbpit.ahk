; AHK Kerbpit Control Script 
; Jonathan Medders "EberKain"
;
; The basic idea is to monitor joystick buttons and send the correct commands to 
;   either the game window or one of the terminals depending on the desired action
; 
;
;
;
;
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force  ; Only allow one copy of the script to run at time

;key delay has a big imact on sending the messages to terminals
;    (how long it takes to send message, pause between keypresses)
SetKeyDelay,1,-1

;VARIABLES
;the active MFD index used by flight computer select switch (0-5)
act_mfd := 3

;the rate of adjustment for the autopilot controls
apr_spd := 10
apr_alt := 1000
apr_hdg := 5

;-------CONFIGURATION SECTON--------------------

;the window locations for the mfd displays
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

;which MFD displays each kind of script
SS_MID := 1  ;situation status
VS_MID := 2  ;vessel status
AP_MID := 3  ;autopilots
NV_MID := 4  ;navigation

;are the button strips on top or bottom for each mfd
SS_TOP := true
VS_TOP := true
AP_TOP := false
NV_TOP := false

;change the joystick id for each action
Hotkey, 1joy1, MFD1B1
Hotkey, 1joy1, MFD1B2
Hotkey, 1joy1, MFD1B3
Hotkey, 1joy1, MFD1B4
Hotkey, 1joy1, MFD1B5
Hotkey, 1joy1, MFD1B6
Hotkey, 1joy1, MFD2B1
Hotkey, 1joy1, MFD2B2
Hotkey, 1joy1, MFD2B3
Hotkey, 1joy1, MFD2B4
Hotkey, 1joy1, MFD2B5
Hotkey, 1joy1, MFD2B6
Hotkey, 1joy1, MFD3B1
Hotkey, 1joy1, MFD3B2
Hotkey, 1joy1, MFD3B3
Hotkey, 1joy1, MFD3B4
Hotkey, 1joy1, MFD3B5
Hotkey, 1joy1, MFD3B6
Hotkey, 1joy1, MFD4B1
Hotkey, 1joy1, MFD4B2
Hotkey, 1joy1, MFD4B3
Hotkey, 1joy1, MFD4B4
Hotkey, 1joy1, MFD4B5
Hotkey, 1joy1, MFD4B6


Hotkey,^Numpad0,ResetMFD0
Hotkey,^NumpadDot,ResetMFDALL
Hotkey,^NumpadEnter,RelogMFDALL
Hotkey,^Numpad7,LISTMFD%act_mfd%
Hotkey,^Numpad8,AutopilotNode
Hotkey,^Numpad9,AutopilotLaunch
Hotkey,^Numpad5,AutopilotLand
Hotkey,^Numpad6,AutopilotAircraft
Hotkey,^Numpad1,ResetMFD1
Hotkey,^Numpad2,ResetMFD2
Hotkey,^Numpad3,ResetMFD3
Hotkey,^Numpad4,ResetMFD4
Hotkey,^Left,AutopilotHeadDown
Hotkey,^Right,AutopilotHeadUp
Hotkey,^Up,AutopilotAltUp
Hotkey,^Down,AutopilotAltDown

;alt to test remote numpad
Hotkey,!Numpad0,FC0
Hotkey,!Numpad1,FC1
Hotkey,!Numpad2,FC2
Hotkey,!Numpad3,FC3
Hotkey,!Numpad4,FC4
Hotkey,!Numpad5,FC5
Hotkey,!Numpad6,FC6
Hotkey,!Numpad7,FC7
Hotkey,!Numpad8,FC8
Hotkey,!Numpad9,FC9
Hotkey,!NumpadSub,FCSUB
Hotkey,!NumpadEnter,FCENTER

;--------CONFIGURATION END--------------



;shortcuts to launch core programs 
AutopilotLaunch:
	ControlSend,,run{Space}A1(%AP_MID%,false).{Enter},kOS MFD%AP_MID%
	Return
AutopilotNode:
	ControlSend,,run{Space}A2(%AP_MID%,false).{Enter},kOS MFD%AP_MID%
	Return
AutopilotLand:
	ControlSend,,run{Space}A3(%AP_MID%,false).{Enter},kOS MFD%AP_MID%
	Return
AutopilotAircraft:
	ControlSend,,run{Space}A4(%AP_MID%,false).{Enter},kOS MFD%AP_MID% 
	Return
	
;send course adjustments to the autopilot
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
FC0:
	ControlSend,,0,kOS MFD%amfd% 
	Return
FC1:
	ControlSend,,1,kOS MFD%amfd% 
	Return
FC2:
	ControlSend,,2,kOS MFD%amfd% 
	Return
FC3:
	ControlSend,,3,kOS MFD%amfd% 
	Return
FC4:
	ControlSend,,4,kOS MFD%amfd% 
	Return
FC5:
	ControlSend,,5,kOS MFD%amfd% 
	Return
FC6:
	ControlSend,,6,kOS MFD%amfd% 
	Return
FC7:
	ControlSend,,7,kOS MFD%amfd% 
	Return
FC8:
	ControlSend,,8,kOS MFD%amfd% 
	Return
FC9:
	ControlSend,,9,kOS MFD%amfd% 
	Return
FCSUB:
	ControlSend,,`-,kOS MFD%amfd% 
	Return
FCENTER:
	ControlSend,,{Enter},kOS MFD%amfd% 
	Return

;run list utility
LISTMFD1:
	ControlSend,,C1.{Enter},kOS MFD1
	Return
LISTMFD2:
	ControlSend,,C1.{Enter},kOS MFD2
	Return
LISTMFD3:
	ControlSend,,C1.{Enter},kOS MFD3
	Return
LISTMFD4:
	ControlSend,,C1.{Enter},kOS MFD4
	Return
	

;reset MFD functions
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
	ControlSend,,run C1(%AP_MID%`,%AP_TOP%).{enter}, kOS MFD%AP_MID% ;run the list script
	ControlSend,,run B3(%NV_MID%`,%NV_TOP%).{enter}, kOS MFD%NV_MID% ;run the nav script
	ControlSend,,run B1(%SS_MID%`,%SS_TOP%).{enter}, kOS MFD%SS_MID% ;run the status script
	ControlSend,,run B2(%VS_MID%`,%VS_TOP%).{enter}, kOS MFD%VS_MID% ;run the status script
	Return

RelogMFDALL:
	ControlSend,,5{Enter}, kOS MFD0 ;log into the kOS CPU
	ControlSend,,1{Enter}, kOS MFD1 ;log into the kOS CPU
	ControlSend,,2{Enter}, kOS MFD2 ;log into the kOS CPU
	ControlSend,,3{Enter}, kOS MFD3 ;log into the kOS CPU
	ControlSend,,4{Enter}, kOS MFD4 ;log into the kOS CPU
	Sleep 500
	ControlSend,,switch to archive.{Enter}, kOS MFD0 ;log into the kOS CPU
	ControlSend,,switch to archive.{Enter}, kOS MFD1 ;log into the kOS CPU
	ControlSend,,switch to archive.{Enter}, kOS MFD2 ;log into the kOS CPU
	ControlSend,,switch to archive.{Enter}, kOS MFD3 ;log into the kOS CPU
	ControlSend,,switch to archive.{Enter}, kOS MFD4 ;log into the kOS CPU
	Sleep 500
	ControlSend,,run C1(%AP_MID%`,%AP_TOP%).{enter}, kOS MFD%AP_MID% ;run the list script
	ControlSend,,run B3(%NV_MID%`,%NV_TOP%).{enter}, kOS MFD%NV_MID% ;run the nav script
	ControlSend,,run B1(%SS_MID%`,%SS_TOP%).{enter}, kOS MFD%SS_MID% ;run the status script
	ControlSend,,run B2(%VS_MID%`,%VS_TOP%).{enter}, kOS MFD%VS_MID% ;run the status script
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
	
;mfd button commands
MFD1B1:
	ControlSend,,^!1,Kerbal Space Program 
	Return
MFD1B2:
	ControlSend,,^!2,Kerbal Space Program 
	Return
MFD1B3:
	ControlSend,,^!3,Kerbal Space Program 
	Return
MFD1B4:
	ControlSend,,^!4,Kerbal Space Program 
	Return
MFD1B5:
	ControlSend,,^!5,Kerbal Space Program 
	Return
MFD1B6:
	ControlSend,,^!6,Kerbal Space Program 
	Return
MFD2B1:
	ControlSend,,^!7,Kerbal Space Program 
	Return
MFD2B2:
	ControlSend,,^!8,Kerbal Space Program 
	Return
MFD2B3:
	ControlSend,,^!9,Kerbal Space Program 
	Return
MFD2B4:
	ControlSend,,^!0,Kerbal Space Program 
	Return
MFD2B5:
	ControlSend,,^!`-,Kerbal Space Program 
	Return
MFD2B6:
	ControlSend,,^!`=,Kerbal Space Program 
	Return
MFD3B1:
	ControlSend,,^!q,Kerbal Space Program 
	Return
MFD3B2:
	ControlSend,,^!w,Kerbal Space Program 
	Return
MFD3B3:
	ControlSend,,^!e,Kerbal Space Program 
	Return
MFD3B4:
	ControlSend,,^!r,Kerbal Space Program 
	Return
MFD3B5:
	ControlSend,,^!t,Kerbal Space Program 
	Return
MFD3B6:
	ControlSend,,^!y,Kerbal Space Program 
	Return
MFD4B1:
	ControlSend,,^!u,Kerbal Space Program 
	Return
MFD4B2:
	ControlSend,,^!i,Kerbal Space Program 
	Return
MFD4B3:
	ControlSend,,^!o,Kerbal Space Program 
	Return
MFD4B4:
	ControlSend,,^!p,Kerbal Space Program 
	Return
MFD4B5:
	ControlSend,,^!`[,Kerbal Space Program 
	Return
MFD4B6:
	ControlSend,,^!`],Kerbal Space Program 
	Return
