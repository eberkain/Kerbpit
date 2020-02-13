// MFD STATUS - VESSEL INFORATION
// by Jonathan Medders  'EberKain'
//
// The general idea here is to make a program that can display the current 
// state of the vessel orbit, etc...

//load libs
run lib_mfd.
run lib_formating.

//setup the screen info fields
clearscreen.

//     ----=----=----=----=----=xxxxx----=----=----=----=----=
print "    F1   │   F2   │   F3   │   F4   │   F5   │   F6   " at (0,0).
print "—————————┴————————┴————————┴————————┴————————┴————————" at (0,1).
print "  RESOURCES               " at (0,2).
print "Electric   :   0%   0/0               ░░░░░░░░░░░░░░░ " at (0,3).
print "Liq. Fuel  :   0%   0/0               ░░░░░░░░░░░░░░░ " at (0,4).
print "Oxidizer   :   0%   0/0               ░░░░░░░░░░░░░░░ " at (0,5).
print "Monoprop   :   0%   0/0               ░░░░░░░░░░░░░░░ " at (0,6).
print "——————————————————————————————————————————————————————" at (0,7).
print "Ablator    :   0%   0/0               ░░░░░░░░░░░░░░░ " at (0,8).
print "Shielding  :   0%   0/0               ░░░░░░░░░░░░░░░ " at (0,9).
print "——————————————————————————————————————————————————————" at (0,10).
print "Oxygen     :   0%   0/0               ░░░░░░░░░░░░░░░ " at (0,11).
print "Nitrogen   :   0%   0/0               ░░░░░░░░░░░░░░░ " at (0,12).
print "Food       :   0%   0/0               ░░░░░░░░░░░░░░░ " at (0,13).
print "Water      :   0%   0/0               ░░░░░░░░░░░░░░░ " at (0,14).
print "——————————————————————————————————————————————————————" at (0,15).
print "Hydrogen   :   0%   0/0               ░░░░░░░░░░░░░░░ " at (0,16).
print "WasteWater :   0%   0/0               ░░░░░░░░░░░░░░░ " at (0,17).
print "Waste      :   0%   0/0               ░░░░░░░░░░░░░░░ " at (0,18).
print "CO2        :   0%   0/0               ░░░░░░░░░░░░░░░ " at (0,19).
print "xxx        :   0%   0/0               ░░░░░░░░░░░░░░░ " at (0,20).
print "xxx        :   0%   0/0               ░░░░░░░░░░░░░░░ " at (0,21).
print "xxx        :   0%   0/0               ░░░░░░░░░░░░░░░ " at (0,22).
print "xxx        :   0%   0/0               ░░░░░░░░░░░░░░░ " at (0,23).
print "xxx        :   0%   0/0               ░░░░░░░░░░░░░░░" at (0,24).

//to track the time and throttle the script execution
set looptime to time:seconds.
set done to false.
set animstep to 0.

//create a list of res we want to show and what line they are on
set lex to lexicon(
	"ElectricCharge",3,
	"LiquidFuel",4,
	"Oxidizer",5,
	"MonoPropellant",6,
	"Ablator",8,
	"Shielding",9,
	"Oxygen",11,
	"Nitrogen",12,
	"Food",13,
	"Water",14,
	"Hydrogen",16,
	"WasteWater",17,
	"Waste",18,
	"CarbonDioxide",19 ).


until done = true {
	
	//update the info x times per sec
	if time:seconds > looptime {
		set looptime to time:seconds + 0.5.

		//print a character to animate to indicate script is running and healty
		if animstep = 0 { print "/" at (0,2). }
		if animstep = 1 OR animstep = 3 { print "|" at (0,2). }
		if animstep = 2 { print "\" at (0,2). }
		set animstep to animstep + 1.
		if animstep = 4 { set animstep to 0. }
	
		//get resources structure
		set reslist to ship:resources.

		//loop through all resrouces
		for mres in reslist {
		
			// if this is one we want to display
			if lex:haskey(mres:name) { 
			
				//print the percentage first
				print round(mres:amount/mres:capacity*100,0):tostring():padleft(3)+"%" at (13,lex[mres:name]).

				//print the mass
				print round(mres:amount,0) + "/" + round(mres:capacity,0) at (20,lex[mres:name]).
				
				//print an eta till depleted
				
				//print a progress bar for pct
				print mfd_progress(15,mres:amount/mres:capacity) at(38,lex[mres:name]).
			}
		}
		
	}
	
	wait 0.001.

}