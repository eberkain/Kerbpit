// MFD Navigation
// by Jonathan Medders  'EberKain'
//
// the general idea here is stay in this program and depending on user 
// input we create manuvre nodes which are then executed by the autopilot
//
// The mfd buttons are used to select a type of node to calculate
// then depending on the type of node selected we request user input for params

//load libraries
run lib_mfd.
run lib_formating.
run lib_navigation.

//collect passed params
parameter mfdid, mfdtop.

//adjust print offset for the control bar
set poff to 0.
if mfdtop = true { set poff to 2. }

//monitor reserved action groups for button activity
set btn1 to false. 
set btn2 to false. 
set btn3 to false. 
set btn4 to false. 
set btn5 to false. 
set btn6 to false.

//flag button press based on MFDID 
on AG227 { if mfdid = 1 { set btn1 to true. } preserve. }
on AG228 { if mfdid = 1 { set btn2 to true. } preserve. }
on AG229 { if mfdid = 1 { set btn3 to true. } preserve. }
on AG230 { if mfdid = 1 { set btn4 to true. } preserve. }
on AG231 { if mfdid = 1 { set btn5 to true. } preserve. }
on AG232 { if mfdid = 1 { set btn6 to true. } preserve. }
on AG233 { if mfdid = 2 { set btn1 to true. } preserve. }
on AG234 { if mfdid = 2 { set btn2 to true. } preserve. }
on AG235 { if mfdid = 2 { set btn3 to true. } preserve. }
on AG236 { if mfdid = 2 { set btn4 to true. } preserve. }
on AG237 { if mfdid = 2 { set btn5 to true. } preserve. }
on AG238 { if mfdid = 2 { set btn6 to true. } preserve. }
on AG239 { if mfdid = 3 { set btn1 to true. } preserve. }
on AG240 { if mfdid = 3 { set btn2 to true. } preserve. }
on AG241 { if mfdid = 3 { set btn3 to true. } preserve. }
on AG242 { if mfdid = 3 { set btn4 to true. } preserve. }
on AG243 { if mfdid = 3 { set btn5 to true. } preserve. }
on AG244 { if mfdid = 3 { set btn6 to true. } preserve. }
on AG245 { if mfdid = 4 { set btn1 to true. } preserve. }
on AG246 { if mfdid = 4 { set btn2 to true. } preserve. }
on AG247 { if mfdid = 4 { set btn3 to true. } preserve. }
on AG248 { if mfdid = 4 { set btn4 to true. } preserve. }
on AG249 { if mfdid = 4 { set btn5 to true. } preserve. }
on AG250 { if mfdid = 4 { set btn6 to true. } preserve. }

//print the main display
local function printmenu {

	clearscreen. 
	//print the button labels at top or bottom
	if mfdtop = true { 
		print "  RESET  │  LEFT  │ RIGHT  │   UP   │  DOWN  │ SELECT  " at(0,0).
		print "─────────┴────────┴────────┴────────┴────────┴─────────" at(0,1). }
	else {
		print "─────────┬────────┬────────┬────────┬────────┬─────────" at(0,23).
		print "  RESET  │  LEFT  │ RIGHT  │   UP   │  DOWN  │ SELECT" at(0,24). }

	//     ----=----=----=----=----=xxxxx----=----=----=----=----=
	print "  NAVIGATION SYSTEM                                    " at (0,0+poff).
	print "═════════════════╤═════════════════╤═══════════════════" at (0,1+poff).
	print "  Circulize      │  Match Plane    │  Target Deorbit   " at (0,2+poff).
	print "  Change Ap      │  Hohman Trans   │  22               " at (0,3+poff).
	print "  Change Pe      │  Adj Close App  │  23               " at (0,4+poff).
	print "  Change Inc     │  Match Velo     │  24               " at (0,5+poff).
	print "  5              │  15             │  25               " at (0,6+poff).
	print "  6              │  16             │  26               " at (0,7+poff).
	print "  7              │  17             │  27               " at (0,8+poff).
	print "  8              │  18             │  28               " at (0,9+poff).
	print "  9              │  19             │  29               " at (0,10+poff).
	print "  10             │  20             │  30               " at (0,11+poff).
	print "─────────────────┴─────────────────┴───────────────────" at (0,12+poff).
	print "                                                       " at (0,13+poff).
	print "                                                       " at (0,14+poff).
	print "                                                       " at (0,15+poff).
	print "                                                       " at (0,16+poff).
	print "                                                       " at (0,17+poff).
	print "                                                       " at (0,18+poff).
	print "                                                       " at (0,19+poff).
	print "                                                       " at (0,20+poff).
	print "                                                       " at (0,21+poff).
	print "                                                  " at (0,22+poff).
}

