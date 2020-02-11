// MFD STATUS - VESSEL INFORATION
// by Jonathan Medders  'EberKain'
//
// The general idea here is to make a program that can display the current 
// state of the vessel orbit, etc...

//setup the screen info fields
clearscreen.
//     ----=----=----=----=----=xxxxx----=----=----=----=----=
print "    F1   │   F2   │   F3   │   F4   │   F5   │   F6   " at (0,0).
print "—————————┴————————┴————————┴————————┴————————┴————————" at (0,1).
print "  VESSEL                        " at (0,2).
print "Electric   :              " at (0,3).
print "Liq. Fuel  :              " at (0,4).
print "Oxidizer   :              " at (0,5).
print "Monoprop   :              " at (0,6).
print "Oxygen     :              " at (0,7).
print "Hydrogen   :              " at (0,8).
print "Food       :              " at (0,9).
print "Water      :              " at (0,10).
print "xxx        :              " at (0,11).
print "xxx        :              " at (0,12).
print "xxx        :              " at (0,13).
print "xxx        :              " at (0,14).
print "xxx        :              " at (0,15).
print "xxx        :              " at (0,16).
print "xxx        :              " at (0,17).
print "xxx        :              " at (0,18).
print "xxx        :              " at (0,19).
print "xxx        :              " at (0,20).
print "xxx        :              " at (0,21).
print "xxx        :              " at (0,22).
print "xxx        :              " at (0,23).
print "xxx        :              " at (0,24).

//to track the time and throttle the script execution
set looptime to time:seconds.
set done to false.
set animstep to 0.

//flag to see if we should recalculate the capacity of each resource
set calcap to true.  

set cap_ec to 0.

until done = true {
	
	//update capacity if needed
	if calcap = true {
		set calcap to false.
		
		set reslist to ship:resources.
		for mres in reslist {
			if mres:name = "ElectricCharge" {
				print mres:amount + " / " + mres:capacity at (14,5).
			}
		}
	}
	
	//update the info 5 times per sec
	if time:seconds > looptime {
		set looptime to time:seconds + 0.2.
		
		//print a character to animate to indicate script is running and healty
		if animstep = 0 { print "/" at (0,0). }
		if animstep = 1 OR animstep = 3 { print "|" at (0,0). }
		if animstep = 2 { print "\" at (0,0). }
		set animstep to animstep + 1.
		if animstep = 4 { set animstep to 0. }
	
		//print left side values
		print round(ship:electriccharge,1) at (14,3).
	
		
	}
}