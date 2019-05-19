mutable struct Accumulator
    value::Float64
end

# Functor - callable type
function (acc::Accumulator)(y::Real)
    acc.value += y
    return acc.value
end

@show a = Accumulator(1.0);
@show a(0.2);
@show a(0.3);

# using a regular function
function add!(acc::Accumulator, y::Real)
    acc.value += y
    return acc.value
end

@show add!(a, 0.4);

# Additional functors - special for Int arguments
function (acc::Accumulator)(y::Int) 
    acc.value += 2y
    return acc.value
end

@show a = Accumulator(0);
@show a(0.2);
@show a(0.3);
@show a(3);

