// MFD STATUS - VESSEL INFORATION
// by Jonathan Medders  'EberKain'
//
// The general idea here is to make a program that can display the current 
// state of the vessel resources, cameras, systems, etc...
//
// resource list iterator is dynamically created based on res on vessel 
// this is to be faster and more responsive


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

//print the background for each of the mdf pages
local function print_page {
	parameter pageid. 
	if pageid = 1 { 
		if mfdtop = true { 
			print "  STAGE  │ CAMERA │ SYSTEM │   F4   │   F5   │   F6    " at (0,0).
			print "─────────┴────────┴────────┴────────┴────────┴─────────" at (0,1). }
		else {
			print "─────────┬────────┬────────┼────────┬────────┬─────────" at (0,23).
			print "  STAGE  │ CAMERA │ SYSTEM │   F4   │   F5   │   F6    " at (0,24). }

		print "  TOTAL RESOURCES - MAIN MENU                          " at (0,0+poff).
		print "═══════════════════════════════════════════════════════" at (0,1+poff).
		print "           :                                           " at (0,2+poff).
		print "           :                                           " at (0,3+poff).
		print "           :                                           " at (0,4+poff).
		print "           :                                           " at (0,5+poff).
		print "           :                                           " at (0,6+poff).
		print "           :                                           " at (0,7+poff).
		print "           :                                           " at (0,8+poff).
		print "           :                                           " at (0,9+poff).
		print "           :                                           " at (0,10+poff).
		print "           :                                           " at (0,11+poff).
		print "           :                                           " at (0,12+poff).
		print "           :                                           " at (0,13+poff).
		print "           :                                           " at (0,14+poff).
		print "           :                                           " at (0,15+poff).
		print "           :                                           " at (0,16+poff).
		print "           :                                           " at (0,17+poff).
		print "           :                                           " at (0,18+poff).
		print "           :                                           " at (0,19+poff).
		print "           :                                           " at (0,20+poff).
		print "           :                                           " at (0,21+poff).
		print "           :                                          " at  (0,22+poff).
	}

	if pageid = 2 { 
		if mfdtop = true { 
			print "   BACK  │   F2   │   F3   │  F4    │   F5   │   F6    " at (0,0).
			print "─────────┴────────┴────────┴────────┴────────┴─────────" at (0,1). }
		else {
			print "─────────┬────────┬────────┼────────┬────────┬─────────" at (0,23).
			print "   BACK  │   F2   │   F3   │  F4    │   F5   │   F6    " at (0,24). }

		print "  STAGE RESOURCES                                      " at (0,0+poff).
		print "═══════════════════════════════════════════════════════" at (0,1+poff).
		print "           :                                           " at (0,2+poff).
		print "           :                                           " at (0,3+poff).
		print "           :                                           " at (0,4+poff).
		print "           :                                           " at (0,5+poff).
		print "           :                                           " at (0,6+poff).
		print "           :                                           " at (0,7+poff).
		print "           :                                           " at (0,8+poff).
		print "           :                                           " at (0,9+poff).
		print "           :                                           " at (0,10+poff).
		print "           :                                           " at (0,11+poff).
		print "           :                                           " at (0,12+poff).
		print "           :                                           " at (0,13+poff).
		print "           :                                           " at (0,14+poff).
		print "           :                                           " at (0,15+poff).
		print "           :                                           " at (0,16+poff).
		print "           :                                           " at (0,17+poff).
		print "           :                                           " at (0,18+poff).
		print "           :                                           " at (0,19+poff).
		print "           :                                           " at (0,20+poff).
		print "           :                                           " at (0,21+poff).
		print "           :                                          " at  (0,22+poff).
	}

	if pageid = 3 { 
		if mfdtop = true { 
			print "   BACK  │   F2   │   F3   │   UP   │  DOWN  │  SET    " at (0,0).
			print "─────────┴────────┴────────┴────────┴────────┴─────────" at (0,1). }
		else {
			print "─────────┬────────┬────────┼────────┬────────┬─────────" at (0,23).
			print "   BACK  │   F2   │   F3   │   UP   │  DOWN  │  SET    " at (0,24). }

		print "  CAMERA SELECTOR                                      " at (0,0+poff).
		print "════╤════════════╤═════════════════════════════════════" at (0,1+poff).
		print "    │            │                                     " at (0,2+poff).
		print "    │            │                                     " at (0,3+poff).
		print "    │            │                                     " at (0,4+poff).
		print "    │            │                                     " at (0,5+poff).
		print "    │            │                                     " at (0,6+poff).
		print "    │            │                                     " at (0,7+poff).
		print "    │            │                                     " at (0,8+poff).
		print "    │            │                                     " at (0,9+poff).
		print "    │            │                                     " at (0,10+poff).
		print "    │            │                                     " at (0,11+poff).
		print "    │            │                                     " at (0,12+poff).
		print "    │            │                                     " at (0,13+poff).
		print "    │            │                                     " at (0,14+poff).
		print "    │            │                                     " at (0,15+poff).
		print "    │            │                                     " at (0,16+poff).
		print "    │            │                                     " at (0,17+poff).
		print "    │            │                                     " at (0,18+poff).
		print "    │            │                                     " at (0,19+poff).
		print "    │            │                                     " at (0,20+poff).
		print "    │            │                                     " at (0,21+poff).
		print "    │            │                                    " at (0,22+poff).
	}
	
	if pageid = 4 { 
		if mfdtop = true { 
			print "   BACK  │  LEFT  │ RIGHT  │   UP   │  DOWN  │ TOGGLE  " at (0,0).
			print "─────────┴────────┴────────┴────────┴────────┴─────────" at (0,1). }
		else {
			print "─────────┬────────┬────────┼────────┬────────┬─────────" at (0,23).
			print "   BACK  │  LEFT  │ RIGHT  │   UP   │  DOWN  │ TOGGLE " at (0,24). }

		print "  SYSTEM CONTROL                                       " at (0,0+poff).
		print "════╤════════════╤═════════════════════════════════════" at (0,1+poff).
		print "    │            │                                     " at (0,2+poff).
		print "    │            │                                     " at (0,3+poff).
		print "    │            │                                     " at (0,4+poff).
		print "    │            │                                     " at (0,5+poff).
		print "    │            │                                     " at (0,6+poff).
		print "    │            │                                     " at (0,7+poff).
		print "    │            │                                     " at (0,8+poff).
		print "    │            │                                     " at (0,9+poff).
		print "    │            │                                     " at (0,10+poff).
		print "    │            │                                     " at (0,11+poff).
		print "    │            │                                     " at (0,12+poff).
		print "    │            │                                     " at (0,13+poff).
		print "    │            │                                     " at (0,14+poff).
		print "    │            │                                     " at (0,15+poff).
		print "    │            │                                     " at (0,16+poff).
		print "    │            │                                     " at (0,17+poff).
		print "    │            │                                     " at (0,18+poff).
		print "    │            │                                     " at (0,19+poff).
		print "    │            │                                     " at (0,20+poff).
		print "    │            │                                     " at (0,21+poff).
		print "    │            │                                    " at (0,22+poff).
	}

}

