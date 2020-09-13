#=
julia> fib(n) = n < 3 ? 1 : fib(n-1) + fib(n-2)

julia> fib.(1:10)
10-element Array{Int64,1}:
  1
  1
  2
  3
  5
  8
 13
 21
 34
 55
 =#

function fib(n)
    if n < 3
        return (result = 1, counter = 1)
    else
        result1, counter1 = fib(n - 1)
        result2, counter2 = fib(n - 2)
        return (result = result1 + result2, counter = 1 + counter1 + counter2)
    end
end

# How many times does the function get called?
#=
julia> fib(6)
(result = 8, counter = 15)

julia> fib(10)
(result = 55, counter = 109)

julia> fib(20)
(result = 6765, counter = 13529)
=#

# How well does it perform?
#=
julia> @btime fib(40)
  569.906 ms (0 allocations: 0 bytes)
(result = 102334155, counter = 204668309)
=#

const fib_cache = Dict()

_fib(n) = n < 3 ? 1 : fib(n-1) + fib(n-2)

function fib(n)
    if haskey(fib_cache, n)
        return fib_cache[n]
    else
        value = _fib(n)
        fib_cache[n] = value
        return value
    end
end

# Benchmark performance. Make sure cache is emptied at each
#=
julia> @btime fib(40) setup=(empty!(fib_cache))
  38.731 ns (0 allocations: 0 bytes)
102334155
=#
