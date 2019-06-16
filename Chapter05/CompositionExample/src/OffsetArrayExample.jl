using OffsetArrays

# A regular array is indexed from 1 to length of the array
x = rand(3)
x[1:3]

# An offset array can be indexed with different values 
# Here's an example of a 0-based index
y = OffsetArray(rand(3), 0:2)
y[0:2]

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