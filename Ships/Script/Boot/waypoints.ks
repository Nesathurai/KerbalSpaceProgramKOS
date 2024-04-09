@clobberbuiltins off.

global waypoints is allwaypoints().
global going_to_waypoint is false.
function get_current_waypoint{
    for wp in waypoints {
        if wp:isselected() {
            global current_waypoint is wp. 
            print current_waypoint.
            return. 
        }
    }
    global current_waypoint is waypoints[0].
}

function go_to_waypoint{
    set going_to_waypoint to true.
}
