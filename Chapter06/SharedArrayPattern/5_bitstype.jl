# ----------------------------------------------------------------
# Using immutable types
# ----------------------------------------------------------------

using SharedArrays

@everywhere struct Point{T <: Real}
    x::T
    y::T
end
A = SharedArray{Point{Float64}}(3);
A .= [Point(rand(), rand()) for in in 1:length(A)]

#=
julia> @everywhere struct Point{T <: Real}
           x::T
           y::T
       end

julia> A = SharedArray{Point{Float64}}(3);

julia> A .= [Point(rand(), rand()) for in in 1:length(A)]
3-element SharedArray{Point{Float64},1}:
 Point{Float64}(0.07859856539270682, 0.2065974967070332)
 Point{Float64}(0.7820850739788159, 0.9971987501535848)
 Point{Float64}(0.10800356384806586, 0.24558257669174854)
=#


# ----------------------------------------------------------------
# Non-bits types (such as mutable struct) are not supported
# ----------------------------------------------------------------

@everywhere mutable struct MutablePoint{T <: Real}
    x::T
    y::T
end
B = SharedArray{MutablePoint{Float64}}(3);

#=
julia> @everywhere mutable struct MutablePoint{T <: Real}
    x::T
    y::T
end

julia> B = SharedArray{MutablePoint{Float64}}(3);
ERROR: ArgumentError: type of SharedArray elements must be bits types, got MutablePoint{Float64}
=#