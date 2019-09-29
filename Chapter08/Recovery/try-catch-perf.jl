function mysqrt1!(xs)
    for i in eachindex(xs)
        xs[i] = sqrt(xs[i])
    end
end

function mysqrt2!(xs)
    for i in eachindex(xs)
        try
            xs[i] = sqrt(xs[i])
        catch ex
            nothing
        end
    end
end

using BenchmarkTools

#=
julia> x = rand(100000)

julia> @btime mysqrt1!(copy($x))
  547.331 μs (2 allocations: 781.33 KiB)

julia> @btime mysqrt2!(copy($x))
  2.921 ms (2 allocations: 781.33 KiB)
=#

function mysqrt3!(xs)
    for i in eachindex(xs)
        if xs[i] >= 0.0
            xs[i] = sqrt(xs[i])
        end
    end
end

#=
julia> @btime mysqrt3!(copy($x))
  545.789 μs (2 allocations: 781.33 KiB)
=#

