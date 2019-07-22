# ------------------------------------------------------------
# Using the @inferred macro from Base.Test module

using Test

#=
julia> @inferred random_data(1)
ERROR: return type Array{Int64,1} does not match inferred return type Union{Array{Float64,1}, Array{Int64,1}}

julia> @inferred random_data(2)
ERROR: return type Array{Float64,1} does not match inferred return type Union{Array{Float64,1}, Array{Int64,1}}
=#

