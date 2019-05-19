# ------------------------------------------------------------------------------
# Space war game!
mutable struct Position
    x::Int
    y::Int
end

struct Size
    width::Int
    height::Int
end

struct Widget
    name::String
    position::Position
    size::Size
end

# Define pretty print functions
Base.show(io::IO, p::Position) = print(io, "(", p.x, ",", p.y, ")")
Base.show(io::IO, s::Size) = print(io, s.width, " x ", s.height)
Base.show(io::IO, w::Widget) = print(io, w.name, " at ", w.position, " size ", w.size)

# single-line functions
move_up!(widget, v)    = widget.position.y -= v
move_down!(widget, v)  = widget.position.y += v
move_left!(widget, v)  = widget.position.x -= v
move_right!(widget, v) = widget.position.x += v

# long version
function move_up!(widget, v)
    widget.position.y -= v
end

# let's test these functions
w = Widget("asteroid", Position(0, 0), Size(10, 20))
move_up!(w, 10)
move_down!(w, 10)
move_left!(w, 20)
move_right!(w, 20)
print(w)   # should be back to position (0,0)
# REPL
# julia> w = Widget("asteroid", Position(0, 0), Size(10, 20))
# asteroid at (0,0) size 10 x 20

# julia> move_up!(w, 10)
# -10

# julia> move_down!(w, 10)
# 0

# julia> move_left!(w, 20)
# -20

# julia> move_right!(w, 20)
# 0

# julia> print(w) 
# asteroid at (0,0) size 10 x 20


# behavior without annotating type in arguments
move_up!(1, 2)
# REPL
# julia> move_up!(1, 2)
# ERROR: type Int64 has no field position

# Now, restart REPL.
# Redfine with type annotation.
move_up!(widget::Widget, v::Real) = widget.position.y -= v
move_up!(1, 2)

# REPL
# julia> move_up!(1, 2)
# ERROR: MethodError: no method matching move_up!(::Float64, ::Float64)
# Closest candidates are:
#   move_up!(::Widget, ::Real) at REPL[7]:1

# ------------------------------------------------------------------------------
# Optional arguments

# Make a bunch of asteroids
function make_asteroids(N::Int, pos_range = 0:200, size_range = 10:30)
    pos_rand() = rand(pos_range)
    sz_rand() = rand(size_range)
    return [Widget("Asteroid #$i", 
                Position(pos_rand(), pos_rand()), 
                Size(sz_rand(), sz_rand())) 
        for i in 1:N]
end
# REPL
# julia> make_asteroids
# make_asteroids (generic function with 3 methods)
#
# julia> make_asteroids(     <-- hit TAB key
# make_asteroids(N::Int64) in Main at REPL[21]:12
# make_asteroids(N::Int64, pos_range) in Main at REPL[21]:12
# make_asteroids(N::Int64, pos_range, size_range) in Main at REPL[21]:12

asteroids = make_asteroids(5)
# REPL
# julia> asteroids = make_asteroids(5)
# 5-element Array{Widget,1}:
#  Asteroid #1 at (129,172) size 20 x 17
#  Asteroid #2 at (93,143) size 29 x 22 
#  Asteroid #3 at (157,152) size 26 x 14
#  Asteroid #4 at (120,3) size 26 x 15  
#  Asteroid #5 at (5,178) size 20 x 26  

asteroids = make_asteroids(5, 1:10)
# REPL
# julia> asteroids = make_asteroids(5, 1:10)
# 5-element Array{Widget,1}:
#  Asteroid #1 at (4,10) size 10 x 20
#  Asteroid #2 at (4,5) size 27 x 14 
#  Asteroid #3 at (3,1) size 12 x 16 
#  Asteroid #4 at (5,9) size 28 x 26 
#  Asteroid #5 at (4,3) size 11 x 28 

asteroids = make_asteroids(5, 0:100:500, 5:5:10)
# REPL
# julia> asteroids = make_asteroids(5, 0:100:500, 5:5:10)
# 5-element Array{Widget,1}:
#  Asteroid #1 at (100,400) size 10 x 10
#  Asteroid #2 at (500,400) size 10 x 10
#  Asteroid #3 at (500,100) size 5 x 5  
#  Asteroid #4 at (200,0) size 5 x 10   
#  Asteroid #5 at (300,300) size 5 x 10 

