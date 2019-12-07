# multiple dispatch

# ----------------------------------------------------------------------
# setup

mutable struct Position
    x::Int
    y::Int
end

struct Size
    width::Int
    height::Int
end


# A thing should have a position and size
abstract type Thing end
position(t::Thing) = t.position
size(t::Thing) = t.size
shape(t::Thing) = :unknown

# Type of weapons
@enum Weapon Laser Missile

# Spaceship 
struct Spaceship <: Thing
    position::Position
    size::Size
    weapon::Weapon
end
shape(s::Spaceship) = :saucer

# Asteroid 
struct Asteroid <: Thing
    position::Position
    size::Size
end

# ----------------------------------------------------------------------
# dispatch to the narrowest type

s1 = Spaceship(Position(0,0), Size(30,5), Missile);
s2 = Spaceship(Position(10,0), Size(30,5), Laser);
a1 = Asteroid(Position(20,0), Size(20,20));
a2 = Asteroid(Position(0,20), Size(20,20));

#=
julia> s1 = Spaceship(Position(0,0), Size(30,5), Missile);

julia> s2 = Spaceship(Position(10,0), Size(30,5), Laser);

julia> a1 = Asteroid(Position(20,0), Size(20,20));

julia> a2 = Asteroid(Position(0,20), Size(20,20));

julia> position(s1), size(s1), shape(s1)
(Position(0, 0), Size(30, 5), :saucer)

julia> position(a1), size(a1), shape(a1)
(Position(20, 0), Size(20, 20), :unknown)
=#

# ----------------------------------------------------------------------

struct Rectangle
    top::Int
    left::Int
    bottom::Int
    right::Int
    # return two upper-left and lower-right points of the rectangle
    Rectangle(p::Position, s::Size) = 
        new(p.y+s.height, p.x, p.y, p.x+s.width)
end

# check if the two rectangles (A & B) overlap
function overlap(A::Rectangle, B::Rectangle)
    return A.left < B.right && A.right > B.left &&
        A.top > B.bottom && A.bottom < B.top
end

# using abstract type Thing
function collide(A::Thing, B::Thing)
    println("Checking collision of thing vs. thing")
    rectA = Rectangle(position(A), size(A))
    rectB = Rectangle(position(B), size(B))
    return overlap(rectA, rectB)
end

#=
julia> collide(s1, s2);
Checking collision of thing vs. thing

julia> collide(a1, a2);
Checking collision of thing vs. thing

julia> collide(s1, a1);
Checking collision of thing vs. thing

julia> collide(a1, s1);
Checking collision of thing vs. thing
=#

# more specific
function collide(A::Spaceship, B::Spaceship)
    println("Checking collision of spaceship vs. spaceship")
    return true   # just a test
end 

#=
julia> collide(s1, s2);
Checking collision of spaceship vs. spaceship

julia> collide(a1, a2);
Checking collision of thing vs. thing

julia> collide(s1, a1);
Checking collision of thing vs. thing

julia> collide(a1, s1);
Checking collision of thing vs. thing
=#

# ----------------------------------------------------------------------
# Ambiguity

function collide(A::Asteroid, B::Thing)
    println("Checking collision of asteroid vs. thing")
    return true
end

function collide(A::Thing, B::Asteroid)
    println("Checking collision of thing vs. asteroid")
    return false
end

collide(a1, s1);
collide(s1, a1);
collide(a1, a2);

#= REPL
julia> collide(a1, s1);
Checking collision of asteroid vs. thing

julia> collide(s1, a1);
Checking collision of thing vs. asteroid

julia> collide(a1, a2);
ERROR: MethodError: collide(::Asteroid, ::Asteroid) is ambiguous. Candidates:
  collide(A::Thing, B::Asteroid) in Main at REPL[23]:2
  collide(A::Asteroid, B::Thing) in Main at REPL[22]:5
Possible fix, define
  collide(::Asteroid, ::Asteroid)
=#

function collide(A::Asteroid, B::Asteroid)
    println("Checking collision of asteroid vs. asteroid")
    return true  # just a test
end
collide(a1, a2);

#= REPL
julia> collide(a1, a2);
Checking collision of asteroid vs. asteroid
=#

# ----------------------------------------------------------------------
# detecting ambiguity

using Test

module Foo
    foo(x, y) = 1
    foo(x::Integer, y) = 2
    foo(x, y::Integer) = 3
end

detect_ambiguities(Main.Foo)

#= REPL
julia> using Test

julia> module Foo
            foo(x, y) = 1
            foo(x::Integer, y) = 2
            foo(x, y::Integer) = 3
       end
Main.Foo

julia> detect_ambiguities(Main.Foo)
1-element Array{Tuple{Method,Method},1}:
 (foo(x::Integer, y) in Main.Foo at REPL[25]:3, foo(x, y::Integer) in Main.Foo at REPL[25]:4)
=#

# -- fixed 
module Foo
    foo(x, y) = 1
    foo(x::Integer, y) = 2
    foo(x, y::Integer) = 3
    foo(x::Integer, y::Integer) = 4
end

detect_ambiguities(Main.Foo)


#=
julia> module Foo
            foo(x, y) = 1
            foo(x::Integer, y) = 2
            foo(x, y::Integer) = 3
            foo(x::Integer, y::Integer) = 4
        end
Main.Foo

julia> detect_ambiguities(Main.Foo)
0-element Array{Tuple{Method,Method},1}
=#

# -- multiple modules
module Foo2
    foo(x, y) = 1
    foo(x::Integer, y) = 2
    foo(x, y::Integer) = 3
end

module Foo4
    import Main.Foo2
    Foo2.foo(x::Integer, y::Integer) = 4
end

detect_ambiguities(Main.Foo2, Main.Foo4)

#=
julia> module Foo2
       foo(x, y) = 1
       foo(x::Integer, y) = 2
       foo(x, y::Integer) = 3
       end
Main.Foo2

julia> module Foo4
       import Main.Foo2
       Foo2.foo(x::Integer, y::Integer) = 4
       end
Main.Foo4

julia> detect_ambiguities(Main.Foo2, Main.Foo4)
0-element Array{Tuple{Method,Method},1}
=#

# ----------------------------------------------------------------------
# dynamic dispatch

# randomly pick two things and check
function check_randomly(things)
    for i in 1:5
        two = rand(things, 2)
        collide(two...)
    end
end

check_randomly([s1, s2, a1, a2])

#= REPL
julia> check_randomly([s1, s2, a1, a2])
Checking collision of spaceship vs. spaceship
Checking collision of thing vs. asteroid
Checking collision of asteroid vs. thing
Checking collision of asteroid vs. thing
Checking collision of asteroid vs. asteroid
=#
