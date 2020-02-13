// MFD Function Library
// by Jonathan Medders  'EberKain'
//
// just some things to shortcut code elsewhere




//print a progress bar at the location with the number of segments that represents the value
local minstrmas to "░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░".
local maxstrmas to "████████████████████████████████████████████████████████████████████".
function mfd_progress {

	//get the params
	parameter seg, pct.

	//create substrings the right length
	set minstr to minstrmas:substring(0,seg).
	set maxstr to maxstrmas:substring(0,seg).
	
	//decide where to splice the strings
	set cutpt to round(pct*seg,0).
	
	//take first part from minstr and second part from maxstr
	return minstr:substring(0,seg-cutpt) + maxstr:substring(0,cutpt).
}

//convert from a decimal to degree min sec format for lat/lng
function dms_formating {

	//get the decimal value and the "lat" "lng" type
	parameter xval, typ to "". 

	//create a flag for the sign 
	set sign to 1.
	if xval < 0 { set sign to -1. }

	//are we tagging with N,S,E,W?
	set hemi to "".
	if typ:tolower() = "lat" {
		if sign = 1 { set hemi to "N". }
		else { set hemi to "S". } 	
	}
	else {
		if sign = 1 { set hemi to "E". }
		else { set hemi to "W". }
	}
	
	//calc the values
	set yval to abs(xval).
	set dval to floor(yval).
	set zval to 60*(yval-dval).
	set mval to floor(zval).
	set sval to floor(60*(zval-mval)).
	
	//build the string and return 
	return dval+"°"+mval+"'"+sval+char(34)+hemi.
}

//collect number input from the flight comptuer keyboard buttons
function mfd_numinput {
	//get the params, print location, allow neg, min/max limits
	parameter px, py, neg is false, minv is 0, maxv is 0.
	
	//clear out anything in the terminal input
	terminal:input:clear.
	
	//local vars
	set done to false. 
	set sign to " ".
	set inputval to "".
	
	//loop until enter is pressed
	until done = true {
		//if there is a character in the input waiting then process
		if terminal:input:haschar {

			//get the character and check if it was a number
			set char to terminal:input:getchar().
			set cval to char:tonumber(-1).

			//if the character is a return then confirm the value
			if char = terminal:input:ENTER { 
				terminal:input:clear. 
				set done to true. 
				set num to inputval:tonumber(0).
				if sign = "-" { set num to -num. }
				return num.
			}
			
			//if character was a backspace then delete last character of string
			if char = terminal:input:backspace {
				set inputval to inputval:remove(inputval:length-1,1).	
				
				//print at loc so we can see what is being input
				print sign+inputval+" " at(px,py).
			}
			
			//if character is a minus then reverse the sign of the input
			if char = "-" and neg = true {
				if sign = " " { set sign to "-". }
				else { set sign to " ". }
				
				//clamp the new value if needed
				if minv <> 0 or maxv <> 0 {
					set inputval to abs(mfd_clamp((sign+inputval):tonumber(0),minv,maxv)):tostring().
				}
				
				//print at loc so we can see what is being input
				print sign+inputval+" " at(px,py).
			}

			// if the input was a number then add to string
			if cval >= 0 { 
				set inputval to inputval + char. 

				//clamp the new value if needed
				if minv <> 0 or maxv <> 0 {
					set inputval to abs(mfd_clamp((sign+inputval):tonumber(0),minv,maxv)):tostring().
				}

				//print at loc so we can see what is being input
				print sign+inputval at(px,py).
			} 
		}
		wait 0.001.
	}	
}

//clamp the value into the range
function mfd_clamp {
	parameter val, minv, maxv.
	
	return max(min(val,maxv),minv).
}

//convert desired inc to heading for launches
function mfd_inctohdg {
	parameter inc.
	//TODO calculate target heading for the launch to hit the desired incl.
	//also skew heading so 90 deg hits the latitude inclination
	return inc+90.
}

//limit the target inclination based on latitude
function mfd_adjinc {
	parameter inc, lat.
	//if not on the equator then we have to set bounds on the target incl. 
	//you cannot have a final inclination lower than the starting latitude
	//assume input is from -180 to 180
	//three regions require adjustment 

	//if we are close to equator, no restrictions
	if abs(lat) < 1 {
		return inc.
	}

	//if we are in the north hemi 
	if lat > 1 { 
		if inc < lat { return lat. }
		else { return inc. }
	}
	//else we are in south hemi
	else { 
		if inc > lat { return lat. }
		else { return inc. }
	}

}