// MFD STATUS - Orbit Information
// by Jonathan Medders  'EberKain'
//
// The general idea here is to make a program that can display the current 
// state of the vessel orbit, etc...

//setup the screen info fields
clearscreen.
//     ----=----=----=----=----=xxxxx----=----=----=----=----=
print "    F1   │   F2   │   F3   │   F4   │   F5   │   F6   " at (0,0).
print "—————————┴————————┴————————┼————————┴————————┴————————" at (0,1).
print "  SITUATION                │  FLIGHT       " at (0,2).
print "             :             │AGL Alt.     : " at (0,3).
print "Velocity     :             │ASL Alt.     : " at (0,4).
print "xxx          :             │Airspeed     : " at (0,5).
print "xxx          :             │Vert. Speed  : " at (0,6).
print "xxx          :             │Ground Speed : " at (0,7).
print "xxx          :             │Air Press.   : " at (0,8).
print "xxx          :             │Dyn. Press.  : " at (0,9).
print "xxx          :             │xxx          : " at (0,10).
print "xxx          :             │xxx          : " at (0,11).
print "———————————————————————————┤xxx          : " at (0,12).
print "  ORBIT                    │xxx          : " at (0,13).
print "Apoapsis     :             │xxx          : " at (0,14).
print "Periapsis    :             │xxx          : " at (0,15).
print "Time to Ap   :             │xxx          : " at (0,16).
print "Time to Pe   :             │xxx          : " at (0,17).
print "Inclination  :             │xxx          : " at (0,18).
print "Eccentricity :             │xxx          : " at (0,19).
print "xxx          :             │xxx          : " at (0,20).
print "xxx          :             │xxx          : " at (0,21).
print "xxx          :             │xxx          : " at (0,22).
print "xxx          :             │xxx          : " at (0,23).
print "xxx          :             │xxx          : " at (0,24).


//to track the time and throttle the script execution
set looptime to time:seconds.
set done to false.
set animstep to 0.

until done = true {
	
	//update the info 5 times per sec
	if time:seconds > looptime {
		set looptime to time:seconds + 0.2.
		
		//print a character to animate to indicate script is running and healty
		if animstep = 0 { print "/" at (0,2). }
		if animstep = 1 OR animstep = 3 { print "|" at (0,2). }
		if animstep = 2 { print "\" at (0,2). }
		set animstep to animstep + 1.
		if animstep = 4 { set animstep to 0. }
	
		//print left side values
		
		print (round(ship:velocity:orbit:mag,2) + " m/s"):padright(10) at (15,4).


		print (round(ship:apoapsis/1000,2) + " km"):padright(10) at (15,14).
		print (round(ship:periapsis/1000,2) + " km"):padright(10) at (15,15).
		print time(eta:apoapsis):clock at (15,16).
		print time(eta:periapsis):clock at (15,17).
	
		//print right side values
		print (round(alt:radar/1000,max(4-(round(alt:radar/1000,0):tostring():length),0)) + " km"):padright(10) at (43,3).
		print (round(ship:altitude/1000,2) + " km"):padright(10) at (43,4).
		print (round(ship:airspeed,2) + " m/s"):padright(10) at (43,5).
		print (round(ship:verticalspeed,2) + " m/s"):padright(10) at (43,6).
		print (round(ship:groundspeed,2) + " m/s"):padright(10) at (43,7).
		print (round(ship:body:atm:altitudepressure(ship:altitude),2) + " atm"):padright(10) at (43,8).
		print (round(ship:dynamicpressure*constant:ATMtokPa,2) + " kPa"):padright(10) at (43,9).
	
	}
	
	wait 0.001.
	
}