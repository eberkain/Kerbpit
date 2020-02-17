# Kerbpit

This is a project to build a KSP desktop simpit 
  The general idea is to build custom kOS scripts to control throttle and steering
  All other systems are manually controlled via tactile switches
  kOS scripts are used to monitor ship systems and generate manuvre nodes
  The main game window should see minimal use to the point where it can simply display a camera view

Kerbpit.ahk is an AutoHotKey script that is used to interface custom controllers KSP
  Controls can be bound to direct in-game actions
  Controls can send simulated keypresses to ksp
  Controls can send complex commands to kOS

kOS is used to operate 4 simultanious MFD screens on side monitors  
  MFD1 contains a orbit status display
  MFD2 contains a vessel status display
  MFD3 runs autopilot programs that control steering and throttle
  MFD4 is a flight computer that creates nav nodes
  MFD0 is a hidden terminal used to send complex commands via AHk
  
Custom built controllers are used to shortcut common actions, each controller can support 32 buttons and 8 analog axis
  Flight Computer is the right side console and used to interface with MFDS and provide analog controls
    4 keyswitch-Select button allows you to choose what MFD to send commands to
    1 keyswitch-master to send to all MFD terminal windows
    1 keyswitch-input to send to hidden input term
    18 keyswitch-letter/number buttons are used to pick a program (A-F,0-9,decimal,minus)
    1 keyswitch-list button will display a list of programs for that MFD
    1 keyswitch-Run button begins a kOS run command
    1 keyswitch-exec button is used to start the program
    1 keyswitch-end button is used to stop a program
    1 keyswitch-reset button to reset the mfd terminal window if something goes awry
    1 keyswitch-reboot button to relog the terminals without chanigng windows
    1 keyswitch-local button to switch to local drive
    1 keyswitch-archive button to switch to archive
    1 keyswitch-copy button to copy a program to local
    2 thumbstick-RCS axis controls linear (up,down,left,right)(fore,back)
    2 thumbstick-RCS axis control rotation (pitch,yaw)(roll)
    4 slide pot robotics controls, single axis. 
    8 keyswitch-robotics controls
    12 mini buttons-mfd interface extentions
  Navigation Controller is the left side console and is used to manipulate autopilot programs and manuvre nodes
    10 keyswitch-tweak +/- buttons for HDG, ALT, SPD, MAXROLL, MAXVSPD
    3 3-way toggle-rate adjustment controls how much to add/sub per press
    4 keyswitch-Execute shortcuts to launch commonly used autopilot programs directly to MFD3
      Launch, Land, Exec Node, Atmo Autopilot
    1 keyswitch-kill the current autopilot
    4 keyswitch-time control buttons to control time warp +/- norm/phys
    3 keyswitch-change the navball mode
    3 dials-aircraft trim dials
    6 keyswitch-+/- buttons for Prograde, Radial, Normal
    1 3-way toggle-rate switch for amount to change dev by
    2 keyswitch-+/- node time control
    1 3-way toggle-for rate of time change
    11 keyswitch-sas controls for each mode and on/off
    12 mini buttons-mfd interface extentions
  Overhead Panel
    various controls for all onboard systems, see controls.txt
    send commands to MFD0 to activate in-game action based on button pressed
