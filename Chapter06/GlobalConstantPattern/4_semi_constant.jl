# Constant is nice but what if we have to use a variable
# because it needs to by mutated?  Let's solve it by using
# a Ref (scalar) value. 

# Initialize constant Ref object with value of 10
const semi_constant = Ref(10)

#=
julia> const semi_constant = Ref(0)
Base.RefValue{Int64}(0)
=#

function add_using_global_semi_constant(x)
    return x + semi_constant[]
end

@btime add_using_global_semi_constant(10);
#= performance
julia> @btime add_using_global_semi_constant(10);
  2.097 ns (0 allocations: 0 bytes)
=#

# how to set Ref object value
semi_constant[] = 20
semi_constant
#=
julia> semi_constant[] = 20
20

julia> semi_constant
Base.RefValue{Int64}(20)
=#

# Option #2.  
# How about mutable struct?
mutable struct Slot
    value::Int
end

const constant_slot = Slot(10)

function add_using_global_constant_slot(x)
    return constant_slot.value + x
end

add_using_global_constant_slot(10)

@btime add_using_global_constant_slot(10)
#=
julia> @btime add_using_global_constant_slot(10)
  2.097 ns (0 allocations: 0 bytes)
=#