run "0:boot/common.ks".
run "0:boot/lib_nav.ks".
run "0:boot/pid_gui.ks".

function aot_pid_fusion{
    Parameter pid_alt_out.
    Parameter pid_yaw_out.
    Parameter pid_pitch_out.
    Parameter pid_roll_out.

    set m1_aot to 20*((c_throttle*pid_alt_out + c_rotation*(-1*c_pitch*pid_pitch_out + -1*c_roll*pid_roll_out))/(c_throttle + c_rotation + c_pitch + c_roll)).
    set m2_aot to 20*((c_throttle*pid_alt_out + c_rotation*(   c_pitch*pid_pitch_out + -1*c_roll*pid_roll_out))/(c_throttle + c_rotation + c_pitch + c_roll)).
    set m3_aot to 20*((c_throttle*pid_alt_out + c_rotation*(   c_pitch*pid_pitch_out +    c_roll*pid_roll_out))/(c_throttle + c_rotation + c_pitch + c_roll)).
    set m4_aot to 20*((c_throttle*pid_alt_out + c_rotation*(-1*c_pitch*pid_pitch_out +    c_roll*pid_roll_out))/(c_throttle + c_rotation + c_pitch + c_roll)).

    return list(m1_aot, m2_aot, m3_aot, m4_aot).
}

function brake_pid_fusion{
    Parameter pid_yaw_out.
    set m1_brake to -1*pid_yaw_out.
    set m2_brake to    pid_yaw_out.
    set m3_brake to -1*pid_yaw_out.
    set m4_brake to    pid_yaw_out.
    return list(m1_brake, m2_brake, m3_brake, m4_brake).
}

// best you can get is 50hz physics ticks, but script may be running faster
until 0{
    update_gui().
    update_gui_pid(gui_v5:value).
    // print m1:allactions.
    // print m1:alleventnames.
    // print m1:part:children.
    
    if (going_to_waypoint = false){
        SET pids["altitude"]:setpoint   to 500.0.
        SET pids["yaw"]:setpoint        to 0.0 + c_yaw_input*SHIP:CONTROL:PILOTROTATION:X. 
        SET pids["pitch"]:setpoint      to 0.0 + c_pitch_input*SHIP:CONTROL:PILOTROTATION:Y.
        SET pids["roll"]:setpoint       to 0.0 + c_roll_input*SHIP:CONTROL:PILOTROTATION:Z.
    }
    else{
        if(SHIP:ALTITUDE <= 200){
            set pids["altitude"]:setpoint to current_waypoint:altitude + 100.
        }
        
        set pids["yaw"]:setpoint to 0.0 + c_yaw_input*SHIP:CONTROL:PILOTROTATION:X.
        
        set pitch_offset to 20.
        if(SHIP:ALTITUDE <= 200){
            set pitch_offset to 20*SHIP:ALTITUDE/200.
        }
        if(current_waypoint:geoposition:distance > 1000){
            // set 'cruising' altitude 
            set pids["altitude"]:setpoint to 500.
            set pids["pitch"]:setpoint to - (pitch_offset + c_pitch_input*SHIP:CONTROL:PILOTROTATION:Y).
        }
        else{
            set pids["pitch"]:setpoint to - (pitch_offset*current_waypoint:geoposition:distance/1000 + c_pitch_input*SHIP:CONTROL:PILOTROTATION:Y).
        }
        SET pids["roll"]:setpoint       to 0.0 + c_roll_input*SHIP:CONTROL:PILOTROTATION:Z.
    }
    
    set current_time to TIME:SECONDS.

    // based on rotated orientation of ship 
    set pid_alt_out     to pids["altitude"]:UPDATE(current_time, SHIP:ALTITUDE).
    set pid_yaw_out     to pids["yaw"]:UPDATE(current_time, wrap_angle(compass_for(ship) - current_waypoint:geoposition:heading)).
    set pid_pitch_out   to pids["pitch"]:UPDATE(current_time, wrap_angle(pitch_for(ship))).
    set pid_roll_out    to pids["roll"]:UPDATE(current_time, wrap_angle(roll_for(ship))).

    set aot_out         to aot_pid_fusion(pid_alt_out, pid_yaw_out, pid_pitch_out, pid_roll_out).
    set brake_out       to brake_pid_fusion(pid_yaw_out).

    ipc1:CONNECTION:SENDMESSAGE(list(aot_out[0],brake_out[0])).
    ipc2:CONNECTION:SENDMESSAGE(list(aot_out[1],brake_out[1])).
    ipc3:CONNECTION:SENDMESSAGE(list(aot_out[2],brake_out[2])).
    ipc4:CONNECTION:SENDMESSAGE(list(aot_out[3],brake_out[3])).

    // print round(current_time,4) + " | aot   | [" + round(aot_out[0],4) + ", " + round(aot_out[1],4) + ", " + round(aot_out[2],4) + ", " + round(aot_out[3],4) + "]".
    // print round(current_time,4) + " | brake | [" + round(brake_out[0],4) + ", " + round(brake_out[1],4) + ", " + round(brake_out[2],4) + ", " + round(brake_out[3],4) + "]".

    wait 0.02.
}
