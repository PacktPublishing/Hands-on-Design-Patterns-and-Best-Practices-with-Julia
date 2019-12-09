# ------------------------------------------------------------
# What is type stability

using BenchmarkTools

# this function is not type stable
random_data(n) = isodd(n) ? rand(Int, n) : rand(Float64, n)

@code_warntype random_data(3)
#=
julia> @code_warntype random_data(3)
Variables
  #self#::Core.Compiler.Const(random_data, false)
  n::Int64

Body::Union{Array{Float64,1}, Array{Int64,1}}
1 ─ %1 = Main.isodd(n)::Bool
└──      goto #3 if not %1
2 ─ %3 = Main.rand(Main.Int, n)::Array{Int64,1}
└──      return %3
3 ─ %5 = Main.rand(Main.Float64, n)::Array{Float64,1}
└──      return %5
=#

function double_sum_of_random_data(n)
    data = random_data(n)
    total = 0
    for v in data
        total += 2 * v
    end
    return total
end

@btime double_sum_of_random_data(100000);
@btime double_sum_of_random_data(100001);
#=
julia> @btime double_sum_of_random_data(100000);
  347.050 μs (2 allocations: 781.33 KiB)

julia> @btime double_sum_of_random_data(100001);
  179.623 μs (2 allocations: 781.39 KiB)
=#

# See how may red marks with Union types?

@code_warntype double_sum_of_random_data(100000);
#=
julia> @code_warntype double_sum_of_random_data(100000);
Variables
  #self#::Core.Compiler.Const(double_sum_of_random_data, false)
  n::Int64
  data::Union{Array{Float64,1}, Array{Int64,1}}
  total::Union{Float64, Int64}
  @_5::Union{Nothing, Tuple{Union{Float64, Int64},Int64}}
  v::Union{Float64, Int64}

Body::Union{Float64, Int64}
1 ─       (data = Main.random_data(n))
│         (total = 0)
│   %3  = data::Union{Array{Float64,1}, Array{Int64,1}}
│         (@_5 = Base.iterate(%3))
│   %5  = (@_5 === nothing)::Bool
│   %6  = Base.not_int(%5)::Bool
└──       goto #4 if not %6
2 ┄ %8  = @_5::Tuple{Union{Float64, Int64},Int64}::Tuple{Union{Float64, Int64},Int64}
│         (v = Core.getfield(%8, 1))
│   %10 = Core.getfield(%8, 2)::Int64
│   %11 = total::Union{Float64, Int64}
│   %12 = (2 * v)::Union{Float64, Int64}
│         (total = %11 + %12)
│         (@_5 = Base.iterate(%3, %10))
│   %15 = (@_5 === nothing)::Bool
│   %16 = Base.not_int(%15)::Bool
└──       goto #4 if not %16
3 ─       goto #2
4 ┄       return total

=#

