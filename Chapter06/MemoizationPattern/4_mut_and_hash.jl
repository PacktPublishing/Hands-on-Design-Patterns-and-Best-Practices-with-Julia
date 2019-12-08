# This is a slow implementation
slow_sum_abs = (x::AbstractVector{T} where {T <: Real}) -> begin
    sleep(2)
    sum(abs(v) for v in x)
end

# test
x = [1, -2, 3, -4, 5]
sum_abs = memoize(slow_sum_abs);
@time sum_abs(x)
@time sum_abs(x)

#=
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
push!(x, -6)
@time sum_abs(x)

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

# Let's try again
push!(x, 7)
@time sum_abs(x)

#=
julia> push!(x, 7)
7-element Array{Int64,1}:
  1
 -2
  3
 -4
  5
 -6
  7

julia> @time sum_abs(x)
  2.004985 seconds (14 allocations: 368 bytes)
28

julia> @time sum_abs(x)
  0.000032 seconds (6 allocations: 192 bytes)
28
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

# define sum_abs again to start refresh
sum_abs = memoize(slow_sum_abs)

x = [1, -2, 3, -4, 5];
for i in 6:30
    push!(x, i * (iseven(i) ? -1 : 1))
    ts = @elapsed val = sum_abs(x)
    println(i, ": ", x, " -> ", val, " (", round(ts, digits=1), "s)")
    ts = @elapsed val = sum_abs(x)
    println(i, ": ", x, " -> ", val, " (", round(ts, digits=1), "s)")
end

#=
julia> sum_abs = memoize(slow_sum_abs);

julia> x = [1, -2, 3, -4, 5];

6: [1, -2, 3, -4, 5, -6] -> 21 (2.0s)
6: [1, -2, 3, -4, 5, -6] -> 21 (0.0s)
7: [1, -2, 3, -4, 5, -6, 7] -> 28 (2.0s)
7: [1, -2, 3, -4, 5, -6, 7] -> 28 (0.0s)
8: [1, -2, 3, -4, 5, -6, 7, -8] -> 36 (2.0s)
8: [1, -2, 3, -4, 5, -6, 7, -8] -> 36 (0.0s)
9: [1, -2, 3, -4, 5, -6, 7, -8, 9] -> 45 (2.0s)
9: [1, -2, 3, -4, 5, -6, 7, -8, 9] -> 45 (0.0s)
10: [1, -2, 3, -4, 5, -6, 7, -8, 9, -10] -> 55 (2.0s)
10: [1, -2, 3, -4, 5, -6, 7, -8, 9, -10] -> 55 (0.0s)
=#
