# what can a vehicle do?

module Vehicle

# -- Interface --
# Basic operational functions that a vehicle should implement:
#
# power_on!(v) 
# power_off!(v) 
# turn!(v, angle)
# move!(v, distance)

# Define generic functions
function power_on! end
function power_off! end
function turn! end
function move! end

# Figure out a travel plan from current position (src)
# to destination (dst)
function travel_path(src, dest)
    return 30, 1e10   # just a test
end

# Value-add logic that can be reused
function go_trip(v, src, dest) 
    power_on!(v)
    angle, distance = travel_path(src, dest)
    turn!(v, angle)
    move!(v, distance)
    power_off!(v)
end

end # module