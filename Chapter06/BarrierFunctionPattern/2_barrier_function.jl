# ------------------------------------------------------------
# We can use a barrier function

function double_sum_of_random_data(n)
    data = random_data(n)
    return double_sum(data)
end

function double_sum(data)
    total = 0
    for v in data
        total += 2 * v
    end
    return total
end

#=
julia> @btime double_sum_of_random_data(100000);
  243.624 μs (2 allocations: 781.33 KiB)

julia> @btime double_sum_of_random_data(100001);
  181.035 μs (2 allocations: 781.39 KiB)
=#

# Another potential issue is the accumulator.

#=
julia> @code_warntype double_sum(random_floats)
Body::Union{Float64, Int64}
1 ── %1  = (Base.arraylen)(data)::Int64
│    %2  = (Base.sle_int)(0, %1)::Bool
=#

# There are better ways to write it.

# Fix 1 - use zero function to match type
function double_sum2(data)
    total = zero(eltype(data))
    for v in data
        total += 2 * v
    end
    return total
end

# Fix 2 - leverage type parameter, more flexible
function double_sum3(data::AbstractVector{T}) where {T <: Number}
    total = zero(T)
    for v in data
        total += v
    end
    return total
end

# performance is similar though due to compiler's smartness
#=
julia> @btime double_sum($random_floats);
  103.513 μs (0 allocations: 0 bytes)

julia> @btime double_sum2($random_floats);
  103.505 μs (0 allocations: 0 bytes)

julia> @btime double_sum3($random_floats);
  103.503 μs (0 allocations: 0 bytes)
=#

# But, maybe it could be bad if you do specify a type for the accummulator.
function double_sum4(data)
    total::Float32 = 0
    for v in data
        total += 2 * v
    end
    return total
end

#=
julia> @btime double_sum4($random_floats);
  310.402 μs (0 allocations: 0 bytes)
=#

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