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
mean(nda, dims = :x)
mean(nda, dims = :y)

#=
julia> M = reshape(collect(1:9), 3, 3);

julia> nda = NamedDimsArray{(:x, :y)}(M)
3×3 NamedDimsArray{(:x, :y),Int64,2,Array{Int64,2}}:
 1  4  7
 2  5  8
 3  6  9

julia> mean(nda, dims = :x)
1×3 NamedDimsArray{(:x, :y),Float64,2,Array{Float64,2}}:
 2.0  5.0  8.0

julia> mean(nda, dims = :y)
3×1 NamedDimsArray{(:x, :y),Float64,2,Array{Float64,2}}:
 4.0
 5.0
 6.0
=#