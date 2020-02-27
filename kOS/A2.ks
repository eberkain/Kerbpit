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
print "Burn Dur.    :             │                           " at(0,11+poff).
print "───────────────────────────┤                           " at(0,12+poff).
print "Node VANG    :             │                           " at(0,13+poff).
print "Max Stop     :             │                           " at(0,14+poff).
print "───────────────────────────┤                           " at(0,15+poff).
print "Current Mass :             │                           " at(0,16+poff).
print "Max Accel.   :             │                           " at(0,17+poff).
print "Curr. Throt. :             │                           " at(0,18+poff).
print "Remaining ΔV :             │                           " at(0,19+poff).
print "Node Dot Prd.:             │                           " at(0,20+poff).
print "                           │                           " at(0,21+poff).
print "                           │                           " at(0,22+poff).

//print node info
print round(nd:eta,0) at(15,2+poff).
print round(nd:deltav:mag) at(15,3+poff).

//calculate params needed for burn calc
list engines in eng.
set dv to nd:deltav:mag.			//m/s of burn
set m to ship:mass*1000. 		//starting mass
set p to eng[0]:visp.    		//engine eff
set f to eng[0]:possiblethrust*1000. //engine thrust

//update the display with preburn info
print round(m,0) at(15,5+poff).
print round(p,0) at(15,6+poff).
print round(f,0) at(15,7+poff).

//calculat the burn duration
set em to m / constant():e^(dv /(9.80665 * p)).
set ff to f / 9.80665 / p.
set bd to (m - em) / ff.

//print the post burn estimates
print round(em,0) at(15,9+poff).
print round(ff,2) at(15,10+poff).
print round(bd,2) at(15,11+poff).

//timewarp to 1 min before burn starts
kuniverse:timewarp:warpto(time:seconds + nd:eta - (bd/2) - 60).
print "warping to node" at(28,2+poff).

//wait until the warp is done
wait until nd:eta <= (bd/2 + 59).

//lock the steering to the node, enable rcs and rot rcs
set np to nd:deltav. //points to node, don't care about the roll direction.
lock steering to np.
RCS ON.
SAS OFF.
print "steering locked" at(28,4+poff).
print "rcs enabled" at(28,5+poff).

//adjust the maxstoptime on the fly relative to how far the steering needs to travel
set aligned to false.
until aligned {
	set fdif to vang(np, ship:facing:vector).
	set mst to (fdif*0.1)+4.
	set steeringmanager:maxstoppingtime to mst.

	print round(fdif,0)+"   " at(15,13+poff).
	print round(mst,0)+"   " at(15,14+poff).
	
	if fdif < 0.25 {
		set aligned to true. 
	}
}

//now we need to wait until the burn vector and ship's facing are aligned
wait until aligned = true. 
print "steering aligned" at(28,7+poff).
print "warping to start" at(28,8+poff).

//the ship is facing the right direction
//timewarp to 3 sec before burn start
kuniverse:timewarp:warpto(time:seconds + nd:eta - (bd/2) - 3).
wait until nd:eta <= (bd/2).

//loop timer control 
set looptime to time:seconds.
set animstep to 0.

//set the trottle control
set tset to 0.
lock throttle to tset.
set tsetflag to false.
print "throttle locked" at(28,10+poff).
print "starting burn" at(28,11+poff).

set done to False.
//save initial deltav
set dvv to nd:deltav.
until done {
    //recalculate current max_acceleration, as it changes while we burn through fuel
    set max_acc to ship:maxthrust/ship:mass.
    set nvd to vdot(dvv, nd:deltav).

	//update status
	print round(ship:mass*1000,0) at(15,15+poff).
	print round(max_acc,2) at(15,16+poff).
	print round(tset*100,0) at(15,17+poff).
	print round(nd:deltav:mag,1) at(15,18+poff).
	print round(nvd,0) at(15,19+poff).

    //throttle is 100% until there is less than 1 second of time left to burn
    //when there is less than 1 second - decrease the throttle linearly
    set tset to min(nd:deltav:mag/max_acc, 1).
	if tset < 1 AND tsetflag = false { 
		print "reducing throttle" at(28,13+poff). 
		set tsetflag to true.
	}

    //here's the tricky part, we need to cut the throttle as soon as our nd:deltav and initial deltav start facing opposite directions
    //this check is done via checking the dot product of those 2 vectors
    if nvd < 0     {
        print "burn stopped" at(28,14+poff). 
		lock throttle to 0.
        break.
    }

    //we have very little left to burn, less then 0.1m/s
    if nd:deltav:mag < 0.1
    {
        print "finalizing burn" at(28,15+poff).
        //we burn slowly until our node vector starts to drift significantly from initial vector
        //this usually means we are on point
        wait until vdot(dvv, nd:deltav) < 0.5.

        lock throttle to 0.
        print "burn ended." at(28,16+poff).
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

print "steering released" at(28,18+poff).
print "throttle released" at(28,19+poff).
print "stability assist on" at(28,20+poff).

wait 1.

//we no longer need the maneuver node
remove nd.

//set throttle to 0 just in case.
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.