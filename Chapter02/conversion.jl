# conversion examples

# lossy

#=
julia> convert(Float64, 1//3)
0.3333333333333333

julia> convert(Rational, convert(Float64, 1//3))
6004799503160661//18014398509481984
=#



#= REPL

------------------------------------------------------------------------------
Use case #1

julia> x = rand(3)
3-element Array{Float64,1}:
 0.7472603457673705 
 0.08245417518187859
 0.06299555866248618

julia> x[1] = 1
1

julia> x
3-element Array{Float64,1}:
 1.0 
 0.08245417518187859
 0.06299555866248618
 
------------------------------------------------------------------------------
Use case #2

julia> mutable struct Foo 
           x::Float64
       end

julia> foo = Foo(1.0)
Foo(1.0)

julia> foo.x = 2
2

julia> foo
Foo(2.0)

------------------------------------------------------------------------------
Use case #3

julia> struct Foo 
           x::Float64
           Foo(v) = new(v)
       end

julia> Foo(1)
Foo(1.0)

------------------------------------------------------------------------------
Use case #4

julia> function foo()
           local x::Float64
           x = 1
           println(x, " has type of ", typeof(x))
       end

julia> foo()
1.0 has type of Float64

------------------------------------------------------------------------------
Use case #5

julia> function foo()::Float64
           return 1
       end

julia> foo()
1.0

------------------------------------------------------------------------------
Use case #6

julia> ccall((:exp, "libc"), Float64, (Float64,), 2)
7.38905609893065

------------------------------------------------------------------------------

julia> subtypetree(AbstractFloat)
AbstractFloat
    BigFloat
    Float16
    Float32
    Float64

julia> twice(x::AbstractFloat) = 2x;

julia> twice(1.0)
2.0

julia> BigFloat("1.5e1234")
1.500000000000000000000000000000000000000000000000000000000000000000000000000007e+1234

------------------------------------------------------------------------------

julia> twice(2)
ERROR: MethodError: no method matching twice(::Int64)

------------------------------------------------------------------------------

julia> twice(x) = 2x
twice (generic function with 1 method)

julia> twice(1.0)
2.0

julia> twice(1)
2

------------------------------------------------------------------------------

julia> twice(x::Number) = 2x
twice (generic function with 1 method)

julia> twice(2.0)
4.0

julia> twice(2)
4

julia> twice(2//3)
4//3
=#
