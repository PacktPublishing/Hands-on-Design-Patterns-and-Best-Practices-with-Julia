# But, we have 16 processes, shouldn't it be 16x faster?

# Let's try a heavier example.

using Statistics: std, mean, median
using StatsBase: skewness, kurtosis

function stats_by_security(valuation, funcs)
    (nstates, nattr, n) = size(valuation)
    result = zeros(n, nattr, length(funcs))
    for i in 1:n
        for j in 1:nattr
            for (k, f) in enumerate(funcs)
                result[i, j, k] = f(valuation[:, j, i])
            end
        end
    end
    return result
end

funcs = (std, skewness, kurtosis);
@time result = stats_by_security(valuation, funcs);
#=
julia> funcs = (std, skewness, kurtosis);

julia> @time result = stats_by_security(valuation, funcs);
 20.271371 seconds (3.72 M allocations: 67.162 GiB, 4.84% gc time)
=#

# Distributed version.

@everywhere using Statistics: std, mean, median
@everywhere using StatsBase: skewness, kurtosis

function stats_by_security2(valuation, funcs)
    (nstates, nattr, n) = size(valuation)
    result = SharedArray{Float64}((n, nattr, length(funcs)))
    @sync @distributed for i in 1:n
        for j in 1:nattr
            for (k, f) in enumerate(funcs)
                result[i, j, k] = f(valuation[:, j, i])
            end
        end
    end
    return result
end

@time result = stats_by_security2(valuation, funcs);
#=
julia> @time result = stats_by_security2(valuation, funcs);
  2.351749 seconds (4.89 k allocations: 234.469 KiB)
=#

# How much faster?
#=
julia> 20.271371 / 2.351749
8.619700061528675
=#

