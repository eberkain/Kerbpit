// MFD Utility - Program List
// by Jonathan Medders  'EberKain'
//
//
// 


//load libraries
run lib_mfd.
run lib_formating.
run lib_navigation.

//collect passed params
parameter mfdid, mfdtop.

//adjust print offset for the control bar
set poff to 0.
if mfdtop = true { set poff to 2. }

//print the button labels at top or bottom
if mfdtop = true { 
	print "  FC-TRAN│ FC-MAXQ│ THR-OVR│CTRL-OVR│   F5   │   F6    " at(0,0).
	print "─────────┴────────┴────────┴────────┴────────┴─────────" at(0,1). }
else {
	print "─────────┬────────┬────────┼────────┬────────┬─────────" at(0,23).
	print "  FC-TRAN│ FC-MAXQ│ THR-OVR│CTRL-OVR│   F5   │   F6   " at(0,24). }

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


run lib_mfd.

clearscreen.
//     ----=----=----=----=----=xxxxx----=----=----=----=----=
print "  AUTOPILOT PROGRAMS                                   " at(0,0).
print "A1 - Launch to Orbit                                   "	at(0,1).
print "A2 - Execute Next Node                                 " at(0,2).
print "A3 - Perform Landing                                   "	at(0,3).
print "A4 - Aircraft Autopilot                                "	at(0,4).
print " " at (0,5).
print "B1 - Situation Status " at (0,6).
print "B2 - Vessel Status " at (0,7).
print "B3 - Navigation Control " at (0,8).
print " " at (0,9).
print "C1 - Program List " at (0,10).
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

print "─────────┬────────┬────────┬────────┬────────┬─────────" at (0,23).
print "    F1   │   F2   │   F3   │   F4   │   F5   │   F6   " at (0,24).

//to track the time and throttle the script execution
set looptime to time:seconds.
set done to false.
set animstep to 0.

until done = true {
	//update the info 5 times per sec
	if time:seconds > looptime {
		set looptime to time:seconds + 0.2.
		
		//print an animated icon to show the script is running
		set animstep to mfd_animicon(0,0,animstep).

	
	
	}	
}
