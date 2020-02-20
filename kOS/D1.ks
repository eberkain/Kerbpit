// MFD STATUS - VESSEL INFORATION
// by Jonathan Medders  'EberKain'
//
// The general idea here is to make a program that can display the current 
// state of the vessel orbit, etc...

local function print_page {
	parameter pageid. 

		//     ----=----=----=----=----=xxxxx----=----=----=----=----=
		print " RES-ALL │ RES-ST │ CAMERA │   UP   │   DN   │  SET    " at (0,0).
		print "─────────┴────────┴────────┴────────┴────────┴─────────" at (0,1).

	if pageid = 1 { 
		//     ----=----=----=----=----=xxxxx----=----=----=----=----=
		print "  TOTAL RESOURCES                                      " at (0,2).
		print "Electric   : 0.000 kg    084d 012h    ░░░░░░░░░░░░░░░  " at (0,3).
		print "Liq. Fuel  :                                           " at (0,4).
		print "Oxidizer   :                                           " at (0,5).
		print "Monoprop   :                                           " at (0,6).
		print "───────────────────────────────────────────────────────" at (0,7).
		print "Ablator    :                                           " at (0,8).
		print "Shielding  :                                           " at (0,9).
		print "───────────────────────────────────────────────────────" at (0,10).
		print "Oxygen     :                                           " at (0,11).
		print "Nitrogen   :                                           " at (0,12).
		print "Food       :                                           " at (0,13).
		print "Water      :                                           " at (0,14).
		print "───────────────────────────────────────────────────────" at (0,15).
		print "Hydrogen   :                                           " at (0,16).
		print "WasteWater :                                           " at (0,17).
		print "Waste      :                                           " at (0,18).
		print "CO2        :                                           " at (0,19).
		print "xxx        :                                           " at (0,20).
		print "xxx        :                                           " at (0,21).
		print "xxx        :                                           " at (0,22).
		print "xxx        :                                           " at (0,23).
		print "xxx        :                                          " at (0,24).
	}

	if pageid = 2 { 
		//     ----=----=----=----=----=xxxxx----=----=----=----=----=
		print "  STAGE RESOURCES                                      " at (0,2).
		print "Electric   : 0.000 kg    084d 012h    ░░░░░░░░░░░░░░░  " at (0,3).
		print "Liq. Fuel  :                                           " at (0,4).
		print "Oxidizer   :                                           " at (0,5).
		print "Monoprop   :                                           " at (0,6).
		print "───────────────────────────────────────────────────────" at (0,7).
		print "Ablator    :                                           " at (0,8).
		print "Shielding  :                                           " at (0,9).
		print "───────────────────────────────────────────────────────" at (0,10).
		print "Oxygen     :                                           " at (0,11).
		print "Nitrogen   :                                           " at (0,12).
		print "Food       :                                           " at (0,13).
		print "Water      :                                           " at (0,14).
		print "───────────────────────────────────────────────────────" at (0,15).
		print "Hydrogen   :                                           " at (0,16).
		print "WasteWater :                                           " at (0,17).
		print "Waste      :                                           " at (0,18).
		print "CO2        :                                           " at (0,19).
		print "xxx        :                                           " at (0,20).
		print "xxx        :                                           " at (0,21).
		print "xxx        :                                           " at (0,22).
		print "xxx        :                                           " at (0,23).
		print "xxx        :                                          " at (0,24).
	}


	if pageid = 3 { 
		//     ----=----=----=----=----=xxxxx----=----=----=----=----=
		print "                    CAMERA SELECTOR                    " at (0,2).
		print "════╤════════════╤═════════════════════════════════════" at (0,3).
		print "    │            │                                     " at (0,4).
		print "    │            │                                     " at (0,5).
		print "    │            │                                     " at (0,6).
		print "    │            │                                     " at (0,7).
		print "    │            │                                     " at (0,8).
		print "    │            │                                     " at (0,9).
		print "    │            │                                     " at (0,10).
		print "    │            │                                     " at (0,11).
		print "    │            │                                     " at (0,12).
		print "    │            │                                     " at (0,13).
		print "    │            │                                     " at (0,14).
		print "    │            │                                     " at (0,15).
		print "    │            │                                     " at (0,16).
		print "    │            │                                     " at (0,17).
		print "    │            │                                     " at (0,18).
		print "    │            │                                     " at (0,19).
		print "    │            │                                     " at (0,20).
		print "    │            │                                     " at (0,21).
		print "    │            │                                     " at (0,22).
		print "    │            │                                     " at (0,23).
		print "    │            │   " at (0,24).
	}

}

