# Constant folding

# Quick example
function constant_folding_example()
    a = 2 * 3
    b = a + 1
    return b > 1 ? 10 : 20
end
constant_folding_example()
@code_typed constant_folding_example()
#=
julia> @code_typed constant_folding_example()
CodeInfo(
1 ─     return 10
) => Int64
=#

# ------------------------------------------------------------
# Optional content below
# ------------------------------------------------------------

# Constant propagation
const constant_a = 1
function constant_propagation_example()
    a = constant_a
    b = a + 1
    return b > 1 ? 10 : 20
end
constant_propagation_example()
@code_typed constant_propagation_example()
#=
julia> @code_typed constant_propagation_example()
CodeInfo(
1 ─     return 10
) => Int64
=#

# If it's a variable, then all bets are off...
variable_a = 1
function propagate_my_variable()
    a = variable_a
    b = a + 1
    return b > 1 ? 10 : 20
end
propagate_my_variable()
@code_typed propagate_my_variable()
#=
julia> @code_typed propagate_my_variable()
CodeInfo(
1 ─ %1 = Main.variable_a::Any
│   %2 = (%1 + 1)::Any
│   %3 = (%2 > 1)::Any
└──      goto #3 if not %3
2 ─      return 10
3 ─      return 20
) => Int64
=#

# how bad is it?
@btime constant_propagation_example();
@btime propagate_my_variable();
#=
julia> @btime constant_propagation_example();
  0.030 ns (0 allocations: 0 bytes)

julia> @btime propagate_my_variable();
  40.749 ns (0 allocations: 0 bytes)
=#

