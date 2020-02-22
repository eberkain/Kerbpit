// MFD Autopilot - Execute Next Node
// by Jonathan Medders  'EberKain'
//
// based on the hoverslam script by mrbradleyjh
// https://github.com/mrbradleyjh/kOS-Hoverslam/blob/master/hoverslam.ks
//
// landing on an airless body is a 3 part process beginning in low orbit
// make a retrograde burn to pick a general landing area
// make a medium altitude burn to kill horizonal velocity
// perform a last second suicide burn
//
// this program should skip deorbit burn if already on a suborbital path

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
//print the button labels at top or bottom
if mfdtop = true { 
	print "    F1   │   F2   │   F3   │   F4   │   F5   │   F6   " at (0,0).
	print "─────────┴────────┴────────┴────────┴────────┴─────────" at(0,1). }
else {
	print "─────────┬────────┬────────┼────────┬────────┬─────────" at(0,23).
	print "    F1   │   F2   │   F3   │   F4   │   F5   │   F6   " at (0,0). }

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
on AG230 { if nfdud = 1 { set btn4 to true. } preserve. }
on AG231 { if mfdid = 1 { set btn5 to true. } preserve. }
on AG232 { if mfdid = 1 { set btn6 to true. } preserve. }
on AG233 { if mfdid = 2 { set btn1 to true. } preserve. }
on AG234 { if mfdid = 2 { set btn2 to true. } preserve. }
on AG235 { if mfdid = 2 { set btn3 to true. } preserve. }
on AG236 { if nfdud = 2 { set btn4 to true. } preserve. }
on AG237 { if mfdid = 2 { set btn5 to true. } preserve. }
on AG238 { if mfdid = 2 { set btn6 to true. } preserve. }
on AG239 { if mfdid = 3 { set btn1 to true. } preserve. }
on AG240 { if mfdid = 3 { set btn2 to true. } preserve. }
on AG241 { if mfdid = 3 { set btn3 to true. } preserve. }
on AG242 { if nfdud = 3 { set btn4 to true. } preserve. }
on AG243 { if mfdid = 3 { set btn5 to true. } preserve. }
on AG244 { if mfdid = 3 { set btn6 to true. } preserve. }
on AG245 { if mfdid = 4 { set btn1 to true. } preserve. }
on AG246 { if mfdid = 4 { set btn2 to true. } preserve. }
on AG247 { if mfdid = 4 { set btn3 to true. } preserve. }
on AG248 { if nfdud = 4 { set btn4 to true. } preserve. }
on AG249 { if mfdid = 4 { set btn5 to true. } preserve. }
on AG250 { if mfdid = 4 { set btn6 to true. } preserve. }

//print out the display
print "     AUTOMATED LANDING            STATUS ".
print "  Vector Difference : ".
print "  Max Stopping Time : ".
print "  Suborbital Pe.    : ".
print "  ".
print "  Landing Latitude  : ".
print "  Landing Longitude : ".
print "  Ground Speed      : ".
print "  ".
print "  True Radar Alt.   : ".
print "  Vertical Speed.   : ".
print "  Gravity at Body   : ".
print "  Max Deceleration  : ".
print "  Stopping Distance : ".
print "  Ideal Throttle    : ".
print "  Impact Time       : ".
print "  Time Till Burn    : ".

print "steering locked" at(33,1).
print "throttle locked" at(33,2).
lock steering to ship:facing:vector.
lock throttle to 0.

//do a deorbit burn if not currently suborbital
set suborb to true.  //assume we are already suborbital
set tset to 0.
set suborbalign to false.

//if not suborbital then we need to make a burn 
if ship:orbit:PERIAPSIS > 0 { 
	set suborb to false. 
	lock steering to retrograde.
	lock throttle to tset.
	rcs on.
	sas off.
	print "performing deorbit" at(33,4).
}

//do this loop until we are suborbital 
until suborb = true {
	//adjust the turn rate
	set vdif to vang(retrograde:vector, ship:facing:vector).
	set mst to (vdif*0.1)+4.
	set steeringmanager:maxstoppingtime to mst.
	set pecomp to (body:radius*0.8) + ship:orbit:periapsis. 

	//print status
	print round(vdif,0)+"   " at(23,1).
	print round(mst,0)+"   " at(23,2).
	print round(pecomp,0)+"   " at(23,3).
	
	//check if aligned
	if vdif < 0.25 { set suborbalign to true. }
	
	
	//if aligned then burn engines
	if suborbalign = true { 
		//reduce burn near end
		if pecomp < 10000 { set tset to (pecomp/10000)+0.1. }
		else { set tset to 1. }
	}
	
	//stop burn here
	if pecomp < 0 {
		set suborb to true.
		sas on.
		rcs off.
		unlock steering.
		unlock throttle. 
		set ship:control:pilotmainthrottle to 0.

		print "deorbit done" at(33,5).
	}
}

//dont go any furter with program until we are suborbital
wait until suborb = true.

//estimate landing coords based on traj data
PRINT round(ADDONS:TR:IMPACTPOS:LAT,2) at(23,5).
PRINT round(ADDONS:TR:IMPACTPOS:LNG,2) at(23,6).

