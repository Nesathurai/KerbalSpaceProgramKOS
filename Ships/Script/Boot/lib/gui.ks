// @lazyglobal off.
@clobberbuiltins off.

run "0:boot/lib/waypoints.ks".

global fname is "0:boot/quadcopter/data/pid_".
global pids is LEXICON("altitude",  PIDLOOP(0.01, 0.0001, 0.0001),
                        "yaw",      PIDLOOP(0.01, 0.00015, 0.001),
                        "pitch",    PIDLOOP(0.01, 0.00015, 0.001),
                        "roll",     PIDLOOP(0.01, 0.00015, 0.001)).

global c_width is 100.

function init_gui{
    get_current_waypoint().
    create_pid_gui().
    create_debug_gui().
}

function create_debug_gui{
    global debug_gui is gui(500,700).
    set debug_gui:x to 50.
    set debug_gui:y to 800.
    set debug_gui:draggable to true.
    set debug_gui:style:align to "LEFT".
    
    FROM {local i is 0.} UNTIL i = 15 STEP {set i to i+1.} DO {
        debug_gui:addhlayout().
    }.

    debug_gui:widgets[0]:ADDLABEL("Allan's debug gui!").
    set debug_gui:widgets[1]:ADDLABEL():style:width to c_width.
    set debug_gui:widgets[1]:ADDLABEL("ALT"):style:width to c_width.
    set debug_gui:widgets[1]:ADDLABEL("YAW"):style:width to c_width.
    set debug_gui:widgets[1]:ADDLABEL("PITCH"):style:width to c_width.
    set debug_gui:widgets[1]:ADDLABEL("ROLL"):style:width to c_width.

    set debug_gui:widgets[2]:ADDLABEL("CURRENT"):style:width to c_width.
    set debug_gui:widgets[2]:ADDLABEL():style:width to c_width.
    set debug_gui:widgets[2]:ADDLABEL():style:width to c_width.
    set debug_gui:widgets[2]:ADDLABEL():style:width to c_width.
    set debug_gui:widgets[2]:ADDLABEL():style:width to c_width.

    set debug_gui:widgets[3]:ADDLABEL("DESIRED"):style:width to c_width.
    set debug_gui:widgets[3]:ADDLABEL():style:width to c_width.
    set debug_gui:widgets[3]:ADDLABEL():style:width to c_width.
    set debug_gui:widgets[3]:ADDLABEL():style:width to c_width.
    set debug_gui:widgets[3]:ADDLABEL():style:width to c_width.

    set debug_gui:widgets[4]:ADDLABEL("ERROR"):style:width to c_width.
    set debug_gui:widgets[4]:ADDLABEL():style:width to c_width.
    set debug_gui:widgets[4]:ADDLABEL():style:width to c_width.
    set debug_gui:widgets[4]:ADDLABEL():style:width to c_width.
    set debug_gui:widgets[4]:ADDLABEL():style:width to c_width.

    set debug_gui:widgets[5]:ADDLABEL():style:width to c_width.
    set debug_gui:widgets[5]:ADDLABEL("M1"):style:width to c_width.
    set debug_gui:widgets[5]:ADDLABEL("M2"):style:width to c_width.
    set debug_gui:widgets[5]:ADDLABEL("M3"):style:width to c_width.
    set debug_gui:widgets[5]:ADDLABEL("M4"):style:width to c_width.

    set debug_gui:widgets[6]:ADDLABEL("AoA"):style:width to c_width.
    set debug_gui:widgets[6]:ADDLABEL():style:width to c_width.
    set debug_gui:widgets[6]:ADDLABEL():style:width to c_width.
    set debug_gui:widgets[6]:ADDLABEL():style:width to c_width.
    set debug_gui:widgets[6]:ADDLABEL():style:width to c_width.

    debug_gui:show().
}

