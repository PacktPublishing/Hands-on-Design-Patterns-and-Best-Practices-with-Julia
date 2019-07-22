# ------------------------------------------------------------
# Similar situation can happen with array types

function slow_positives(xs)
    ys = []   # this is actually Vector{Any}
    for x in xs
        if x > 0
            push!(ys, x)
        end
    end
    return ys
end

function fast_positives(xs)
    ys = similar(xs, 0)
    for x in xs
        if x > 0
            push!(ys, x)
        end
    end
    return ys
end

#=
julia> x = rand(Int, 100000);

julia> @btime slow_positives($x);
  1.632 ms (49730 allocations: 1.76 MiB)

julia> @btime fast_positives($x);
  1.023 ms (16 allocations: 1.00 MiB)
=#

# huge number of allocations!


