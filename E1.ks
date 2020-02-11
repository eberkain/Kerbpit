// MFD STATUS - Orbit Information
// by Jonathan Medders  'EberKain'
//
// The general idea here is to make a program that can display the current 
// state of the vessel orbit, etc...

//setup the screen info fields
clearscreen.
//     ----=----=----=----=----=xxxxx----=----=----=----=----=
print "    F1   │   F2   │   F3   │   F4   │   F5   │   F6   " at (0,0).
print "—————————┴————————┴————————┴————————┴————————┴————————" at (0,1).
print "  SITUATION                   STATUS       " at (0,2).
print "Altitude     :              Air Pressure : " at (0,3).
print "Apoapsis     :              Dyn. Press.  : " at (0,4).
print "Periapsis    :              xxx          : " at (0,5).
print "Time to Ap   :              xxx          : " at (0,6).
print "Time to Pe   :              xxx          : " at (0,7).
print "xxx          :              xxx          : " at (0,8).
print "xxx          :              xxx          : " at (0,9).
print "xxx          :              xxx          : " at (0,10).
print "xxx          :              xxx          : " at (0,11).
print "xxx          :              xxx          : " at (0,12).
print "xxx          :              xxx          : " at (0,13).
print "xxx          :              xxx          : " at (0,14).
print "xxx          :              xxx          : " at (0,15).
print "xxx          :              xxx          : " at (0,16).
print "xxx          :              xxx          : " at (0,17).
print "xxx          :              xxx          : " at (0,18).
print "xxx          :              xxx          : " at (0,19).
print "xxx          :              xxx          : " at (0,20).
print "xxx          :              xxx          : " at (0,21).
print "xxx          :              xxx          : " at (0,22).
print "xxx          :              xxx          : " at (0,23).
print "xxx          :              xxx          : " at (0,24).


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
		print round(ship:altitude/1000,2) + " km    " at (15,3).
		print round(ship:apoapsis/1000,2) + " km    " at (15,4).
		print round(ship:periapsis/1000,2) at (15,5).
		print time(eta:apoapsis):clock at (15,6).
		print time(eta:periapsis):clock at (15,7).
	
		//print right side values
		print round(ship:body:atm:altitudepressure(ship:altitude),2) + " atm   " at (43,3).
		print round(ship:dynamicpressure*constant:ATMtokPa,2) + " kPa   " at (43,4).
	
	}
}