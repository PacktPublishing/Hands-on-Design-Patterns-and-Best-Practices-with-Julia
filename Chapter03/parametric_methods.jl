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
# julia> explode([a1, a2])
# Exploding Asteroid (20,0) 20x20
# Exploding Asteroid (0,20) 20x20

explode([:building, :hill])
# julia> explode([:building, :hill])
# Exploding building
# Exploding hill

# julia> Vector{Asteroid} <: AbstractVector{Asteroid}
# true

# Same function with a more narrow type
function explode(things::AbstractVector{T}) where {T <: Thing}
    for t in things
        println("Exploding thing => ", t)
    end
end

explode([a1, a2])
# julia> explode([a1, a2])
# Exploding thing => Asteroid (20,0) 20x20
# Exploding thing => Asteroid (0,20) 20x20

# ---------------

# specifying abstract/concrete types in method signature
function tow(A::Spaceship, B::Thing)
    "tow 1"
end

methods(tow)
# julia> methods(tow)
# # 1 method for generic function "tow":
# [1] tow(A::Spaceship, B::Thing) in Main at REPL[17]:8

# equivalent of parametric type 
function tow(A::Spaceship, B::T) where {T <: Thing}
    "tow 2"
end

methods(tow)
# julia> methods(tow)
# # 1 method for generic function "tow":
# [1] tow(A::Spaceship, B::T) where T<:Thing in Main at REPL[20]:2

# --- ensure type consistency

function group_anything(A::Thing, B::Thing)
    println("Grouped ", A, " and ", B)
end

group_anything(s1, s2)
group_anything(a1, a2)
group_anything(s1, a1)
group_anything(a1, s1)

# julia> group_anything(s1, s2)
# Grouped Spaceship (0,0) 30x5/Missile and Spaceship (10,0) 30x5/Laser

# julia> group_anything(a1, a2)
# Grouped Asteroid (20,0) 20x20 and Asteroid (0,20) 20x20

# julia> group_anything(s1, a1)
# Grouped Spaceship (0,0) 30x5/Missile and Asteroid (20,0) 20x20

# julia> group_anything(a1, s1)
# Grouped Asteroid (20,0) 20x20 and Spaceship (0,0) 30x5/Missile


function group_same_things(A::T, B::T) where {T <: Thing}
    println("Grouped ", A, " and ", B)
end

group_same_things(s1, s2)
group_same_things(a1, a2)
group_same_things(s1, a1)
group_same_things(a1, s1)

# julia> group_same_things(s1, s2)
# Grouped Spaceship (0,0) 30x5/Missile and Spaceship (10,0) 30x5/Laser

# julia> group_same_things(a1, a2)
# Grouped Asteroid (20,0) 20x20 and Asteroid (0,20) 20x20

# julia> group_same_things(s1, a1)
# ERROR: MethodError: no method matching group_same_things(::Spaceship, ::Asteroid)
# Closest candidates are:
#   group_same_things(::T<:Thing, ::T<:Thing) where T<:Thing at REPL[52]:2

# julia> group_same_things(a1, s1)
# ERROR: MethodError: no method matching group_same_things(::Asteroid, ::Spaceship)
# Closest candidates are:
#   group_same_things(::T<:Thing, ::T<:Thing) where T<:Thing at REPL[52]:2

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

# ----------------------------------------------------------------------
# Enforce type relationships

function leap!(A::Spaceship, 
        leaps::AbstractVector{T}, 
        angle::S) where {T <: Integer, S <: T}
    println("Leap!")
end

leap!(s1, [10, 15, 12], 30)
leap!(s1, [10, 15, 12], UInt8(30))


function travel(A::Spaceship, distance::T, angle::S) where {T <: Real, S <: T}
    println("Teleport ", distance, " at ", angle, " degrees") 
end

travel(s1, 1e30, 60.0)
travel(s1, 1e30, 30)

julia> travel(s1, 1e30, 60.0)
Teleport 1.0e30 at 60.0 degrees

# why does it work?  Int64 is not subtype of Float64?

