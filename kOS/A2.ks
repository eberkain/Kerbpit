// MFD Autopilot - Execute Next Node
// by Jonathan Medders  'EberKain'
//
// based on the kOS sample script
//
// All we are trying to accomplish with this script is to control 
// the vessel steering and throttle, all other systems are manual
//
// The program is launched by a shortcut on the autopilot controller 
// no parameters or special setup is involved

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

//get the node
set nd to nextnode.

//print out the mfd screen
//     ----=----=----=----=----=xxxxx----=----=----=----=----=
print "  EXECUTE MANUVRE NODE                                 " at(0,0+poff).
print "═══════════════════════════╤═══════════════════════════" at(0,1+poff).
print "Node ETA     :             │                           " at(0,2+poff).
print "Node ΔV      :             │                           " at(0,3+poff).
print "───────────────────────────┤                           " at(0,4+poff).   
print "Start Mass   :             │                           " at(0,5+poff).
print "ISP          :             │                           " at(0,6+poff).
print "Aval Thrust  :             │                           " at(0,7+poff).
print "───────────────────────────┤                           " at(0,8+poff).
print "Ending Mass  :             │                           " at(0,9+poff).
print "Fuel Flow    :             ├───────────────────────────" at(0,10+poff).
print "Burn Time    :             │                           " at(0,11+poff).
print "───────────────────────────┤                           " at(0,12+poff).
print "Node VANG    :             │                           " at(0,13+poff).
print "Max Stop     :             │                           " at(0,14+poff).
print "Angular Vel  :             │                           " at(0,15+poff).
print "───────────────────────────┤                           " at(0,16+poff).
print "Current Mass :             │                           " at(0,17+poff).
print "Max Accel.   :             │                           " at(0,18+poff).
print "Curr. Throt. :             │                           " at(0,19+poff).
print "Remaining ΔV :             │                           " at(0,20+poff).
print "Node Dot Prd.:             │                           " at(0,21+poff).
print "                           │                           " at(0,22+poff).

//print node info
print (time_formating(nd:eta,5)):padright(10) at(15,2+poff).
print (" "+round(nd:deltav:mag)+" m/s"):padright(10) at(15,3+poff).

//calculate params needed for burn calc
list engines in englist.
set burndv to nd:deltav:mag.			//m/s of burn
set shipm to ship:mass*1000. 		//starting mass
set comisp to 0. 
set comthr to 0.  

//check all the engines for active engines
for eng in englist {
	if eng:ignition {
		set comisp to comisp + (eng:visp*(eng:availablethrust*1000)).	//engine eff
		set comthr to comthr + eng:availablethrust*1000. //engine thrust
	}
}

