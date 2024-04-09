local controller_name is CORE:TAG:REPLACE("c","m").
SET M TO SHIP:PARTSTAGGED(controller_name)[0].
local m is M:getmodule("ModuleRoboticServoRotor"). 

function aot_firmware{
    Parameter desired_state.

    m:setfield("torque limit(%)",100).
    for child in m:part:children {
        child:getmodule("ModuleControlSurface"):setfield("Deploy Angle",desired_state).
    }
    // print m:part:children[0]:allactions.
    // print child:getmodule("ModuleControlSurface"):allmodules.
}

function brake_firmware{
    Parameter desired_state.
    if(desired_state > 0){
        print "brake true". 
        m:setfield("brake",1).
        m:doaction("brake",true).
    }
    else{
        print "brake false". 
        m:setfield("brake",0).
        m:doaction("brake",false).
    }
}

until 0{
    WAIT UNTIL NOT CORE:MESSAGES:EMPTY. // make sure we've received something
    SET RECEIVED TO CORE:MESSAGES:POP.  
    print RECEIVED:SENTAT + " | [" + RECEIVED:CONTENT[0] + ", " + RECEIVED:CONTENT[1] + "]".
    aot_firmware(RECEIVED:CONTENT[0]).
    brake_firmware(RECEIVED:CONTENT[1]).
    wait 0.02. 
}