function create_pid_gui{
    global pid_gui is gui(500,700).
    set pid_gui:x to 50.
    set pid_gui:y to 200.
    set pid_gui:draggable to true.
    set pid_gui:style:align to "LEFT".

    FROM {local i is 0.} UNTIL i = 15 STEP {set i to i+1.} DO {
        pid_gui:addhlayout().
    }.
    
    pid_gui:widgets[0]:ADDLABEL("Allan's PID GUI"). 
    pid_gui:widgets[1]:addpopupmenu().
    
    // set gui_v5:maxvisible to 4. 
    set pid_gui:widgets[1]:widgets[0]:onchange to {
        parameter choice.
        loadPID(choice).
    }.
    for pid in pids:keys {pid_gui:widgets[1]:widgets[0]:addoption(pid).}.

    set pid_gui:widgets[2]:ADDLABEL("Current / Setpoint"):style:width to c_width.
    set pid_gui:widgets[2]:ADDLABEL():style:width to c_width.
    set pid_gui:widgets[2]:ADDLABEL():style:width to c_width.
    set pid_gui:widgets[2]:addbutton("-"):onclick to {
        set pids[pid_gui:widgets[1]:widgets[0]:value]:setpoint to pids[pid_gui:widgets[1]:widgets[0]:value]:setpoint - 1.
        // update_pid_gui(pid_gui:widgets[1]:widgets[0]:value).
    }.
    set pid_gui:widgets[2]:widgets[3]:style:width to c_width.
    set pid_gui:widgets[2]:addbutton("+"):onclick to {
        set pids[pid_gui:widgets[1]:widgets[0]:value]:setpoint to pids[pid_gui:widgets[1]:widgets[0]:value]:setpoint + 1.
        // update_pid_gui(pid_gui:widgets[1]:widgets[0]:value).
    }.
    set pid_gui:widgets[2]:widgets[4]:style:width to c_width.

    set pid_gui:widgets[3]:ADDLABEL("Type"):style:width to c_width.
    set pid_gui:widgets[3]:ADDLABEL("K_"):style:width to c_width. 
    set pid_gui:widgets[3]:ADDLABEL("Term"):style:width to c_width. 
    set pid_gui:widgets[3]:ADDLABEL():style:width to c_width. 
    set pid_gui:widgets[3]:ADDLABEL():style:width to c_width. 

    set pid_gui:widgets[4]:ADDLABEL("P"):style:width to c_width.
    set pid_gui:widgets[4]:ADDLABEL():style:width to c_width.
    set pid_gui:widgets[4]:ADDLABEL():style:width to c_width.
    SET pid_gui:widgets[4]:ADDBUTTON("-"):ONCLICK TO {
        set pids[pid_gui:widgets[1]:widgets[0]:value]:kp to pids[pid_gui:widgets[1]:widgets[0]:value]:kp - 0.001.
        // update_pid_gui(pid_gui:widgets[1]:widgets[0]:value).
    }.
    set pid_gui:widgets[4]:widgets[3]:style:width to c_width.
    SET pid_gui:widgets[4]:ADDBUTTON("+"):ONCLICK TO {
        set pids[pid_gui:widgets[1]:widgets[0]:value]:kp to pids[pid_gui:widgets[1]:widgets[0]:value]:kp + 0.001.
        // update_pid_gui(pid_gui:widgets[1]:widgets[0]:value).
    }.
    set pid_gui:widgets[4]:widgets[4]:style:width to c_width.

    set pid_gui:widgets[5]:ADDLABEL("I"):style:width to c_width.
    set pid_gui:widgets[5]:ADDLABEL():style:width to c_width.
    set pid_gui:widgets[5]:ADDLABEL():style:width to c_width.
    SET pid_gui:widgets[5]:ADDBUTTON("-"):ONCLICK TO {
        set pids[pid_gui:widgets[1]:widgets[0]:value]:ki to pids[pid_gui:widgets[1]:widgets[0]:value]:ki - 0.001.
        // update_pid_gui(pid_gui:widgets[1]:widgets[0]:value).
    }.
    set pid_gui:widgets[5]:widgets[3]:style:width to c_width.
    SET pid_gui:widgets[5]:ADDBUTTON("+"):ONCLICK TO {
        set pids[pid_gui:widgets[1]:widgets[0]:value]:ki to pids[pid_gui:widgets[1]:widgets[0]:value]:ki + 0.001.
        // update_pid_gui(pid_gui:widgets[1]:widgets[0]:value).
    }.
    set pid_gui:widgets[5]:widgets[4]:style:width to c_width.

    set pid_gui:widgets[6]:ADDLABEL("D"):style:width to c_width.
    set pid_gui:widgets[6]:ADDLABEL():style:width to c_width.
    set pid_gui:widgets[6]:ADDLABEL():style:width to c_width.
    SET pid_gui:widgets[6]:ADDBUTTON("-"):ONCLICK TO {
        set pids[pid_gui:widgets[1]:widgets[0]:value]:kd to pids[pid_gui:widgets[1]:widgets[0]:value]:kd - 0.001.
        // update_pid_gui(pid_gui:widgets[1]:widgets[0]:value).
    }.
    set pid_gui:widgets[6]:widgets[3]:style:width to c_width.
    SET pid_gui:widgets[6]:ADDBUTTON("+"):ONCLICK TO {
        set pids[pid_gui:widgets[1]:widgets[0]:value]:kd to pids[pid_gui:widgets[1]:widgets[0]:value]:kd + 0.001.
        // update_pid_gui(pid_gui:widgets[1]:widgets[0]:value).
    }.
    set pid_gui:widgets[6]:widgets[4]:style:width to c_width.
    
    set pid_gui:widgets[7]:ADDLABEL("Output"):style:width to c_width.
    set pid_gui:widgets[7]:ADDLABEL():style:width to c_width.
    set pid_gui:widgets[7]:ADDLABEL():style:width to c_width.
    set pid_gui:widgets[7]:ADDLABEL():style:width to c_width.
    set pid_gui:widgets[7]:ADDLABEL():style:width to c_width.

    set pid_gui:widgets[8]:ADDLABEL("Error Sum"):style:width to c_width.
    set pid_gui:widgets[8]:ADDLABEL():style:width to c_width.
    set pid_gui:widgets[8]:ADDLABEL():style:width to c_width.
    set pid_gui:widgets[8]:ADDLABEL():style:width to c_width.
    set pid_gui:widgets[8]:ADDLABEL():style:width to c_width.

    set pid_gui:widgets[9]:ADDLABEL("Current Waypoint"):style:width to c_width.
    set pid_gui:widgets[9]:ADDLABEL("Altitude"):style:width to c_width.
    set pid_gui:widgets[9]:ADDLABEL("Latitude"):style:width to c_width.
    set pid_gui:widgets[9]:ADDLABEL("Longitude"):style:width to c_width.
    set pid_gui:widgets[9]:ADDLABEL():style:width to c_width.

    set pid_gui:widgets[10]:ADDLABEL():style:width to c_width.
    set pid_gui:widgets[10]:ADDLABEL():style:width to c_width.
    set pid_gui:widgets[10]:ADDLABEL():style:width to c_width.
    set pid_gui:widgets[10]:ADDLABEL():style:width to c_width.
    set pid_gui:widgets[10]:ADDLABEL():style:width to c_width.

    set pid_gui:widgets[11]:ADDLABEL():style:width to c_width.
    set pid_gui:widgets[11]:ADDLABEL():style:width to c_width.
    set pid_gui:widgets[11]:ADDLABEL():style:width to c_width.
    set pid_gui:widgets[11]:ADDLABEL():style:width to c_width.
    set pid_gui:widgets[11]:ADDLABEL():style:width to c_width.

    set pid_gui:ADDBUTTON("GO TO WAYPOINT"):onclick to go_to_waypoint@.
    set pid_gui:ADDBUTTON("SAVE PID"):onclick to savePID@.
    set pid_gui:ADDBUTTON("LOAD PID"):onclick to loadPID@.
    set pid_gui:ADDBUTTON("RESET PID"):onclick to {pids[pid_gui:widgets[1]:widgets[0]:value]:reset.}.
    set pid_gui:ADDBUTTON("CLOSE"):onclick to {pid_gui:HIDE().}.

    loadPID("altitude").
    loadPID("yaw").
    loadPID("pitch").
    loadPID("roll").
    // update_pid_gui().

    pid_gui:show().
}

