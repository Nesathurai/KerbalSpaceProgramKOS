// @lazyglobal off.
@clobberbuiltins off.

// run "0:boot/common.ks".
run "0:boot/waypoints.ks".

global fname is "0:boot/data/pid_".
global pids is LEXICON("altitude",  PIDLOOP(0.01, 0.0001, 0.0001),
                        "yaw",      PIDLOOP(0.01, 0.00015, 0.001),
                        "pitch",    PIDLOOP(0.01, 0.00015, 0.001),
                        "roll",     PIDLOOP(0.01, 0.00015, 0.001)).

// Create a GUI window
global my_gui IS GUI(500,700).
set my_gui:x to 100.
set my_gui:y to 200.
set my_gui:draggable to true.
set my_gui:style:align to "LEFT".

// Add widgets to the GUI
global gui_v0 IS my_gui:ADDLABEL("Allan's drone control!").
SET gui_v0:STYLE:ALIGN TO "LEFT".
// SET gui_v0:STYLE:HSTRETCH TO True. // Fill horizontally
global gui_v1 IS my_gui:ADDLABEL("").
// SET gui_data0:STYLE:ALIGN TO "LEFT".
global gui_v2 IS my_gui:ADDLABEL("").
global gui_v3 IS my_gui:ADDLABEL("").
global gui_v4 IS my_gui:ADDLABEL("").

global gui_v5 is my_gui:addpopupmenu().
set gui_v5:maxvisible to 4. 
for pid in pids:keys {gui_v5:addoption(pid).}
// set gui_v5:value to gui_v5:options[0].
SET gui_v5:onchange TO {
    parameter choice. 
    if (going_to_waypoint = false){
    loadPID_(choice).
    }
    update_gui_pid(choice).
}.

global gui_v6_h0 is my_gui:addvbox():addhbox().
global gui_v6_h1 is gui_v6_h0:ADDLABEL("Setpoint").
global gui_v6_h2 is gui_v6_h0:ADDLABEL().
global gui_v6_h3 is gui_v6_h0:ADDLABEL().
global gui_v6_h4 is gui_v6_h0:ADDBUTTON("-").
global gui_v6_h5 is gui_v6_h0:ADDBUTTON("+").
SET gui_v6_h4:ONCLICK TO {
    set pids[gui_v5:value]:setpoint to pids[gui_v5:value]:setpoint - 1.
    update_gui_pid(gui_v5:value).
}.
SET gui_v6_h5:ONCLICK TO {
    set pids[gui_v5:value]:setpoint to pids[gui_v5:value]:setpoint + 1.
    update_gui_pid(gui_v5:value).
}.

global gui_v7_h0 is my_gui:addvlayout():addhlayout().
global gui_v7_h1 is gui_v7_h0:ADDLABEL("Type").
global gui_v7_h2 is gui_v7_h0:ADDLABEL("K_").
global gui_v7_h3 is gui_v7_h0:ADDLABEL("Term").
global gui_v7_h4 is gui_v7_h0:ADDLABEL("---").
global gui_v7_h5 is gui_v7_h0:ADDLABEL("+++").

global gui_v8_h0 is my_gui:addvbox():addhbox().
global gui_v8_h1 is gui_v8_h0:ADDLABEL("P").
global gui_v8_h2 is gui_v8_h0:ADDLABEL().
global gui_v8_h3 is gui_v8_h0:ADDLABEL().
global gui_v8_h4 is gui_v8_h0:ADDBUTTON("-").
global gui_v8_h5 is gui_v8_h0:ADDBUTTON("+").
SET gui_v8_h4:ONCLICK TO {
    set pids[gui_v5:value]:kp to pids[gui_v5:value]:kp - 0.001.
    update_gui_pid(gui_v5:value).
}.
SET gui_v8_h5:ONCLICK TO {
    set pids[gui_v5:value]:kp to pids[gui_v5:value]:kp + 0.001.
    update_gui_pid(gui_v5:value).
}.

global gui_v9_h0 is my_gui:addvbox():addhbox.
global gui_v9_h1 is gui_v9_h0:ADDLABEL("I").
global gui_v9_h2 is gui_v9_h0:ADDLABEL().
global gui_v9_h3 is gui_v9_h0:ADDLABEL().
global gui_v9_h4 is gui_v9_h0:ADDBUTTON("-").
global gui_v9_h5 is gui_v9_h0:ADDBUTTON("+").
SET gui_v9_h4:ONCLICK TO {
    set pids[gui_v5:value]:ki to pids[gui_v5:value]:ki - 0.001.
    update_gui_pid(gui_v5:value).
}.
SET gui_v9_h5:ONCLICK TO {
    set pids[gui_v5:value]:ki to pids[gui_v5:value]:ki + 0.001.
    update_gui_pid(gui_v5:value).
}.

