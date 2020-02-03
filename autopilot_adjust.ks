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
set LEX["heading"] to LEX["heading"] + pHdg.
set LEX["altitude"] to LEX["altitude"] + pAlt.
set LEX["speed"] to LEX["speed"] + pSpd.
set LEX["maxroll"] to LEX["maxroll"] + pMrl.
set LEX["maxvspd"] to LEX["maxvspd"] + pMsp.

//then write the lexicon back to a json
writejson(LEX,"autopilot.json").