// @lazyglobal off.
@clobberbuiltins off.

SET M1 TO SHIP:PARTSTAGGED("m1")[0].
SET M2 TO SHIP:PARTSTAGGED("m2")[0].
SET M3 TO SHIP:PARTSTAGGED("m3")[0].
SET M4 TO SHIP:PARTSTAGGED("m4")[0].

global m1 is M1:getmodule("ModuleRoboticServoRotor").
global m2 is M2:getmodule("ModuleRoboticServoRotor").
global m3 is M3:getmodule("ModuleRoboticServoRotor").
global m4 is M4:getmodule("ModuleRoboticServoRotor").

SET ipc1 TO PROCESSOR("c1").
SET ipc2 TO PROCESSOR("c2").
SET ipc3 TO PROCESSOR("c3").
SET ipc4 TO PROCESSOR("c4").

global c_throttle is 2.0.
global c_rotation is 0.5.
global c_pitch is 1.0.
global c_roll is 1.0.
global c_yaw_input is 100.
global c_pitch_input is 10.
global c_roll_input is 10.
