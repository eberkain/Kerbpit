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
