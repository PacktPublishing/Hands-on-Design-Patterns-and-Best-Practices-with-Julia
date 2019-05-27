module FighterJets

export FighterJet

mutable struct FighterJet
    # power status: true = on, false = off
    power::Bool 
    # current direction in radians
    direction::Float64
    # current position coordinate (x,y)
    position::Tuple{Float64, Float64} 
end

# Import generic functions
import Vehicle: power_on!, power_off!, turn!, move!, position

# Implementation of Vehicle interface
function power_on!(fj::FighterJet)
    fj.power = true
    println("Powered on: ", fj)
    nothing
end

function power_off!(fj::FighterJet)
    fj.power = false
    println("Powered off: ", fj)
    nothing
end

function turn!(fj::FighterJet, direction)
    fj.direction = direction
    println("Changed direction to ", direction, ": ", fj)
    nothing
end

function move!(fj::FighterJet, distance) 
    x, y = fj.position
    dx = round(distance * cos(fj.direction), digits = 2)
    dy = round(distance * sin(fj.direction), digits = 2)
    fj.position = (x + dx, y + dy)
    println("Moved (", dx, ",", dy, "): ", fj)
    nothing
end

function position(fj::FighterJet)
    fj.position
end

end # module
