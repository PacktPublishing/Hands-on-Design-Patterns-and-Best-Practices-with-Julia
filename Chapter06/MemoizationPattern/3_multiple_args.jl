# ------------------------------------------------------------
# Does it work with multiple arguments?
# It should becasue the arguments are slurped into a tuple 
# which becomes the key of the cache.

function memoize(f)
    memo = Dict()
    (args...; kwargs...) -> begin
        x = (args, kwargs)
        if haskey(memo, x)
            return memo[x]
        else
            value = f(args...; kwargs...)
            memo[x] = value
            return value
        end
    end
end


# Simulate a slow function with positional arguments and keyword arguments
slow_op = (a, b = 2; c = 3, d) -> begin
    sleep(2)
    a + b + c + d
end

slow_op = memoize(slow_op)

#=
julia> @time op(2, d = 5);
  2.006106 seconds (22 allocations: 864 bytes)

julia> @time op(2, d = 5);
  0.000024 seconds (17 allocations: 672 bytes)

julia> @time op(1, c = 4, d = 5);
  2.525788 seconds (255.28 k allocations: 12.640 MiB)

julia> @time op(1, c = 4, d = 5);
  0.000023 seconds (16 allocations: 624 bytes)
=#

