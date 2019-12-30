# Behavior subtyping

abstract type Vehicle end

struct Car <: Vehicle end

move(v::Vehicle) = "$v has moved.";

car = Car();
move(car)
#=
julia> move(helicopter)
"Helicopter() has moved."
=#

# Inheritance over multiple levels

abstract type FlyingVehicle <: Vehicle end

liftoff(v::FlyingVehicle) = "$v has lifted off.";

struct Helicopter <: FlyingVehicle end

helicopter = Helicopter();
move(helicopter)
liftoff(helicopter)
#=
julia> move(helicopter)
"Helicopter() has moved."

julia> liftoff(helicopter)
"Helicopter() has lifted off."
=#

# Method overrides

liftoff(h::Helicopter) = "$h has lifted off vertically.";

liftoff(helicopter)
#=
julia> liftoff(h::Helicopter) = "$h has lifted off vertically.";

julia> liftoff(helicopter)
"Helicopter() has lifted off vertically."
=#

# Duck typing

abstract type Animal end

struct Horse <: Animal end

move(h::Horse) = "$h running fast.";

horse = Horse();
move(horse)


