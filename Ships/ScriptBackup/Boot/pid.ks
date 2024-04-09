// pidloop
// SET g TO KERBIN:MU / KERBIN:RADIUS^2.
// LOCK accvec TO SHIP:SENSORS:ACC - SHIP:SENSORS:GRAV.
// LOCK gforce TO accvec:MAG / g.

// LOCK STEERING TO R(0,0,-90) + HEADING(90,90).

// SET Kp TO 0.1.
// SET Kd TO 0.05.
// SET Ki TO 0.005.
// SET PID TO PIDLOOP(Kp, Ki, Kd).
// SET PID:SETPOINT TO 500.

// SET thrott TO 1.
// LOCK THROTTLE TO thrott.

// until false {
//     SET thrott TO PID:UPDATE(TIME:SECONDS, ship:ALTITUDE).
//     // pid:update() is given the input time and input and returns the output. gforce is the input.
//     WAIT 0.001.
// }


LOCK STEERING TO R(0,0,-90) + HEADING(90,90).

// PID-loop
SET g TO KERBIN:MU / KERBIN:RADIUS^2.
LOCK accvec TO SHIP:SENSORS:ACC - SHIP:SENSORS:GRAV.
LOCK gforce TO accvec:MAG / g.

SET gforce_setpoint TO 1.2.

// LOCK P TO gforce_setpoint - gforce.
LOCK P TO 1000 - ship:ALTITUDE.
SET I TO 0.
SET D TO 0.
SET P0 TO P.

LOCK in_deadband TO ABS(P) < 0.01.

SET Kp TO 0.00095.
SET Ki TO 0.03.
SET Kd TO 0.05.

LOCK dthrott TO Kp * P + Ki * I + Kd * D.

SET thrott TO 0.
LOCK THROTTLE to thrott.

SET t0 TO TIME:SECONDS.
UNTIL SHIP:ALTITUDE > 40000 {
    SET dt TO TIME:SECONDS - t0.
    IF dt > 0 {
        IF NOT in_deadband {
            SET I TO I + P * dt.
            SET D TO (P - P0) / dt.

            // If Ki is non-zero, then limit Ki*I to [-1,1]
            IF Ki > 0 {
                SET I TO MIN(1.0/Ki, MAX(-1.0/Ki, I)).
            }

            // set throttle but keep in range [0,1]
            SET thrott to MIN(1, MAX(0, dthrott)).
            print P.
            print thrott.

            SET P0 TO P.
            SET t0 TO TIME:SECONDS.
        }
    }
    WAIT 0.1.
}

// Function VelocityCalculator {
//   Parameter OrbitHeight.

//   set KerbinRadius to 600000.
//   set TotalRadius to OrbitHeight + KerbinRadius.
//   set OrbitalPeriod to ship:orbit:period.
//   return (2 * 3.1416 * TotalRadius) / OrbitalPeriod.
//   // everything after the return command will be skipped because a return command ends a function.
//   print "this will be skipped".
// }

// set CurrentVelocity to VelocityCalculator(400000).
// print CurrentVelocity.
