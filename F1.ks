//MFD Autopilot - Launch to Orbit Script
// by Jonathan Medders  'EberKain'
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

// ----=----=----=----=----=----=----=----=----=----=
//       LAUNCH TO ORBIT                STATUS
//  Altitude (km)     : ####       getting params 
//  Inclination (deg) : ####        [ALT]  [INC]
//  
//  Landed Latiatude  : ####       ready to launch    
//  True Target Incl. : ####       steering locked
//                                 throttle locked
//  Current Altitude  : #### 
//  Current Apoaposis : ####       pitching over
//  Current Pitch     : ####       reducing throttle
//  Current Throttle  : ####
//                                 controls unlocked
//  Target Pitch      : ####       waiting for vac
//  Target Throttle   : ####       
//                                 node created
//                                 terminating prog

//collect passed params
parameter passed_alt, passed_inc.

//main input vars
set taralt to "".
set hasalt to false.
set tarinc to "".
set hasinc to false.

//other control values
set maxaoa to 5. //the max number of degrees to steer off prograde marker

//setup the screen info fields
clearscreen.
print "       LAUNCH TO ORBIT               STATUS".
print "  Altitude (km)     :            getting params ".
print "  Inclination (deg) : ".
print " ".
print "  Landed Latiatude  : ".        
print "  True Target Incl. : ".                              
print " ".
print "  Current Altitude  : ". 
print "  Current Apoaposis : ".
print "  Curr. Incl. (deg) : ".
print "  Velocity Pitch    : ".
print "  Vessel Pitch      : ".
print "  Target Pitch      : ".
print "  Real Target Pitch : ".
print " ".
print "  Current Throttle  : ".                              
print "  Target Throttle   : ".   
print " ".
print "  Max AoA     (deg) :  " + maxaoa.
print "  Current AoA (deg) :  ".
print "  Limited AoA (deg) :  ".
print "  Actual Pressure   :  ".
print "  Dynamic Pressure  :  ".

//check the parameters, if they were used then populate the vars and flip flags
if passed_alt > 0 {
	set hasalt to true.
	set taralt to passed_alt.
	print taralt at(23,1).
	print "[ALT]" at(34,2).
}
if passed_inc > 0 {
	set hasinc to true.
	set tarinc to passed_inc.
	print tarinc at(23,2).
	print "[INC]" at(42,2).
}

//otherwise we prompt the user to input params 
on terminal:input:haschar {
	set char to terminal:input:getchar().
	set val to char:tonumber(-1).
	if hasalt = false {
		if char = terminal:input:ENTER { 
			terminal:input:clear. 
			set hasalt to true. 
			print "[ALT]" at(34,2).
		}
		if char = terminal:input:backspace {
			set taralt to taralt:remove(taralt:length-1,1).	
			print taralt + " " at(23,1).
		}
		if val >= 0 { // input was a number
			set taralt to taralt + char. 
			print taralt at(23,1).
		} 
		//if input was a letter then do nothing
	}
	else {
		if char = terminal:input:ENTER { 
			terminal:input:clear. 
			set hasinc to true. 
			print "[INC]" at(42,2).
		}
		if char = terminal:input:backspace {
			set tarinc to tarinc:remove(tarinc:length-1,1).	
			print tarinc + " " at(23,2).
		}
		if val >= 0 { // input was a number
			set tarinc to tarinc + char. 
			print tarinc at(23,2).
		} 
		//if input was a letter then do nothing
	}
	preserve. 
}

//halt program until vars are ready to use
wait until hasalt = true.
wait until hasinc = true.

//calculate realtarinc which is the larger of tarinc and grounded latitude
//assume most launches are at equator so the tarinc is fine to use
set realtarinc to tarinc+90.

//if ship is in northem hemi then use larger of lat vs tarinc
if SHIP:LATITUDE > 1 {
	set realtarinc to MAX(tarinc,SHIP:LATITUDE).
}

//if ship is in souther hemi use smaller of lat vs tarinc
if SHIP:LATITUDE < -1 {
	set realtarinc to MIN(tarinc,SHIP:LATITUDE).
}

//take over control of steering
set velpit to 89.
set shppit to 89.
set tarpit to 89.
set realtarpit to 89. 
set curaoa to 0.
set pitchstarted to false.
set pitchstartalt to 0.
lock steering to heading(realtarinc,realtarpit).

//take over control of throttle
set tarthr to 1.
set featherstarted to false.
set launchdone to false.
lock throttle to tarthr.

//update the status
print "ready to launch" at(33,4).
print "steering locked" at(33,5).
print "throttle locked" at(33,6).
print ROUND(SHIP:LATITUDE,2) at(23,4).
print realtarinc + " deg" at(23,5).


//control steering and throttle until the AP reaches the taralt
until launchdone {
	set velpit to 90-VANG(UP:FOREVECTOR, PROGRADE:FOREVECTOR).
	set shppit to 90-vang(UP:FOREVECTOR, FACING:FOREVECTOR).
	set curaoa to shppit - realtarpit.
	set curpress to SHIP:BODY:ATM:altitudepressure(SHIP:ALTITUDE).
	set limaoa to maxaoa * (1-(curpress/0.25)).
	
	//if less than 100m above ground and in thick atmo
	//then lock steering up 
	if SHIP:ALTITUDE < 1000 OR curpress > 0.25 {
		set tarpit to 89.
		set realtarpit to 89.
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
	
	//update the status display 
	print ROUND(SHIP:ALTITUDE,0)+" m" at(23,7).
	print ROUND(SHIP:APOAPSIS,0)+" m" at(23,8).
	print ROUND(SHIP:OBT:INCLINATION,0) at(23,9).
	
	print ROUND(velpit+0.001,2) at(23,10).
	print ROUND(shppit+0.001,2) at(23,11).
	print ROUND(tarpit+0.001,2) at(23,12).
	print ROUND(realtarpit+0.001,2) at(23,13).
	
	print ROUND((THROTTLE*100),0)+" %   " at(23,15).
	print ROUND((tarthr*100),0)+" %   " at(23,16).

	print ROUND(curaoa+0.001,2) at(23,19).
	print ROUND(limaoa+0.001,2) at(23,20).
	print ROUND(curpress,2) at(23,21).
	print ROUND(SHIP:DYNAMICPRESSURE,2) at(23,22).

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
