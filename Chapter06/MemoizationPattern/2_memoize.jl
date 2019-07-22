# define fib as anonymous function
fib = n -> begin
    println("called")
    return n < 3 ? 1 : fib(n-1) + fib(n-2)
end

# memoize function
function memoize(f)
    memo = Dict()
    x -> begin
        if haskey(memo, x)
            return memo[x]
        else
            value = f(x)
            memo[x] = value
            return value
        end
    end
end

# redefine fib function to take advantage of memo cache
fib = memoize(fib)

#=
julia> fib(6)
called
called
called
called
called
called
8
=#

#=
julia> fib(6)
8

julia> fib(5)
5
=#

#=
julia> fib = n -> n < 3 ? 1 : fib(n-1) + fib(n-2)
#8 (generic function with 1 method)

julia> fib = memoize(fib)
#5 (generic function with 1 method)

julia> @btime fib(40)
  50.191 ns (0 allocations: 0 bytes)
102334155
=#

# What to do with generic functions?
# let's use a wrapper