julia> travel(s1, 1e30, 30)
Teleport 1.0e30 at 30 degrees


# ----------------------------------------------------------------------
# collection types in parametric methods

targets1 = [a1, a2]
targets2 = [s2, a1, a2]

# julia> targets1 = [a1, a2]
# 2-element Array{Asteroid,1}:
#  Asteroid (20,0) 20x20
#  Asteroid (0,20) 20x20

# julia> targets2 = [s2, a1, a2]
# 3-element Array{Thing,1}:
#  Spaceship (10,0) 30x5/Laser
#  Asteroid (20,0) 20x20      
#  Asteroid (0,20) 20x20      

# attack an array of target objects
function attack(A::Spaceship, B::AbstractVector{T}) where {T <: Thing}
    for b in B
        println(A, " --attack--> ", b)
    end
end

attack(s1, targets1)
attack(s1, targets2)

# julia> attack(s1, targets1)
# Spaceship (0,0) 30x5/Missile --attack--> Asteroid (20,0) 20x20
# Spaceship (0,0) 30x5/Missile --attack--> Asteroid (0,20) 20x20

# julia> attack(s1, targets2)
# Spaceship (0,0) 30x5/Missile --attack--> Spaceship (10,0) 30x5/Laser
# Spaceship (0,0) 30x5/Missile --attack--> Asteroid (20,0) 20x20
# Spaceship (0,0) 30x5/Missile --attack--> Asteroid (0,20) 20x20

# what if we just use abstract type?
function attack(A::Spaceship, B::AbstractVector{Thing})
    for b in B
        println(A, " --attack2--> ", b)
    end
end
attack(s1, [a1, a2])
# julia> attack(s1, [a1, a2])
# Spaceship (0,0) 30x5/Missile --attack--> Asteroid (20,0) 20x20
# Spaceship (0,0) 30x5/Missile --attack--> Asteroid (0,20) 20x20

attack(s1, [s2, a1, a2])
# julia> attack(s1, [s2, a1, a2])
# Spaceship (0,0) 30x5/Missile --attack2--> Spaceship (10,0) 30x5/Laser,Missile
# Spaceship (0,0) 30x5/Missile --attack2--> Asteroid (20,0) 20x20
# Spaceship (0,0) 30x5/Missile --attack2--> Asteroid (0,20) 20x20

# Moral of the story -> parametric method is dispatched for homongenous vector

# ----------------------------------------------------------------------
# more parameters?

function move_all(things::AbstractVector{T}, height::S) where {S <: Signed, T <: Thing}
    for t in things
        t.position.y += height
    end
    return things
end

println("Before move:")
foreach(println, [s1, s2, a1, a2])

move_all([s1, s2], 300)
println("After 1st move:")
foreach(println, [s1, s2, a1, a2])

move_all([s1, s2, a1, a2], 300)
println("After 2nd move:")
foreach(println, [s1, s2, a1, a2])

# julia> println("Before move:")
# Before move:

# julia> foreach(println, [s1, s2, a1, a2])
# Spaceship (0,0) 30x5/Missile
# Spaceship (10,0) 30x5/Laser,Missile
# Asteroid (20,0) 20x20
# Asteroid (0,20) 20x20

# julia> move_all([s1, s2], 300)
# 2-element Array{Spaceship,1}:
#  Spaceship (0,300) 30x5/Missile       
#  Spaceship (10,300) 30x5/Laser,Missile

# julia> move_all([s1, s2, a1, a2], 300)
# 4-element Array{Thing,1}:
#  Spaceship (0,600) 30x5/Missile       
#  Spaceship (10,600) 30x5/Laser,Missile
#  Asteroid (20,300) 20x20              
#  Asteroid (0,320) 20x20               

# julia> println("After 2nd move:")
# After 2nd move:

# julia> foreach(println, [s1, s2, a1, a2])
# Spaceship (0,600) 30x5/Missile
# Spaceship (10,600) 30x5/Laser,Missile
# Asteroid (20,300) 20x20
# Asteroid (0,320) 20x20


