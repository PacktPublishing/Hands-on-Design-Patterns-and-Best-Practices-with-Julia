# define fib as anonymous function
fib = n -> begin
    println("called with n = $n")
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
fib(6)

#=
julia> fib(6)
called with n = 6
called with n = 5
called with n = 4
called with n = 3
called with n = 2
called with n = 1
8
=#

#=
julia> fib(6)
8

julia> fib(10)
called with n = 10
called with n = 9
called with n = 8
called with n = 7
55
=#

#=
julia> fib = n -> n < 3 ? 1 : fib(n-1) + fib(n-2);

julia> fib = memoize(fib);

julia> @btime fib(40)
  50.191 ns (0 allocations: 0 bytes)
102334155
=#

# What if it's not an anonymous function?

#=
julia> fib(n) = n < 3 ? 1 : fib(n-1) + fib(n-2);

fib = memoize(fib)
=#
