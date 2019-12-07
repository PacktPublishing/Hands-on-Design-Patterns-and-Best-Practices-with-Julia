#=
Strategy pattern defines a family of algorithms that are
interchangeable.

Let's try a Fibonacci calculator.
=#

# function is first-class
using Memoize
@memoize function fib_memoized(n) 
    if n <= 2
        return 1
    else
        return fib_memoized(n-1) + fib_memoized(n-2)
    end
end

function fib_recursive(n)
    if n <= 2
        return 1
    else
        return fib_recursive(n-1) + fib_recursive(n-2)
    end
end

function fib_iterative(n)
    n <= 2 && return 1
    prev1, prev2 = 1, 1
    local curr
    for i in 3:n
        curr = prev1 + prev2
        prev1, prev2 = curr, prev1
    end
    return curr
end

# From client's persepctive, we can pass any function (strategy)
# to any other function that requires a fibonacci function.
function find_golden_ratio(n; fib = fib_memoized)
    return fib(n) / fib(n-1)
end

# Another way is to use dispatch.

abstract type Algo end
struct Memoized <: Algo end
struct Recursive <: Algo end
struct Iterative <: Algo end

# Memoization startegy
using Memoize
@memoize _fib(n) = n <= 2 ? 1 : _fib(n-1) + _fib(n-2)
fib(::Memoized, n) = _fib(n)

# Recursive strategy
function fib(algo::Recursive, n)
    if n <= 2
        return 1
    else 
        return fib(algo, n-1) + fib(algo, n-2)
    end
end

# Iterative strategy
function fib(algo::Iterative, n) 
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
function find_golden_ratio(n; algo = Memoized())
    return fib(algo, n) / fib(algo, n-1)
end

# Testing all implementation
using Test
fib6 = [1, 1, 2, 3, 5, 8]
@test [fib(Memoized(), n)  for n in 1:6] == fib6
@test [fib(Recursive(), n) for n in 1:6] == fib6
@test [fib(Iterative(), n) for n in 1:6] == fib6

