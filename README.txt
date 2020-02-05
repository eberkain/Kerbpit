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
  Flight Computer is used to interface with MFDS and control what is displayed
    4 keyswitch-Select button allows you to choose what MFD to send commands to
    1 keyswitch-list button will display a list of programs for that MFD
    1 keyswitch-Run button begins a kOS run command
    17 keyswitch-letter/number buttons are used to pick a program (A-F,0-9,decimal)
    1 keyswitch-exec button is used to start the program
    1 keyswitch-end button is used to stop a program
    1 keyswitch-reset button to reset the mfd terminal window if something goes awry
    1 keyswitch-master reset to reset all MFD terminal windows
    1 keyswitch-master reboot to relog into all CPUs without resetting terminals, for switching craft
    4 thumbstick-RCS axis controls, linear xyz, rotation xyz
  Autopilot controller is used to interact with running programs to tweak autopilot
    10 keyswitch-tweak +/- buttons for HDG, ALT, SPD, MAXROLL, MAXVSPD
    3 3-way toggle-rate adjustment controls how much to add/sub per press
    4 keyswitch-Execute shortcuts to launch commonly used autopilot programs directly to MFD3
      Launch, Land, Exec Node, Atmo Autopilot
    1 keyswitch-kill the current autopilot
    4 keyswitch-time control buttons to control time warp +/- norm/phys
    3 keyswitch-change the navball mode
    3 dials-aircraft trim dials
  Navigation Controller manipulates manuvre nodes
    6 keyswitch-+/- buttons for Prograde, Radial, Normal
    1 3-way toggle-rate switch for amount to change dev by
    2 keyswitch-+/- node time control
    1 3-way toggle-for rate of time change
    11 keyswitch-sas controls for each mode and on/off
  Overhead Panel
    various controls for all onboard systems
    bind actions to groups in-game using AGX
    send commands to MFD0 to active group based on button pressed
  MFD Controls
    Each MFD has a strip of 6 buttons that can be used to directly interact with programs
    This is done by tying the buttons to action groups
    kOS has the ability to monitor action groups and react to button presses
    24 AGX groups are reserved for this feature
