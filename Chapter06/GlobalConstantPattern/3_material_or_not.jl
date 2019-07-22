# Is this overhead material or not?
# Maybe the benefit of using a constant is not so significant
# in real use cases? 

variable = 10
function sum_variable_many_times(N)
    total = rand(variable)
    for i in 1:N
        total .+= rand(variable)
    end
    return total
end
@btime sum_variable_many_times(100);
#=
julia> @btime sum_variable_many_times(100);
  54.986 μs (301 allocations: 20.47 KiB)
=#

const constant = 10
function sum_constant_many_times(N)
    total = rand(constant)
    for i in 1:N
        total .+= rand(constant)
    end
    return total
end
@btime sum_constant_many_times(100);
#=
julia> @btime sum_constant_many_times(100);
  8.282 μs (101 allocations: 15.78 KiB)
=#

#= How bad?  
julia> 54.986 / 8.282
6.6392175802946145
=#


