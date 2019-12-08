# Example 1
using Dates

# @time macro
#=
julia> @time sum(rand(10_000_000))
  0.043366 seconds (7 allocations: 76.294 MiB, 18.50% gc time)
5.000372959218527e6
=#

# manual version
#=
begin
    t1 = now()
    result = sum(rand(10_000_000))
    t2 = now()
    elapsed = t2 - t1
    println("It took ", elapsed)
    result
end
=#

# if implemented as a function
#=
function timeit(func)
    t1 = now()
    result = func()
    t2 = now()
    elapsed = t2 - t1
    println("It took ", elapsed)
    result
end
=#

# how to use?
#=
julia> mycode() = sum(rand(10_000_000))
mycode (generic function with 1 method)

julia> timeit(mycode)
It took 45 milliseconds
5.002266841783055e6
=#

#------------------------------------------------------------------------------
# loop unrolling

# sample loop
#=
for i in 1:3
    println("hello: ", i)
end
=#

# unrolled version
#=
println("hello: ", 1)
println("hello: ", 2)
println("hello: ", 3)
=#

# using the Unrolled.jl package
#=
using Unrolled

@unroll function hello(xs)
    @unroll for i in xs
        println("hello: ", i)
    end
end
=#

# usage
#=
julia> seq = tuple(1:3...)
(1, 2, 3)

julia> hello(seq)
hello: 1
hello: 2
hello: 3
=#

# lowered code
#=
julia> @code_lowered(hello(seq))
CodeInfo(
1 ─ i@_5 = (Base.getindex)(xs, 1)
│ (Main.println)("hello: ", i@_5)
│ i@_4 = (Base.getindex)(xs, 2)
│ (Main.println)("hello: ", i@_4)
│ i@_3 = (Base.getindex)(xs, 3)
│ (Main.println)("hello: ", i@_3)
│ %7 = Main.nothing
└── return %7
)
=#
