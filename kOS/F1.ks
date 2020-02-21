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
parameter passed_alt is 9999, passed_inc is 9999.

//main input vars
set taralt to 9999.
set hasalt to false.
set tarinc to 9999.
set hasinc to false.

//setup the screen info fields
clearscreen.
//     ----=----=----=----=----=xxxxx----=----=----=----=----=
print "                    LAUNCH TO ORBIT                    " at(0,0).
print "═══════════════════════════╤═══════════════════════════" at(0,1).
print "Target Alt.  :             │                           " at(0,2).
print "Target Inc.  :             │                           " at(0,3).
print "Adj. Inc.    :             │                           " at(0,4).
print "Target Head. :             │                           " at(0,5).                              
print "───────────────────────────┤                           " at(0,6).   
print "Orbit Pitch  :             │                           " at(0,7).
print "Surf. Pitch  :             │                           " at(0,8).
print "Diff Orb/Surf:             │                           " at(0,9).
print "Vessel Pitch :             ├───────────────────────────" at(0,10).
print "Target Pitch :             │  Launch Graph             " at(0,11).
print "Limit Pitch  :             │                           " at(0,12).                              
print "───────────────────────────┤  🢁                        " at(0,13).
print "Max AoA      :             │ talt                      " at(0,14).
print "Current AoA  :             │  🢃                        " at(0,15).
print "Max TWR      :             │                           " at(0,16).
print "Curr. TWR    :             │                           " at(0,17).
print "Curr. Throt  :             │                           " at(0,18).
print "Downrange    :             │                           " at(0,19).
print "MaxQ         :             │                           " at(0,20).
print "MaxQ Alt     :             │                2xtalt     " at(0,21).
print "Low Pres Alt :             │              🢀 range 🢂   " at(0,22).
print "─────────┬────────┬────────┼────────┬────────┬─────────" at(0,23).
print "  FC-TRAN│ FC-MAXQ│ THR-OVR│CTRL-OVR│   F5   │   F6   " at (0,24).

//monitor reserved action groups for button activity
set btn1 to AG239. 
set btn2 to AG240. 
set btn3 to AG241. 
set btn4 to AG242. 
set btn5 to AG243. 
set btn6 to AG244. 

//check the parameters, if they were used then populate the vars and flip flags
if passed_alt <> 9999 {
	set hasalt to true.
	set taralt to passed_alt.
	print "p" at(12,2).
}
if passed_inc <> 9999 {
	set hasinc to true.
	set tarinc to passed_inc.
	print "p" at(12,3).
}

//if we did not take a param then we need to take terminal input
if hasalt = false or hasinc = false {
	print "term-input:         " at (28,2).
}
else {
	print "init-param"+si_formating(taralt,"")+"  "+padding(tarinc,1,2)+" °" at(28,2).
}

if hasalt = false { 
	set taralt to mfd_numinput(40,2,false).  
	set hasalt to true.
	print "t" at(12,2).
}
wait until hasalt = true.

