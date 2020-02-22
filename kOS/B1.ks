// MFD STATUS - Situation Information
// by Jonathan Medders  'EberKain'
//
// The general idea here is to make a program that can display the current 
// state of the vessel orbit, etc...


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
	print "    F1   │   F2   │   F3   │   F4   │   F5   │   F6   " at (0,24). }

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

//     ----=----=----=----=----=xxxxx----=----=----=----=----=
print "    F1   │   F2   │   F3   │   F4   │   F5   │   F6   " at (0,0).
print "─────────┴────────┴────────┼────────┴────────┴────────" at (0,1).
print "  SITUATION                │  FLIGHT                  " at (0,2).
print "Altitude     :             │AGL Alt.     :            " at (0,3).
print "Velocity     :             │             :            " at (0,4).
print "Node ETA     :             │Airspeed     :            " at (0,5).
print "             :             │Vert. Speed  :            " at (0,6).
print "Stage Δv     :             │Ground Speed :            " at (0,7).
print "xxx          :             │Heading      :            " at (0,8).
print "xxx          :             │             :            " at (0,9).
print "Latitude     :             │xxx          :            " at (0,10).
print "Longitude    :             │xxx          :            " at (0,11).
print "───────────────────────────┤xxx          :            " at (0,12).
print "  ORBIT                    │xxx          :            " at (0,13).
print "Apoapsis     :             │xxx          :            " at (0,14).
print "Periapsis    :             │xxx          :            " at (0,15).
print "Time to Ap   :             │xxx          :            " at (0,16).
print "Time to Pe   :             │Air Press.   :            " at (0,17).
print "Inclination  :             │Dyn. Press.  :            " at (0,18).
print "Eccentricity :             │xxx          :            " at (0,19).
print "xxx          :             │xxx          :            " at (0,20).
print "xxx          :             │xxx          :            " at (0,21).
print "xxx          :             │xxx          :            " at (0,22).
print "xxx          :             │xxx          :            " at (0,23).
print "xxx          :             │xxx          :            " at (0,24).


//to track the time and throttle the script execution
set looptime to time:seconds.
set done to false.
set animstep to 0.

until done = true {
	
	//update the info 5 times per sec
	if time:seconds > looptime {
		set looptime to time:seconds + 0.1.
		
		//print an animated icon to show the script is running
		set animstep to mfd_animicon(0,2,animstep).
	
		//print left side values
		print (si_formating(ship:altitude,"m")):padright(10) at (15,3).
		print (si_formating(ship:velocity:orbit:mag,"m/s")):padright(10) at (15,4).

	
		print (dms_formating(ship:geoposition:lat,"lat")):padright(10) at (16,10).
		print (dms_formating(ship:geoposition:lng,"lng")):padright(10) at (16,11).


		print (si_formating(ship:apoapsis,"m")):padright(10) at (15,14).
		print (si_formating(ship:periapsis,"m")):padright(10) at (15,15).
		print (time_formating(eta:apoapsis,5)):padright(10) at (15,16).
		print (time_formating(eta:periapsis,5)):padright(10) at (15,17).
		print (padding(ship:orbit:inclination,1,2)+" °"):padright(10) at (15,18).
		print (padding(ship:orbit:eccentricity,1,4)):padright(10) at (15,19).
	
		//print right side values
		print (si_formating(alt:radar,"m")):padright(10) at (43,3).
		print (si_formating(ship:airspeed,"m/s")):padright(10) at (43,5).
		print (si_formating(ship:verticalspeed,"m/s")):padright(10) at (43,6).
		print (si_formating(ship:groundspeed,"m/s")):padright(10) at (43,7).
		print (padding(mod(360 - latlng(90,0):bearing,360),1,2)+" °"):padright(10) at (44,8).

		
		
		print (padding(ship:body:atm:altitudepressure(ship:altitude),1,2)+" atm"):padright(10) at (44,17).
		print (padding(ship:dynamicpressure*constant:ATMtokPa,1,2)+" kPa"):padright(10) at (44,18).
	
	}
	
	wait 0.001.
	
}