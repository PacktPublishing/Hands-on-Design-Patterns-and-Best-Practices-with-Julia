# ------------------------------------------------------------
# We can use a barrier function
using BenchmarkTools

function double_sum(data)
    total = 0
    for v in data
        total += 2 * v
    end
    return total
end

function double_sum_of_random_data(n)
    data = random_data(n)
    return double_sum(data)
end

@btime double_sum_of_random_data(100000);
@btime double_sum_of_random_data(100001);

#=
julia> @btime double_sum_of_random_data(100000);
  245.044 μs (2 allocations: 781.33 KiB)

julia> @btime double_sum_of_random_data(100001);
  180.454 μs (2 allocations: 781.39 KiB)

=#

# Another potential issue is the accumulator.

@code_warntype double_sum(rand(Int, 3));
@code_warntype double_sum(rand(Float64, 3));
# -- red text for the Float64 call against the `total` variable
#=
julia> @code_warntype double_sum(rand(Int, 3));
Variables
  #self#::Core.Compiler.Const(double_sum, false)
  data::Array{Int64,1}
  total::Int64
  @_4::Union{Nothing, Tuple{Int64,Int64}}
  v::Int64

Body::Int64
1 ─       (total = 0)
│   %2  = data::Array{Int64,1}
│         (@_4 = Base.iterate(%2))
│   %4  = (@_4 === nothing)::Bool
│   %5  = Base.not_int(%4)::Bool
└──       goto #4 if not %5
2 ┄ %7  = @_4::Tuple{Int64,Int64}::Tuple{Int64,Int64}
│         (v = Core.getfield(%7, 1))
│   %9  = Core.getfield(%7, 2)::Int64
│   %10 = total::Int64
│   %11 = (2 * v)::Int64
│         (total = %10 + %11)
│         (@_4 = Base.iterate(%2, %9))
│   %14 = (@_4 === nothing)::Bool
│   %15 = Base.not_int(%14)::Bool
└──       goto #4 if not %15
3 ─       goto #2
4 ┄       return total

julia> @code_warntype double_sum(rand(Float64, 3));
Variables
  #self#::Core.Compiler.Const(double_sum, false)
  data::Array{Float64,1}
  total::Union{Float64, Int64}
  @_4::Union{Nothing, Tuple{Float64,Int64}}
  v::Float64

Body::Union{Float64, Int64}
1 ─       (total = 0)
│   %2  = data::Array{Float64,1}
│         (@_4 = Base.iterate(%2))
│   %4  = (@_4 === nothing)::Bool
│   %5  = Base.not_int(%4)::Bool
└──       goto #4 if not %5
2 ┄ %7  = @_4::Tuple{Float64,Int64}::Tuple{Float64,Int64}
│         (v = Core.getfield(%7, 1))
│   %9  = Core.getfield(%7, 2)::Int64
│   %10 = total::Union{Float64, Int64}
│   %11 = (2 * v)::Float64
│         (total = %10 + %11)
│         (@_4 = Base.iterate(%2, %9))
│   %14 = (@_4 === nothing)::Bool
│   %15 = Base.not_int(%14)::Bool
└──       goto #4 if not %15
3 ─       goto #2
4 ┄       return total

=#

# There are better ways to write it.

# Fix 1 - use zero function to match type
function double_sum(data)
    total = zero(eltype(data))
    for v in data
        total += 2 * v
    end
    return total
end

# check again - no more red text in the output
@code_warntype double_sum(rand(Int, 3));
@code_warntype double_sum(rand(Float64, 3));

# Fix 2 - leverage type parameter, more flexible
function double_sum(data::AbstractVector{T}) where {T <: Number}
    total = zero(T)
    for v in data
        total += v
    end
    return total
end

# check again - no more red text in the output
@code_warntype double_sum(rand(Int, 3));
@code_warntype double_sum(rand(Float64, 3));

# -----
# using zero(s), one(s), and similar

#=
julia> zero(Int)
0

julia> zeros(Float64, 5)
5-element Array{Float64,1}:
 0.0
 0.0
 0.0
 0.0
 0.0

julia> zeros(Float64, 5)^C

julia> one(UInt8)
0x01

julia> ones(UInt8, 5)
5-element Array{UInt8,1}:
 0x01
 0x01
 0x01
 0x01
 0x01

julia> A = rand(3,4)
3×4 Array{Float64,2}:
 0.275294  0.333407   0.380679  0.680078
 0.795881  0.297336   0.478146  0.377958
 0.534937  0.0791554  0.916814  0.210469

julia> B = similar(A)
3×4 Array{Float64,2}:
 9.88131e-324  4.94066e-324  4.94066e-324  4.94066e-324
 9.88131e-324  4.94066e-324  4.94066e-324  0.0         
 4.94066e-324  4.94066e-324  4.94066e-324  2.32833e-314

julia> zeros(axes(A))
3×4 Array{Float64,2}:
 0.0  0.0  0.0  0.0
 0.0  0.0  0.0  0.0
 0.0  0.0  0.0  0.0

=#