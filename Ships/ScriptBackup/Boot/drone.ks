
// local module_list is M1:allmodules.
print "abcd".
SET M1 TO SHIP:PARTSTAGGED("m1")[0].
SET M2 TO SHIP:PARTSTAGGED("m2")[0].
SET M3 TO SHIP:PARTSTAGGED("m3")[0].
SET M4 TO SHIP:PARTSTAGGED("m4")[0].

local m1 is M1:getmodule("ModuleRoboticServoRotor"). 
local m2 is M2:getmodule("ModuleRoboticServoRotor"). 
local m3 is M3:getmodule("ModuleRoboticServoRotor"). 
local m4 is M4:getmodule("ModuleRoboticServoRotor"). 

local c_throttle is 50.
local c_rotation is 17.
local c_yaw is 1.
local c_pitch is 1.
local c_roll is 1.

// print motor.
// local event_list is motor:alleventnames.
// for this_event in event_list {
//     print this_event.
    // if this_event:contains(module_event) {
    //     this_part:getmodule(this_module):doevent(this_event).
    // }
// }
// print "".
// for  this_module in module_list {
    // local event_list is m1:getmodule(this_module):alleventnames.
    // print this_module.
    // for this_event in event_list {
    //     print this_event.
        // if this_event:contains(module_event) {
        //     this_part:getmodule(this_module):doevent(this_event).
        // }
    // }
// }
// print "". 
// local events is m1:allactions.
// print events.

// print "[" + m1:getfield("brake") + ", " +  m2:getfield("brake") + ", " + m3:getfield("brake") + ", " + m4:getfield("brake") + "]".

// Create a GUI window
LOCAL my_gui IS GUI(500).
set my_gui:x to 100.
set my_gui:y to 200.
set my_gui:draggable to true.
set my_gui:style:align to "LEFT". 

// Add widgets to the GUI
LOCAL gui_title IS my_gui:ADDLABEL("Allan's drone control!").
SET gui_title:STYLE:ALIGN TO "LEFT".
SET gui_title:STYLE:HSTRETCH TO True. // Fill horizontally
LOCAL gui_data0 IS my_gui:ADDLABEL("").
SET gui_data0:STYLE:ALIGN TO "LEFT".
SET gui_data0:STYLE:HSTRETCH TO True. // Fill horizontally
LOCAL gui_data1 IS my_gui:ADDLABEL("").
SET gui_data1:STYLE:ALIGN TO "LEFT".
SET gui_data1:STYLE:HSTRETCH TO True. // Fill horizontally
LOCAL gui_data2 IS my_gui:ADDLABEL("").
SET gui_data2:STYLE:ALIGN TO "LEFT".
SET gui_data2:STYLE:HSTRETCH TO True. // Fill horizontally

LOCAL ok TO my_gui:ADDBUTTON("OK").

my_gui:SHOW().

function update_gui{
    // SET gui_data0:TEXT TO "(YAW, PITCH, ROLL) = (" + SHIP:CONTROL:PILOTROTATION:X:TOSTRING + ", " + SHIP:CONTROL:PILOTROTATION:Y:TOSTRING + ", " + SHIP:CONTROL:PILOTROTATION:Z:TOSTRING + ")".
    SET gui_data0:TEXT TO "(YAW, PITCH, ROLL) = (" + ROUND(SHIP:FACING:YAW,5):TOSTRING + ", " + ROUND(SHIP:FACING:PITCH,5):TOSTRING + ", " + ROUND(SHIP:FACING:ROLL,5):TOSTRING + ")".
    SET gui_data1:TEXT TO "(LATITUDE, LONGITUDE) = (" + ROUND(SHIP:GEOPOSITION:LAT,5):TOSTRING + ", " + ROUND(SHIP:GEOPOSITION:LNG,5):TOSTRING + ")".
    SET gui_data2:TEXT TO "Torque (M1, M2, M3, M4) = (" + m1:getfield("torque limit(%)") + ", " + m2:getfield("torque limit(%)") + ", " + m3:getfield("torque limit(%)") + ", " + m4:getfield("torque limit(%)") + ")".
    // print SHIP:UP:FOREVECTOR.
    SET fore TO VECDRAW(
        V(0,0,0),
        SHIP:UP:FOREVECTOR,
        RGB(1,0,0),
        "SHIP:UP:FORE",
        5.0,
        TRUE,
        0.2,
        TRUE,
        TRUE
    ).
    // print SHIP:UP:TOPVECTOR.
    SET top TO VECDRAW(
        V(0,0,0),
        SHIP:UP:TOPVECTOR,
        RGB(1,0,0),
        "SHIP:UP:TOP",
        5.0,
        TRUE,
        0.2,
        TRUE,
        TRUE
    ).
    // print SHIP:UP:STARVECTOR.
    SET star TO VECDRAW(
        V(0,0,0),
        SHIP:UP:STARVECTOR,
        RGB(1,0,0),
        "SHIP:UP:STAR",
        5.0,
        TRUE,
        0.2,
        TRUE,
        TRUE
    ).
}

function myClickChecker {
    my_gui:HIDE().
}

