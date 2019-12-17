module BuilderExample

# Car parts
struct Engine
    value 
end

struct Wheels 
    value 
end

struct Chassis 
    value 
end

# Easy syntax for Union{T, Nothing}
const Maybe{T} = Union{T,Nothing}

# Car object
mutable struct Car 
    engine::Maybe{Engine}
    wheels::Maybe{Wheels}
    chassis::Maybe{Chassis}
end

Car() = Car(nothing, nothing, nothing)

function add(wheels::Wheels)
    return function (c::Car)
        c.wheels = wheels
        return c
    end
end

function add(engine::Engine)
    return function (c::Car)
        c.engine = engine
        return c
    end
end

function add(chassis::Chassis)
    return function (c::Car)
        c.chassis = chassis
        return c
    end
end

car = Car() |>
    add(Engine("4-cylinder 1600cc Engine")) |>
    add(Wheels("4x 20-inch wide wheels")) |>
    add(Chassis("Roadster Chassis"))

println(car)

car = Car()
car.engine = Engine("4-cylinder 1600cc Engine")
car.wheels = Wheels("4x 20-inch wide wheels")
car.chassis = Chassis("Roadster Chassis")

end #module

using .BuilderExample
BuilderExample.test()
