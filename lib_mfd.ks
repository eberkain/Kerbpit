// MFD Function Library
// by Jonathan Medders  'EberKain'
//
// just some things to shortcut code elsewhere




//print a progress bar at the location with the number of segments that represents the value
local minstrmas to "……………………………………………………………………………………………………………………………………………………………………………………".
local maxstrmas to "▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒".
function mfd_progress {

	//get the params
	parameter mx, my, seg, pct.

	//create substrings the right length
	set minstr to minstrmas:substring(0,seg).
	set maxstr to maxstrmas:substring(0,seg).
	
	//decide where to splice the strings
	set cutpt to round(pct*seg,0).
	
	//take first part from minstr and second part from maxstr
	print minstr:substring(0,seg-cutpt) + maxstr:substring(0,cutpt) at (mx,my).
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
	return dval+"°"+mval+"'"+sval+char(34)+ttag.
}