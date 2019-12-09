function sum_of_sqrt1(xs)
    total = zero(eltype(xs))
    for i in eachindex(xs)
        total += sqrt(xs[i])
    end
    return total
end

function sum_of_sqrt2(xs)
    total = zero(eltype(xs))
    for i in eachindex(xs)
        try
            total += sqrt(xs[i])
        catch
            # ignore error intentionally
        end
    end
    return total
end

using BenchmarkTools
x = rand(100_000);
@btime sum_of_sqrt1($x);
@btime sum_of_sqrt2($x);

#=
julia> x = rand(100_000);

julia> @btime sum_of_sqrt1($x);
  482.818 μs (0 allocations: 0 bytes)

julia> @btime sum_of_sqrt2($x);
  2.455 ms (0 allocations: 0 bytes)
=#

function sum_of_sqrt3(xs)
    total = zero(eltype(xs))
    for i in eachindex(xs)
        if xs[i] >= 0.0
            total += sqrt(xs[i])
        end
    end
    return total
end

@btime sum_of_sqrt3($x);
#=
julia> @btime sum_of_sqrt3($x);
  545.789 μs (2 allocations: 781.33 KiB)
=#

