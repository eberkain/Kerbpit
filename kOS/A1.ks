// MFD Autopilot - Launch to Orbit Script
// by Jonathan Medders  'EberKain'
//
// made from scratch to hopefully work on all planets and launchers
//
// All we are trying to accomplish with this script is to control 
// the vessel steering and throttle, all other systems are manual
//
// The program is launched by a shortcut on the autopilot controller 
//  Once the program starts with a default altitude and inclination of 100km / 0deg
//  Using the +/- heading and altitude keys the user can update the autopilot.json file 
//  Which this program reads in and uses as a guide
//
// Alternatively, the user can use the flight computer to switch to MFD3 and run F1
//  This should prompt the user for a desired altitude and inclination before starting
//
// The general idea for execution is... 
// Throttle to hold a TWR less than 2
// doa gentel turn until after passing maxq
// switch aoa reference to orbital 
// take pitch down to 0 after maxq based on ap vs taralt 

//load libraries
run lib_mfd.
run lib_formating.
run lib_navigation.

//collect passed params
parameter mfdid, mfdtop, passed_alt is 9999, passed_inc is 9999.

//adjust print offset for the control bar
set poff to 0.
if mfdtop = true { set poff to 2. }

clearscreen. 
//print the button labels at top or bottom
if mfdtop = true { 
	print "  FC-TRAN│ FC-MAXQ│ THR-OVR│CTRL-OVR│   F5   │   F6    " at(0,0).
	print "─────────┴────────┴────────┴────────┴────────┴─────────" at(0,1). }
else {
	print "─────────┬────────┬────────┼────────┬────────┬─────────" at(0,23).
	print "  FC-TRAN│ FC-MAXQ│ THR-OVR│CTRL-OVR│   F5   │   F6   " at(0,24). }

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
//main input vars
set taralt to 9999.
set hasalt to false.
set tarinc to 9999.
set hasinc to false.

//setup the screen info fields
//     ----=----=----=----=----=xxxxx----=----=----=----=----=
print "                    LAUNCH TO ORBIT                    " at(0,0+poff).
print "═══════════════════════════╤═══════════════════════════" at(0,1+poff).
print "Target Alt.  :             │                           " at(0,2+poff).
print "Target Inc.  :             │                           " at(0,3+poff).
print "Adj. Inc.    :             │                           " at(0,4+poff).
print "Target Head. :             │                           " at(0,5+poff).                              
print "───────────────────────────┤                           " at(0,6+poff).   
print "Orbit Pitch  :             │                           " at(0,7+poff).
print "Surf. Pitch  :             │                           " at(0,8+poff).
print "Diff Orb/Surf:             │                           " at(0,9+poff).
print "Vessel Pitch :             ├───────────────────────────" at(0,10+poff).
print "Target Pitch :             │  Launch Graph             " at(0,11+poff).
print "Limit Pitch  :             │                           " at(0,12+poff).                              
print "───────────────────────────┤  🢁                        " at(0,13+poff).
print "Max AoA      :             │ talt                      " at(0,14+poff).
print "Current AoA  :             │  🢃                        " at(0,15+poff).
print "Max TWR      :             │                           " at(0,16+poff).
print "Curr. TWR    :             │                           " at(0,17+poff).
print "Curr. Throt  :             │                           " at(0,18+poff).
print "Downrange    :             │                           " at(0,19+poff).
print "MaxQ         :             │                           " at(0,20+poff).
print "MaxQ Alt     :             │                2xtalt     " at(0,21+poff).
print "Low Pres Alt :             │              🢀 range 🢂 " at(0,22+poff).

//check the parameters, if they were used then populate the vars and flip flags
if passed_alt <> 9999 {
	set hasalt to true.
	set taralt to passed_alt.
	print "p" at(12,2+poff).
}
if passed_inc <> 9999 {
	set hasinc to true.
	set tarinc to passed_inc.
	print "p" at(12,3+poff).
}