//load libs
run lib_mfd.
run lib_formating.


//setup paging system 
set curr_page to 1.
print_page(curr_page).

//to track the time and throttle the script execution
set looptime to time:seconds.
set done to false.
set animstep to 0.

//create a list of res we want to show and what line they are on
set reslexindex to lexicon().
set reslexgroup to lexicon(
	"LiquidFuel",0,
	"Oxidizer",0,
	"MonoPropellant",0,
	"Ablator",1,
	"Shielding",1,
	"ElectricCharge",2,
	"Oxygen",2,
	"Nitrogen",2,
	"Food",2,
	"Water",2,
	"Hydrogen",3,
	"WasteWater",3,
	"Waste",3,
	"CarbonDioxide",3,
	"Ammonia",3 ).

//create a lex to save eta info
set etalex to lexicon().       //a future time where the resource will expire
set prevlex to lexicon().		//the amnt of the resouce last we checked
set prevlextime to lexicon().  //the time last we checked

//control values for camera list 
set camlistdone to false. 
set clist to list().  //a list to save camera parts in
set camsel to 1.
set prevcamsel to 0.
set actcam to 0.	
set actcamprt to ship:rootpart.
set shippartcount to 0.
set change_camsel to false. 

//define the resource structure that we pull for current resources
set resupid to 0. //the current index to work with on this loop
set lex_to_res to lexicon().  //middleman that holds direct references to the resources on the ship
set lastpartcount to 0.		//how many parts were on the ship when lex_to_res was calc
set lastlextype to 0.