//load libs
run lib_mfd.
run lib_formating.

//setup the screen info fields
clearscreen.

//setup paging system 
set curr_page to 1.
print_page(curr_page).

//to track the time and throttle the script execution
set looptime to time:seconds.
set done to false.
set animstep to 0.

//create a list of res we want to show and what line they are on
set reslex to lexicon(
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

//create a lex to save eta info
set etalex to lexicon().

//to hold the data from the previous check 
set prevlex to lexicon().
set prevtime to time:seconds.
set prevdelay to 1.

//monitor the action groups for mfd button presses
set btn1 to false. 
set btn2 to false. 
set btn3 to false. 
set btn4 to false. 
set btn5 to false. 
set btn6 to false. 

//respond to button presses
on AG233 { 	set btn1 to true. preserve. }
on AG234 { 	set btn2 to true. preserve.  }
on AG235 { 	set btn3 to true. preserve.  }
on AG236 { 	set btn4 to true. preserve.  }
on AG237 { 	set btn5 to true. preserve.  }
on AG238 { 	set btn6 to true. preserve.  }

//control values for camera list 
set camlistdone to false. 
set clist to list().  //a list to save camera parts in
set camsel to 1.
set actcam to 0.	

//define the resource structure
set reslist to list().

until done = true {
	
	if btn1 = true {
		set btn1 to false.
		set curr_page to 1.
		print_page(curr_page).
	}
	if btn2 = true {
		set btn2 to false.
		set curr_page to 2.
		print_page(curr_page).
	}
	if btn3 = true {
		set btn3 to false.
		set curr_page to 3.
		set camlistdone to false. 
		print_page(curr_page).
	}

	set printres to false. 
	
	//run the main loop every x sec
	if time:seconds > looptime {
		set looptime to time:seconds + 0.25.

		//print an animated icon to show the script is running
		set animstep to mfd_animicon(0,2,animstep).

		//print the overall resources page
		if curr_page = 1 { 
			set reslist to ship:resources.
			set printres to true. 
		}
		if curr_page = 2 { 
			set reslist to stage:resources.
			set printres to true. 
		}

		//print resources if flagged
		if printres = true {
			//loop through all resrouces
			for mres in reslist {
			
				// if this is one we want to display
				if reslex:haskey(mres:name) { 
				
					//print the percentage first
					//print round(mres:amount/mres:capacity*100,0):tostring():padleft(3)+"%" at (13,lex[mres:name]).

					//print the mass
					print si_formating(mres:amount*mres:density*100000,"g") at(12,reslex[mres:name]).
					//print round(mres:amount,0) + "/" + round(mres:capacity,0) at (20,lex[mres:name]).
					
					//print an eta till depleted
					if etalex:haskey(mres:name) {
						if etalex[mres:name] = 0 { 
							print " hold":padright(14) at (24,reslex[mres:name]).
						}
						else if etalex[mres:name] < 0 {
							print time_formating(-(etalex[mres:name]-time:seconds),5):padright(13)+"⮜" at (24,reslex[mres:name]).
						}
						else {
							//etalex containes an estimated time code for when the res depletes 
							print time_formating((etalex[mres:name]-time:seconds),5):padright(13)+"⮞" at (24,reslex[mres:name]).
						}
					}	
					else {
						print " calculating":padright(13) at (24,reslex[mres:name]).
					}
					
					if mres:capacity > 0 {
						//print a progress bar for pct
						print mfd_progress(15,mres:amount/mres:capacity) at(38,reslex[mres:name]).
					}
					else { 
						print "░░░░░░░░░░░░░░░" at(38,reslex[mres:name]).
					}
				}
			}
		}
	}

	if curr_page = 1 or curr_page = 2 {
		//every x seconds check all resources and update eta based on diff from last time
		if time:seconds > prevtime + prevdelay { 
			set localtime to time:seconds.
			set deltatime to localtime - prevtime.
			set prevtime to localtime.
			
			
			//loop through all resources
			for mres in reslist {
				//if there is a prev value to compare to then update the eta
				if prevlex:haskey(mres:name) {
					//how much has it changed since last check
					set diff to prevlex[mres:name]-mres:amount.
					
					//extimate how how long till resource is depleted at that rate
					if diff = 0 { //if its negative then the resource has gone up 
						set etalex[mres:name] to 0. //special flag to indicate infinity
					}
					//if resource is filling up 
					else if diff < 0 {
						set filltime to (mres:capacity-mres:amount)/(diff/deltatime).
						set etalex[mres:name] to -time:seconds-filltime.
					}
					//if resource is depleting
					else {
						//calc the time in seconds till the resource is gone at current rate
						set deptime to mres:amount/(diff/deltatime). //<< pretty sure this is the problem
		
						//set the etatime as a global time value
						set etalex[mres:name] to time:seconds+deptime. 
					}
				}
				
				//update the prev value for next time
				set prevlex[mres:name] to mres:amount.
			}
		}
	}
	
	//print the cameras page
	if curr_page = 3 {
	
		//if list has not been printed yet then 
		if camlistdone = false {
			
			//create a fresh list to work with 
			set clist to list().
			
			//get all the parts
			set plist to ship:parts.

			//check if the part has the camera module 
			for prt in plist {
				if prt:hasmodule("MuMechModuleHullCameraZoom") {
					//save the part to the list
					clist:add(prt).
					print clist:length at (52,2).
				}
				
			}
			
			//list one on each line 
			set camline to 4.
			for cam in clist {
				print cam:tag:padright(10) at (5,camline).
				print cam:title:padright(20) at (18,camline). 
				set camline to camline + 1.
			}
			
			set camlistdone to true.
		}
		
		//move the selector up
		if btn4 = true {
			set btn4 to false.

			//check if its safe to decrement
			if camsel > 1 {
				//remove old pointer
				print " " at(2, 3+camsel).
				//increment counter
				set camsel to camsel - 1.
			}
		}
		//move the selector down
		if btn5 = true {
			set btn5 to false.
			//check if its safe to increment
			if camsel < clist:length {
				//remove old pointer
				print " " at(2, 3+camsel).
				//increment counter
				set camsel to camsel + 1.
			}
		}
		//select
		if btn6 = true {
			set btn6 to false.
			//remove the prev active camera marker and deactivate camera
			if actcam > 0 {
				print " " at(0,3+actcam).
				set cmod to clist[actcam-1]:getmodule("MuMechModuleHullCameraZoom").
				if cmod:hasevent("Deactivate Camera") { cmod:doevent("Deactivate Camera"). }
				if cmod:hasevent("deactivate camera") { cmod:doevent("deactivate camera"). }
			}
			
			//activate the camera
			set actcam to camsel. 

			//find the camera module and actiate the event
			set cmod to clist[camsel-1]:getmodule("MuMechModuleHullCameraZoom").
			if cmod:hasevent("Activate Camera") { cmod:doevent("Activate Camera"). }
			if cmod:hasevent("activate camera") { cmod:doevent("activate camera"). }
		}

		
		//show an arrow for the current selection
		print "⮞" at(2, 3+camsel).
		
		//show a marker for the currently active camera 
		if actcam > 0 {
			print "▐" at(0,3+actcam).
		}
	
		//

	}
	
	wait 0.001.

}