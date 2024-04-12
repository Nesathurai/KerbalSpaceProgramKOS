// @lazyglobal off.
@clobberbuiltins off.

run "0:boot/lib/waypoints.ks".

global fname is "0:boot/quadcopter/data/pid_".
global pids is LEXICON("altitude",  PIDLOOP(0.01, 0.0001, 0.0001),
                        "yaw",      PIDLOOP(0.01, 0.00015, 0.001),
                        "pitch",    PIDLOOP(0.01, 0.00015, 0.001),
                        "roll",     PIDLOOP(0.01, 0.00015, 0.001)).

// Create a GUI window
global my_gui IS GUI(500,700).
set my_gui:x to 50.
set my_gui:y to 800.
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

global c_width is 100.

global pid_gui is create_pid_gui().

function create_pid_gui{

    get_current_waypoint().

    set gui_root to gui(500,700).
    set gui_root:x to 50.
    set gui_root:y to 200.
    set gui_root:draggable to true.
    set gui_root:style:align to "LEFT".

    FROM {local i is 0.} UNTIL i = 15 STEP {set i to i+1.} DO {
        gui_root:addhlayout().
    }.
    
    gui_root:widgets[0]:ADDLABEL("Allan's PID GUI"). 
    gui_root:widgets[1]:addpopupmenu().
    
    // set gui_v5:maxvisible to 4. 
    set gui_root:widgets[1]:widgets[0]:onchange to {
        parameter choice.
        loadPID(choice).
    }.
    for pid in pids:keys {gui_root:widgets[1]:widgets[0]:addoption(pid).}.

    set gui_root:widgets[2]:ADDLABEL("Current / Setpoint"):style:width to c_width.
    set gui_root:widgets[2]:ADDLABEL():style:width to c_width.
    set gui_root:widgets[2]:ADDLABEL():style:width to c_width.
    set gui_root:widgets[2]:addbutton("-"):onclick to {
        set pids[gui_root:widgets[1]:widgets[0]:value]:setpoint to pids[gui_root:widgets[1]:widgets[0]:value]:setpoint - 1.
        update_pid_gui(gui_root:widgets[1]:widgets[0]:value).
    }.
    set gui_root:widgets[2]:widgets[3]:style:width to c_width.
    set gui_root:widgets[2]:addbutton("+"):onclick to {
        set pids[gui_root:widgets[1]:widgets[0]:value]:setpoint to pids[gui_root:widgets[1]:widgets[0]:value]:setpoint + 1.
        update_pid_gui(gui_root:widgets[1]:widgets[0]:value).
    }.
    set gui_root:widgets[2]:widgets[4]:style:width to c_width.

    set gui_root:widgets[3]:ADDLABEL("Type"):style:width to c_width.
    set gui_root:widgets[3]:ADDLABEL("K_"):style:width to c_width. 
    set gui_root:widgets[3]:ADDLABEL("Term"):style:width to c_width. 
    set gui_root:widgets[3]:ADDLABEL():style:width to c_width. 
    set gui_root:widgets[3]:ADDLABEL():style:width to c_width. 

    set gui_root:widgets[4]:ADDLABEL("P"):style:width to c_width.
    set gui_root:widgets[4]:ADDLABEL():style:width to c_width.
    set gui_root:widgets[4]:ADDLABEL():style:width to c_width.
    SET gui_root:widgets[4]:ADDBUTTON("-"):ONCLICK TO {
        set pids[gui_root:widgets[1]:widgets[0]:value]:kp to pids[gui_root:widgets[1]:widgets[0]:value]:kp - 0.001.
        update_pid_gui(gui_root:widgets[1]:widgets[0]:value).
    }.
    set gui_root:widgets[4]:widgets[3]:style:width to c_width.
    SET gui_root:widgets[4]:ADDBUTTON("+"):ONCLICK TO {
        set pids[gui_root:widgets[1]:widgets[0]:value]:kp to pids[gui_root:widgets[1]:widgets[0]:value]:kp + 0.001.
        update_pid_gui(gui_root:widgets[1]:widgets[0]:value).
    }.
    set gui_root:widgets[4]:widgets[4]:style:width to c_width.

    set gui_root:widgets[5]:ADDLABEL("I"):style:width to c_width.
    set gui_root:widgets[5]:ADDLABEL():style:width to c_width.
    set gui_root:widgets[5]:ADDLABEL():style:width to c_width.
    SET gui_root:widgets[5]:ADDBUTTON("-"):ONCLICK TO {
        set pids[gui_root:widgets[1]:widgets[0]:value]:ki to pids[gui_root:widgets[1]:widgets[0]:value]:ki - 0.001.
        update_pid_gui(gui_root:widgets[1]:widgets[0]:value).
    }.
    set gui_root:widgets[5]:widgets[3]:style:width to c_width.
    SET gui_root:widgets[5]:ADDBUTTON("+"):ONCLICK TO {
        set pids[gui_root:widgets[1]:widgets[0]:value]:ki to pids[gui_root:widgets[1]:widgets[0]:value]:ki + 0.001.
        update_pid_gui(gui_root:widgets[1]:widgets[0]:value).
    }.
    set gui_root:widgets[5]:widgets[4]:style:width to c_width.

    set gui_root:widgets[6]:ADDLABEL("D"):style:width to c_width.
    set gui_root:widgets[6]:ADDLABEL():style:width to c_width.
    set gui_root:widgets[6]:ADDLABEL():style:width to c_width.
    SET gui_root:widgets[6]:ADDBUTTON("-"):ONCLICK TO {
        set pids[gui_root:widgets[1]:widgets[0]:value]:kd to pids[gui_root:widgets[1]:widgets[0]:value]:kd - 0.001.
        update_pid_gui(gui_root:widgets[1]:widgets[0]:value).
    }.
    set gui_root:widgets[6]:widgets[3]:style:width to c_width.
    SET gui_root:widgets[6]:ADDBUTTON("+"):ONCLICK TO {
        set pids[gui_root:widgets[1]:widgets[0]:value]:kd to pids[gui_root:widgets[1]:widgets[0]:value]:kd + 0.001.
        update_pid_gui(gui_root:widgets[1]:widgets[0]:value).
    }.
    set gui_root:widgets[6]:widgets[4]:style:width to c_width.
    
    set gui_root:widgets[7]:ADDLABEL("Output"):style:width to c_width.
    set gui_root:widgets[7]:ADDLABEL():style:width to c_width.
    set gui_root:widgets[7]:ADDLABEL():style:width to c_width.
    set gui_root:widgets[7]:ADDLABEL():style:width to c_width.
    set gui_root:widgets[7]:ADDLABEL():style:width to c_width.

    set gui_root:widgets[8]:ADDLABEL("Error Sum"):style:width to c_width.
    set gui_root:widgets[8]:ADDLABEL():style:width to c_width.
    set gui_root:widgets[8]:ADDLABEL():style:width to c_width.
    set gui_root:widgets[8]:ADDLABEL():style:width to c_width.
    set gui_root:widgets[8]:ADDLABEL():style:width to c_width.

    set gui_root:widgets[9]:ADDLABEL("Current Waypoint"):style:width to c_width.
    set gui_root:widgets[9]:ADDLABEL("Altitude"):style:width to c_width.
    set gui_root:widgets[9]:ADDLABEL("Latitude"):style:width to c_width.
    set gui_root:widgets[9]:ADDLABEL("Longitude"):style:width to c_width.
    set gui_root:widgets[9]:ADDLABEL():style:width to c_width.

    set gui_root:widgets[10]:ADDLABEL():style:width to c_width.
    set gui_root:widgets[10]:ADDLABEL():style:width to c_width.
    set gui_root:widgets[10]:ADDLABEL():style:width to c_width.
    set gui_root:widgets[10]:ADDLABEL():style:width to c_width.
    set gui_root:widgets[10]:ADDLABEL():style:width to c_width.

    set gui_root:widgets[11]:ADDLABEL():style:width to c_width.
    set gui_root:widgets[11]:ADDLABEL():style:width to c_width.
    set gui_root:widgets[11]:ADDLABEL():style:width to c_width.
    set gui_root:widgets[11]:ADDLABEL():style:width to c_width.
    set gui_root:widgets[11]:ADDLABEL():style:width to c_width.

    set gui_root:ADDBUTTON("GO TO WAYPOINT"):onclick to go_to_waypoint@.
    set gui_root:ADDBUTTON("SAVE PID"):onclick to savePID@.
    set gui_root:ADDBUTTON("LOAD PID"):onclick to loadPID@.
    set gui_root:ADDBUTTON("RESET PID"):onclick to {pids[gui_root:widgets[1]:widgets[0]:value]:reset.}.
    set gui_root:ADDBUTTON("CLOSE"):onclick to {gui_root:HIDE().}.

    loadPID("altitude").
    loadPID("yaw").
    loadPID("pitch").
    loadPID("roll").
    update_pid_gui().

    my_gui:show().
    gui_root:show().
    return gui_root.
}