//select which resources we are looking at
//update if on this page and the parts have changed or the lat update was for the other page
local function resetreslex { 
	parameter source.
	//update the lex with the current resounces
	set lex_to_res to lexicon().
	for ires in source {
		lex_to_res:add(ires:name,ires).
	}
	
	//create a custom lex with only the resources we want to monitor 
	//loop through the reslexgroup and... 
	set rowcount to 2. 
	set lastgroup to 0.
	set reslexindex to lexicon().
	for xres in reslexgroup:keys { 
		//if we found a matching res from the above list...
		if lex_to_res:haskey(xres) {
			if lex_to_res[xres]:capacity > 0 {
				//at the end of each reslexgroup print out a spacer for the group
				if reslexgroup[xres] <> lastgroup {
					print "───────────────────────────────────────────────────────" at(0,rowcount+poff).
					set rowcount to rowcount + 1. 
				}
				set lastgroup to reslexgroup[xres].
				
				//then add it to the reslexindex with a row number
				reslexindex:add(xres,rowcount).
				print xres:substring(0,min(xres:length,10)) at(0,rowcount+poff).
				set rowcount to rowcount + 1.
			}
		}
	}
	
	//clear the eta calculations 
	set etalex to lexicon().
	set prevlex to lexicon().
	set prevlextime to lexicon().
}