//if we did not take a param then we need to take terminal input
if hasalt = false or hasinc = false {
	print "term-input:         " at (28,2+poff).
}
else {
	print "init-param"+si_formating(taralt,"")+"  "+padding(tarinc,1,2)+" °" at(28,2+poff).
}

if hasalt = false { 
	set taralt to mfd_numinput(40,2,false).  
	set hasalt to true.
	print "t" at(12,2+poff).
}
wait until hasalt = true.

//check other param
if hasinc = false { 
	print "             " at (40,2+poff).
	set tarinc to mfd_numinput(40,2,false,0,180).  
	set hasinc to true.
	print "t" at(12,3+poff).
}
wait until hasinc = true.

//TODO determine if planet has atmo and skip some steps

//find the altitude where pressure drops below 0.25 atm
//we are going to keep a very limited AoA until this point
set prestest to 1.
set presalt to 0.
set presinc to 0.
until prestest < 0.05 {
	set prestest to SHIP:BODY:ATM:altitudepressure(presalt).
	set presalt to presalt + 100. 
}
print si_formating(presalt,"m") at(15,22+poff).

//get a target heading to hit the desired incl
set aztime to time:seconds.
set azstep to 0.
set adjinc to mfd_adjinc(tarinc,ship:latitude).
set tarhdg to azimuth(adjinc,taralt).
print "calc-path-0" at(28,3+poff).

//track pitch variables
//pitch of the orbit prograde marker
lock orbpit to 90-vang(up:forevector, ship:prograde:forevector).  
//pitch of the surface prograde marker
lock srfpit to 90-vang(up:forevector, ship:srfprograde:forevector).  
//pitch difference between two progrades, when this drops <1 we transition 
lock compit to vang(ship:prograde:forevector, ship:srfprograde:forevector).  
//pitch of the ship currently
lock shppit to 90-vang(up:forevector, ship:facing:forevector).  
//targeted pitch to steer to 
set tarpit to 90.  
//tergeted pitch under aoa limits << steering lock to this
set limpit to 90.   
set forcepitch to false. 

//track aoa variables
set curaoa to 0. //the current aoa, calc in loop for transition swap
set maxaoa to 5. //the max number of degrees to steer off prograde marker

//take over control of steering
lock steering to up. //heading(tarhdg,limpit).
set steerhead to false.  //is steering locked to heading
print "ctrl-lock:up  " at(28,4+poff).

//take over control of throttle
set curthr to 1.
lock maxtwr to ship:availablethrust/(ship:mass*constant:g0).
lock curtwr to (ship:availablethrust*curthr)/(ship:mass*constant:g0).
lock throttle to curthr.
set forcethrottle to false. 

//write a new lexicon with the starting values
set lextime to time:seconds.
set LEX to lexicon().
set LEX["hdg"] to tarinc.
set LEX["alt"] to taralt.
set LEX["spd"] to 0.
writejson(LEX,"ap.json").
print "trim-init" at(43,4+poff).

//loop control vars
set featherstarted to false.
set launchdone to false. //flag to kill the main launch loop 
set animstep to 0. //animation for showing program is runnnig
set distim to time:seconds. //display update timer
set printstep to 0.

//transtiion track
set protrans to false.  //which prograde marker is relevant
set forceprotrans to false.
set pitchstartap to 0. //track the point where we started pitching over

//for tracking maxq transition
set maxq to 0. 
set maxqpassed to false.
set maxqalt to 0.
set maxqpit to 0.
set forcemaxq to false.

//display map 
print "map:" at(43,3+poff).
//instead of an array for data, make it an array for characters
set mapw to 26.
set maph to 12.
set map to mfd_nugarray(mapw,maph,47,3+poff).
set maptime to time:seconds.
set lgpos to latlng(ship:latitude,ship:longitude).
lock drange to (ship:geoposition:position-lgpos:position):mag.
set mx to 0.
set my to 0.