function pid_fusion{
    Parameter pid_alt_out.
    Parameter pid_yaw_out.
    Parameter pid_pitch_out.
    Parameter pid_roll_out.

    set m1_throt to max(c_throttle*pid_alt_out + c_rotation*(-1*c_yaw*pid_yaw_out + -1*c_pitch*pid_pitch_out +    c_roll*pid_roll_out),0).
    set m2_throt to max(c_throttle*pid_alt_out + c_rotation*(-1*c_yaw*pid_yaw_out +    c_pitch*pid_pitch_out + -1*c_roll*pid_roll_out),0).
    set m3_throt to max(c_throttle*pid_alt_out + c_rotation*(   c_yaw*pid_yaw_out +    c_pitch*pid_pitch_out +    c_roll*pid_roll_out),0).
    set m4_throt to max(c_throttle*pid_alt_out + c_rotation*(   c_yaw*pid_yaw_out + -1*c_pitch*pid_pitch_out + -1*c_roll*pid_roll_out),0).
    // set m1_throt to max(c_throttle*pid_alt_out + c_rotation*(-1*c_yaw*SHIP:CONTROL:PILOTROTATION:X + -1*c_pitch*SHIP:CONTROL:PILOTROTATION:Y +    c_roll*SHIP:CONTROL:PILOTROTATION:Z),0).
    // set m2_throt to max(c_throttle*pid_alt_out + c_rotation*(-1*c_yaw*SHIP:CONTROL:PILOTROTATION:X +    c_pitch*SHIP:CONTROL:PILOTROTATION:Y + -1*c_roll*SHIP:CONTROL:PILOTROTATION:Z),0).
    // set m3_throt to max(c_throttle*pid_alt_out + c_rotation*(   c_yaw*SHIP:CONTROL:PILOTROTATION:X +    c_pitch*SHIP:CONTROL:PILOTROTATION:Y +    c_roll*SHIP:CONTROL:PILOTROTATION:Z),0).
    // set m4_throt to max(c_throttle*pid_alt_out + c_rotation*(   c_yaw*SHIP:CONTROL:PILOTROTATION:X + -1*c_pitch*SHIP:CONTROL:PILOTROTATION:Y + -1*c_roll*SHIP:CONTROL:PILOTROTATION:Z),0).
    
    return list(m1_throt, m2_throt, m3_throt, m4_throt).
}

SET ok:ONCLICK TO myClickChecker@. // This could also be an anonymous function instead.

SET ipc1 TO PROCESSOR("c1").
SET ipc2 TO PROCESSOR("c2").
SET ipc3 TO PROCESSOR("c3").
SET ipc4 TO PROCESSOR("c4").

SET pid_altitude TO PIDLOOP(0.1, 0.10, 0, 0, 1, 0).
SET pid_altitude:setpoint to 500.
SET mythrot to 0.

SET pid_yaw TO PIDLOOP(0.1, 0.10, 0, -1, 1, 0).
SET pid_yaw:setpoint to SHIP:UP:YAW.

SET pid_pitch TO PIDLOOP(0.1, 0.10, 0, -1, 1, 0).
SET pid_pitch:setpoint to SHIP:UP:pitch.

SET pid_roll TO PIDLOOP(0.1, 0.10, 0, -1, 1, 0).
SET pid_roll:setpoint to SHIP:UP:roll.

// run "0:boot/drone.ks".
// best you can get is 50hz physics ticks, but script may be running faster 
until 0{
    // print "here".
    update_gui().
    
    SET pid_yaw:setpoint to SHIP:UP:YAW.
    SET pid_pitch:setpoint to SHIP:UP:pitch.
    SET pid_roll:setpoint to SHIP:UP:roll.

    set pid_alt_out to pid_altitude:UPDATE(TIME:SECONDS, ALTITUDE).
    set pid_yaw_out to pid_yaw:UPDATE(TIME:SECONDS, SHIP:FACING:YAW).
    set pid_pitch_out to pid_pitch:UPDATE(TIME:SECONDS, SHIP:FACING:PITCH).
    set pid_roll_out to pid_roll:UPDATE(TIME:SECONDS, SHIP:FACING:ROLL).
    set throttle_out to pid_fusion(pid_alt_out, pid_yaw_out, pid_pitch_out, pid_roll_out). 
    // print mythrot.
    // print SHIP:FACING. 
    // ipc1:CONNECTION:SENDMESSAGE(mythrot).
    ipc1:CONNECTION:SENDMESSAGE(throttle_out[0]).
    ipc2:CONNECTION:SENDMESSAGE(throttle_out[1]).
    ipc3:CONNECTION:SENDMESSAGE(throttle_out[2]).
    ipc4:CONNECTION:SENDMESSAGE(throttle_out[3]).
    print round(time:seconds,4) + " | [" + round(throttle_out[0],4) + ", " + round(throttle_out[1],4) + ", " + round(throttle_out[2],4) + ", " + round(throttle_out[3],4) + "]".
    // print SHIP:FACING.
    // SET PREV_TIME to TIME:SECONDS.
    
    wait 0.02.
}
