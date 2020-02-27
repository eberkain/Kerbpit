// MFD STATUS - Situation Information
// by Jonathan Medders  'EberKain'
//
// The general idea here is to make a program that can display the current 
// state of the vessel orbit, etc...
//
// also have a page for target selection
// list is created dynamically, grouping types of objects together, excluding debris


//load libraries
run lib_mfd.
run lib_formating.
run lib_navigation.

//collect passed params
parameter mfdid, mfdtop.

//adjust print offset for the control bar
set poff to 0.
if mfdtop = true { set poff to 2. }

clearscreen.

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

//current active page
set curr_page to 0. 

//print the background for each of the mdf pages
local function print_page {
	parameter pageid. 
	if pageid = 0 { //general overview
		//print the button labels at top or bottom
		if mfdtop = true { 
			print "  ORBIT  │ FLIGHT │  LAND  │  TARG  │  TSEL  │   F6    " at (0,0).
			print "─────────┴────────┴────────┴────────┴────────┴─────────" at(0,1). }
		else {
			print "─────────┬────────┬────────┼────────┬────────┬─────────" at(0,23).
			print "  ORBIT  │ FLIGHT │  LAND  │  TARG  │  TSEL  │   F6  " at (0,24). }
		//     ----=----=----=----=----=xxxxx----=----=----=----=----=
		print "  SITUATION STATUS                                    " at (0,0+poff).
		print "═══════════════════════════╤══════════════════════════" at (0,1+poff).
		print "Altitude     :             │AGL Alt.     :            " at (0,2+poff).
		print "Velocity     :             │Airspeed     :            " at (0,3+poff).
		print "Acceleration :             │Vert. Speed  :            " at (0,4+poff).
		print "Stage Δv     :             │Ground Speed :            " at (0,5+poff).
		print "Total Δv     :             │Heading      :            " at (0,6+poff).
		print "Node ETA     :             │Air Press.   :            " at (0,7+poff).
		print "Total Mass   :             │Dyn. Press.  :            " at (0,8+poff).
		print "Part Count   :             │Mach Number  :            " at (0,9+poff).
		print "Situation    :             │Intake Air   :            " at (0,10+poff).
		print "Biome        :             │xxx          :            " at (0,11+poff).
		print "───────────────────────────┼──────────────────────────" at (0,12+poff).
		print "Apoapsis     :             │Latitude     :            " at (0,13+poff).
		print "Periapsis    :             │Longitude    :            " at (0,14+poff).
		print "Time to Ap   :             │Impact Time  :            " at (0,15+poff).
		print "Time to Pe   :             │Impact Biome :            " at (0,16+poff).
		print "Inclination  :             │Suicide Burn :            " at (0,17+poff).
		print "Eccentricity :             │SB ΔV        :            " at (0,18+poff).
		print "Peroid       :             │Aval. Thrust :            " at (0,19+poff).
		print "xxx          :             │Max Thrust   :            " at (0,20+poff).
		print "xxx          :             │                          " at (0,21+poff).
		print "xxx          :             │                        " at (0,22+poff).
	}
	else if pageid = 1 { //Orbit Info
		//print the button labels at top or bottom
		if mfdtop = true { 
			print "   BACK  │   F2   │   F3   │   F4   │   F5   │   F6   " at (0,0).
			print "─────────┴────────┴────────┴────────┴────────┴─────────" at(0,1). }
		else {
			print "─────────┬────────┬────────┼────────┬────────┬─────────" at(0,23).
			print "   BACK  │   F2   │   F3   │   F4   │   F5   │   F6   " at (0,24). }
		//     ----=----=----=----=----=xxxxx----=----=----=----=----=
		print "  ORBIT STATUS                                    " at (0,0+poff).
		print "═══════════════════════════╤══════════════════════════" at (0,1+poff).
		print "Altitude     :             │Ang to Prog  :            " at (0,2+poff).
		print "Velocity     :             │Ang to Retro :            " at (0,3+poff).
		print "Acceleration :             │Time to An   :            " at (0,4+poff).
		print "Stage Δv     :             │Time to Dn   :            " at (0,5+poff).
		print "Total Δv     :             │             :            " at (0,6+poff).
		print "Node ETA     :             │             :            " at (0,7+poff).
		print "Total Mass   :             │             :            " at (0,8+poff).
		print "Part Count   :             │             :            " at (0,9+poff).
		print "Situation    :             │             :            " at (0,10+poff).
		print "Biome        :             │             :            " at (0,11+poff).
		print "───────────────────────────┼──────────────────────────" at (0,12+poff).
		print "Apoapsis     :             │                          " at (0,13+poff).
		print "Periapsis    :             │                          " at (0,14+poff).
		print "Time to Ap   :             │                          " at (0,15+poff).
		print "Time to Pe   :             │                          " at (0,16+poff).
		print "Inclination  :             │                          " at (0,17+poff).
		print "Eccentricity :             │                          " at (0,18+poff).
		print "Peroid       :             │                          " at (0,19+poff).
		print "xxx          :             │                          " at (0,20+poff).
		print "xxx          :             │                          " at (0,21+poff).
		print "xxx          :             │                        " at (0,22+poff).
	}
	else if pageid = 2 { //Flight Info
		//print the button labels at top or bottom
		if mfdtop = true { 
			print "   BACK  │   F2   │   F3   │   F4   │   F5   │   F6   " at (0,0).
			print "─────────┴────────┴────────┴────────┴────────┴─────────" at(0,1). }
		else {
			print "─────────┬────────┬────────┼────────┬────────┬─────────" at(0,23).
			print "   BACK  │   F2   │   F3   │   F4   │   F5   │   F6  " at (0,24). }
		//     ----=----=----=----=----=xxxxx----=----=----=----=----=
		print "  FLIGHT STATUS                                       " at (0,0+poff).
		print "═══════════════════════════╤══════════════════════════" at (0,1+poff).
		print "Altitude     :             │Thrust Offset:            " at (0,2+poff).
		print "Velocity     :             │Thrust Torque:            " at (0,3+poff).
		print "Acceleration :             │             :            " at (0,4+poff).
		print "Stage Δv     :             │             :            " at (0,5+poff).
		print "Total Δv     :             │             :            " at (0,6+poff).
		print "Node ETA     :             │             :            " at (0,7+poff).
		print "Total Mass   :             │             :            " at (0,8+poff).
		print "Part Count   :             │             :            " at (0,9+poff).
		print "Situation    :             │             :            " at (0,10+poff).
		print "Biome        :             │             :            " at (0,11+poff).
		print "───────────────────────────┼──────────────────────────" at (0,12+poff).
		print "AGL Alt.     :             │                          " at (0,13+poff).
		print "Airspeed     :             │                          " at (0,14+poff).
		print "Vert. Speed  :             │                          " at (0,15+poff).
		print "Ground Speed :             │                          " at (0,16+poff).
		print "Heading      :             │                          " at (0,17+poff).
		print "Air Press.   :             │                          " at (0,18+poff).
		print "Dyn. Press.  :             │                          " at (0,19+poff).
		print "Mach Number  :             │                          " at (0,20+poff).
		print "Intake Air   :             │                          " at (0,21+poff).
		print "xxx          :             │                        " at (0,22+poff).
	}
	if pageid = 3 { //landing stats
		//print the button labels at top or bottom
		if mfdtop = true { 
			print "   BACK  │   F2   │   F3   │   F4   │   F5   │   F6  " at (0,0).
			print "─────────┴────────┴────────┴────────┴────────┴─────────" at(0,1). }
		else {
			print "─────────┬────────┬────────┼────────┬────────┬─────────" at(0,23).
			print "   BACK  │   F2   │   F3   │   F4   │   F5   │   F6  " at (0,24). }
		//     ----=----=----=----=----=xxxxx----=----=----=----=----=
		print "  LANDING STATUS                                      " at (0,0+poff).
		print "═══════════════════════════╤══════════════════════════" at (0,1+poff).
		print "Altitude     :             │             :            " at (0,2+poff).
		print "Velocity     :             │             :            " at (0,3+poff).
		print "Acceleration :             │             :            " at (0,4+poff).
		print "Stage Δv     :             │             :            " at (0,5+poff).
		print "Total Δv     :             │             :            " at (0,6+poff).
		print "Node ETA     :             │             :            " at (0,7+poff).
		print "Total Mass   :             │             :            " at (0,8+poff).
		print "Part Count   :             │             :            " at (0,9+poff).
		print "Situation    :             │             :            " at (0,10+poff).
		print "Biome        :             │             :            " at (0,11+poff).
		print "───────────────────────────┼──────────────────────────" at (0,12+poff).
		print "Latitude     :             │                          " at (0,13+poff).
		print "Longitude    :             │                          " at (0,14+poff).
		print "Impact Time  :             │                          " at (0,15+poff).
		print "Impact Biome :             │                          " at (0,16+poff).
		print "Suicide Burn :             │                          " at (0,17+poff).
		print "SB ΔV        :             │                          " at (0,18+poff).
		print "Aval. Thrust :             │                          " at (0,19+poff).
		print "Max Thrust   :             │                          " at (0,20+poff).
		print "             :             │                          " at (0,21+poff).
		print "             :             │                        " at (0,22+poff).
	}
	if pageid = 4 { //target status
		//print the button labels at top or bottom
		if mfdtop = true { 
			print "   BACK  │   F2   │   F3   │   F4   │   F5   │   F6  " at (0,0).
			print "─────────┴────────┴────────┴────────┴────────┴─────────" at(0,1). }
		else {
			print "─────────┬────────┬────────┼────────┬────────┬─────────" at(0,23).
			print "   BACK  │   F2   │   F3   │   F4   │   F5   │   F6  " at (0,24). }
		//     ----=----=----=----=----=xxxxx----=----=----=----=----=
		print "  TARGET STATUS                                       " at (0,0+poff).
		print "═══════════════════════════╤══════════════════════════" at (0,1+poff).
		print "Altitude     :             │             :            " at (0,2+poff).
		print "Velocity     :             │             :            " at (0,3+poff).
		print "Acceleration :             │             :            " at (0,4+poff).
		print "Stage Δv     :             │             :            " at (0,5+poff).
		print "Total Δv     :             │             :            " at (0,6+poff).
		print "Node ETA     :             │             :            " at (0,7+poff).
		print "Total Mass   :             │             :            " at (0,8+poff).
		print "Part Count   :             │             :            " at (0,9+poff).
		print "Situation    :             │             :            " at (0,10+poff).
		print "Biome        :             │             :            " at (0,11+poff).
		print "───────────────────────────┼──────────────────────────" at (0,12+poff).
		print "             :             │                          " at (0,13+poff).
		print "             :             │                          " at (0,14+poff).
		print "             :             │                          " at (0,15+poff).
		print "             :             │                          " at (0,16+poff).
		print "             :             │                          " at (0,17+poff).
		print "             :             │                          " at (0,18+poff).
		print "             :             │                          " at (0,19+poff).
		print "             :             │                          " at (0,20+poff).
		print "             :             │                          " at (0,21+poff).
		print "             :             │                        " at (0,22+poff).
	}
	if pageid = 5 { //Target Selection
		//print the button labels at top or bottom
		if mfdtop = true { 
			print "   BACK  │  LEFT  │ RIGHT  │   UP   │  DOWN  │ SELECT" at (0,0).
			print "─────────┴────────┴────────┴────────┴────────┴─────────" at(0,1). }
		else {
			print "─────────┬───────┴┬────────┬───────┴┬────────┬─────────" at(0,23).
			print "   BACK  │  LEFT  │ RIGHT  │   UP   │  DOWN  │ SELECT " at (0,24). }
		//     ----=----=----=----=----=xxxxx----=----=----=----=----=
		print "  TARGET SELECTION                                     " at (0,0+poff).
		print "═════════════════╤═════════════════╤═══════════════════" at (0,1+poff).
		print "                 │                 │                   " at (0,2+poff).
		print "                 │                 │                   " at (0,3+poff).
		print "                 │                 │                   " at (0,4+poff).
		print "                 │                 │                   " at (0,5+poff).
		print "                 │                 │                   " at (0,6+poff).
		print "                 │                 │                   " at (0,7+poff).
		print "                 │                 │                   " at (0,8+poff).
		print "                 │                 │                   " at (0,9+poff).
		print "                 │                 │                   " at (0,10+poff).
		print "                 │                 │                   " at (0,11+poff).
		print "                 │                 │                   " at (0,12+poff).
		print "                 │                 │                   " at (0,13+poff).
		print "                 │                 │                   " at (0,14+poff).
		print "                 │                 │                   " at (0,15+poff).
		print "                 │                 │                   " at (0,16+poff).
		print "                 │                 │                   " at (0,17+poff).
		print "                 │                 │                   " at (0,18+poff).
		print "                 │                 │                   " at (0,19+poff).
		print "                 │                 │                   " at (0,20+poff).
		print "                 │                 │                   " at (0,21+poff).
		print "                 │                 │                 " at (0,22+poff).
	}
}
print_page(curr_page).

