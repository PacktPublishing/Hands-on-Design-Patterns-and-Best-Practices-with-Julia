# Parametric methods revisited

# Simple example
triple(x::Array{T,1}) where {T <: Real} = 3x

# T can be concrete or abstract.  
# It's determined by whatever being passed into the function.
triple([1,2,3])
triple(Real[1,2,3.0])
#=
julia> triple([1,2,3])
3-element Array{Int64,1}:
 3
 6
 9

julia> triple(Real[1,2,3.0])
3-element Array{Real,1}:
 3  
 6  
 9.0
=#

# What's in method table?
methods(triple)
#=
julia> methods(triple)
# 1 method for generic function "triple":
[1] triple(x::Array{T,1}) where T<:Real in Main at REPL[2]:1
=#

# The where-clause can be placed inside as part of the type
triple(x::Array{T,1} where {T <: Real}) = 3x

methods(triple)
#=
julia> methods(triple)
# 1 method for generic function "triple":
[1] triple(x::Array{T,1} where T<:Real) in Main at REPL[37]:1
=#

# It replaces the previous method as it is functionally equivalent
# from a dispatch perspective.

# Primary difference.  T is available in method body if it's 
# placed outside.

triple(x::Array{T,1}) where {T <: Real} = (3x, T)
triple([1,2])
#=
julia> triple(x::Array{T,1}) where {T <: Real} = (3x, T)
triple (generic function with 1 method)

julia> triple([1,2])
([3, 6], Int64)
=#

triple(x::Array{T,1} where {T <: Real}) = (3x, T)
triple([1,2])
#=
julia> triple(x::Array{T,1} where {T <: Real}) = (3x, T)
triple (generic function with 1 method)

julia> triple([1,2])
ERROR: UndefVarError: T not defined
=#

# -----------------------------------------------------------------

# A more complex example.
add(a::Array{T,1}, x::T) where {T <: Real} = (T, a .+ x)

# T = Int64
add([1,2,3], 1)
#=
julia> add([1,2,3], 1)
(Int64, [2, 3, 4])
=#

# Remember that parametric types are invariant.  
# They are determined EXACTLY by what was passed. 
# In the following case, T has to be Int64 but it's
# inconsistent with the second argument.
add([1,2,3], 1.0)
#=
julia> add([1,2,3], 1.0)
ERROR: MethodError: no method matching add(::Array{Int64,1}, ::Float64)
Closest candidates are:
  add(::Array{T,1}, ::T) where T<:Real at REPL[2]:1
=#

# It also include abstract types as long as T is consistent:
add(Signed[1,2,3], Int8(1))
#=
julia> add(Signed[1,2,3], 1)
(Signed, [2, 3, 4])
=#

# -----------------------------------------------------------------

# Diagonal rule

diagonal(x::T, y::T) where {T <: Number} = T

# Types must match because T appears more than once in covariant position.
# T must be concrete.  
diagonal(1, 2.0)
#=
julia> diagonal(1, 2.0)
ERROR: MethodError: no method matching diagonal(::Int64, ::Float64)
=#

not_diagonal(A::Array{T,1}, x::T, y::T) where {T <: Number} = T

# T is not a diagonal variable because it was introduced by
# the parametric type Array, which unambiguously determined 
# that T is the type being passed.

#=
julia> not_diagonal(Real[1,2,3],4,5)
Real
=#

# -----------------------------------------------------------------

# An even more complex example.

# add(a::Array{T,1}, x::T, y::T) where {T <: Real} = 
#     (T, a .+ x .+ y)

# add([1,2,3], 1, 2)
# add(Signed[1,2,3], 1, 2)
#=
julia> add([1,2,3], 1, 2)
(Int64, [4, 5, 6])

julia> add(Signed[1,2,3], 1, 2)
(Signed, [4, 5, 6])
=#

# What if one type variable relates to another?

mytypes1(a::Array{T,1}, x::S) where {S <: Number, T <: S} = T
mytypes2(a::Array{T,1}, x::S) where {S <: Number, T <: S} = S

# happy cases
#=
julia> mytypes1([1,2,3], 4)
Int64

julia> mytypes2([1,2,3], 4)
Int64
=#

# array of abstract type
#=
julia> mytypes1(Signed[1,2,3], 4)
Signed

julia> mytypes2(Signed[1,2,3], 4)
ERROR: UndefVarError: S not defined
=#

# That's because there are too many possibilities of S.
# As we already know that T = Signed, since T <: S,
# S has to be a super type of T.  But then there are too
# many of them - Integer, Real, Number, and Any.

# Just because a method is dispatched does not mean the the type 
# parameter can be determined.