//check other param
if hasinc = false { 
	print "             " at (40,2).
	set tarinc to mfd_numinput(40,2,false,0,180).  
	set hasinc to true.
	print "t" at(12,3).
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
print si_formating(presalt,"m") at(15,22).

//get a target heading to hit the desired incl
set aztime to time:seconds.
set azstep to 0.
set adjinc to mfd_adjinc(tarinc,ship:latitude).
set tarhdg to azimuth(adjinc,taralt).
print "calc-path-0" at(28,3).

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
print "ctrl-lock:up  " at(28,4).

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
set LEX["mrl"] to 0.
set LEX["mvs"] to 0.
writejson(LEX,"ap.json").
print "trim-init" at(43,4).

//loop control vars
set featherstarted to false.
set launchdone to false. //flag to kill the main launch loop 
set animstep to 0. //animation for showing program is runnnig
set distim to time:seconds. //display update timer

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
print "map:" at(43,3).
//instead of an array for data, make it an array for characters
set mapw to 26.
set maph to 12.
set map to mfd_createarray(mapw,maph,47,3).
set maptime to time:seconds.
set lgpos to latlng(ship:latitude,ship:longitude).
lock drange to (ship:geoposition:position-lgpos:position):mag.
set mx to 0.
set my to 0.

//control steering and throttle until the AP reaches the taralt
until launchdone {
	
	//force navball transition
	if btn1 <> AG239 {
		set btn1 to AG239.
		print "F" at(25,9).
		set protrans to true.
	}
	
	//override maxq monitor
	if btn2 <> AG240 { 
		set btn2 to AG240.
		print "F" at (25,21).
		set forcemaxq to true. 
	}
	
	//override throttle limiter
	if btn3 <> AG241 {
		set btn3 to AG241.
		print "F" at (25,18).
		set forcethrottle to true. 
	}

	//override tarpit to match orbit prograde
	if btn4 <> AG242 {
		set btn4 to AG242.
		print "F" at (25,11).
		lock steering to ship:prograde.
	}
	
	//we need to update the azimuth every so often during launch
	if time:seconds > aztime + 5 {
		set aztime to time:seconds.

		//print something so we know its updating
		set azstep to azstep + 1.
		if azstep = 10 { set azstep to 0. }
		print azstep at (38,3).

		//recalculate
		set adjinc to mfd_adjinc(tarinc,ship:latitude).
		set tarhdg to azimuth(adjinc,taralt).
	}
	
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
			print "a" at(12,3).
		}
		if newtaralt <> taralt {
			set taralt to newtaralt.
			print "a" at(12,2).
		}
	}

	//once a second update the launch path graphic 
	if time:seconds > maptime + 2 { 
	
		// the map area is 12x24 characters, 38x24 pixels
		// loc of map, size of map, data, xpct, ypct
		set retv to mfdmap_drawpixel(28,11,mapw,maph,map,drange/(taralt*2),1-ship:altitude/taralt).

		//parse the return value
		set slist to retv:split(":").
		set mx to slist[0]:tonumber(0).
		set my to slist[1]:tonumber(0).
		//print retv+"  "+mx+"/"+my at (2,0).
	}

	//we want to transition from looking at the surface prograde marker 
	//to the orbit marker when they line up
	if protrans = false {
		if (compit < maxaoa and ship:verticalspeed > 100) or forceprotrans = true {
			set protrans to true.
			set NAVMODE to "ORBIT".
			print "ref-trans" at(28,5).
			print "🡴rt" at(mx+2,my).
		}
	}

	//calculate the current AoA vs the correct prograde marker
	if protrans = false {
		set curaoa to abs(shppit - srfpit).
	}
	else {
		set curaoa to abs(shppit - orbpit).
	}

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
			print "maxq-pass" at(43,5).
			print "🡴mq" at(mx+2,my).
		}
	}

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
	
	//calculate the limited pitch, the thing steering is locked to.  
	//must be withing the maxaoa range of the current prograde reference
	if ship:verticalspeed < 100 and ship:altitude < 1000 {
		set limpit to 90.
	}
	else if protrans = false { //compare vs surface
		if steerhead = false {
			set steerhead to true.
			lock steering to heading(tarhdg,limpit).
			print "ctrl-lock:hd" at(28,4).
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

	//after the AP is 95% there start lowering the throttle
	if SHIP:APOAPSIS/taralt > 0.95 {
		set curthr to 1 - (((SHIP:APOAPSIS/taralt)-0.95)/0.05).
		
		//update status
		if featherstarted = false {
			print "throt-down" at(28,6).
			set featherstarted to true.
		}
		
		//if feather is done then end the loop
		if curthr < 0.01 {
			print "throt-off" at(43,6).
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
				print "🡴fo" at(mx+2,my).
			}
		}
	}

	//only update the status display a few times a second to save CPU
	if time:seconds > distim + 0.2 {
		set distim to time:seconds.

		//new status data
		print si_formating(taralt,"m"):padright(10) at(15,2).
		print (padding(tarinc,1,2)+" °"):padright(10) at(15,3).
		print (padding(adjinc,1,2)+" °"):padright(10) at(15,4).
		print (padding(tarhdg,1,2)+" °"):padright(10) at(15,5).

		print (padding(orbpit,1,2)+" °"):padright(10) at(15,7).
		print (padding(srfpit,1,2)+" °"):padright(10) at(15,8).
		print (padding(compit,1,2)+" °"):padright(10) at(15,9).
		print (padding(shppit,1,2)+" °"):padright(10) at(15,10).
		print (padding(tarpit,1,2)+" °"):padright(10) at(15,11).
		print (padding(limpit,1,2)+" °"):padright(10) at(15,12).

		print (padding(maxaoa,1,2)+" °"):padright(10) at(15,14).
		print (padding(curaoa,1,2)+" °"):padright(10) at(15,15).
		print (padding(maxtwr,1,3)):padright(10) at(15,16).
		print (padding(curtwr,1,3)):padright(10) at(15,17).
		print (padding(curthr*100,3,0)+" %"):padright(10) at(15,18).
		print si_formating(drange,"m"):padright(10) at(15,19).
		print si_formating(maxq*constant:atmtokpa*1000,"Pa"):padright(10) at(15,20).
		print si_formating(maxqalt,"m"):padright(10) at(15,21).

		//print an animated icon to show the script is running
		set animstep to mfd_animicon(0,0,animstep).

	}
	
	//wait 0.001.
}

//once we have achieved AP then release controls
wait until launchdone.

//release controls
set throttle to 0. 
unlock throttle. 
unlock steering.
print "ctrl-rel" at(28,7).
SAS ON.
print "SAS-ON" at(43,7).

//Once the vessel is out of the atmo  
print "wait-vac" at(43,8).
wait until SHIP:BODY:ATM:altitudepressure(SHIP:ALTITUDE) = 0.

//create a node to circulize at the AP 
set ndvel to (SHIP:BODY:MU / (SHIP:BODY:RADIUS + SHIP:APOAPSIS))^0.5.
set apvel to VELOCITYAT(SHIP, time:seconds + eta:apoapsis):ORBIT:MAG.
set newnode to node(time:seconds + eta:apoapsis,0,0,ndvel-apvel).
add newnode.
print "circ node @ "+si_formating(ndvel-apvel,"m/s") at(28,9).

//terminate the autopilot
//clear screen and run list program if possible
