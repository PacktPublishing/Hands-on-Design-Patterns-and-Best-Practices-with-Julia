#
#=
julia> sum_abs = (x::AbstractVector{T} where {T <: Real}) -> begin
           sleep(2)
           sum(abs(v) for v in x)
       end
#23 (generic function with 1 method)

julia> x = [1, -2, 3, -4, 5]
5-element Array{Int64,1}:
  1
 -2
  3
 -4
  5

julia> sum_abs = memoize(sum_abs)

julia> @time sum_abs(x)
  2.252544 seconds (380.69 k allocations: 19.528 MiB, 0.43% gc time)
15

julia> @time sum_abs(x)
  0.000007 seconds (6 allocations: 192 bytes)
15
=#

# CAUTION: What if the data is changed?
#=
julia> push!(x, -6)
6-element Array{Int64,1}:
  1
 -2
  3
 -4
  5
 -6

julia> @time sum_abs(x)
  0.000010 seconds (6 allocations: 192 bytes)
15
=#

# How to fix?  Let's create a hash function
function hash_all_args(args, kwargs)
    h = 0xed98007bd4471dc2
    h += hash(args, h)
    h += hash(kwargs, h)
    return h
end

# Adjust memoize function 
function memoize(f)
    memo = Dict()
    (args...; kwargs...) -> begin
        key = hash_all_args(args, kwargs)
        if haskey(memo, key)
            return memo[key]
        else
            value = f(args...; kwargs...)
            memo[key] = value
            return value
        end
    end
end

#=
julia> x = [1, -2, 3, -4, 5];

julia> @time sum_abs(x)
  2.151430 seconds (135.56 k allocations: 6.614 MiB)
15

julia> @time sum_abs(x)
  0.000004 seconds (4 allocations: 160 bytes)
15

julia> push!(x, 6)
6-element Array{Int64,1}:
  1
 -2
  3
 -4
  5
  6

julia> @time sum_abs(x)
  2.001693 seconds (11 allocations: 384 bytes)
21

julia> @time sum_abs(x)
  0.000005 seconds (4 allocations: 160 bytes)
21
=#