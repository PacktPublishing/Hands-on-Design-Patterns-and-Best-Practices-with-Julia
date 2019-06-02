# Type Operators

#------------------------------------------------------------------------------
# isa operator
#= REPL
julia> 1 isa Int
true

julia> 1 isa Float64
false

julia> 1 isa Real
true
=#

#------------------------------------------------------------------------------
# What's Int type's heritage?
#= REPL
julia> supertype(Int)
Signed

julia> supertype(Signed)
Integer

julia> supertype(Integer)
Real
=#

#------------------------------------------------------------------------------
# check if Int is a subtype of Real
#= REPL
julia> Int <: Real
true
=#

#------------------------------------------------------------------------------
# documentation
#= REPL
help?> isa
search: isa isascii isapprox isabspath isassigned isabstracttype disable_sigint isnan ispath isvalid ismarked istaskdone

  isa(x, type) -> Bool

  Determine whether x is of the given type. Can also be used as an infix operator, e.g. x isa type.

help?> <:
search: <:

  <:(T1, T2)

  Subtype operator: returns true if and only if all values of type T1 are also of type T2.
=#
