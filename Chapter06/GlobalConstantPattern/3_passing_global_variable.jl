# Passing global variables around fixes performance issue
# Why?  functions are specialized by argument types.

using BenchmarkTools

# using global variable
variable = 10
function add_by_passing_global_variable(x, v)
    return x + v
end

@btime add_by_passing_global_variable(10, $variable);
#=
julia> @btime add_by_passing_global_variable(10, $variable);
  0.032 ns (0 allocations: 0 bytes)
=#

const constant = 10
function add_by_passing_global_constant(x, v)
    return x + v
end
@btime add_by_passing_global_constant(10, $constant);
#=
julia> @btime add_by_passing_global_constant(10, $constant);
  0.032 ns (0 allocations: 0 bytes)
=#