set selx to 0. 
set sely to 0. 

local function printselector {
	set selprog to (selx*10)+sely+1.
	print selprog+"  " at(40,0+poff).
	print "⮞" at(18*selx, sely+poff+2).
}
local function clearselector {
	print " " at(18*selx, sely+poff+2).
}
local function printsel2 {
	print "⮞" at(0, sel2+poff+13).
}
local function clearsel2 {
	print " " at(0, sel2+poff+13).
}

//control vars for the selector 
set progsel to 0.
set selmode to 0.
set sel2max to 0.	//how many options to choose from 
set sel2 to 0.

//print the starting background
printmenu.
printselector.

//animated icon control vals
set animtime to time:seconds.
set animstep to 0.

//start main loop 
set done to false. 
until done {
	//if we are selecting which program to run
	if selmode = 0 {
		//selector left
		if btn2 = true { 
			set btn2 to false.
			clearselector.
			set selx to selx - 1.
			if selx < 0 { set selx to 0. }
			printselector.
		}
		//selector right 
		if btn3 = true {
			set btn3 to false.
			clearselector.
			set selx to selx + 1.
			if selx > 2 { set selx to 2. }
			printselector.
		}
		//selector up
		if btn4 = true { 
			set btn4 to false. 
			clearselector.
			set sely to sely - 1. 
			if sely < 0 { set sely to 0. }
			printselector.
		}
		//selector down
		if btn5 = true { 
			set btn5 to false. 
			clearselector.
			set sely to sely + 1.
			if sely >9 { set sely to 9. }
			printselector.
		}
		//execute a program based on the value of the selected program
		if btn6 = true {
			set btn6 to false. 

			//Circulize
			if selprog = 1 {  
				set selmode to 1.
				set sel2max to 4.
				printsel2.
				print "Ap" at (2,13+poff).
				print "Pe" at (2,14+poff).
				print "Now" at (2,15+poff).
				print "Eta" at (2,16+poff).
				print "Alt" at (2,17+poff).
			} 
		}
	}
	//now we are selecting a sub option like when to execute this action
	if selmode = 1 {
		//cancel this program selection and reset to main select mode
		if btn1 = true {
			set btn1 to false. 
			set selmode to 0. 
			printmenu.
			printselector.
		}
		//move sel up
		if btn4 = true { 
			set btn4 to false. 
			clearsel2.
			set sel2 to sel2 - 1.
			if sel2 < 0 { set sel2 to 0. }
			printsel2.
		}
		//move sel down
		if btn5 = true {
			set btn5 to false. 
			clearsel2.
			set sel2 to sel2 + 1.
			if sel2 > sel2max { set sel2 to sel2max. }
			printsel2.
		}
		//lock in this selection and proceeed with program 
		if btn6 = true {
			set btn6 to false. 
			
			//circulize
			if selprog = 1 {
				//at AP
				if sel2 = 0 {
					//create a node to circulize at the AP 
					set ndvel to (SHIP:BODY:MU / (SHIP:BODY:RADIUS + SHIP:APOAPSIS))^0.5.
					set apvel to VELOCITYAT(SHIP, time:seconds + eta:apoapsis):ORBIT:MAG.
					set newnode to node(time:seconds + eta:apoapsis,0,0,ndvel-apvel).
					add newnode.
					print "circ node @ "+si_formating(ndvel-apvel,"m/s") at(2,20+poff).
				}
			}
		}
	}
	
	
	//do periodiacally
	if animtime < time:seconds {
		set animtime to time:seconds + 0.05. 
		
		//print an animated icon to show the script is running
		set animstep to mfd_animicon(0,0+poff,animstep).
	}	
}
