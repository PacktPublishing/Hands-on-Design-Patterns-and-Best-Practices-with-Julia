module Vehicle

# ------------------------------------------------------------------
# 1. Export/Imports
# ------------------------------------------------------------------
export go!, land!

# ------------------------------------------------------------------
# 2. Interface documentation
# ------------------------------------------------------------------
# A vehicle must implement the following functions for vehicle `v`:
#
# power_on!(v) - turn on the vehicle's engine
# power_off!(v) - turn off the vehicle's engine
# turn!(v, direction) - steer the vehicle to the specified direction 
# move!(v, distance) - move the vehicle by the specified distance
# position(v) - returns the (x,y) position of the vehicle
# engage_wheels!(v) - engage wheels for landing.  Optional.
# has_wheels(v) - returns true if the vehicle has wheels.

# ------------------------------------------------------------------
# 3. Generic definitions for the interface
# ------------------------------------------------------------------
function power_on! end
function power_off! end
function turn! end
function move! end
function position end

# soft contracts
engage_wheels!(args...) = nothing

# trait
has_wheels(vehicle) = error("Not implemented.")

# ------------------------------------------------------------------
# 4. Game logic 
# ------------------------------------------------------------------

# Returns a travel plan from current position to destination
function travel_path(position, destination)
    return round(π/6, digits=2), 1000   # just a test
end

# Space travel logic
function go!(vehicle, destination) 
    power_on!(vehicle)
    direction, distance = travel_path(vehicle, destination)
    turn!(vehicle, direction)
    move!(vehicle, distance)
    power_off!(vehicle)
    nothing
end

# Landing
function land!(vehicle)
    engage_wheels!(vehicle)
    println("Landing vehicle: ", vehicle)
end

# Landing (using trait)
function land2!(vehicle)
    has_wheels(vehicle) && engage_wheels!(vehicle)
    println("Landing vehicle: ", vehicle)
end

end # module