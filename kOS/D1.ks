// MFD Master Controller Program
// by Jonathan Medders  'EberKain'
//
// This program is run on a terminal and recieves all input commands
// decodes those actions and then either sends a message to another cpu
// or manipulates the vessel or game state in some way 
//
// all actions are 3 character commands, the main loop checkes the terminal 
// for any characters and collets them into sets of 3
// decodes the action and then calls necessry functions

run lib_mfd.

set core:part:tag to "master".

clearscreen. 
core:messages:clear().

//cpu references
set cpulex to lexicon(). 
set cputime to list(time:seconds,time:seconds,time:seconds,time:seconds).

//input control
set ia to "".
set icount to 0. 
set iready to false. 
set itime to 0. 

//main loop 
set done to false. 
until done = true {

	//if there is new input 
	if terminal:input:haschar {
		set ia to ia + terminal:input:getchar().
		set icount to icount + 1. 
		if icount >= 3 { 
			set icount to 0. 
			set iready to true. 
		}
		set itime to time:seconds.
	}

	//if too much time has passed since the last terminal input 
	//and we didn't get 3 characters, the reset the input field
	if time:seconds > itime+0.5 and icount > 0 { 
		set icount to 0.
		set ia to "".
		print "incomplete action cleared".
	}
	
	//if there is an action ready to execute
	if iready = true {
		set iready to false. 
		
		print "input action : " + ia.
		
		//mfd action button pressed  m[term][btn]
		if ia:substring(0,1) = "m" {
			if cpulex:haskey(ia:substring(1,1)) {
				if processorexists(cpulex[ia:substring(1,1)]) {
					if processor(cpulex[ia:substring(1,1)]):connection:sendmessage(ia:substring(2,1)) {
						print "msg sent to : "+cpulex[ia:substring(1,1)].
					}
				}
				else {
					print "cpu not found : "+cpulex[ia:substring(1,1)].
				}
			}
			else { 
				print "cpuid not in lex : "+ia:substring(1,1).
			}
		}
		
		//autopilot actions  a[][]

		//part actions   p[][]

		//reset the action string to start collecting new string next loop
		set ia to "".
	}

	//recieve messages from other cpus to register them for message sending
	if core:messages:empty = false { 
		set cpuname to core:messages:pop:content:tostring. 
		
		//save a ref to the cpuid in the lex    slave-#-##
		set cpuid to cpuname:substring(6,1).
		if cpulex:haskey(cpuid) {
			set cpulex[cpuid] to cpuname.
			print "updated cpuid "+cpuid.
		}
		else { 
			cpulex:add(cpuid,cpuname).
			print "added cpuid "+cpuid.
		}
		set cputime[cpuid:tonumber(1)-1] to time:seconds.
	}
	
	//check how long since each mfd reported in 
	from {set cpuid to 1.} until cpuid > 4 step {set cpuid to cpuid+1.} do {
		
		//if it has been too long since the cpu last reported in 
		if time:seconds > cputime[cpuid-1]+10 { 
			set cputime[cpuid-1] to time:seconds.
			print "cpu not active : " + cpuid.

			if cpulex:haskey(cpuid:tostring) { 
				if processorexists(cpulex[cpuid:tostring]) {
					//set the mfd boot file and reboot it
					set processor(cpulex[cpuid:tostring]):bootfilename to "C1.ks".
					processor(cpulex[cpuid:tostring]):activate.  //shit
					print "rebooting cpu : " + cpuid. 
				}
				else {
					print "unable to boot : " + cpuid.
				}
			}
			else {
				print "no cpu registerd : " + cpuid.
			}
		}
	}
	
	wait 0.001.
}