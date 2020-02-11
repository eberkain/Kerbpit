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

// ----=----=----=----=----=----=----=----=----=----=
//    EXECUTE MANUVRE NODE            STATUS
//  Node ETA    (sec) : ####       
//  Node DeltaV (m/s) : ####        
//  

//get the node
set nd to nextnode.

//print out the mfd screen
clearscreen.
print "    EXECUTE MANUVRE NODE            STATUS ".
print "  Node ETA     (sec): " + round(nd:eta,0).
print "  Node DeltaV  (m/s): " + round(nd:deltav:mag).
print " ".
print "  Starting Mass     : ".
print "  Engine ISP        : ".
print "  Engine Thrust     : ".
print " ".
print "  Ending Mass       : ".
print "  Fuel Flow         : ".
print "  Burn Duration     : ".
print " ".
print "  Node VANG         : ".
print "  Max Stop Time     : ".
print " ".
print "  Current Mass      : ".
print "  Curr. Max Accel.  : ".
print "  Curr. Throttle    : ".
print "  Remaining DeltaV  : ".
print "  Node Dot Prod.    : ".


//calculate params needed for burn calc
list engines in eng.
set dv to nd:deltav:mag.			//m/s of burn
set m to ship:mass*1000. 		//starting mass
set p to eng[0]:visp.    		//engine eff
set f to eng[0]:possiblethrust*1000. //engine thrust

//update the display
print round(m,0) at(23,4).
print round(p,0) at(23,5).
print round(f,0) at(23,6).

//calculat the burn duration
set em to m / constant():e^(dv /(9.80665 * p)).
set ff to f / 9.80665 / p.
set bd to (m - em) / ff.

//calculate the burn duration
print round(em,0) at(23,8).
print round(ff,2) at(23,9).
print round(bd,2) at(23,10).

//timewarp to 1 min before burn starts
kuniverse:timewarp:warpto(time:seconds + nd:eta - (bd/2) - 60).
print "warping to node" at(33,1).

//wait until the warp is done
wait until nd:eta <= (bd/2 + 59).

//lock the steering to the node, enable rcs and rot rcs
set np to nd:deltav. //points to node, don't care about the roll direction.
lock steering to np.
RCS ON.
SAS OFF.
print "steering locked" at(33,3).
print "rcs enabled" at(33,4).

//adjust the maxstoptime on the fly relative to how far the steering needs to travel
set aligned to false.
until aligned {
	set fdif to vang(np, ship:facing:vector).
	set mst to (fdif*0.1)+4.
	set steeringmanager:maxstoppingtime to mst.

	print round(fdif,0)+"   " at(23,12).
	print round(mst,0)+"   " at(23,13).
	
	if fdif < 0.25 {
		set aligned to true. 
	}
}

//now we need to wait until the burn vector and ship's facing are aligned
wait until aligned = true. 
print "steering aligned" at(33,6).
print "warping to start" at(33,7).

//the ship is facing the right direction
//timewarp to 3 sec before burn start
kuniverse:timewarp:warpto(time:seconds + nd:eta - (bd/2) - 3).
wait until nd:eta <= (bd/2).

//set the trottle control
set tset to 0.
lock throttle to tset.
set tsetflag to false.
print "throttle locked" at(33,9).
print "starting burn" at(33,10).

set done to False.
//save initial deltav
set dvv to nd:deltav.
until done {
    //recalculate current max_acceleration, as it changes while we burn through fuel
    set max_acc to ship:maxthrust/ship:mass.
    set nvd to vdot(dvv, nd:deltav).

	//update status
	print round(ship:mass*1000,0) at(23,15).
	print round(max_acc,2) at(23,16).
	print round(tset*100,0) at(23,17).
	print round(nd:deltav:mag,1) at(23,18).
	print round(nvd,0) at(23,19).

    //throttle is 100% until there is less than 1 second of time left to burn
    //when there is less than 1 second - decrease the throttle linearly
    set tset to min(nd:deltav:mag/max_acc, 1).
	if tset < 1 AND tsetflag = false { 
		print "reducing throttle" at(33,12). 
		set tsetflag to true.
	}

    //here's the tricky part, we need to cut the throttle as soon as our nd:deltav and initial deltav start facing opposite directions
    //this check is done via checking the dot product of those 2 vectors
    if nvd < 0     {
        print "burn stopped" at(33,14). 
		lock throttle to 0.
        break.
    }

    //we have very little left to burn, less then 0.1m/s
    if nd:deltav:mag < 0.1
    {
        print "finalizing burn" at(33,14).
        //we burn slowly until our node vector starts to drift significantly from initial vector
        //this usually means we are on point
        wait until vdot(dvv, nd:deltav) < 0.5.

        lock throttle to 0.
        print "burn ended." at(33,15).
        set done to True.
    }
}

//finalize and terminate
unlock steering.
unlock throttle.
SAS ON.

print "steering released" at(33,16).
print "throttle released" at(33,17).
print "stability assist on" at(33,18).

wait 1.

//we no longer need the maneuver node
remove nd.

//set throttle to 0 just in case.
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.