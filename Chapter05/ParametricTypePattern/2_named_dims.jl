# NamedDims.jl package (a Parametric Type pattern example)

#= Sample code from the package

"""
The `NamedDimsArray` constructor takes a list of names as `Symbol`s,
one per dimension, and an array to wrap.
"""
struct NamedDimsArray{L, T, N, A<:AbstractArray{T, N}} <: AbstractArray{T, N}
    # `L` is for labels, it should be an `NTuple{N, Symbol}`
    data::A
end

function NamedDimsArray{L}(orig::AbstractArray{T, N}) where {L, T, N}
    if !(L isa NTuple{N, Symbol})
        throw(ArgumentError(
            "A $N dimentional array, needs a $N-tuple of dimension names. Got: $L"
        ))
    end
    return NamedDimsArray{L, T, N, typeof(orig)}(orig)
end
=#

M = reshape(collect(1:9), 3, 3);
nda = NamedDimsArray{(:x, :y)}(M)
dimnames(nda)

#=
julia> M = reshape(collect(1:9), 3, 3);

julia> nda = NamedDimsArray{(:x, :y)}(M)
3×3 NamedDimsArray{(:x, :y),Int64,2,Array{Int64,2}}:
 1  4  7
 2  5  8
 3  6  9

julia> dimnames(nda)
(:x, :y)
=#

NamedDimsArray{(:x, :y),Int64,2,Array{Int64,2}} <: NamedDimsArray{(:x, :y)}
NamedDimsArray{(:x, :y),Int64,2,Array{Int64,2}} <: NamedDimsArray{(:a, :b)}
#=
julia> NamedDimsArray{(:x, :y),Int64,2,Array{Int64,2}} <: NamedDimsArray{(:x, :y)}
true

julia> NamedDimsArray{(:x, :y),Int64,2,Array{Int64,2}} <: NamedDimsArray{(:a, :b)}
false
=#

NamedDimsArray{(:x, :y)}
NamedDimsArray{(:x, :y), T, N, A} where A<:AbstractArray{T,N} where N where T 
NamedDimsArray{L, T, N, A} where A<:AbstractArray{T,N} where N where T where L
#=
julia> NamedDimsArray{(:x, :y)}
NamedDimsArray{(:x, :y),T,N,A} where A<:AbstractArray{T,N} where N where T

julia> NamedDimsArray{(:x, :y), T, N, A} where A<:AbstractArray{T,N} where N where T 
NamedDimsArray{(:x, :y),T,N,A} where A<:AbstractArray{T,N} where N where T

julia> NamedDimsArray{L, T, N, A} where A<:AbstractArray{T,N} where N where T where L
NamedDimsArray
=#
