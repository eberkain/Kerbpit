// 
//     AUTOPILOT PROGRAMS
//   A1 - Launch to Orbit
//
// 


clearscreen.
//     ----=----=----=----=----=xxxxx----=----=----=----=----=
print "  AUTOPILOT PROGRAMS                                   " at(0,0).
print "F1 - Launch to Orbit                                   "	at(0,1).
print "F2 - Execute Next Node                                 " at(0,2).
print "F3 - Perform Landing                                   "	at(0,3).
print "F4 - Aircraft Autopilot                                "	at(0,4).
print " " at (0,5).
print " " at (0,6).
print " " at (0,7).
print " " at (0,8).
print " " at (0,9).
print " " at (0,10).
print " " at (0,11).
print " " at (0,12).
print " " at (0,13).
print " " at (0,14).
print " " at (0,15).
print " " at (0,16).
print " " at (0,17).
print " " at (0,18).
print " " at (0,19).
print " " at (0,20).
print " " at (0,21).
print " " at (0,22).

print "—————————┬————————┬————————┬————————┬————————┬—————————" at (0,23).
print "    F1   │   F2   │   F3   │   F4   │   F5   │   F6   " at (0,24).

//to track the time and throttle the script execution
set looptime to time:seconds.
set done to false.
set animstep to 0.

until done = true {
	//update the info 5 times per sec
	if time:seconds > looptime {
		set looptime to time:seconds + 0.2.
		
		//print a character to animate to indicate script is running and healty
		if animstep = 0 { print "/" at (0,0). }
		if animstep = 1 OR animstep = 3 { print "|" at (0,0). }
		if animstep = 2 { print "\" at (0,0). }
		set animstep to animstep + 1.
		if animstep = 4 { set animstep to 0. }
	
	
	}	
}