//timewarp to 3 min before impact
set wttr to false.
set wtt to time:seconds + ADDONS:TR:TIMETILLIMPACT - 90.
print "warping to preburn" at(33,7).
print "   in " + round(wtt-time:seconds) + " sec" at(33,8).
until wttr = true { 
	if time:seconds > wtt { set wttr to true. }
	if kuniverse:timewarp:rate = 1 { kuniverse:timewarp:warpto(wtt). }
}

//execute pre-landing burn to kill horizonal velocity 
set hvelstop to false.
set preburalign to false.

//point at the horizon
lock vs to velocity:surface:normalized.
lock tarang to angleaxis(-90, vcrs(up:forevector,vs)) * up:forevector.
lock steering to tarang.
set tset to 0.
lock throttle to tset.
sas off.
rcs on.
print "locking to horizon" at(33,10).

//loop till burn is done
until hvelstop = true {

	//adjust the turn rate
	set vdif to vang(tarang, ship:facing:vector).
	set mst to (vdif*0.1)+4.
	set steeringmanager:maxstoppingtime to mst.

	//print status
	print round(vdif,0)+"   " at(23,1).
	print round(mst,0)+"   " at(23,2).
	print round(ship:groundspeed,0)+"   " at(23,7).
	
	//check if aligned
	if vdif < 0.25 AND preburalign = false { 
		set preburalign to true. 
		print "performing pre-burn" at(33,11).
	}
	
	//if aligned then burn engines
	if preburalign = true { 
		//reduce burn near end
		if ship:groundspeed < 25 { set tset to (ship:groundspeed/25)+0.1. }
		else { set tset to 1. }
	}

	//then burn until groundspeed is < 1
	if ship:groundspeed < 0.25 {
		set tset to 0.
		set hvelstop to true.
	}
}

//dont go to final burn yet
wait until hvelstop = true.

//estimate landing coords based on traj data
PRINT round(ADDONS:TR:IMPACTPOS:LAT,2) at(23,5).
PRINT round(ADDONS:TR:IMPACTPOS:LNG,2) at(23,6).
set navmode to "surface".

//start final burn 
set hsalign to false.
set hsdone to false. 
set hsburning to false.
print "ready final burn" at (33,13).
lock steering to srfretrograde.

until hsdone {
	//use ship:bounds:bottomaltradar to get dist above ground
	set trueradar to ship:bounds:bottomaltradar.
	// Gravity (m/s^2)
	set g to constant:g * body:mass / body:radius^2.	
	// Maximum deceleration possible (m/s^2)	
	set maxdecel to ((ship:availablethrust*0.75) / ship:mass) - g.	
	// The distance the burn will require
	set stopdist to (ship:verticalspeed^2 / (2 * maxdecel)).
	// Throttle required for perfect hoverslam	
	set idealthrottle to stopdist/trueradar.			
	// Time until impact, used for landing gear
	set impacttime to trueradar/abs(ship:verticalspeed).
	// est time till burn should start
	set ttb to (trueradar-stopDist)/abs(ship:verticalspeed).

	//adjust the maxstoptime on the fly relative to how far the steering needs to travel
	set vdif to vang(srfretrograde:vector, ship:facing:vector).
	set mst to (vdif*0.1)+4.
	set steeringmanager:maxstoppingtime to mst.

	print round(vdif,0)+"   " at(23,1).
	print round(mst,0)+"   " at(23,2).
	print round(ship:groundspeed,1)+"   " at(23,7).
	print round(trueradar,1)+"   " at(23,9).
	print round(ship:verticalspeed,1)+"   " at(23,10).
	print round(g,4)+"   " at(23,11).
	print round(maxdecel,0)+"   " at(23,12).
	print round(stopdist,1)+"   " at(23,13).
	print round(idealthrottle*100,0)+"   " at(23,14).
	print round(impacttime,2)+"   " at(23,15).
	print round(ttb,2)+"   " at(23,16).
	
	//check if aligned for burn
	if vdif < 0.25 AND ttb > 10 { 
		set hsalign to true. 
		rcs off.
		sas on.
		unlock steering.
	}
	
	//physics warp accelerate to landing burn
	if ttb > 10 AND hsalign = true {
		if kuniverse:timewarp:rate = 1 { 
			SET WARPMODE TO "PHYSICS".
			SET WARP TO 3.
		}
	}
	else {
		SET WARP TO 0.
		rcs on.
		sas off.
		lock steering to srfretrograde.
	}
	//start the burn
	if trueradar < stopDist AND hsburning = false {
		print "performing burn" at(33,14).
		lock throttle to idealthrottle.
		set hsburning to true.
	}
	
	//check if burn is done
	if ship:verticalspeed > -0.01 {
		print "burn finished" at(33,15).
		lock throttle to 0.
		set hsdone to true.
	}
	
}

//wait for the burn to finish
WAIT UNTIL hsdone.
print "stabalizing..." at(33,17).
rcs on.
sas off.

//wait for the ship to stabalize and settle
wait 10.

//end program
print "steering unlocked" at(33,18).
print "throttle unlocked" at(33,19).
print "program terminated" at(33,20).
set ship:control:pilotmainthrottle to 0.
rcs off.
sas on.
