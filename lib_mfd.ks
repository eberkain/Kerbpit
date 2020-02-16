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

//calcualte a launch direction to hit a desired inclination
function mfd_calcazimuth {
	parameter inc, lat.
	//if not on the equator then we have to set bounds on the target incl. 
	//you cannot have a final inclination lower than the starting latitude
	//assume input is from -180 to 180
	//three regions require adjustment 
	return 90.
}


//limit the target inclination based on latitude
function mfd_adjinc {
	parameter inc, lat.
	//if not on the equator then we have to set bounds on the target incl. 

	//no adj near equator
	if lat > -0.5 and lat < 0.5 { 
		return inc.
	}
	//inc is lower than the lat
	else if abs(inc) < abs(lat) {
        return lat.
    }
	//everywhere else
	else {
		return inc.
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

//print a grid of characters to display a 2d array
function mfd_quadmap {
	//top left start pos, size, data 
	parameter gx,gy,gw,gh,gdata.

	//single dots ▖▗▘▝
	//double dots ▚▞▄▀▌▐
	//tri dots ▙▟▛▜
	//full dots █
	//shade blocks ░▒▓
	
	//loop through the character range x/y
	//comare the corrisponding data values 
	//pick the character to print to match data

//              ▄▄▄▀▀▀▀▀▀
//          ▗▞▀
//       ▗▞▘
//     ▗▘
//   ▗▘
//  ▞
// ▌
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
			set map[i][t] to "0000".
		}
	}

	return map. 
}

//print an image using half filled squares  ▄▀█
function mfdmap_halfmapdraw {
	parameter mx, my, mw, mh, map, print_empty to false. 
	
	//each character represents two pixels, 4 possible characters. 
	//loop through character area
	from {local i is 0.} until i = mw step {set i to i+1.} do {
		from {local t is 0.} until t = mh/2 step {set t to t+1.} do {
			//get the two pixels we are going to display with this character
			set va to map[i][2*t].
			set vb to map[i][2*t+1].

			//pick the character display based on the data 
			if va = 0 and vb = 0 and print_empty = true { print " " at(mx+i,my+t). }
			if va = 0 and vb = 1 { print "▄" at(mx+i,my+t). }
			if va = 1 and vb = 0 { print "▀" at(mx+i,my+t). }
			if va = 1 and vb = 1 { print "█" at(mx+i,my+t). }
		}
	}
}

//change the value of the pixels to render image
//called repeadatly so just draw the current point
function mfdmap_drawpixel {
	//map pos, map size, point pos pct
	parameter mx,my,mw,mh,map,vx,vy,print_empty to false.
	
	//value numbers must be on the map
	if vx > 0 and vx < 1 and vy > 0 and vy < 1 {
		
		//find x,y value for the character to change
		set cx to round(vx*(mw-1)).
		set cy to round(vy*(mh-1)).
		
		//find the x,y of the pixel to change
		set px to mfd_clamp(round(vx*((mw*2)-1)) - (cx*2),0,1).
		set py to mfd_clamp(round(vy*((mh*2)-1)) - (cy*2),0,1).
		
		//find the binary index of the new pixel
		// 0001  =  3      px=0   py=0
		// 0010  =  2      px=1   py=0
		// 0100  =  1      px=0   py=1
		// 1000  =  0      px=1   py=1
		set pix to (1-px)+((1-py)*2).

		//check and set the current map value of that index
		set maps to map[cx][cy]. 
		if maps[pix] = "0" {
			//build a new string
			set map[cx][cy] to maps:substring(0,pix)+"1"+maps:substring(pix+1,3-pix).
		}
		
		//print debug data
		//print "x:"+round(vx,2)+":"+cx+":"+px+"  " at(mx,my).
		//print "y:"+round(vy,2)+":"+cy+":"+py+"  " at(mx,my+1).
		//print "p:"+pix+":"+map[cx][cy]+"   " at(mx,my+2).
		
		//print the pixel
		//single dots ▖▗▘▝
		//double dots ▚▞▄▀▌▐
		//tri dots ▙▟▛▜
		//full dots █
		if map[cx][cy] = "0000" { print " " at(mx+cx,my+cy). }
		else if map[cx][cy] = "0001" { print "▘" at(mx+cx,my+cy). }
		else if map[cx][cy] = "0010" { print "▝" at(mx+cx,my+cy). }
		else if map[cx][cy] = "0011" { print "▀" at(mx+cx,my+cy). }
		else if map[cx][cy] = "0100" { print "▖" at(mx+cx,my+cy). }
		else if map[cx][cy] = "0101" { print "▌" at(mx+cx,my+cy). }
		else if map[cx][cy] = "0110" { print "▞" at(mx+cx,my+cy). }
		else if map[cx][cy] = "0111" { print "▛" at(mx+cx,my+cy). }
		else if map[cx][cy] = "1000" { print "▗" at(mx+cx,my+cy). }
		else if map[cx][cy] = "1001" { print "▚" at(mx+cx,my+cy). }
		else if map[cx][cy] = "1010" { print "▐" at(mx+cx,my+cy). }
		else if map[cx][cy] = "1011" { print "▜" at(mx+cx,my+cy). }
		else if map[cx][cy] = "1100" { print "▄" at(mx+cx,my+cy). }
		else if map[cx][cy] = "1101" { print "▙" at(mx+cx,my+cy). }
		else if map[cx][cy] = "1110" { print "▟" at(mx+cx,my+cy). }
		else if map[cx][cy] = "1111" { print "█" at(mx+cx,my+cy). }
	
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