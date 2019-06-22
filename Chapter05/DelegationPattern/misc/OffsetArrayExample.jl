# OffsetArrays uses the Delegation pattern to reuse existing 
# functionalities from AbstractArray.  

# A regular array is indexed from 1 to length of the array

x = rand(3)
x[1:3]
#=
julia> x = rand(3)
3-element Array{Float64,1}:
 0.8261642367634516
 0.8348724419409639
 0.9849442213235109

julia> x[1:3]
3-element Array{Float64,1}:
 0.8261642367634516
 0.8348724419409639
 0.9849442213235109
=#

# An offset array can be indexed with different values 
# Here's an example of a 0-based index

using OffsetArrays
y = OffsetArray(rand(3), 0:2)
y[0:2]
#=
julia> using OffsetArrays

julia> y = OffsetArray(rand(3), 0:2)
OffsetArray(::Array{Float64,1}, 0:2) with eltype Float64 with indices 0:2:
 0.5101137754975911 
 0.18269142048901643
 0.9359844942154083 

julia> y[0:2]
3-element Array{Float64,1}:
 0.5101137754975911 
 0.18269142048901643
 0.9359844942154083 
=#

# code sniplet from https://github.com/JuliaArrays/OffsetArrays.jl
#=

struct OffsetArray{T,N,AA<:AbstractArray} <: AbstractArray{T,N}
    parent::AA
    offsets::NTuple{N,Int}
end

Base.parent(A::OffsetArray) = A.parent

Base.size(A::OffsetArray) = size(parent(A))
Base.size(A::OffsetArray, d) = size(parent(A), d)

Base.eachindex(::IndexCartesian, A::OffsetArray) = CartesianIndices(axes(A))
Base.eachindex(::IndexLinear, A::OffsetVector)   = axes(A, 1)

=#