//control steering and throttle until the AP reaches the taralt
until launchdone {
	
	//print "Z" at (2,0).
	//force navball transition
	if btn1 = true {
		set btn1 to false.
		print "F" at(25,9+poff).
		set protrans to true.
	}
	
	//override maxq monitor
	if btn2 = true { 
		set btn2 to false.
		print "F" at (25,21+poff).
		set forcemaxq to true. 
	}
	
	//override throttle limiter
	if btn3 = true {
		set btn3 to false.
		print "F" at (25,18+poff).
		set forcethrottle to true. 
	}

	//override tarpit to match orbit prograde
	if btn4 = true {
		set btn4 to false.
		print "F" at (25,11+poff).
		lock steering to ship:prograde.
	}
	
	//print "A" at (2,0).
	//we need to update the azimuth every so often during launch
	if time:seconds > aztime + 5 {
		set aztime to time:seconds.

		//print something so we know its updating
		set azstep to azstep + 1.
		if azstep = 10 { set azstep to 0. }
		print azstep at (38,3+poff).

		//recalculate
		set adjinc to mfd_adjinc(tarinc,ship:latitude).
		set tarhdg to azimuth(adjinc,taralt).
	}
	
	//print "B" at (2,0).
	//We need to support the autopilot lexicaon tweaking
	//if once sec has passed since last update then
	if time:seconds > lextime + 1 {
		set lextime to time:seconds.
		
		//read in the lexicon and update the params
		set LEX to readjson("ap.json").
		set newtarinc to LEX["hdg"].
		set newtaralt to LEX["alt"].
		
		//if the value has changed, then update. 
		if newtarinc <> tarinc {
			set tarinc to newtarinc. 
			set adjinc to mfd_adjinc(tarinc,ship:latitude).
			set tarhdg to azimuth(adjinc,ship:latitude).
			print "a" at(12,3+poff).
		}
		if newtaralt <> taralt {
			set taralt to newtaralt.
			print "a" at(12,2+poff).
		}
	}

	//print "C" at (2,0).
	//once a second update the launch path graphic 
	if time:seconds > maptime + 10 { 
	
		// the map area is 12x24 characters, 38x24 pixels
		// loc of map, size of map, data, xpct, ypct
		set retv to mfdmap_drawpixel(28,11+poff,mapw,maph,map,drange/(taralt*2),1-ship:altitude/taralt).

		//parse the return value, droppped ret value for performance
		set slist to retv:split(":").
		set mx to slist[0]:tonumber(0).
		set my to slist[1]:tonumber(0).
		//print retv+"  "+mx+"/"+my at (2,0).
	}

	//print "D" at (2,0).
	//we want to transition from looking at the surface prograde marker 
	//to the orbit marker when they line up
	if protrans = false {
	
		if (compit < maxaoa and ship:verticalspeed > 100) or forceprotrans = true {
			set protrans to true.
			set NAVMODE to "ORBIT".
			print "ref-trans" at(28,5+poff).
			print "🡴rt" at(mx+2,my+poff).
		}
	}

	//print "E" at (2,0).
	//calculate the current AoA vs the correct prograde marker
	if protrans = false {

		set curaoa to abs(shppit - srfpit).
	}
	else {

		set curaoa to abs(shppit - orbpit).
	}

	//print "F" at (2,0).
	//skip maxq monitor if no atmo
	if ship:body:atm:exists = false { set maxqpassed to true. }

	//we need to monitor the dynamic pressure and once it starts to go down
	//we can start to relax the limiter 
	if maxqpassed = false { 
		
		//if the pressure is going up then save the new max
		if ship:dynamicpressure > maxq { 
			set maxq to ship:dynamicpressure.
		}
		
		//if the pressure has dropped 10% then assume we have passed maxq
		if (ship:dynamicpressure < maxq*0.95 and ship:verticalspeed > 100 ) or forcemaxq {
			set maxqpassed to true. 
			set maxqalt to ship:altitude.
			set maxqpit to tarpit.
			print "maxq-pass" at(43,5+poff).
			print "🡴mq" at(mx+2,my+poff).
		}
	}

	//print "G" at (2,0).
	//get the current air pressure for use later
	set curpress to SHIP:BODY:ATM:altitudepressure(SHIP:ALTITUDE).

	//calculate the maximum angle of attack
	//	we have a limit until past maxq
	//  we then scale the aoa out based on current air pressure
	if maxqpassed = false {  
		set maxaoa to 5. 
	}
	else { 
		set maxaoa to max(5,abs(15 * (1-(curpress/(ship:body:atm:altitudepressure(maxqalt)+0.000001))))). 
	}

	//calculate the target pitch based on the current ap vs target alt
	//	for the first segment in thick atmo we go a small turn
	//  after passing maxq we go from to 0 relative to ap
	if maxqpassed = false {
		//set the target pitch as a linear scale based on altitude
		set tarpit to mfd_convert(ship:altitude,1000,presalt,90,65).
		set pitchstartap to ship:apoapsis.
	}
	else {
		//set the target pitch based on ap value
		set tarpit to max(0,mfd_convert(ship:apoapsis,pitchstartap,taralt*.95,maxqpit,0)).
	}
	
	//print "H" at (2,0).
	//calculate the limited pitch, the thing steering is locked to.  
	//must be withing the maxaoa range of the current prograde reference
	if ship:verticalspeed < 100 and ship:altitude < 1000 {
		set limpit to 90.
	}
	else if protrans = false { //compare vs surface
		if steerhead = false {
			set steerhead to true.
			lock steering to heading(tarhdg,limpit).
			print "ctrl-lock:hd" at(28,4+poff).
		}
		
		//if within range
		if tarpit < srfpit + maxaoa and tarpit > srfpit - maxaoa { 
			set limpit to tarpit. 
		}
		else { //outside of aoa
			if tarpit > srfpit { set limpit to srfpit+maxaoa. }
			else { set limpit to srfpit-maxaoa. }
		} 
	}
	else { //compare vs orbit
		//if within range
		if tarpit < orbpit + maxaoa and tarpit > orbpit - maxaoa { 
			set limpit to tarpit. 
		}
		else { //outside of aoa
			if tarpit > orbpit { set limpit to orbpit+maxaoa. }
			else { set limpit to orbpit-maxaoa. }
		} 
	
	}

	//print "I" at (2,0).
	//after the AP is 95% there start lowering the throttle
	if SHIP:APOAPSIS/taralt > 0.95 {
		set curthr to 1 - (((SHIP:APOAPSIS/taralt)-0.95)/0.05).
		
		//update status
		if featherstarted = false {
			print "throt-down" at(28,6+poff).
			set featherstarted to true.
		}
		
		//if feather is done then end the loop
		if curthr < 0.01 {
			print "throt-off" at(43,6+poff).
			set launchdone to true.
		}
	}
	
	// else we just keep the throttle under 2 twr
	else {
		if ship:availablethrust > 0 {
			if forcethrottle = true { 
				set curthr to 1.
			}
			else { 
				set curthr to ship:mass*constant:g0*2/(ship:availablethrust+0.00001).
				if curthr > 1 { set curthr to 1. }
			}
		}
		else {
			set curthr to 0.
			
			//mark flameout event
			if ship:altitude > 1000 {
				print "🡴fo" at(mx+2,my+poff).
			}
		}
	}

	//print "J" at (2,0).
	//only update the status display a few times a second to save CPU
	if time:seconds > distim + 0.05 {
		set distim to time:seconds.

		if printstep = 0 {
			print si_formating(taralt,"m"):padright(10) at(15,2+poff).
			print (padding(tarinc,1,2)+" °"):padright(10) at(15,3+poff). }
			//print (round(taralt)+" "):padright(10) at(15,2+poff).
			//print (round(tarinc)+" °"):padright(10) at(15,3+poff). }
		else if printstep = 1 {
			print (padding(adjinc,1,2)+" °"):padright(10) at(15,4+poff).
			print (padding(tarhdg,1,2)+" °"):padright(10) at(15,5+poff). }
			//print (round(adjinc,2)+" °"):padright(10) at(15,4+poff).
			//print (round(tarhdg,2)+" °"):padright(10) at(15,5+poff). }
		else if printstep = 2 { 
			print (padding(orbpit,1,2)+" °"):padright(10) at(15,7+poff).
			print (padding(srfpit,1,2)+" °"):padright(10) at(15,8+poff). }
			//print (round(orbpit,1)+" °"):padright(10) at(15,7+poff).
			//print (round(srfpit,1)+" °"):padright(10) at(15,8+poff). }
		else if printstep = 3 { 
			print (padding(compit,1,2)+" °"):padright(10) at(15,9+poff).
			print (padding(shppit,1,2)+" °"):padright(10) at(15,10+poff). }
			//print (round(compit,1)+" °"):padright(10) at(15,9+poff).
			//print (round(shppit,1)+" °"):padright(10) at(15,10+poff). }
		else if printstep = 4 {
			print (padding(tarpit,1,2)+" °"):padright(10) at(15,11+poff).
			print (padding(limpit,1,2)+" °"):padright(10) at(15,12+poff). }
			//print (round(tarpit,1)+" °"):padright(10) at(15,11+poff).
			//print (round(limpit,1)+" °"):padright(10) at(15,12+poff). }
		else if printstep = 5 {
			print (padding(maxaoa,1,2)+" °"):padright(10) at(15,14+poff).
			print (padding(curaoa,1,2)+" °"):padright(10) at(15,15+poff). }
			//print (round(maxaoa,1)+" °"):padright(10) at(15,14+poff).
			//print (round(curaoa,1)+" °"):padright(10) at(15,15+poff). }
		else if printstep = 6 { 
			print (padding(maxtwr,1,3)):padright(10) at(15,16+poff).
			print (padding(curtwr,1,3)):padright(10) at(15,17+poff). }
			//print (round(maxtwr,3)+" "):padright(10) at(15,16+poff).
			//print (round(curtwr,3)+" "):padright(10) at(15,17+poff). }
		else if printstep = 7 {
			print (padding(curthr*100,3,0)+" %"):padright(10) at(15,18+poff).
			print si_formating(drange,"m"):padright(10) at(15,19+poff). }
			//print (round(curthr*100)+" %"):padright(10) at(15,18+poff).
			//print (round(drange)+" "):padright(10) at(15,19+poff). }
		else if printstep = 8 {
			print si_formating(maxq*constant:atmtokpa*1000,"Pa"):padright(10) at(15,20+poff).
			print si_formating(maxqalt,"m"):padright(10) at(15,21+poff). }
			//print (round(maxq*constant:atmtokpa*1000)+" "):padright(10) at(15,20+poff).
			//print (round(maxqalt)+" "):padright(10) at(15,21+poff). }

		set printstep to printstep + 1.
		if printstep = 9 { set printstep to 0. }

		//print an animated icon to show the script is running
		set animstep to mfd_animicon(0,0+poff,animstep).

	}
	
	//wait 0.001.
}

//once we have achieved AP then release controls
wait until launchdone.

//release controls
set throttle to 0. 
unlock throttle. 
unlock steering.
print "ctrl-rel" at(28,7+poff).
SAS ON.
print "SAS-ON" at(43,7+poff).

//Once the vessel is out of the atmo  
print "wait-vac" at(43,8+poff).
wait until SHIP:BODY:ATM:altitudepressure(SHIP:ALTITUDE) = 0.

//create a node to circulize at the AP 
set ndvel to (SHIP:BODY:MU / (SHIP:BODY:RADIUS + SHIP:APOAPSIS))^0.5.
set apvel to VELOCITYAT(SHIP, time:seconds + eta:apoapsis):ORBIT:MAG.
set newnode to node(time:seconds + eta:apoapsis,0,0,ndvel-apvel).
add newnode.
print "circ node @ "+si_formating(ndvel-apvel,"m/s") at(28,9+poff).

//terminate the autopilot
//clear screen and run list program if possible
