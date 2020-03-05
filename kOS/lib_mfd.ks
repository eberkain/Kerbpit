// MFD Function Library
// by Jonathan Medders  'EberKain'
//
// just some things to shortcut code elsewhere




//print a progress bar at the location with the number of segments that represents the value
local minstrmas to "░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░".
local maxstrmas to "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓".
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
	parameter xval, typ. 

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

//display an animated icon at the specificed location
function mfd_animicon {

		parameter px,py,st.
		
		//print a character to animate to indicate script is running and healty
		if st = 0 { print "▖" at (px,py). }
		if st = 1 { print "▘" at (px,py). }
		if st = 2 { print "▝" at (px,py). }
		if st = 3 { print "▗" at (px,py). }

		set st to st + 1.
		if st = 4 { set st to 0. }
	
		return st.
}

//create a 2d array of the size
function mfd_createarray {
	parameter mw, mh, tx, ty.
	
	set map to list().
	
	from {local i is 0.} until i = mw step {set i to i+1.} do {
		map:add (list()). 
		from {local t is 0.} until t = mh step {set t to t+1.} do {
			print i + ":" + t + " "at(tx,ty).
			map[i]:add(t).
			set map[i][t] to 0.
		}
	}

	return map. 
}
//faster
function mfd_nugarray {
    parameter mw, mh, tx, ty.
    
    local map is list().
    
    local line is list().
	local t is 0.
	local i is 0.
    from {set t to 0.} until t = mh step {set t to t+1.} do {
        line:add(0).
		print i + ":" + t + " "at(tx,ty).
    }
    from {set i to 0.} until i = mw step {set i to i+1.} do {
        map:add(line:copy). 
		print i + ":" + t + " "at(tx,ty).
    }

    return map. 
}

//character map for drawing
set quad_char to " ▘▝▀▖▌▞▛▗▚▐▜▄▙▟█".
set p0_lex to lexicon(1,1,3,3,5,5,7,7,9,9,11,11,13,13,15,15).
set p1_lex to lexicon(2,2,3,3,6,6,7,7,10,10,11,11,14,14,15,15).
set p2_lex to lexicon(4,4,5,5,6,6,7,7,12,12,13,13,14,14,15,15).
set p3_lex to lexicon(8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15).

//change the value of the pixels to render image
//called repeadatly so just draw the current point
function mfdmap_drawpixel {
	//map pos, map size, point pos pct
	parameter mx,my,mw,mh,map,vx,vy.
	
	//value numbers must be on the map
	if vx > 0 and vx < 1 and vy > 0 and vy < 1 {
		
		//find x,y value for the character to change
		set cx to round(vx*(mw-1)).
		set cy to round(vy*(mh-1)).
		
		//find the x,y of the pixel to change
		set px to mfd_clamp(round(vx*((mw*2)-1)) - (cx*2),0,1).
		set py to mfd_clamp(round(vy*((mh*2)-1)) - (cy*2),0,1).

		//calculate the binary value of this pixel 
		set pbv to (px*py*3)+(py*3)+(px*1)+1.  //binary root val  1,2,4,8

		//we need to see if the target pixel is already on, assume it is not
		set p0 to 0.
		set p1 to 0.
		set p2 to 0.
		set p3 to 0.

		//check if the pixel is on by comparing vs the set of all characters with the pixel on
		if p0_lex:haskey(map[cx][cy]) { set p0 to 1. } 
		if p1_lex:haskey(map[cx][cy]) { set p1 to 1. } 
		if p2_lex:haskey(map[cx][cy]) { set p2 to 1. } 
		if p3_lex:haskey(map[cx][cy]) { set p3 to 1. } 
		
		//if the target pixel is off and the binary value points to it, then just add them
		if p0 = 0 and pbv = 1 { set map[cx][cy] to map[cx][cy] + pbv. }
		if p1 = 0 and pbv = 2 { set map[cx][cy] to map[cx][cy] + pbv. }
		if p2 = 0 and pbv = 4 { set map[cx][cy] to map[cx][cy] + pbv. }
		if p3 = 0 and pbv = 8 { set map[cx][cy] to map[cx][cy] + pbv. }

		//faster method indexes the character needed off a string 
		print quad_char[map[cx][cy]] at(mx+cx,my+cy).

		//return the character that was changed
		return (mx+cx)+":"+(my+cy).
	}
	else { return "0:0". }
}

//convert from one range to another
function mfd_convert {
	parameter OldValue, OldMin, OldMax, NewMin, NewMax.
	
	return (((OldValue - OldMin) * (NewMax - NewMin)) / (OldMax - OldMin)) + NewMin.
}

//clamp a value to a range
function mfd_clamp {
	parameter num, nmin, nmax.
	return min(max(num, nmin), nmax).
}

//since we can't query an engine to see what kind of fuel it uses
//we assume any fuel on the stage is used for dv
//TODO: need a way to account for monoprop
set fueltypes to list("LiquidFuel","Oxidizer","SolidFuel").

//calculate the stage delta v 
function calcstagedeltav {
	
	//we find all the active engines and average the isp based on relative thrust
	list engines in alleng.
	set avgisp to 0. 
	set totthr to 0. 
	set fuellist to list(). 
	for eng in alleng {
		if eng:ignition {
			//make a list of all fuel types in use, well shit...
			//fuellist:add("engfueltype").
			set avgisp to avgisp + (eng:isp * eng:availablethrust).
			set totthr to totthr + eng:availablethrust. 
		}
	}
	if totthr > 0 {	set avgisp to avgisp / totthr. }
	else return 0. 

	//calculate the mass of the fuel in the stage
	set stgres to stage:resourceslex.
	set stgdrymass to ship:mass.
	for fuel in fueltypes {
		set res to stgres[fuel].
		set stgdrymass to stgdrymass - (res:amount*res:density).
	}
	
	//print round(avgisp)+":"+round(stgdrymass) at(20,2).
	
	//return the stage deltav
	return (constant:g0 * (avgisp * (ln(ship:mass / stgdrymass)))).
}