//to track the time and throttle the script execution
set looptime to time:seconds.
set done to false.
set animstep to 0.

//target selection vars
set targlist to list().  //a place to store all the possible targets
set targlistpage to 0.
set targlistnumpages to 1. 
set targlistcreated to false. 

//selector icon 
set seltarg to 0.
set selx to 0. 
set sely to 0. 

//selector scroll feature 
set selscroll to 0. 
set padstrmade to false. 
set padstr to "".

//functions to move selector
local function printselector {
	set selscroll to 0. 
	set padstrmade to false. 
	set seltarg to (60*targlistpage)+(selx*20)+sely.
	print seltarg+"  " at(35,0+poff).
	print "⮞" at(18*selx, sely+poff+2).
}
local function clearselector {
	if targlist:length > seltarg {
		print "  "+targlist[seltarg][0]:substring(0,min(targlist[seltarg][0]:length,15)) at(18*selx, sely+poff+2).
	}
	else { 	print "                 " at(18*selx, sely+poff+2). 	}
}
local function printtargetlist {
	clearscreen.
	//print the background
	print_page(curr_page).
	print ((targlistpage*60)+1) + "-" + min((1+targlistpage)*60,targlist:length) +"/"+ targlist:length at (40,0+poff).
	
	//print the list of targets
	//loop trrough the 60 positions to print 
	from { local i is 0. } until i = 60 step { set i to i + 1. } do {
		set ptarg to i + (60*targlistpage).
		//if this pos is within the size of the list then print 
		if targlist:length > ptarg { 
			set targname to targlist[ptarg][0].
			set tx to floor(((ptarg-(60*targlistpage))/20),0).
			set ty to mod(ptarg,20).
			print tx + ":" + ty at (25,0+poff).
			print targname:substring(0,min(targname:length,15)) at(2+(tx*18),2+ty+poff).
		}
	}
	printselector.
}

