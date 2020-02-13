// MFD Autopilot - real-time adjuster
// by Jonathan Medders  'EberKain'
//
// What we are doing here is making a running program interactive
// We get triggered by a joystick button in AHK that calls this script
// The script reads in the autopilot json, tweaks it based on the params
// and rewrites back out the autopilot json
//
//	autopilot json is a lexicon data struct
//		heading
//		altitude
//		speed
//		maxroll
//		maxvspd

//collect the passed params
parameter pHdg, pAlt, pSpd, pMrl, pMsp.

//first read in the data
set LEX TO READJSON("autopilot.json").

//then apply adjustmens from params
set LEX["hdg"] to LEX["hdg"] + pHdg.
set LEX["alt"] to LEX["alt"] + pAlt.
set LEX["spd"] to LEX["spd"] + pSpd.
set LEX["mrl"] to LEX["mrl"] + pMrl.
set LEX["mvs"] to LEX["mvs"] + pMsp.

//then write the lexicon back to a json
writejson(LEX,"autopilot.json").