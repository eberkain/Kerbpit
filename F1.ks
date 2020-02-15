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
print "───────────────────────────┤                          " at(0,6).   
print "Orbit Pitch  :             │                           " at(0,7).
print "Surf. Pitch  :             │                           " at(0,8).
print "Diff Orb/Surf:             │                           " at(0,9).
print "Vessel Pitch :             │                           " at(0,10).
print "Target Pitch :             │                           " at(0,11).
print "Limit Pitch  :             │                           " at(0,12).                              
print "───────────────────────────┤                          " at(0,13).
print "Max AoA      :             │                           " at(0,14).
print "Current AoA  :             │                           " at(0,15).
print "Max TWR      :             │                           " at(0,16).
print "Curr. TWR    :             │                           " at(0,17).
print "Curr. Throt  :             │                           " at(0,18).
print "                           │                           " at(0,19).
print "MaxQ         :             │                           " at(0,20).
print "MaxQ Alt     :             │                           " at(0,21).
print "Low Pres Alt :             │                           " at(0,22).
print "─────────┬────────┬────────┼────────┬────────┬─────────" at(0,23).
print "    F1   │   F2   │   F3   │   F4   │   F5   │   F6   " at (0,24).

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
	print "waiting for input..." at (28,2).
}
else {
	print "initilizing with parameters" at (28,2).
	print "    " + taralt + "       " + tarinc at (28,3).
}

if hasalt = false { 
	set taralt to mfd_numinput(28,3,false).  
	set hasalt to true.
	print "t" at(12,2).
}
wait until hasalt = true.

//check other param
if hasinc = false { 
	set tarinc to mfd_numinput(40,3,true,-180,180).  
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
set adjinc to mfd_adjinc(tarinc,ship:latitude).
set tarhdg to mfd_inctohdg(adjinc).
print "calculating launch path" at(28,4).

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

//track aoa variables
set curaoa to 0. //the current aoa, calc in loop for transition swap
set maxaoa to 5. //the max number of degrees to steer off prograde marker

//take over control of steering
lock steering to up. //heading(tarhdg,limpit).
set steerhead to false.  //is steering locked to heading
print "steering locked : up" at(28,5).

//take over control of throttle
set curthr to 1.
lock maxtwr to ship:availablethrust/(ship:mass*constant:g0).
lock curtwr to (ship:availablethrust*curthr)/(ship:mass*constant:g0).
lock throttle to curthr.
print "throttle locked" at(28,6).

//write a new lexicon with the starting values
set lextime to time:seconds.
set LEX to lexicon().
set LEX["hdg"] to tarinc.
set LEX["alt"] to taralt.
set LEX["spd"] to 0.
set LEX["mrl"] to 0.
set LEX["mvs"] to 0.
writejson(LEX,"ap.json").
print "trim system initilizaed" at(28,7).

//loop control vars
set featherstarted to false.
set launchdone to false. //flag to kill the main launch loop 
set protrans to false.  //which prograde marker is relevant
set animstep to 0. //animation for showing program is runnnig
set progstep to 0. //control for what stage of launch we are at
set progtime to 0. //timer the program can use 
set pitchstartap to 0. //track the point where we started pitching over

//for tracking maxq transition
set maxq to 0. 
set maxqpassed to false.
set maxqalt to 0.
set maxqpit to 0.

//control steering and throttle until the AP reaches the taralt
until launchdone {

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
			set tarhead to mfd_inctohdg(tarinc).
			print "a" at(12,3).
		}
		if newtaralt <> taralt {
			set taralt to newtaralt.
			print "a" at(12,2).
		}

		//print an animated icon to show the script is running
		set animstep to mfd_animicon(0,0,animstep).
	}

	//we want to transition from looking at the surface prograde marker 
	//to the orbit marker when they line up
	if protrans = false {
		if compit < maxaoa and ship:verticalspeed > 100 {
			set protrans to true.
			set NAVMODE to "ORBIT".
			print "reference transition" at(28,10).
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
		if ship:dynamicpressure < maxq*0.95 and ship:verticalspeed > 100 {
			set maxqpassed to true. 
			set maxqalt to ship:altitude.
			set maxqpit to tarpit.
			print "passing maxq" at(28,9).
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
		set maxaoa to max(5,abs(15 * (1-(curpress/ship:body:atm:altitudepressure(maxqalt))))). 
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
			print "steering locked : head" at(28,5).
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
			print "reducing throttle" at(28,11).
			set featherstarted to true.
		}
		
		//if feather is done then end the loop
		if curthr < 0.01 {
			set launchdone to true.
		}
	}
	
	// else we just keep the throttle under 2 twr
	else {
		if ship:availablethrust > 0 { 
			set curthr to ship:mass*constant:g0*2/ship:availablethrust.
			if curthr > 1 { set curthr to 1. }
		}
		else {
			set curthr to 0.
		}
	}

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

	print si_formating(maxqalt,"m"):padright(10) at(15,21).
	print si_formating(maxq*constant:atmtokpa*1000,"Pa"):padright(10) at(15,20).

	//wait 0.001.
}

//once we have achieved AP then release controls
wait until launchdone.
unlock throttle. 
set throttle to 0. 
unlock steering.
SAS ON.
print "control released" at(28,13).
print "stability assist on" at(28,14).
print "waiting for vac" at(28,15).

//Once the vessel is out of the atmo  
wait until SHIP:BODY:ATM:altitudepressure(SHIP:ALTITUDE) = 0.

//create a node to circulize at the AP 
set ndvel to (SHIP:BODY:MU / (SHIP:BODY:RADIUS + SHIP:APOAPSIS))^0.5.
set apvel to VELOCITYAT(SHIP, time:seconds + eta:apoapsis):ORBIT:MAG.
set newnode to node(time:seconds + eta:apoapsis,0,0,ndvel-apvel).
add newnode.
print "circ node @ "+(ndvel-apvel)+" m/s" at(33,16).
print "terminating autopilot" at(33,18).

//terminate the autopilot
//clear screen and run list program if possible
