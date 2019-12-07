# more like an assembly line
struct Parts 
    p1
    p2
    p3
end

mutable struct Car
    engine
    chassis
    wheels
end

struct Job
    model::String
    parts::Parts
    car::Car
end

# builder functions
build_engine(parts) = "Inline 4-cylinder Engine"
build_chassis(parts) = "Spider Chassis"
build_wheels(parts) = "4x 20-inch wide wheels"

# job management
determine_parts(model) = Parts(1,2,3)

create_job(model) = Job(model, determine_parts(model), 
    Car(nothing,nothing,nothing))

# Imperative programming style
function build_car(model)
    job = create_job(model)
    job.car.engine = build_engine(job.parts)
    job.car.chassis = build_chassis(job.parts)
    job.car.wheels = build_wheels(job.parts)
    return job.car
end

# test
build_car("Toyota Miata")
#=
julia> build_car("Toyota Miata")
Car("Inline 4-cylinder Engine", "Spider Chassis", "4x 20-inch wide wheels")
=#

# Functional pipe style
function build_engine(job::Job)
    job.car.engine = "Inline 4-cylinder Engine"
    return job
end

function build_chassis(job::Job)
    job.car.chassis = "Spider Chassis"
    return job
end

function build_wheels(job::Job)
    job.car.wheels = "4x 20-inch wide wheels"
    return job
end

finished_car = job -> job.car

function build_car_now(model)
    model |>
    create_job |>
    build_engine |>
    build_chassis |>
    build_wheels |> 
    finished_car
end

# test
build_car_now("Toyota Miata")
#=
=#

# explanation:
#=
`determine_parts` function takes a `model` and returns a `Job` object
that contains all necessary details about what parts are required
to build the engine, chassis, and wheels.  The `car` field contains 
a Car object but has nothing assigned in any of its fields.

`build_engine` function takes the job and extract parts required
to build an engine and modify the Car object with the finalized 
engine.  Similarly, `build_chassis` and `build_wheels` functions 
build the chassis and wheels accordingly.
=#