function update_pid_gui{
    parameter pid is "altitude".
    set gui_root:widgets[2]:widgets[1]:text to round(pids[pid]:input,7):tostring.
    set gui_root:widgets[2]:widgets[2]:text to round(pids[pid]:setpoint,7):tostring.
    set gui_root:widgets[4]:widgets[1]:text to round(pids[pid]:kp,7):tostring.
    set gui_root:widgets[5]:widgets[1]:text to round(pids[pid]:ki,7):tostring.
    set gui_root:widgets[6]:widgets[1]:text to round(pids[pid]:kd,7):tostring.
    
    set gui_root:widgets[4]:widgets[2]:text to round(pids[pid]:pterm,7):tostring.
    set gui_root:widgets[5]:widgets[2]:text to round(pids[pid]:iterm,7):tostring.
    set gui_root:widgets[6]:widgets[2]:text to round(pids[pid]:dterm,7):tostring.
    set gui_root:widgets[7]:widgets[2]:text to round(pids[pid]:output,7):tostring.
    set gui_root:widgets[8]:widgets[2]:text to round(pids[pid]:error,7):tostring.

    set gui_root:widgets[10]:widgets[0]:text to current_waypoint:name.
    set gui_root:widgets[10]:widgets[1]:text to ROUND(current_waypoint:altitude,5):TOSTRING.
    set gui_root:widgets[10]:widgets[2]:text to ROUND(current_waypoint:geoposition:lat,5):TOSTRING.
    set gui_root:widgets[10]:widgets[3]:text to ROUND(current_waypoint:geoposition:lng,5):TOSTRING.

    set gui_root:widgets[11]:widgets[0]:text to "Current". 
    set gui_root:widgets[11]:widgets[1]:text to ROUND(SHIP:ALTITUDE,5):TOSTRING.
    set gui_root:widgets[11]:widgets[2]:text to ROUND(SHIP:GEOPOSITION:LAT,5):TOSTRING.
    set gui_root:widgets[11]:widgets[3]:text to ROUND(SHIP:GEOPOSITION:LNG,5):TOSTRING.

}


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

}

function savePID {
    local data is LEXICON("setpoint",pids[gui_root:widgets[1]:widgets[0]:value]:setpoint,"p",pids[gui_root:widgets[1]:widgets[0]:value]:kp,"i",pids[gui_root:widgets[1]:widgets[0]:value]:ki,"d",pids[gui_root:widgets[1]:widgets[0]:value]:kd).
    WRITEJSON(data, fname + gui_root:widgets[1]:widgets[0]:value + ".json").
    set save_button:pressed to false.
}

function loadPID{
    parameter choice is gui_root:widgets[1]:widgets[0]:value.
    SET data TO READJSON(fname + choice + ".json").
    set pids[choice]:setpoint to data["setpoint"].
    set pids[choice]:kp to data["p"].
    set pids[choice]:ki to data["i"].
    set pids[choice]:kd to data["d"].
    set gui_root:widgets[17]:pressed to false.
    update_pid_gui(choice). 
}
