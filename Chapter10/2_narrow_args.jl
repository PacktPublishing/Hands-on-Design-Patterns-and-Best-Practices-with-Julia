# argument types too specific?
function sumprod(A::Vector{Float64}, B::Vector{Float64})
    return sum(A .* B)
end

# what options are available?
sumprod_1(A::Vector{Float64}, B::Vector{Float64}) = sum(A .* B)
sumprod_2(A::Vector{Number}, B::Vector{Number}) = sum(A .* B)
sumprod_3(A::Vector{T}, B::Vector{T}) where T <: Number = sum(A .* B)
sumprod_4(A::Vector{S}, B::Vector{T}) where {S <: Number, T <: Number} = sum(A .* B)
sumprod_5(A::Array{S,N}, B::Array{T,N}) where {N, S <: Number, T <: Number} = sum(A .* B)
sumprod_6(A::AbstractArray{S,N}, B::AbstractArray{T,N}) where {N, S <: Number, T <: Number} = sum(A .* B)
sumprod_7(A, B) = sum(A .* B)

# let's build a test harness to testing various scenarios
function test_harness(f, scenario, args...)
    try 
        f(args...)
        println(f, " #$(scenario) success")
    catch ex
        if ex isa MethodError
            println(f, " #$(scenario) failure (method not selected)")
        else
            println(f, " #$(scenario) failure (unknown error $ex)")
        end
    end
end

# Test a specifc sumprod function against several scenarios
function test_sumprod(f)
    test_harness(f, 1, [1.0,2.0], [3.0, 4.0]);
    test_harness(f, 2, [1,2], [3,4]);
    test_harness(f, 3, [1,2], [3.0,4.0]);
    test_harness(f, 4, rand(2,2), rand(2,2));
    test_harness(f, 5, Number[1,2.0], Number[3.0, 4]);
end

test_sumprod(sumprod_1)
#=
julia> test_sumprod(sumprod_1)
sumprod_1 #1 success
sumprod_1 #2 failure (method not selected)
sumprod_1 #3 failure (method not selected)
sumprod_1 #4 failure (method not selected)
sumprod_1 #5 failure (method not selected)
=#

test_sumprod(sumprod_2)
#=
julia> test_sumprod(sumprod_2)
sumprod_2 #1 failure (method not selected)
sumprod_2 #2 failure (method not selected)
sumprod_2 #3 failure (method not selected)
sumprod_2 #4 failure (method not selected)
sumprod_2 #5 success
=#

test_sumprod(sumprod_3)
#=
julia> test_sumprod(sumprod_3)
sumprod_3 #1 success
sumprod_3 #2 success
sumprod_3 #3 failure (method not selected)
sumprod_3 #4 failure (method not selected)
sumprod_3 #5 success
=#

test_sumprod(sumprod_4)
#=
julia> test_sumprod(sumprod_4)
sumprod_4 #1 success
sumprod_4 #2 success
sumprod_4 #3 success
sumprod_4 #4 failure (method not selected)
sumprod_4 #5 success
=#

test_sumprod(sumprod_5)
#=
julia> test_sumprod(sumprod_5)
sumprod_5 #1 success
sumprod_5 #2 success
sumprod_5 #3 success
sumprod_5 #4 success
sumprod_5 #5 success
=#

test_sumprod(sumprod_6)
#=
julia> test_sumprod(sumprod_6)
sumprod_6 #1 success
sumprod_6 #2 success
sumprod_6 #3 success
sumprod_6 #4 success
sumprod_6 #5 success
=#

test_sumprod(sumprod_7)
#=
julia> test_sumprod(sumprod_7)
sumprod_7 #1 success
sumprod_7 #2 success
sumprod_7 #3 success
sumprod_7 #4 success
sumprod_7 #5 success
=#

#--- any performance impact???
using BenchmarkTools 

A = rand(10_000);
B = rand(10_000);

@btime sumprod_1($A, $B);
@btime sumprod_5($A, $B);
@btime sumprod_6($A, $B);
@btime sumprod_7($A, $B);

#=
julia> @btime sumprod_1($A, $B);
  11.769 μs (2 allocations: 78.20 KiB)

julia> @btime sumprod_5($A, $B);
  11.792 μs (2 allocations: 78.20 KiB)

julia> @btime sumprod_6($A, $B);
  11.944 μs (2 allocations: 78.20 KiB)

julia> @btime sumprod_7($A, $B);
  11.626 μs (2 allocations: 78.20 KiB)
=#