//main loop 
until done = true {

	//process button presses
	//on the main page use buttons to move to other pages
	if curr_page = 0 {
		//switch to orbit page
		if btn1 = true {
			set btn1 to false.
			set curr_page to 1.
		}
		//switch to flight page
		if btn2 = true {
			set btn2 to false.
			set curr_page to 2.
		}
		//switch to Landing page
		if btn3 = true {
			set btn3 to false.
			set curr_page to 3.
		}
		//switch to target page
		if btn4 = true {
			set btn4 to false.
			set curr_page to 4.
		}
		//switch to target select page
		if btn5 = true {
			set btn5 to false.
			set curr_page to 5.
			set targlistcreated to false.
		}
	}
	//on the target sel page use the buttons to make a selection
	else if curr_page = 5 {
		//react to keypresses
		if btn1 = true { //back
			set btn1 to false. 
			set curr_page to 0.
			print_page(curr_page).
		}
		//selector left
		if btn2 = true { 
			set btn2 to false.
			clearselector.
			set selx to selx - 1.
			if selx < 0 { 
				if targlistpage > 0 {
					set targlistpage to targlistpage - 1.
					set selx to 2. 
					printtargetlist.
				}
				else {	set selx to 0. } 
			}
				
			printselector.
		}
		//selector right 
		if btn3 = true {
			set btn3 to false.
			clearselector.
			set selx to selx + 1.
			if selx > 2 { 
				if targlistpage < targlistnumpages-1 {
					set targlistpage to targlistpage + 1.
					set selx to 0. 
					printtargetlist.
				}
				else {	set selx to 2. } 
			}
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
			if sely >19 { set sely to 19. }
			printselector.
		}
		//select item
		if btn6 = true { 
			set btn6 to false.
			set target to targlist[seltarg][1].
		}
	}
		
		
	//update the info 5 times per sec
	if time:seconds > looptime {
		set looptime to time:seconds + 0.05.
		
		//print an animated icon to show the script is running
		set animstep to mfd_animicon(0,0+poff,animstep).

		
		//print the core data block that is on the first 4 pages
		if curr_page <> 5 {
		
		}
		//print the base data block for each page 
		if curr_page = 0 {
			//decide where to start printing based on page
			set xpos to 0. 
			set ypos to 0. 
		
			print (si_formating(ship:altitude,"m")):padright(10) at (15,1+poff).
			print (si_formating(ship:velocity:orbit:mag,"m/s")):padright(10) at (15,2+poff).
		
			print (dms_formating(ship:geoposition:lat,"lat")):padright(10) at (16,8+poff).
			print (dms_formating(ship:geoposition:lng,"lng")):padright(10) at (16,9+poff).

			print (si_formating(ship:apoapsis,"m")):padright(10) at (15,12+poff).
			print (si_formating(ship:periapsis,"m")):padright(10) at (15,13+poff).
			print (time_formating(eta:apoapsis,5)):padright(10) at (15,14+poff).
			print (time_formating(eta:periapsis,5)):padright(10) at (15,15+poff).
			print (padding(ship:orbit:inclination,1,2)+" °"):padright(10) at (15,16+poff).
			print (padding(ship:orbit:eccentricity,1,4)):padright(10) at (15,17+poff).
		
			print (si_formating(alt:radar,"m")):padright(10) at (43,1+poff).
			print (si_formating(ship:airspeed,"m/s")):padright(10) at (43,3+poff).
			print (si_formating(ship:verticalspeed,"m/s")):padright(10) at (43,4+poff).
			print (si_formating(ship:groundspeed,"m/s")):padright(10) at (43,5+poff).
			print (padding(mod(360 - latlng(90,0):bearing,360),1,2)+" °"):padright(10) at (44,6+poff).
			
			print (padding(ship:body:atm:altitudepressure(ship:altitude),1,2)+" atm"):padright(10) at (44,15+poff).
			print (padding(ship:dynamicpressure*constant:ATMtokPa,1,2)+" kPa"):padright(10) at (44,16+poff).
		}

		//target selection page
		else if curr_page = 5 {
			//create the target list if not created
			if targlistcreated = false {
				set targlistcreated to true.
				set targlist to list(). 
				
				//add all the bodie names to the list 
				list bodies in bodlist. //why is this command so weird?!? 
				for bod in bodlist {
					targlist:add(list(bod:name,bod)).
				}
				
				//add all vessels to the list
				list targets in veslist. 
				for ves in veslist {
					if ves:type <> "SpaceObject" and ves:type <> "Debris" and ves:type <> "Flag" {
						targlist:add(list(ves:name,ves)).
					}
				}
				
				//add all the asteroids to the list 
				for ves in veslist {
					if ves:type = "SpaceObject" {
						targlist:add(list(ves:name,ves)).
					}
				}
			
				//calc the num pages
				set targlistnumpages to ceiling(targlist:length/60,0).
			
				//setup selection cursor 
				set selx to 0. 
				set sely to 0. 
				
				printtargetlist.
			}
		
			//if the object name is more tha 15 char then we scroll it 
			//this could be more optimized if we caches the string
			if targlist:length > seltarg {
				if targlist[seltarg][0]:length > 15 {
					if padstrmade = false { 
						set padstr to "               "+targlist[seltarg][0]+"                  ".
						set padstrmade to true. 
					}
					
					print padstr:substring(selscroll,15) at(2+(18*selx), sely+poff+2).
					set selscroll to selscroll + 1. 
					if selscroll > targlist[seltarg][0]:length+15 { set selscroll to 0. }
				}
			}
		}
	}
}