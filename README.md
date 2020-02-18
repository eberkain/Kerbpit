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
  
Custom built controllers are used to shortcut common actions, each control board can support 32 buttons and 8 analog axis
  Flight Computer is the right side console and used to interface with MFDS and provide analog controls, 2 boards
    6 keyswitch-Select button allows you to choose what MFD to send commands to (#, master, input for 5)
          controls an interal AHK value that is used to direct send commands
    4 keyswitch-launch program buttons (situation, vessel status, navigation, list)
          sends a run script command to the selected mfd
    15 keyswitch-number buttons are used to send parameters to programs (A-C,0-9,decimal,minus)
          each sends a single character to the selected mfd
          A - autopilot prog, B - main prog, C - Utility prog
    9 keyswitch-function buttons
          stop-is used to stop a program
          reset-to reset the mfd terminal window if something goes awry
          reboot-to relog the terminals without chanigng windows
          local-to switch to local drive
          archive-to switch to archive
          run-start a kos run command
          exec-finish a run command
          back-backspace button
          ???
    6 mini stem switch-robotics controls
          generic numbered actions that can be bound to robotics commands
    24 mini buttons-mfd interface strips, rj45 extenders
          send actions to mfd5 to toggle reserved action groups which are monitored by programs
    A-3 2xthumbstick-movement controls linear (up,down,left,right)(fore,back)
    A-3 2xthumbstick-movement control rotation (pitch,yaw)(roll)
    A-4 slide pot robotics controls, single axis. 
    D-1  toggle switch for backlight
  Navigation Controller is the left side console and is used to manipulate autopilot programs and manuvre nodes, 2 boards
    10 mini stem switch-trim buttons +/- for HDG, ALT, SPD, MAXROLL, MAXVSPD
          run adjust script on mfd0 to change var, which is then read in by autopilot script later
    9  3x3pos rot switch-rate adjustment controls how much to add/sub per press, hdg, alt, spd
          change var in AHK which is used by trim buttons 
    4  2x2pos rot switch-rate adjust for maxroll, maxvspd
          change var in AHK which is used by trim buttons 
    6 keyswitch-Execute shortcuts to launch prog (Launch, Land, Node, Atmo, stop, ???)
          run program directly on mfd3
    4 keyswitch-time control buttons to control time warp +/- norm/phys
          simulate keypresses sent to KSP window
    3 keyswitch-change the navball mode
          send command to mfd0 to change mode
    8 switch-+/- buttons for Prograde, Radial, Normal, time
          send command to mfd0 to tweak next man node
    6  2x3pos rot switch-rate switch for amount to change (node, 0.01, 0.1, 1)(node time, 1s, 10s, 1m)
          change the rate of the value that is tweaked by node buttons
    2  1xtoggle switch(ON-OFF-ON)-sas on/off
          send action to mfd0 to turn sas on/off
          power leds for mode select only in on position
    10 keyswitch-sas controls for each mode
          send command to mfd0 to select mode          
    A-3 rotary pots-aircraft trim dials
    A-2 slide pots-engine throttle axis with locking lever
    D-1  toggle switch for backlight
  Overhead Panel
    various controls for all onboard systems, see controls.txt
        send commands to MFD0 to activate in-game action based on button pressed