until done = true {
	
	//process button presses
	//if on the main menu then change to sub page
	if curr_page = 1 { 
		if btn1 = true {
			set btn1 to false.
			set curr_page to 2.
			set resupid to 0.
			print_page(curr_page).
		}
		if btn2 = true {
			set btn2 to false.
			set curr_page to 3.
			set camlistdone to false. 
		}
		if btn3 = true {
			set btn3 to false.
			set curr_page to 4.
			print_page(curr_page).
		}
	}
	
	//if on any other page, then proc buttons as actions
	if curr_page <> 1 {
		if btn1 = true { //back button
			set btn1 to false.
			set curr_page to 1.
			set resupid to 0.
			print_page(curr_page).
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
		//select the item
		if btn6 = true {
			set btn6 to false.
		
			set change_camsel to true. 
		}
	}
	
	//run the main loop every x sec
	if time:seconds > looptime {
		set looptime to time:seconds + 0.05.

		//print an animated icon to show the script is running
		set animstep to mfd_animicon(0,0+poff,animstep).

		//if this is a resource page then print one resource update each loop through
		//only look at resources we are going to actually print, ignore others
		if curr_page = 1 or curr_page = 2 {
			//this is just presetup and is usually not executed each loop 
			if curr_page = 1 and ( lastlextype <> 1 or lastpartcount <> ship:parts:length ) { 
				set lastlextype to 1.
				set lastpartcount to ship:parts:length.
				print_page(curr_page).
				resetreslex(ship:resources).
			}
			//update if on this page and the parts have changed or the lat update was for the other page
			if curr_page = 2 and ( lastlextype <> 2 or lastpartcount <> ship:parts:length ) { 
				set lastlextype to 2.
				set lastpartcount to ship:parts:length.
				print_page(curr_page).
				resetreslex(stage:resources).
			}
			
			//we want to index down the reslex and get the correct resource for that 
			if resupid > reslexindex:length-1 { set resupid to 0. }
			if reslexindex:length = 0 {
				print "no resources on stage" at(15,5+poff).
			}
			else if lex_to_res:haskey(reslexindex:keys[resupid]) { 		
				set mres to lex_to_res[reslexindex:keys[resupid]].
				
				//print the mass of the resource 
				print si_formating(mres:amount*mres:density*100000,"g") at(12,reslexindex[mres:name]+poff).

				//print an eta till depleted
				//etalex containes an estimated time code for when the res depletes 
				if etalex:haskey(mres:name) {
					//first we need to calculate how quickly this resource is changing 
					//prevlextime contains the time when this was last calculated 
					//prevlex contains how much of the resource there was last time
					//we are setting etalex which is a future time when this might run out
					set localtime to time:seconds.
					set deltatime to localtime - prevlextime[mres:name].
					set prevlextime[mres:name] to localtime.
					
					//how much has it changed since last check
					set diff to prevlex[mres:name]-mres:amount.
					set prevlex[mres:name] to mres:amount.
							
					//extimate how how long till resource is depleted at that rate
					if diff = 0 {
						set etalex[mres:name] to 0. //special flag to indicate no change
					}
					//if diff is neg then resource is filling up 
					else if diff < 0 {
						set filltime to (mres:capacity-mres:amount)/(diff/deltatime).
						set etalex[mres:name] to -time:seconds-filltime.
					}
					//if resource is depleting
					else {
						//calc the time in seconds till the resource is gone at current rate
						set deptime to mres:amount/(diff/deltatime).
				
						//set the etatime as a global time value
						set etalex[mres:name] to time:seconds+deptime. 
					}
					
					
					//print the time estimate
					if etalex[mres:name] = 0 { 
						print " no change":padright(14) at (24,reslexindex[mres:name]+poff).
					}
					//resouce is filling up 
					else if etalex[mres:name] < 0 {
						print time_formating(-(etalex[mres:name]-time:seconds),5):padright(13)+"⮜" at (24,reslexindex[mres:name]+poff).
					}
					//resouce is depleting
					else {
						print time_formating((etalex[mres:name]-time:seconds),5):padright(13)+"⮞" at (24,reslexindex[mres:name]+poff).
					}
				}
				else {
					// if its not in the lex yet then just say we are calculating it 
					print " calculating":padright(13) at (24,reslexindex[mres:name]+poff).
		
					//we save the current info for the next loop. 
					prevlextime:add(mres:name,time:seconds).
					prevlex:add(mres:name,mres:amount).
					etalex:add(mres:name,0).
				}

	
				//print a progress bar for pct if the resource has a capacity
				if mres:capacity > 0 {
					print mfd_progress(15,mres:amount/mres:capacity) at(38,reslexindex[mres:name]+poff).
				}
				else { 
					print "nil":padright(15) at(38,reslexindex[mres:name]+poff).
				}

			}
			
			//this resource is not on this ship so indicate that 
			else {
				print " N/A ":padright(43) at(12,reslexindex:values[resupid]+poff).				
			}

			//print the current index and then increment for next time 
			print resupid+" " at(38,0+poff).
			set resupid to resupid + 1.
		}
	
		//print the cameras page
		if curr_page = 3 {
		
			//if the active camera is not on the ship anymore, then print an error message
			if actcam > 0 and actcamprt:ship <> ship {
				print "████████████████████████" at(10,10). 
				print "██                    ██" at(10,11). 
				print "██   PROGRAM ERROR    ██" at(10,12). 
				print "██   RESTART SYSTEM   ██" at(10,13). 
				print "██                    ██" at(10,14). 
				print "████████████████████████" at(10,15). 
			}
			else {	
				//check for conditions that require us to redo the list
				if camlistdone = true {
				
					//if the parts on the ship have changed, then redo the list
					if shippartcount <> ship:parts:length { 
						set camlistdone to false. 
						set actcam to 0. 
						set camsel to 1.
					}
				}
			
				//if list has not been printed yet then 
				if camlistdone = false {
					
					//print the background
					print_page(3).

					//create a fresh list to work with 
					set clist to list().
					
					//get all the parts
					set plist to ship:parts.
					set shippartcount to plist:length.
					
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
						
						//check if the active cam is on the list 
						if actcamprt = cam {
							set actcam to camline - 3.
						}
					
						print cam:tag:padright(10) at (5,camline).
						print cam:title:padright(20) at (18,camline). 
						set camline to camline + 1.
					}
					
					set camlistdone to true.
				}
				
				//if a new selection was requested then try to change
				if change_camsel = true { 
					set change_camsel to false. 
					
					//first disable the current cam and have a short wait
					if actcam > 0 {
						print " " at(0,3+actcam).
						set actcammod to actcamprt:getmodule("MuMechModuleHullCameraZoom").
						if actcammod:hasevent("Deactivate Camera") { actcammod:doevent("Deactivate Camera"). }
						if actcammod:hasevent("deactivate camera") { actcammod:doevent("deactivate camera"). }
						wait 0.1.
					}
					
					//if we are activating an already active camera, then just disable it
					if actcam = camsel {
						set actcam to 0. //back to default setting
					}
					
					//else we want to enable the new camera
					else {
						//save the index of the active cam
						set actcam to camsel. 

						//find the camera module and actiate the event
						set cmod to clist[camsel-1]:getmodule("MuMechModuleHullCameraZoom").
						if cmod:hasevent("Activate Camera") { cmod:doevent("Activate Camera"). }
						if cmod:hasevent("activate camera") { cmod:doevent("activate camera"). }
						set actcamprt to clist[camsel-1].
					}
				
				}

				//show an arrow for the current selection
				print "⮞" at(2, 3+camsel).
				
				//show a marker for the currently active camera 
				if actcam > 0 {
					print "▐" at(0,3+actcam).
				}
				
				//debug
				print actcam + ":" + camsel at(4,2).
			}
		}
	}



}