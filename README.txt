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
    6 keyswitch-Select button allows you to choose what MFD to send commands to (#, master, input for 5)
          controls an interal AHK value that is used to direct send commands
    6 keyswitch-launch program buttons (situation, vessel status, navigation, etc...)
          sends a run script command to the selected mfd
    12 keyswitch-number buttons are used to send parameters to programs (0-9,decimal,minus)
          each sends a single character to the selected mfd
    1 keyswitch-list button will display a list of programs for that MFD
    1 keyswitch-Run button begins a kOS run command
    1 keyswitch-exec button is used to start the program
    1 keyswitch-end button is used to stop a program
    1 keyswitch-reset button to reset the mfd terminal window if something goes awry
    1 keyswitch-reboot button to relog the terminals without chanigng windows
    1 keyswitch-local button to switch to local drive
    1 keyswitch-archive button to switch to archive
    1 keyswitch-copy button to copy a program to local, launches a batch prog
    A-2 thumbstick-RCS axis controls linear (up,down,left,right)(fore,back)
    A-2 thumbstick-RCS axis control rotation (pitch,yaw)(roll)
    A-4 slide pot robotics controls, single axis. 
    6 keyswitch-robotics controls
    24 mini buttons-mfd interface strips, rj45 extenders
        send actions to mfd5 to toggle reserved action groups which are monitored by programs
  Navigation Controller is the left side console and is used to manipulate autopilot programs and manuvre nodes
    10 keyswitch-tweak +/- buttons for HDG, ALT, SPD, MAXROLL, MAXVSPD
    9b  3 3pos rot switch-rate adjustment controls how much to add/sub per press, hdg, alt, spd
    4b  2 2pos rot switch-rate adjust for maxroll, maxvspd
    6 keyswitch-Execute shortcuts to launch commonly used autopilot programs directly to MFD3
          Launch, Land, Exec Node, Atmo Autopilot, etc...
    1 keyswitch-kill the current autopilot
    4 keyswitch-time control buttons to control time warp +/- norm/phys
    3 keyswitch-change the navball mode
    A-3 dial pots-aircraft trim dials
    6 keyswitch-+/- buttons for Prograde, Radial, Normal
    2 keyswitch-+/- node time control
    6b  2 3pos rot switch-rate switch for amount to change (node, node time)
    11 keyswitch-sas controls for each mode and on/off
  Overhead Panel
    various controls for all onboard systems, see controls.txt
        send commands to MFD0 to activate in-game action based on button pressed
