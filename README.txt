# Kerbpit

This is a project to build a KSP simpit 

AutoHotKey is used to interface custom controllers KSP
  Controls can be bound to direct in-game actions
  Controls can send simulated keypresses to ksp
  Controls can send complex commands to kOS

kOS is used to operate 4 simultanious MFD screens on side monitors  
  MFD1 contains a orbit status display
  MFD2 contains a vessel status display
  MFD3 runs autopilot programs that control steering and throttle
  MFD4 is a flight computer that creates nav nodes
  MFD0 is a hidden terminal used to send complex commands via AHk
  
Custom built controllers are used to shortcut common actions
  Flight Computer is used to interface with MFDS and control what is displayed
    Select button (4) allows you to choose what MFD to send commands to
    list button will display a list of programs for that MFD
    Run button begins a kOS run command
    letter/number buttons are used to pick a program
    exec button is used to start the program
    end button is used to stop a program
    reset button to reset the mfd window if something goes awry
  Autopilot controller is used to interact with running programs to adjust params
    tweak +/- buttons for HDG, ALT, SPD, etc...
    rate toggles to control how much to add/sub per press
    Execute shortcuts to launch commonly used autopilot programs directly to MFD3
    time control buttons to control time warp
    conf warp-to buttoms for common events
    aircraft trim dials
  Navigation Controller manipulates manuvre nodes
    +/- buttons for Prograde, Radial, Normal
    3-way toggle switch for rate of +/-
    +/- node time control
    3-way toggle switch for rate of +/- time
    sas controls for each mode and on/off
    navball mode switch
  Overhead Panel
    various controls for all onboard systems
    bind actions to groups in-game using AGX
    send commands to MFD0 to active group based on button pressed
  MFD Controls
    Each MFD has a strip of 6 buttons that can be used to directly interact with programs
    This is done by tying the buttons to action groups
    kOS has the ability to monitor action groups and react to button presses
    24 AGX groups are reserved for this feature
