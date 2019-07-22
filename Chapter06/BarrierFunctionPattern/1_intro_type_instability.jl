# ------------------------------------------------------------
# What is type stability

using BenchmarkTools

# this function is not type stable
random_data(n) = isodd(n) ? rand(Int, n) : rand(Float64, n)

#=
julia> @code_warntype random_data(3)
Body::Union{Array{Float64,1}, Array{Int64,1}}
1 ── %1  = (Base.checked_srem_int)(n, 2)::Int64
│    %2  = (%1 === 0)::Bool
│    %3  = (Base.not_int)(%2)::Bool
└───       goto #3 if not %3
2 ── %5  = Random.GLOBAL_RNG::Random.MersenneTwister
...
=#

function double_sum_of_random_data(n)
    data = random_data(n)
    total = 0
    for v in data
        total += 2 * v
    end
    return total
end

#=
julia> @btime double_sum_of_random_data(100000);
  346.047 μs (2 allocations: 781.33 KiB)

julia> @btime double_sum_of_random_data(100001);
  345.016 μs (2 allocations: 781.39 KiB)
=#

# See how may red marks with Union types?
#=
julia> @code_warntype double_sum_of_random_data(100000);
Body::Union{Float64, Int64}
1 ── %1   = invoke Main.random_data(_2::Int64)::Union{Array{Float64,1}, Array{Int64,1}}
│    %2   = (isa)(%1, Array{Float64,1})::Bool
└───        goto #7 if not %2
...
│    %15  = φ (#3 => %11)::Union{Float64, Int64}
...
│    %32  = φ (#9 => %28)::Union{Float64, Int64}
...
=#

