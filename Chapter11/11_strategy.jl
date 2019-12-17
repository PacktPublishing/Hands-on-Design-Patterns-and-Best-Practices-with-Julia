module StrategyExample

abstract type Algo end
struct Memoized <: Algo end
struct Iterative <: Algo end

# Memoization startegy
using Memoize
@memoize function _fib(n)
    n <= 2 ? 1 : _fib(n-1) + _fib(n-2)
end

function fib(::Memoized, n)
    println("Using memoization algorithm")
    _fib(n)
end

# Iterative strategy
function fib(algo::Iterative, n)
    println("Using iterative algorithm")
    n <= 2 && return 1
    prev1, prev2 = 1, 1
    local curr
    for i in 3:n
        curr = prev1 + prev2
        prev1, prev2 = curr, prev1
    end
    return curr
end

# From client's perpsective, it just needs to pass an algorithm
# that is implemented for the `fib` function. 
# function find_golden_ratio(n; algo = Memoized())
#     return fib(algo, n) / fib(algo, n-1)
# end

# auto-selection
function fib(n)
    algo = n > 50 ? Memoized() : Iterative()
    return fib(algo, n)
end

function test()
    @show fib(30)
    @show fib(60)
end

end #module

using .StrategyExample
StrategyExample.test()
