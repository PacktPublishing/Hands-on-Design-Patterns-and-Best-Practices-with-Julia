using Distributions

mutable struct Simulation{N}
    heatmap::Array{Float64, N}
    stats::NamedTuple{(:mean, :std)}
end

function simulate(distribution, dims, n) 
    tp = ntuple(i -> n, dims)
    heatmap = rand(distribution, tp...)
    return Simulation{dims}(heatmap, (mean = mean(heatmap), std = std(heatmap)))
end

sim = simulate(Normal(), 2, 1000);

#=
julia> sim = simulate(Normal(), 2, 1000);

julia> sim.heatmap
1000×1000 Array{Float64,2}:
  1.22768    -0.316595    1.53702     …   0.944001    1.14345  
 -1.09027    -0.553394    1.23286     …   0.779135   -0.966926 
  1.52175     0.297313    1.02013         0.6078     -0.299004 
  ⋮                                   ⋱                        
  0.912278   -0.219911    0.513086       -1.37209     0.126663 
  1.05601     0.650547   -0.490138       -0.321995    0.455638 
 -0.764425    0.175759   -0.245518        0.724038   -0.637692 

julia> sim.stats
(mean = 0.0003489176881672829, std = 1.0002976677059898)
=#

# accessors - getters
# they are just forwarding to the properties

get_heatmap(s::Simulation) = s.heatmap
get_stats(s::Simulation) = s.stats

# alternative naming convention
# note the extension of Base.size generic function
heatmap(s::Simulation) = s.heatmap
stats(s::Simulation) = s.stats

# accessors - setters
# we only want a setter for `points` but not `size`
# we can also add validation.

function heatmap!(
        s::Simulation{N}, 
        new_heatmap::AbstractArray{Float64, N}) where {N}
    s.heatmap = new_heatmap
    s.stats = (mean = mean(new_heatmap), std = std(new_heatmap))
    return nothing
end

# add validation
function heatmap!(
            s::Simulation{N}, 
            new_heatmap::AbstractArray{Float64, N}) where {N}
    if length(unique(size(new_heatmap))) != 1
        error("All dimensions must have same size")
    end
    s.heatmap = new_heatmap
    s.stats = (mean = mean(new_heatmap), std = std(new_heatmap))
    return nothing
end

#= 
julia> heatmap!(sim, rand(10, 3))
ERROR: All dimensions must have same size
=#

# ------------------------------------------------------------------------
# marking fields private

mutable struct Simulation{N}
    _heatmap::Array{Float64, N}
    _stats::NamedTuple{(:mean, :std)}
end

