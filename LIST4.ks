
clearscreen.

//     ----=----=----=----=----=xxxxx----=----=----=----=----=
print "    NAVIGATION PROGRAMS" at(0,0).
print "> A1 - Circulize at AP" at(0,1).
print "  A2 - Circulize at PE" at(0,2).

print "—————————┬————————┬————————┬————————┬————————┬—————————" at (0,23).
print "    F1   │   F2   │   F3   │   F4   │   F5   │   F6   " at (0,24).

//track cursor location
set cur_min to 1.
set cur_max to 2.
set cur to 1.

//react to mfd buttons
when AG250 = true {
	//remove the cursor character
	//move the cursor
	//print a new character
}

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
	
	wait 0.001.
}