# ------------------------------------------------------------------------------
# keyword arguments

function make_asteroids2(N::Int; pos_range = 0:200, size_range = 10:30)
    pos_rand() = rand(pos_range)
    sz_rand() = rand(size_range)
    return [Widget("Asteroid #$i", 
                Position(pos_rand(), pos_rand()), 
                Size(sz_rand(), sz_rand())) 
        for i in 1:N]
end

asteroids = make_asteroids2(5, pos_range = 0:100:500)
# julia> asteroids = make_asteroids2(5, pos_range = 0:100:500)
# 5-element Array{Widget,1}:
#  Asteroid #1 at (200,500) size 29 x 25
#  Asteroid #2 at (100,400) size 18 x 28
#  Asteroid #3 at (400,500) size 13 x 10
#  Asteroid #4 at (200,500) size 12 x 23
#  Asteroid #5 at (200,500) size 16 x 12

asteroids = make_asteroids2(5, size_range = 1:5, pos_range = 0:10:100)
# julia> asteroids = make_asteroids2(5, size_range = 1:5, pos_range = 0:10:100)
# 5-element Array{Widget,1}:
#  Asteroid #1 at (10,90) size 4 x 1
#  Asteroid #2 at (30,20) size 5 x 3
#  Asteroid #3 at (10,70) size 3 x 5
#  Asteroid #4 at (70,70) size 5 x 2
#  Asteroid #5 at (0,60) size 3 x 3 

# ------------------------------------------------------------------------------
# Variable arguments, aka "slurping"

# Shoot any number of targets
function shoot(from::Widget, targets::Widget...)
    println("Type of targets: ", typeof(targets))
    for target in targets
        println(from.name, " --> ", target.name)
    end
end

spaceship = Widget("Spaceship", Position(0, 0), Size(30,30))
target1 = asteroids[1]
target2 = asteroids[2]
target3 = asteroids[3]

shoot(spaceship, target1)
shoot(spaceship, target1, target2, target3)
# julia> shoot(spaceship, target1)
# Type of targets: Tuple{Widget}
# Spaceship --> Asteroid #1

# julia> shoot(spaceship, target1, target2, target3)
# Type of targets: Tuple{Widget,Widget,Widget}
# Spaceship --> Asteroid #1
# Spaceship --> Asteroid #2
# Spaceship --> Asteroid #3

# ------------------------------------------------------------------------------
# splatting

# Special arrangement before attacks
function triangular_formation!(s1::Widget, s2::Widget, s3::Widget)
    x_offset = 30
    y_offset = 50
    s2.position.x = s1.position.x - x_offset
    s3.position.x = s1.position.x + x_offset
    s2.position.y = s3.position.y = s1.position.y - y_offset
    (s1, s2, s3)
end

spaceships = [Widget("Spaceship $i", Position(0,0), Size(20, 50)) 
                for i in 1:3]
triangular_formation!(spaceships...);
spaceships
# julia> spaceships = [Widget("Spaceship $i", Position(0,0), Size(20, 50)) 
#                        for i in 1:3]
# 3-element Array{Widget,1}:
#  Spaceship 1 at (0,0) size 20 x 50
#  Spaceship 2 at (0,0) size 20 x 50
#  Spaceship 3 at (0,0) size 20 x 50

# julia> triangular_formation!(spaceships...);

# julia> spaceships
# 3-element Array{Widget,1}:
#  Spaceship 1 at (0,0) size 20 x 50    
#  Spaceship 2 at (-30,-50) size 20 x 50
#  Spaceship 3 at (30,-50) size 20 x 50 

# ------------------------------------------------------------------------------
# first class functions

function random_move()
    return rand([move_up!, move_down!, move_left!, move_right!])
end

function random_leap!(w::Widget, move_func::Function, distance::Int)
    move_func(w, distance)
    return w
end

spaceship = Widget("Spaceship", Position(0,0), Size(20,50))
random_leap!(spaceship, random_move(), rand(50:100))
random_leap!(spaceship, random_move(), rand(50:100))

# julia> spaceship = Widget("Spaceship", Position(0,0), Size(20,50))
# Spaceship at (0,0) size 20 x 50

