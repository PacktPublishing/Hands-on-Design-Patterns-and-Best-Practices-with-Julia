mutable struct Position
    x::Int
    y::Int
end

struct Size
    width::Int
    height::Int
end

# ----
@enum Weapon Laser Missile

# A thing should have a position and size
abstract type Thing end
position(t::Thing) = t.position
size(t::Thing) = t.size

struct Spaceship <: Thing
    position::Position
    size::Size
    weapon::Weapon
end

Base.show(io::IO, s::Spaceship) = 
    print(io, "Spaceship (", s.position.x, ",", s.position.y, ") " ,
        s.size.width, "x", s.size.height,
        "/", s.weapon)

struct Asteroid <: Thing
    position::Position
    size::Size
end

Base.show(io::IO, s::Asteroid) = 
    print(io, "Asteroid (", s.position.x, ",", s.position.y, 
        ") ", s.size.width, "x", s.size.height)

# Test
s1 = Spaceship(Position(0,0), Size(30,5), Missile) 
s2 = Spaceship(Position(10,0), Size(30,5), Laser) 
a1 = Asteroid(Position(20,0), Size(20,20))
a2 = Asteroid(Position(0,20), Size(20,20))

# ----------------------------------------------------------------------
# parametric methods

# explode an array of objects
function explode(things::AbstractVector{Any})
    for t in things
        println("Exploding ", t)
    end
end

# explode an array of objects (parametric version)
function explode(things::AbstractVector{T}) where {T}
    for t in things
        println("Exploding ", t)
    end
end

explode([a1, a2])
#= REPL
julia> explode([a1, a2])
Exploding Asteroid (20,0) 20x20
Exploding Asteroid (0,20) 20x20
=#

explode([:building, :hill])
#= REPL
julia> explode([:building, :hill])
Exploding building
Exploding hill

julia> Vector{Asteroid} <: AbstractVector{Asteroid}
true
=#

# Same function with a more narrow type
function explode(things::AbstractVector{T}) where {T <: Thing}
    for t in things
        println("Exploding thing => ", t)
    end
end

explode([a1, a2])
#= REPL
julia> explode([a1, a2])
Exploding thing => Asteroid (20,0) 20x20
Exploding thing => Asteroid (0,20) 20x20
=#

# ---------------

# specifying abstract/concrete types in method signature
function tow(A::Spaceship, B::Thing)
    "tow 1"
end

methods(tow)
#=
julia> methods(tow)
# 1 method for generic function "tow":
[1] tow(A::Spaceship, B::Thing) in Main at REPL[17]:8
=#

# equivalent of parametric type 
function tow(A::Spaceship, B::T) where {T <: Thing}
    "tow 2"
end

methods(tow)
#= REPL
julia> methods(tow)
# 1 method for generic function "tow":
[1] tow(A::Spaceship, B::T) where T<:Thing in Main at REPL[20]:2
=#

# --- ensure type consistency

function group_anything(A::Thing, B::Thing)
    println("Grouped ", A, " and ", B)
end

group_anything(s1, s2)
group_anything(a1, a2)
group_anything(s1, a1)
group_anything(a1, s1)

#= REPL
julia> group_anything(s1, s2)
Grouped Spaceship((0,0), 30 x 5, Missile::Weapon = 1) and Spaceship((10,0), 30 x 5, Laser::Weapon = 0)

julia> group_anything(a1, a2)
Grouped Asteroid((20,0), 20 x 20) and Asteroid((0,20), 20 x 20)

julia> group_anything(s1, a1)
Grouped Spaceship((0,0), 30 x 5, Missile::Weapon = 1) and Asteroid((20,0), 20 x 20)

julia> group_anything(a1, s1)
Grouped Asteroid((20,0), 20 x 20) and Spaceship((0,0), 30 x 5, Missile::Weapon = 1)
=#


function group_same_things(A::T, B::T) where {T <: Thing}
    println("Grouped ", A, " and ", B)
end

group_same_things(s1, s2)
group_same_things(a1, a2)
group_same_things(s1, a1)
group_same_things(a1, s1)

#=
julia> group_same_things(s1, s2)
Grouped Spaceship((0,0), 30 x 5, Missile::Weapon = 1) and Spaceship((10,0), 30 x 5, Laser::Weapon = 0)

julia> group_same_things(a1, a2)
Grouped Asteroid((20,0), 20 x 20) and Asteroid((0,20), 20 x 20)

julia> group_same_things(s1, a1)
ERROR: MethodError: no method matching group_same_things(::Spaceship, ::Asteroid)
Closest candidates are:
  group_same_things(::T<:Thing, ::T<:Thing) where T<:Thing at REPL[88]:2

julia> group_same_things(a1, s1)
ERROR: MethodError: no method matching group_same_things(::Asteroid, ::Spaceship)
Closest candidates are:
  group_same_things(::T<:Thing, ::T<:Thing) where T<:Thing at REPL[88]:2
=#

# ----------------------------------------------------------------------
# Extracting type info

eltype(things::AbstractVector{T}) where {T <: Thing} = T

eltype([s1, s2])
eltype([a1, a2])
eltype([s1, s2, a1, a2])

# julia> eltype([s1, s2])
# Spaceship

# julia> eltype([a1, a2])
# Asteroid

# julia> eltype([s1, s2, a1, a2])
# Thing

# julia> typeof([s1, s2])
# Array{Spaceship,1}

# julia> typeof([a1, a2])
# Array{Asteroid,1}

# julia> typeof([s1, s2, a1, a2])
# Array{Thing,1}

