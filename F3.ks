// MFD Autopilot - Execute Next Node
// by Jonathan Medders  'EberKain'
//
// based on the hoverslam script by mrbradleyjh
// https://github.com/mrbradleyjh/kOS-Hoverslam/blob/master/hoverslam.ks
//
// landing on an airless body is a 3 part process beginning in low orbit
// make a retrograde burn to pick a general landing area
// make a medium altitude burn to kill horizonal velocity
// perform a last second suicide burn
//
// there are two ways to start this program
// direct launch shortcut with no params immediately starts a deorbit burn
//   if not already on a suborbital path
// flight computer launch allows you to specify landing coordinates
//   this first requires a plane change burn before starting the rest of the process

// ----=----=----=----=----=----=----=----=----=----=
//    AUTOMATED LANDING            STATUS
//  

//use ship:bounds:bottomaltradar to get dist above ground
//reuse bounds object


clearscreen.
set radarOffset to 4.719.	 				// The value of alt:radar when landed (on gear)
lock trueRadar to alt:radar - radarOffset.			// Offset radar to get distance from gear to ground
lock g to constant:g * body:mass / body:radius^2.		// Gravity (m/s^2)
lock maxDecel to (ship:availablethrust / ship:mass) - g.	// Maximum deceleration possible (m/s^2)
lock stopDist to ship:verticalspeed^2 / (2 * maxDecel).		// The distance the burn will require
lock idealThrottle to stopDist / trueRadar.			// Throttle required for perfect hoverslam
lock impactTime to trueRadar / abs(ship:verticalspeed).		// Time until impact, used for landing gear

WAIT UNTIL ship:verticalspeed < -1.
	print "Preparing for hoverslam...".
	rcs on.
	brakes on.
	lock steering to srfretrograde.
	when impactTime < 3 then {gear on.}

WAIT UNTIL trueRadar < stopDist.
	print "Performing hoverslam".
	lock throttle to idealThrottle.

WAIT UNTIL ship:verticalspeed > -0.01.
	print "Hoverslam completed".
	set ship:control:pilotmainthrottle to 0.
	rcs off.
	sas on.