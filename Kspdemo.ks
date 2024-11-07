
// Define constants
set G to 6.67430E-11.  // Gravitational constant

// Define target altitude for orbit
set target_apogee to 80000.  // 80 km target orbit

// Pre-launch setup
lock throttle to 1.0.  // Full throttle
lock steering to up + R(0,0,90).  // Point straight up for launch

// Countdown and launch
print "Launching in 3... 2... 1...".
wait 1.
stage.  // Activate first stage
print "Launch!".

// Gravity turn at 10km
wait until ship:altitude > 10000.  // Start turn at 10 km
lock steering to heading(90, 45).  // Pitch to 45° eastA

// Fine-tune pitch as altitude increases
until ship:altitude > 40000 {  // Adjust pitch as we climb
    set target_pitch to 45 - (ship:altitude - 10000) / 3000.
    lock steering to heading(90, max(5, target_pitch)).
    wait 0.5.
}

// Cut off throttle at target apogee
wait until apoapsis > target_apogee.
lock throttle to 0.
print "Reached target apoapsis: " + round(apoapsis) + "m.".

// Coast to apogee using time skip
print "Coasting to apogee...".
wait until ship:altitude > 70000.  // Start time skipping in space
wait until eta:apoapsis < 10.  // Fine-tune approach to apogee

// Calculate mu for the current body
set mu to G * body:mass.

// Prepare for circularization burn
set burn_time to (ship:mass * sqrt(mu / (body:radius + apoapsis)) * (1 - periapsis / apoapsis)) / maxthrust.
lock throttle to 1.0.
wait until eta:apoapsis < burn_time / 2.  // Start burn half the burn time before apogee

// Circularization burn
print "Circularizing orbit...".
wait until periapsis >= target_apogee.
lock throttle to 0.
print "Orbit achieved!".

// Script complete
print "Target orbit with apogee and periapsis around " + round(target_apogee) + "m.".