function update_pid_gui{
    parameter pid is "altitude".
    set pid_gui:widgets[2]:widgets[1]:text to round(pids[pid]:input,7):tostring.
    set pid_gui:widgets[2]:widgets[2]:text to round(pids[pid]:setpoint,7):tostring.
    set pid_gui:widgets[4]:widgets[1]:text to round(pids[pid]:kp,7):tostring.
    set pid_gui:widgets[5]:widgets[1]:text to round(pids[pid]:ki,7):tostring.
    set pid_gui:widgets[6]:widgets[1]:text to round(pids[pid]:kd,7):tostring.
    
    set pid_gui:widgets[4]:widgets[2]:text to round(pids[pid]:pterm,7):tostring.
    set pid_gui:widgets[5]:widgets[2]:text to round(pids[pid]:iterm,7):tostring.
    set pid_gui:widgets[6]:widgets[2]:text to round(pids[pid]:dterm,7):tostring.
    set pid_gui:widgets[7]:widgets[2]:text to round(pids[pid]:output,7):tostring.
    set pid_gui:widgets[8]:widgets[2]:text to round(pids[pid]:error,7):tostring.

    set pid_gui:widgets[10]:widgets[0]:text to current_waypoint:name.
    set pid_gui:widgets[10]:widgets[1]:text to round(current_waypoint:altitude,5):TOSTRING.
    set pid_gui:widgets[10]:widgets[2]:text to round(current_waypoint:geoposition:lat,5):TOSTRING.
    set pid_gui:widgets[10]:widgets[3]:text to round(current_waypoint:geoposition:lng,5):TOSTRING.

    set pid_gui:widgets[11]:widgets[0]:text to "Current". 
    set pid_gui:widgets[11]:widgets[1]:text to round(SHIP:ALTITUDE,5):TOSTRING.
    set pid_gui:widgets[11]:widgets[2]:text to round(SHIP:GEOPOSITION:LAT,5):TOSTRING.
    set pid_gui:widgets[11]:widgets[3]:text to round(SHIP:GEOPOSITION:LNG,5):TOSTRING.

    // print "dist: " + current_waypoint:geoposition:distance. 
}

