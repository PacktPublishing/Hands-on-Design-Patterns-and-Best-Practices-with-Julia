# ------------------------------------------------------------------------------
# argument destructuring 

using StatsBase: sample

# Return two random widgets from the list
function random_pair(widgets::Vector{Widget})
    return Tuple(sample(widgets, 2, replace = false))
end

pair = random_pair(asteroids)
# REPL
# julia> random_pair(asteroids)
# (Asteroid #4 at (53,140) size 24 x 11, Asteroid #2 at (131,184) size 18 x 7)

# calculate the area of a widget
area(w::Widget) = w.size.width * w.size.height

# vanilla function - call site a little ugly
function bigger(p1::Widget, p2::Widget)
    area(p1) > area(p2) ? p1 : p2
end
print(bigger(pair[1], pair[2]))
# REPL
# julia> print(bigger(pair[1], pair[2]))
# Asteroid #2 at (31.0,72.0) size 9.0 x 18.0

# take a Vector - implementation look a little ugly
function bigger(pair::Vector{Widget})
    area(pair[1]) > area(pair[2]) ? pair[1] : pair[2]
end
print(bigger(pair))
# REPL
# julia> print(bigger(pair))
# Asteroid #2 at (31.0,72.0) size 9.0 x 18.0

# manual destructuring - better implementation
function bigger(pair::Vector{Widget})
    p1, p2 = pair
    area(p1) > area(p2) ? p1 : p2
end
print(bigger(pair))
# REPL
# julia> print(bigger(pair))
# Asteroid #2 at (31.0,72.0) size 9.0 x 18.0

# automatic destructuring - less code, one less binding (pair)
function bigger((p1, p2)::Vector{Widget})
    area(p1) > area(p2) ? p1 : p2
end
print(bigger(pair))
# REPL
# julia> print(bigger(pair))
# Asteroid #2 at (31.0,72.0) size 9.0 x 18.0

# ------------------------------------------------------------------------------
# operators: []

struct Fleet
    name::String
    spaceships::Vector{Widget}
end

function make_spaceships(N)
    spaceship_size = Size(10, 30)
    spaceship_pos_x = 0
    return [Widget("Spaceship #$i", 
                    Position(i, spaceship_pos_x), 
                    spaceship_size)
                for i in 1:N]
end
fleet = Fleet("Imperial Star Force", make_spaceships(5))

# to get to specific spaceship
println(fleet.spaceships[3])
# REPL
# julia> println(fleet.spaceships[3])
# Spaceship #3 at (3.0,0.0) size 10.0 x 30.0

# let's make it easier
Base.getindex(f::Fleet, i) = f.spaceships[i]
println(fleet[3])
# REPL
# julia> println(fleet[3])
# Spaceship #3 at (3.0,0.0) size 10.0 x 30.0

# how about setting
fleet[3] = Widget("Special Spaceship", Position(0, 0), Size(10, 45))
# REPL
# julia> fleet[3] = Widget("Special Spaceship", Position(0, 0), Size(10, 45))
# ERROR: MethodError: no method matching setindex!(::Fleet, ::Widget, ::Int64)

# let's define it.
Base.setindex!(f::Fleet, w::Widget, i::Int) = f.spaceships[i] = w
fleet[3] = Widget("Special Spaceship", Position(0, 0), Size(10, 45))
fleet.spaceships
# REPL
# julia> fleet.spaceships
# 5-element Array{Widget,1}:
#  Spaceship #1 at (1.0,0.0) size 10.0 x 30.0     
#  Spaceship #2 at (2.0,0.0) size 10.0 x 30.0     
#  Special Spaceship at (0.0,0.0) size 10.0 x 45.0
#  Spaceship #4 at (4.0,0.0) size 10.0 x 30.0     
#  Spaceship #5 at (5.0,0.0) size 10.0 x 30.0  