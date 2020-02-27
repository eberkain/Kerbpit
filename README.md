# Kerbpit

## Overview

### This is a project to build a KSP desktop simpit 
* The general idea is to build custom kOS scripts to control throttle and steering
* Most systems are manually controlled via tactile switches that send kOS commands via AHK keybinds
* kOS scripts are used to monitor ship systems and generate manuvre nodes using MFDS
* The main game window should see minimal use to the point where it can simply display a camera or map view
* Controls can be bound to direct in-game actions
* AHK can send simulated keypresses to ksp
* AHK can send complex commands to kOS to run scripts or perform game actions

### Files
* Kerbpit.ahk is an AutoHotKey script that is used to interface custom controllers KSP
* Actions.csv lists all the action groups, what they do, tactile button type, keybind
* /kOS contains all the kOS scripts
* /3D contains all the 3d printer model files

kOS is used to operate 4 simultanious MFD screens on side monitors  
* In general the MFDs are situation status, vessel status, autopilot, navigation
* The scripts are designed so any program can be run on any mfd 
* the MFD scripts support 6 action buttons that can be either mounted on the top or bottom



## MFD Programs

<img src="https://i.imgur.com/r8E8BcJ.png" alt="" width="200" height="200">

### Navigation Program Features - MFD4
* Generates manuvre nodes based on the parameters given
* In general you specific an type of manuvre, when you execute it, and then any console input
* Supports Free Node - Circulize, Change Orbit (Ap, Pe, Incl, Ecc), Return from Moon
* Supports Target Node - Match Plane, Hohman Transfer, Match Velo, Approach 
* Supports Landing Node - Cross Plane at Coord, Deorbit 

<img src="https://i.imgur.com/EQRwYrf.png" alt="" width="200" height="200"> <img src="https://i.imgur.com/p8G04dM.png" alt="" width="200" height="200"> <img src="https://i.imgur.com/OdGHPVg.png" alt="" width="200" height="200"> 

### Vessel Status Program Features	- MFD2	
* Resource summary by vessel or stage 	
* dynamically fills the list and only calculates important resrouces
* List of all cameras - Allow selection and switching views
* System Controller - activate/deactivate systems like fuel cells, isru, drills, 
		
<img src="https://i.imgur.com/h5i7wb1.png" alt="" width="200" height="200">  <img src="https://i.imgur.com/eevgVyW.png" alt="" width="200" height="200">		

### Situation Status Program Features - MFD1	
* Summary - Main Menu - shows root list plus base list for orbit, surf, land
* Orbit - shows root list, orbit base and adv list, plus diagram of curr orbit and position
* Surface - shows root list, surface base and adv list, plus altitude graph over time 
* Landing - shows root list, landing base and adv list, plus surface terrain crosssection
* Target - shows root list, target base and adv list, plus ??? 
* Target Selection - provide a list of targets and allow user to make selection
	
<img src="https://i.imgur.com/15DyPmC.png" alt="" width="200" height="200">

### Autopilot Programs - MFD3
* each program controls steering and throttle
* some programs include override buttons to alter runtime execution
* some programs utilize the ap adjuster to allow for tweaking of parameters during flight
* Programs include: Launh to Orbit, Execute Next Node, Perform Landing, Atmospheric Autopilot, Docking 

# Custom Controllers 
Each control board can support 32 buttons and 8 analog axis.
Suggested control board is [Leo Bodnar BU0836A 12-Bit Joystick Controller](http://www.leobodnar.com/shop/index.php?main_page=product_info&cPath=94&products_id=204).

![](https://i.imgur.com/YMd97cB.png)
### Flight Computer 
the right side console and used to operate mfds, 2 boards
* 6 keyswitch-Select button allows you to choose what MFD to send commands to (#, master, input for 5)
    - controls an interal AHK value that is used to direct send commands
* 4 keyswitch-launch program buttons (situation, vessel status, navigation, list)
    - sends a run script command to the selected mfd
* 15 keyswitch-number buttons are used to send parameters to programs (A-C,0-9,decimal,minus)
    - each sends a single character to the selected mfd
    - A - autopilot prog, B - main prog, C - Utility prog
* 9 keyswitch-function buttons
    - stop-is used to stop a program
    - reset-to reset the mfd terminal window if something goes awry
    - reboot-to relog the terminals without chanigng windows
    - local-to switch to local drive
    - archive-to switch to archive
    - run-start a kos run command
    - exec-finish a run command
    - back-backspace button
    - ???
* 6 mini pushbutton-robotics controls
    - generic numbered actions that can be bound to robotics commands
* 24 mini buttons-mfd interface strips, rj45 extenders
    - send actions to mfd5 to toggle reserved action groups which are monitored by programs
* A-3 2xthumbstick-movement controls linear (up,down,left,right)(fore,back)
* A-3 2xthumbstick-movement control rotation (pitch,yaw)(roll)
* A-4 slide pot robotics controls, single axis. 
* D-2  rocker switch for backlight (console, mfds)
    
![](https://i.imgur.com/wJTARCr.png)
### Navigation Controller 
the left side console and is used to manipulate autopilot, 2 boards
* 6 pushbutton-trim buttons +/- for HDG, ALT, SPD
    - run adjust script on mfd0 to change var, which is then read in by autopilot script later
* 10  3xrot switch-rate adjustment controls how much to add/sub per press, hdg, alt, spd
    - change var in AHK which is used by trim buttons 
* 5 keyswitch-Execute shortcuts to launch prog (Launch, Land, Node, Atmo, Dock)
    - run program directly on mfd3
* 4 pushbutton-time control buttons to control time warp +/- norm/phys
    - simulate keypresses sent to KSP window
* 3 keyswitch-change the navball mode
    - send command to mfd0 to change mode
* 8 pushbutton-+/- buttons for Prograde, Radial, Normal, time
    - send command to mfd0 to tweak next man node
* 8  2xrot switch-rate switch for amount to change (node, 0.01, 0.1, 1)(node time, 1s, 10s, 1m)
    - change the rate of the value that is tweaked by node buttons
* 2  1xtoggle switch(ON-OFF-ON)-sas on/off
    - send action to mfd0 to turn sas on/off
    - power leds for mode select only in on position
* 10 keyswitch-sas controls for each mode
    - send command to mfd0 to select mode     
* A-2 thumbstick-camera control (horiz, vert)
* A-3 rotary pots-aircraft trim dials
* A-2 slide pots-engine throttle axis with locking lever
* D-1  toggle switch for backlight

### Overhead Panel
* various controls for all onboard systems, see controls.txt
    - send commands to MFD0 to activate in-game action based on button pressed

# SETUP
You will need a monospace font that supports line drawing, boxes and arrows.  I use [Unifont](http://www.unifoundry.com/unifont/index.html) in all screenshots.  

### Putty
setting up saved sessions, fonts, etc...

### Kerbal Operating System
You need to install the mod and any dependencies. 
place all the kOS scripts into the archive folder for your install.  KSP/Saves/Scripts typically

### Auto Hot Key
You have to install the AutoHotKey program to use the scripts.  

### KSP
change keybindings

### AGX
update keybindings
