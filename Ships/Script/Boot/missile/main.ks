run "0:boot/lib_nav.ks".
run "0:boot/pid_gui.ks".

SET E1 TO SHIP:ENGINES[0].

E1:ACTIVATE.
print E1.
print E1:allmodules.
global e1 is E1:getmodule("ModuleGimbal").
print e1.
// print e1:hasgimbal.
print e1:yawangle.
print e1:pitchangle.
print e1:rollangle.

until 0{
    update_gui().
    update_gui_pid(gui_v5:value).

    set current_time to TIME:SECONDS.
    global pids is LEXICON( "yaw",      PIDLOOP(0.001, 0, 0),
                            "pitch",    PIDLOOP(0.001, 0, 0),
                            "roll",     PIDLOOP(0.001, 0, 0)).
    SET pids["yaw"]:setpoint        to 270.0 + SHIP:CONTROL:PILOTROTATION:X. 
    SET pids["pitch"]:setpoint      to -90.0 + SHIP:CONTROL:PILOTROTATION:Y.
    SET pids["roll"]:setpoint       to 0.0 + SHIP:CONTROL:PILOTROTATION:Z.

    set pid_yaw_out     to pids["yaw"]:UPDATE(current_time, wrap_angle(compass_for(ship))).
    set pid_pitch_out   to pids["pitch"]:UPDATE(current_time, wrap_angle(pitch_for(ship))).
    set pid_roll_out    to pids["roll"]:UPDATE(current_time, wrap_angle(roll_for(ship))).

    set SHIP:CONTROL:YAW to pid_yaw_out.
    set SHIP:CONTROL:pitch to pid_pitch_out.
    set SHIP:CONTROL:roll to pid_roll_out.

    print "yaw: + " + compass_for(ship).
    print "pitch: + " + pitch_for(ship).
    print "roll: + " + roll_for(ship).

    // print "yaw: + " + pid_yaw_out.
    // print "pitch: + " + pid_pitch_out.
    // print "roll: + " + pid_roll_out.
    wait 0.2.
}