# julia> random_leap!(spaceship, random_move(), rand(50:100))
# Spaceship at (0,71) size 20 x 50

# julia> random_leap!(spaceship, random_move(), rand(50:100))
# Spaceship at (78,71) size 20 x 50

# ------------------------------------------------------------------------------
# anonymous functions

# using named function

function explode(x)
    println(x, " exploded!")
end

function clean_up_galaxy(asteroids)
    foreach(explode, asteroids)
end

# julia> clean_up_galaxy(asteroids)
# Asteroid #1 at (10,0) size 1 x 2 exploded!
# Asteroid #2 at (30,50) size 1 x 1 exploded!
# Asteroid #3 at (40,60) size 5 x 3 exploded!
# Asteroid #4 at (0,20) size 3 x 1 exploded!
# Asteroid #5 at (80,50) size 3 x 5 exploded!

# using anonymous function
function clean_up_galaxy(asteroids)
    foreach(x -> println(x, " exploded!"), asteroids)
end

# bound to variable, and it can be used more than once
function clean_up_galaxy(asteroids, spaceships)
    ep = x -> println(x, " exploded!")
    foreach(ep, asteroids)
    foreach(ep, spaceships)
end

# julia> clean_up_galaxy(asteroids, spaceships)
# Asteroid #1 at (10,0) size 1 x 2 exploded!
# Asteroid #2 at (30,50) size 1 x 1 exploded!
# Asteroid #3 at (40,60) size 5 x 3 exploded!
# Asteroid #4 at (0,20) size 3 x 1 exploded!
# Asteroid #5 at (80,50) size 3 x 5 exploded!
# Spaceship 1 at (0,0) size 20 x 50 exploded!
# Spaceship 2 at (-30,-50) size 20 x 50 exploded!
# Spaceship 3 at (30,-50) size 20 x 50 exploded!

# ------------------------------------------------------------------------------
# do syntax

# Random healthiness function for testing
healthy(spacehsip) = rand(Bool)

# make sure that the spaceship is healthy before any operation 
function fire(f::Function, spaceship::Widget)
    if healthy(spaceship)
        f(spaceship)
    else
        println("Operation aborted as spaceship is not healthy")
    end
    return nothing
end

# use anonymous function

# julia> fire(s -> println(s, " launched missile!"), spaceship)
# Spaceship at (78,71) size 20 x 50 launched missile!

# julia> fire(s -> println(s, " launched missile!"), spaceship)
# Operation aborted as spaceship is not healthy

# what if we have a more complex operation?
fire(s -> begin
        move_up!(s, 100)
        println(s, " launched missile!")
        move_down!(s, 100)
    end, spaceship)

# cleaner syntax
fire(spaceship) do s
    move_up!(s, 100)
    println(s, " launched missile!")
    move_down!(s, 100)
end

# open/close house keeping 
function process_file(func::Function, filename::AbstractString)
    try
        ios = open(filename)
        func(ios)
    finally
        close(ios)
    end
end

# ------------------------------------------------------------------------------
# Closure

# capture and hide variable
function create_attacker(name)
    spaceship = Widget(name, Position(0,0), Size(20,50))
    return attackee -> println(spaceship.name, " attacks ", attackee.name)
end
attack = create_attacker("Goose Fighter")
attack(asteroids[1])

# # motivation
# move_up!(spaceship, 100)
# move_down!(spaceship, 100)
# move_left!(spaceship, 100)
# move_right!(spaceship, 100)

# # create clousure by capturing the spaceship variable from outer scope
# up!    = v::Real -> move_up!(spaceship, v)
# down!  = v::Real -> move_down!(spaceship, v)
# left!  = v::Real -> move_left!(spaceship, v)
# right! = v::Real -> move_right!(spaceship, v)

# # cleaner code as there is no mention of spaceship!
# up!(100)
# down!(100)
# left!(100)
# right!(100)

# # using closure to implemnt callback 
# function safe_move_up!(w::Widget, callback::Function)
#     try
#         # let's say this call may fail if it collides with an asteroid
#         move_up!(w, 10) 
#     catch ex
#         callback(w, ex)
#     end
# end

# # how to use...
# crash_handler(widget, ex) = println(widget, " problem: ", ex)
# safe_move_up!(spaceship, crash_handler)
