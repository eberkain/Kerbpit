// MFD Utility - Program List
// by Jonathan Medders  'EberKain'
//
// very simple program that displays all the programs 
// that can be run using the terminal input codes
// 


//load libraries
run lib_mfd.
run lib_formating.
run lib_navigation.

//collect passed params
parameter mfdid, mfdtop.

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
on AG230 { if mfdid = 1 { set btn4 to true. } preserve. }
on AG231 { if mfdid = 1 { set btn5 to true. } preserve. }
on AG232 { if mfdid = 1 { set btn6 to true. } preserve. }
on AG233 { if mfdid = 2 { set btn1 to true. } preserve. }
on AG234 { if mfdid = 2 { set btn2 to true. } preserve. }
on AG235 { if mfdid = 2 { set btn3 to true. } preserve. }
on AG236 { if mfdid = 2 { set btn4 to true. } preserve. }
on AG237 { if mfdid = 2 { set btn5 to true. } preserve. }
on AG238 { if mfdid = 2 { set btn6 to true. } preserve. }
on AG239 { if mfdid = 3 { set btn1 to true. } preserve. }
on AG240 { if mfdid = 3 { set btn2 to true. } preserve. }
on AG241 { if mfdid = 3 { set btn3 to true. } preserve. }
on AG242 { if mfdid = 3 { set btn4 to true. } preserve. }
on AG243 { if mfdid = 3 { set btn5 to true. } preserve. }
on AG244 { if mfdid = 3 { set btn6 to true. } preserve. }
on AG245 { if mfdid = 4 { set btn1 to true. } preserve. }
on AG246 { if mfdid = 4 { set btn2 to true. } preserve. }
on AG247 { if mfdid = 4 { set btn3 to true. } preserve. }
on AG248 { if mfdid = 4 { set btn4 to true. } preserve. }
on AG249 { if mfdid = 4 { set btn5 to true. } preserve. }
on AG250 { if mfdid = 4 { set btn6 to true. } preserve. }


run lib_mfd.

clearscreen.
//     ----=----=----=----=----=xxxxx----=----=----=----=----=
print "  MULTIFUNCTION DISPLAY PROGRAMS                       ".
print "═══════════════════════════════════════════════════════".
print "A1 - Launch to Orbit                                   ".
print "A2 - Execute Next Node                                 ".
print "A3 - Perform Landing                                   ".
print "A4 - Aircraft Autopilot                                ".
print "A5 - Docking Autopilot                                 ".
print "                                                       ".
print "B1 - Situation Status                                  ".
print "B2 - Vessel Status                                     ".
print "B3 - Navigation Control                                ".
print "                                                       ".
print "C1 - Program List                                      ".
print "C2 - Copy Programs                                     ".
print "                                                       ".
print "                                                       ".
print "                                                       ".
print "                                                       ".
print "                                                       ".
print "                                                       ".
print "                                                       ".
print "                                                       ".
