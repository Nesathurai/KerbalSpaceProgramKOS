
SET M1 TO SHIP:PARTSTAGGED("m1")[0].
SET M2 TO SHIP:PARTSTAGGED("m2")[0].
SET M3 TO SHIP:PARTSTAGGED("m3")[0].
SET M4 TO SHIP:PARTSTAGGED("m4")[0].

local m1 is M1:getmodule("ModuleRoboticServoRotor"). 
local m2 is M2:getmodule("ModuleRoboticServoRotor"). 
local m3 is M3:getmodule("ModuleRoboticServoRotor"). 
local m4 is M4:getmodule("ModuleRoboticServoRotor"). 

// m1:setfield("brake",1).
// m2:setfield("brake",1).
// m3:setfield("brake",1).
// m4:setfield("brake",1).

// print m1:setfield("torque limit(%)",0).
// print m2:setfield("torque limit(%)",0).
// print m3:setfield("torque limit(%)",0).
// print m4:setfield("torque limit(%)",0).


function motor_firmware{
    // (YAW,PITCH,ROLL)
    // Parameter current_state.
    Parameter desired_state.

    local controller_name is CORE:TAG.

    if controller_name = "c1"{
        // m1:setfield("torque limit(%)",max(c_throttle*SHIP:CONTROL:PILOTMAINTHROTTLE + c_rotation*(-1*c_yaw*SHIP:CONTROL:PILOTROTATION:X + -1*c_pitch*SHIP:CONTROL:PILOTROTATION:Y +    c_roll*SHIP:CONTROL:PILOTROTATION:Z),0)).
        m1:setfield("torque limit(%)",desired_state).
    }
    else if controller_name = "c2"{
        m2:setfield("torque limit(%)",desired_state).
    }
    else if controller_name = "c3"{
        m3:setfield("torque limit(%)",desired_state).
    }
    else if controller_name = "c4"{
        m4:setfield("torque limit(%)",desired_state).
    }
    else{
        print "invalid controller (not c1, c2, c3, c4)!".
    }
}

// for child in m1:children {
//     print child.
// }

// m1:setfield("brake",m1:getfield("brake") + (   x_intensity*SHIP:CONTROL:PILOTROTATION:X + -1*y_intensity*SHIP:CONTROL:PILOTROTATION:Y +    z_intensity*SHIP:CONTROL:PILOTROTATION:Z)).
// m2:setfield("brake",m2:getfield("brake") + (-1*x_intensity*SHIP:CONTROL:PILOTROTATION:X +    y_intensity*SHIP:CONTROL:PILOTROTATION:Y +    z_intensity*SHIP:CONTROL:PILOTROTATION:Z)).
// m3:setfield("brake",m3:getfield("brake") + (   x_intensity*SHIP:CONTROL:PILOTROTATION:X +    y_intensity*SHIP:CONTROL:PILOTROTATION:Y + -1*z_intensity*SHIP:CONTROL:PILOTROTATION:Z)).
// m4:setfield("brake",m4:getfield("brake") + (-1*x_intensity*SHIP:CONTROL:PILOTROTATION:X + -1*y_intensity*SHIP:CONTROL:PILOTROTATION:Y + -1*z_intensity*SHIP:CONTROL:PILOTROTATION:Z)).

// print "[" + m1:getfield("brake") + ", " +  m2:getfield("brake") + ", " + m3:getfield("brake") + ", " + m4:getfield("brake") + "]".
// print "[" + m1:getfield("torque limit(%)") + ", " +  m2:getfield("torque limit(%)") + ", " + m3:getfield("torque limit(%)") + ", " + m4:getfield("torque limit(%)") + "]".

// WAIT UNTIL NOT CORE:MESSAGES:EMPTY. // make sure we've received something
// SET RECEIVED TO CORE:MESSAGES:POP.
until 0{
    WAIT UNTIL NOT CORE:MESSAGES:EMPTY. // make sure we've received something
    SET RECEIVED TO CORE:MESSAGES:POP.  
    print RECEIVED:CONTENT + " @ " + RECEIVED:SENTAT.
    motor_firmware(RECEIVED:CONTENT).
    // IF RECEIVED:CONTENT = "undock" {
    //     // PRINT "Undocking!!!".
    //     print TIME:SECONDS.
    //     // UNDOCK().
    // } ELSE {
    //     PRINT "Unexpected message: " + RECEIVED:CONTENT.
    // }
    wait 0.02. 
}
