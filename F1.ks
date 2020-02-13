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
// when engines ignite throttle is slowly increased from 0 to 1
// Throttle to hold a TWR less than 2
// Hold vertical with sas until past maxq
// Begin a gentel turn of 1 deg AoA after passing maxq
// after passing 0.25 pressure increase AoA limiter
// set angle based on AP versus desired AP 

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
print "———————————————————————————┤                           " at(0,6).   
print "Orbit Pitch  :             │                           " at(0,7).
print "Surf. Pitch  :             │                           " at(0,8).
print "Diff Orb/Surf:             │                           " at(0,9).
print "Vessel Pitch :             │                           " at(0,10).
print "Target Pitch :             │                           " at(0,11).
print "Limit Pitch  :             │                           " at(0,12).                              
print "———————————————————————————┤                           " at(0,13).
print "Max AoA      :             │                           " at(0,14).
print "Current AoA  :             │                           " at(0,15).
print "Limited AoA  :             │                           " at(0,16).
print "                           │                           " at(0,17).
print "                           │                           " at(0,18).
print " Target Throt              │                           " at(0,19).
print " Curr. Throt               │                           " at(0,20).
print "                           │                           " at(0,21).
print "Low Pres Alt :             │                           " at(0,22).
print "—————————┬————————┬————————┼————————┬————————┬—————————" at(0,23).
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
until prestest < 0.25 {
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
//pitch of the ship currently
lock shppit to 90-vang(up:forevector, ship:facing:forevector).  
//pitch difference between two progrades, when this drops <1 we transition 
lock compit to vang(ship:prograde:forevector, ship:srfprograde:forevector).  
//targeted pitch to steer to 
set tarpit to 90.  
//tergeted pitch under aoa limits << steering lock to this
set limpit to 90.   

//track aoa variables
set curaoa to 0. //the current aoa, calc in loop for transition swap
set maxaoa to 5. //the max number of degrees to steer off prograde marker
lock limaoa to max(1,abs(maxaoa * (1-(curpress/0.25)))). //limited aoa based on air pressure

//control for what stage of launch we are at
set progstep to 0.
//track the point where we started pitching over
set pitchstartalt to 0.

//take over control of steering
lock steering to heading(tarhdg,limpit).

//take over control of throttle
set tarthr to 1.
lock throttle to tarthr.


//update the status
//print "ready to launch" at(33,4).
//print "steering locked" at(33,5).
//print "throttle locked" at(33,6).
//print ROUND(SHIP:LATITUDE,2) at(23,4).

//write a new lexicon with the starting values
set lextime to time:seconds.
set LEX to lexicon().
set LEX["hdg"] to tarinc.
set LEX["alt"] to taralt.
set LEX["spd"] to 0.
set LEX["mrl"] to 0.
set LEX["mvs"] to 0.
writejson(LEX,"ap.json").

//loop control vars
set featherstarted to false.
set launchdone to false.
set protrans to false.  //which prograde marker is relevant
set animstep to 0.

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

		//print a character to animate to indicate script is running and healty
		if animstep = 0 { print "/" at (0,0). }
		if animstep = 1 OR animstep = 3 { print "|" at (0,0). }
		if animstep = 2 { print "\" at (0,0). }
		set animstep to animstep + 1.
		if animstep = 4 { set animstep to 0. }
		
	}

	//we want to transition from looking at the surface prograde marker 
	//to the orbit marker when they line up
	if protrans = false {
		if abs(orbpit - srfpit) < 1 {
			set protrans to true.
		}
	}

	//calculate the current AoA vs the correct prograde marker
	if protrans = false {
		set curaoa to abs(shppit - srfpit).
	}
	else {
		set curaoa to abs(shppit - orbpit).
	}
	
	//things we need to calc in loop 
	//tarpit
	//limpit 
	
	
	
	set curpress to SHIP:BODY:ATM:altitudepressure(SHIP:ALTITUDE).
	set limaoa to abs(maxaoa * (1-(curpress/0.25))).
	
	
	//if less than 100m above ground and in thick atmo
	//then lock steering up 
	if curpress > 0.25 {
		if SHIP:ALTITUDE < 1000 {
			set tarpit to 89.
			set realtarpit to 89.
		}
		else {
			set tarpit to 88.
			set realtarpit to 88.
		}
	}

	//otherwise we create an angle based on the relationship between the AP and taralt
	else {
		//save alt for start of curve
		if pitchstarted = false {
			set pitchstartalt to SHIP:ALTITUDE.
			set pitchstarted to true.
			print "pitching over" at(33,8).
		}
	
		//at the start alt the angle is close to 90
		//when the ap is 80% of the goal the angle should be 0
		set tarpit to 90-((SHIP:APOAPSIS-pitchstartalt)/((taralt*1000)-pitchstartalt)*120).
		if tarpit < 0 { set tarpit to 0. }

		//if the tarpit is more than maxaoa deg ahead of the ship:pitch the clamp
		//limit the aoa to a percent of the atmo density, at 0.25atm, 0 deg, at 0atm, maxaoa
		if ABS(shppit-tarpit) > limaoa { 
			set realtarpit to shppit - limaoa. 
		}
		else { set realtarpit to tarpit. }
	}

	//after the AP is 95% there start lowering the throttle
	if SHIP:APOAPSIS/(taralt*1000) > 0.95 {
		set tarthr to 1 - (((SHIP:APOAPSIS/(taralt*1000))-0.95)/0.05).
		
		//update status
		if featherstarted = false {
			print "reducing throttle" at(33,9).
			set featherstarted to true.
		}
		
		//if feather is done then end the loop
		if tarthr < 0.01 {
			set launchdone to true.
		}
	}
	
	// else we just keep the throttle at max
	else {
		set tarthr to 1.
	}
	
	//new status data
	print (si_formating(taralt,"m")):padright(10) at(15,2).
	print (padding(tarinc,1,2)+" °"):padright(10) at(15,3).
	print (padding(adjinc,1,2)+" °"):padright(10) at(15,4).
	print (padding(tarhdg,1,2)+" °"):padright(10) at(15,5).
	

	//update the status display 

	//print ROUND(SHIP:ALTITUDE,0) at(23,7).
	//print ROUND(SHIP:APOAPSIS,0) at(23,8).
	//print ROUND(SHIP:OBT:INCLINATION,2) + "  " at(23,9).
	
	//print ROUND(velpit+0.001,2) at(23,10).
	//print ROUND(shppit+0.001,2) at(23,11).
	//print ROUND(tarpit+0.001,2) at(23,12).
	//print ROUND(realtarpit+0.001,2) at(23,13).
	
	//print ROUND((THROTTLE*100),0) at(23,15).
	//print ROUND((tarthr*100),0) at(23,16).

	//print ROUND(curaoa+0.001,2)+"    " at(23,19).
	//print ROUND(limaoa+0.001,2)+"    " at(23,20).
	//print ROUND(curpress,2) at(23,21).
	//print ROUND(SHIP:DYNAMICPRESSURE,2) at(23,22).

}

//once we have achieved AP then release controls
wait until launchdone.
unlock throttle. 
set throttle to 0. 
unlock steering.
SAS ON.
print "steering released" at(33,11).
print "throttle released" at(33,12).
print "stability assist on" at(33,13).
print "waiting for vac" at(33,14).


//Once the vessel is out of the atmo  
wait until SHIP:BODY:ATM:altitudepressure(SHIP:ALTITUDE) = 0.

//create a node to circulize at the AP 
set ndvel to (SHIP:BODY:MU / (SHIP:BODY:RADIUS + SHIP:APOAPSIS))^0.5.
set apvel to VELOCITYAT(SHIP, time:seconds + eta:apoapsis):ORBIT:MAG.
set newnode to node(time:seconds + eta:apoapsis,0,0,ndvel-apvel).
add newnode.
print "circ node created" at(33,16).
print "ndvel = " + ROUND(ndvel,0) at(33,17).
print "apvel = " + ROUND(apvel,0) at(33,18).

print "terminating autopilot" at(33,20).

//terminate the autopilot
//clear screen and run list program if possible