function update_debug_gui{
    set debug_gui:widgets[2]:widgets[1]:text to round(pids["altitude"]:input,5):tostring.
    set debug_gui:widgets[2]:widgets[2]:text to round(pids["yaw"]:input,5):tostring.
    set debug_gui:widgets[2]:widgets[3]:text to round(pids["pitch"]:input,5):tostring.
    set debug_gui:widgets[2]:widgets[4]:text to round(pids["roll"]:input,5):tostring.
    
    set debug_gui:widgets[3]:widgets[1]:text to round(pids["altitude"]:setpoint,5):tostring.
    set debug_gui:widgets[3]:widgets[2]:text to round(pids["yaw"]:setpoint,5):tostring.
    set debug_gui:widgets[3]:widgets[3]:text to round(pids["pitch"]:setpoint,5):tostring.
    set debug_gui:widgets[3]:widgets[4]:text to round(pids["roll"]:setpoint,5):tostring.

    set debug_gui:widgets[4]:widgets[1]:text to round(pids["altitude"]:error,5):tostring.
    set debug_gui:widgets[4]:widgets[2]:text to round(pids["yaw"]:error,5):tostring.
    set debug_gui:widgets[4]:widgets[3]:text to round(pids["pitch"]:error,5):tostring.
    set debug_gui:widgets[4]:widgets[4]:text to round(pids["roll"]:error,5):tostring.
    
    set debug_gui:widgets[6]:widgets[1]:text to round(m1:part:children[0]:getmodule("ModuleControlSurface"):getfield("Deploy Angle"),5):tostring.
    set debug_gui:widgets[6]:widgets[2]:text to round(m2:part:children[0]:getmodule("ModuleControlSurface"):getfield("Deploy Angle"),5):tostring.
    set debug_gui:widgets[6]:widgets[3]:text to round(m3:part:children[0]:getmodule("ModuleControlSurface"):getfield("Deploy Angle"),5):tostring.
    set debug_gui:widgets[6]:widgets[4]:text to round(m4:part:children[0]:getmodule("ModuleControlSurface"):getfield("Deploy Angle"),5):tostring.
    
    // SET debug_gui:widgets[4]:TEXT TO "PID (alt, yaw, pitch, roll) = (" + round(pids["altitude"]:output,5) + ", " + round(pids["yaw"]:output,5) + ", " + round(pids["pitch"]:output,5) + ", " + round(pids["roll"]:output,5) + ")".
    SET fore1 TO VECDRAW(V(0,0,0),(current_waypoint:geoposition:position - SHIP:GEOPOSITION:POSITION):normalized,RGB(1,0,0),"",5.0,TRUE,0.04,TRUE,TRUE).

}

function savePID {
    local data is LEXICON("setpoint",pids[pid_gui:widgets[1]:widgets[0]:value]:setpoint,"p",pids[pid_gui:widgets[1]:widgets[0]:value]:kp,"i",pids[pid_gui:widgets[1]:widgets[0]:value]:ki,"d",pids[pid_gui:widgets[1]:widgets[0]:value]:kd).
    WRITEJSON(data, fname + pid_gui:widgets[1]:widgets[0]:value + ".json").
    set save_button:pressed to false.
}

function loadPID{
    parameter choice is pid_gui:widgets[1]:widgets[0]:value.
    SET data TO READJSON(fname + choice + ".json").
    set pids[choice]:setpoint to data["setpoint"].
    set pids[choice]:kp to data["p"].
    set pids[choice]:ki to data["i"].
    set pids[choice]:kd to data["d"].
    set pid_gui:widgets[17]:pressed to false.
    update_pid_gui(choice). 
}