global gui_v10_h0 is my_gui:addvbox():addhbox().
global gui_v10_h1 is gui_v10_h0:ADDLABEL("D").
global gui_v10_h2 is gui_v10_h0:ADDLABEL().
global gui_v10_h3 is gui_v10_h0:ADDLABEL().
global gui_v10_h4 is gui_v10_h0:ADDBUTTON("-").
global gui_v10_h5 is gui_v10_h0:ADDBUTTON("+").
SET gui_v10_h4:ONCLICK TO {
    set pids[gui_v5:value]:kd to pids[gui_v5:value]:kd - 0.001.
    update_gui_pid(gui_v5:value).
}.
SET gui_v10_h5:ONCLICK TO {
    set pids[gui_v5:value]:kd to pids[gui_v5:value]:kd + 0.001.
    update_gui_pid(gui_v5:value).
}.

global gui_v11_h0 is my_gui:addvbox():addhbox().
global gui_v11_h1 is gui_v11_h0:ADDLABEL("Output").
global gui_v11_h2 is gui_v11_h0:ADDLABEL().
global gui_v11_h3 is gui_v11_h0:ADDLABEL().
global gui_v11_h4 is gui_v11_h0:ADDLABEL().
global gui_v11_h5 is gui_v11_h0:ADDLABEL().

global gui_v12_h0 is my_gui:addvbox():addhbox().
global gui_v12_h1 is gui_v12_h0:ADDLABEL("Error Sum").
global gui_v12_h2 is gui_v12_h0:ADDLABEL().
global gui_v12_h3 is gui_v12_h0:ADDLABEL().
global gui_v12_h4 is gui_v12_h0:ADDLABEL().
global gui_v12_h5 is gui_v12_h0:ADDLABEL().

global gui_v13_h0 is my_gui:addvbox():addhbox().
global gui_v13_h1 is gui_v13_h0:ADDLABEL("Current Waypoint").
global gui_v13_h2 is gui_v13_h0:ADDLABEL("Altitude").
global gui_v13_h3 is gui_v13_h0:ADDLABEL("Latitude").
global gui_v13_h4 is gui_v13_h0:ADDLABEL("Longitude").
global gui_v13_h5 is gui_v13_h0:ADDLABEL().

global gui_v14_h0 is my_gui:addvbox():addhbox().
global gui_v14_h1 is gui_v14_h0:ADDLABEL().
global gui_v14_h2 is gui_v14_h0:ADDLABEL().
global gui_v14_h3 is gui_v14_h0:ADDLABEL().
global gui_v14_h4 is gui_v14_h0:ADDLABEL().
global gui_v14_h5 is gui_v14_h0:ADDLABEL().

global gui_v15_h0 is my_gui:addvbox():addhbox().
global gui_v15_h1 is gui_v15_h0:ADDLABEL().
global gui_v15_h2 is gui_v15_h0:ADDLABEL().
global gui_v15_h3 is gui_v15_h0:ADDLABEL().
global gui_v15_h4 is gui_v15_h0:ADDLABEL().
global gui_v15_h5 is gui_v15_h0:ADDLABEL().

global go_to_waypoint_button TO my_gui:ADDBUTTON("GO TO WAYPOINT").
SET go_to_waypoint_button:ONCLICK TO go_to_waypoint@.
global save_button TO my_gui:ADDBUTTON("SAVE PID").
SET save_button:ONCLICK TO savePID@. 
global load_button TO my_gui:ADDBUTTON("LOAD PID").
SET load_button:ONCLICK TO loadPID@. 
global reset_button TO my_gui:ADDBUTTON("RESET PID").
SET reset_button:ONCLICK TO {pids[gui_v5:value]:reset.}.
global close_button TO my_gui:ADDBUTTON("CLOSE").
SET close_button:ONCLICK TO {my_gui:HIDE().}.

loadPID_("altitude").
loadPID_("yaw").
loadPID_("pitch").
loadPID_("roll").
get_current_waypoint().
update_gui_pid("altitude").
my_gui:SHOW().