//if we found active engines then continue program
if comthr > 0 {
	//calc the average isp relative to how much thrust each engine has
	set comisp to comisp/comthr.
	
	//update the display with preburn info
	print (si_formating(shipm,"g")):padright(10) at(15,5+poff).
	print (" "+round(comisp,0)+" sec"):padright(10) at(15,6+poff).
	print (si_formating(comthr,"n")):padright(10) at(15,7+poff).

	//calculat the burn duration
	set endmass to shipm / constant():e^(burndv /(constant:g0 * comisp)).
	set fflow to comthr / 9.80665 / comisp.
	set burndur to (shipm - endmass) / fflow.

	//print the post burn estimates
	print (si_formating(endmass,"g")):padright(10) at(15,9+poff).
	print (" "+round(fflow,2)+"U"):padright(10) at(15,10+poff).
	print (time_formating(burndur,5)):padright(10) at(15,11+poff).

	//timewarp to 1 min before burn starts
	kuniverse:timewarp:warpto(time:seconds + nd:eta - (burndur/2) - 60).
	print "warp:node" at(28,2+poff).

	//wait until the warp is done
	wait until nd:eta <= (burndur/2 + 59).

	//lock the steering to the node, enable rcs and rot rcs
	set np to nd:deltav. //points to node, don't care about the roll direction.
	lock steering to np.
	RCS ON.
	SAS OFF.
	print "ctrl-lock" at(28,3+poff).
	print "rcs-on " at(43,2+poff).

	//adjust the maxstoptime on the fly relative to how far the steering needs to travel
	set aligned to false.
	until aligned {
		set fdif to vang(np, ship:facing:vector).
		set mst to (fdif*0.1)+4.
		set steeringmanager:maxstoppingtime to mst.
		set rotr to ship:angularvel:mag * (180/constant:pi).

		print (padding(fdif,1,2)+" °"):padright(10) at(15,13+poff).
		print (padding(mst,1,2)+" sec"):padright(10) at(15,14+poff).
		print (padding(rotr,1,2)+" °/s"):padright(10) at(15,15+poff).
		
		if fdif < 0.25 and rotr < 1.5 {
		
			set aligned to true. 
		}
	}

	//now we need to wait until the burn vector and ship's facing are aligned
	wait until aligned = true. 
	print "ctrl-align" at(28,4+poff).
	print "warp:strt" at(28,5+poff).

	//the ship is facing the right direction
	//timewarp to 3 sec before burn start
	kuniverse:timewarp:warpto(time:seconds + nd:eta - (burndur/2) - 3).
	wait until nd:eta <= (burndur/2).

	//loop timer control 
	set looptime to time:seconds.
	set animstep to 0.

	//set the trottle control
	set tset to 0.
	lock throttle to tset.
	set tsetflag to false.
	print "throt-lock" at(28,6+poff).
	print "burn-strt" at(28,7+poff).

	set done to False.
	//save initial deltav
	set dvv to nd:deltav.
	until done {
		//recalculate current max_acceleration, as it changes while we burn through fuel
		set max_acc to ship:maxthrust/ship:mass.
		set nvd to vdot(dvv, nd:deltav).

		//update status
		print (si_formating(ship:mass*1000,"g")):padright(10) at(15,17+poff).
		print (si_formating(max_acc,"m/s")):padright(10) at(15,18+poff).
		print (" "+round(tset*100,0)+"%"):padright(10) at(15,19+poff).
		print (si_formating(nd:deltav:mag,"m/s")):padright(10) at(15,20+poff).
		print (" "+round(nvd,0)):padright(10) at(15,21+poff).

		//throttle is 100% until there is less than 1 second of time left to burn
		//when there is less than 1 second - decrease the throttle linearly
		set tset to min(nd:deltav:mag/max_acc, 1).
		if tset < 1 AND tsetflag = false { 
			print "reduc-throt" at(43,3+poff). 
			set tsetflag to true.
		}

		//here's the tricky part, we need to cut the throttle as soon as our nd:deltav and initial deltav start facing opposite directions
		//this check is done via checking the dot product of those 2 vectors
		if nvd < 0     {
			print "burn-stop" at(43,4+poff). 
			lock throttle to 0.
			break.
		}

		//we have very little left to burn, less then 0.1m/s
		if nd:deltav:mag < 0.1
		{
			print "burn:final" at(43,5+poff).
			//we burn slowly until our node vector starts to drift significantly from initial vector
			//this usually means we are on point
			wait until vdot(dvv, nd:deltav) < 0.5.

			lock throttle to 0.
			print "burn:ended." at(43,6+poff).
			set done to True.
		}
		
			//update the info x times per sec
		if time:seconds > looptime {
			set looptime to time:seconds + 0.05.
			
			//print an animated icon to show the script is running
			set animstep to mfd_animicon(0,0+poff,animstep).
		}
	}

	//finalize and terminate
	unlock steering.
	unlock throttle.
	SAS ON.

	print "ctrl-release" at(43,7+poff).
	print "sas-on" at(43,8+poff).

	wait 1.

	//we no longer need the maneuver node
	remove nd.

	//set throttle to 0 just in case.
	SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
	
}

//we didnt find an active engine earler so throw an error and end program
else {
	print "████████████████████████" at(10,10). 
	print "██                    ██" at(10,11). 
	print "██   PROGRAM ERROR    ██" at(10,12). 
	print "██  NO ACTIVE ENGINE  ██" at(10,13). 
	print "██                    ██" at(10,14). 
	print "████████████████████████" at(10,15). 
}