function update_gui{
    SET gui_v1:TEXT TO "current (YAW, PITCH, ROLL) = (" + ROUND(wrap_angle(compass_for(ship) - current_waypoint:geoposition:heading),5) + ", " + ROUND(wrap_angle(pitch_for(ship)),5) + ", " + ROUND(wrap_angle(roll_for(ship)),5) + ")".
    SET gui_v2:TEXT TO "error  (YAW, PITCH, ROLL) = (" + ROUND(pids["yaw"]:error,5) + ", " + ROUND(pids["pitch"]:error,5) + ", " + ROUND(pids["roll"]:error,5) + ")".
    SET gui_v3:TEXT TO "AOT (M1, M2, M3, M4) = (" + round(m1:part:children[0]:getmodule("ModuleControlSurface"):getfield("Deploy Angle"),5) + ", " +
                                                       round(m2:part:children[0]:getmodule("ModuleControlSurface"):getfield("Deploy Angle"),5) + ", " +
                                                       round(m3:part:children[0]:getmodule("ModuleControlSurface"):getfield("Deploy Angle"),5) + ", " +
                                                       round(m4:part:children[0]:getmodule("ModuleControlSurface"):getfield("Deploy Angle"),5) + ")".
    SET gui_v4:TEXT TO "PID (alt, yaw, pitch, roll) = (" + round(pids["altitude"]:output,5) + ", " + round(pids["yaw"]:output,5) + ", " + round(pids["pitch"]:output,5) + ", " + round(pids["roll"]:output,5) + ")".
    SET fore1 TO VECDRAW(V(0,0,0),(current_waypoint:geoposition:position - SHIP:GEOPOSITION:POSITION):normalized,RGB(1,0,0),"",5.0,TRUE,0.04,TRUE,TRUE).
    
    // print "dist: " + current_waypoint:geoposition:distance. 

    set gui_v8_h3:text to round(pids[gui_v5:value]:pterm,7):tostring.
    set gui_v9_h3:text to round(pids[gui_v5:value]:iterm,7):tostring.
    set gui_v10_h3:text to round(pids[gui_v5:value]:dterm,7):tostring.
    set gui_v11_h3:text to round(pids[gui_v5:value]:output,7):tostring.
    set gui_v12_h3:text to round(pids[gui_v5:value]:error,7):tostring.

    set gui_v14_h1:text to current_waypoint:name.
    set gui_v14_h2:text to ROUND(current_waypoint:altitude,5):TOSTRING.
    set gui_v14_h3:text to ROUND(current_waypoint:geoposition:lat,5):TOSTRING.
    set gui_v14_h4:text to ROUND(current_waypoint:geoposition:lng,5):TOSTRING.

    set gui_v15_h1:text to "Current". 
    set gui_v15_h2:text to ROUND(SHIP:ALTITUDE,5):TOSTRING.
    set gui_v15_h3:text to ROUND(SHIP:GEOPOSITION:LAT,5):TOSTRING.
    set gui_v15_h4:text to ROUND(SHIP:GEOPOSITION:LNG,5):TOSTRING.
}

function update_gui_pid{
    Parameter pid.
    set gui_v6_h2:text to round(pids[pid]:setpoint,7):tostring.
    set gui_v8_h2:text to round(pids[pid]:kp,7):tostring.
    set gui_v9_h2:text to round(pids[pid]:ki,7):tostring.
    set gui_v10_h2:text to round(pids[pid]:kd,7):tostring.
}

function savePID {
    local data is LEXICON("setpoint",pids[gui_v5:value]:setpoint,"p",pids[gui_v5:value]:kp,"i",pids[gui_v5:value]:ki,"d",pids[gui_v5:value]:kd).
    WRITEJSON(data, fname + gui_v5:value + ".json").
    set save_button:pressed to false.
}

function loadPID {
    SET data TO READJSON(fname + gui_v5:value + ".json").
    set pids[gui_v5:value]:setpoint to data["setpoint"].
    set pids[gui_v5:value]:kp to data["p"].
    set pids[gui_v5:value]:ki to data["i"].
    set pids[gui_v5:value]:kd to data["d"].
    set load_button:pressed to false.
    update_gui_pid(gui_v5:value).
}

function loadPID_ {
    parameter choice. 
    SET data TO READJSON(fname + choice + ".json").
    set pids[choice]:setpoint to data["setpoint"].
    set pids[choice]:kp to data["p"].
    set pids[choice]:ki to data["i"].
    set pids[choice]:kd to data["d"].
    set load_button:pressed to false.
    update_gui_pid(choice). 
}
