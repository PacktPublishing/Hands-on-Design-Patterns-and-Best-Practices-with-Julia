# how struct padding affects memory usage
using DataFrames

# define a struct that contains two fields
struct TwoFields{S,T}
    x::S
    y::T
end

# create arrays of TwoFields having different combinations of Int types
N = 100
overhead = 40  # number of bytes for managing the array
results = DataFrame(xtype=Type[], ytype=Type[], n=Int[], size=Int[], unpadded_size=Int[])
for S ∈ (Int8, Int16, Int32, Int64), T ∈ (Int8, Int16, Int32, Int64)
    var = Symbol("two_$(S)_$(T)")
    obj = [TwoFields{S,T}(S(i), T(i)) for i in 1:N]
    push!(results, (xtype=S, ytype=T, n=N, 
                    size=Base.summarysize(obj), 
                    unpadded_size=overhead + N * (sizeof(S) + sizeof(T))))
end
results.diff = results.size .- results.unpadded_size
results[Symbol("diff%")] = round.(Int, results.diff ./ results.size .* 100)
results

# results
#=
julia> results
16×7 DataFrame
│ Row │ xtype │ ytype │ n     │ size  │ unpadded_size │ diff  │ diff% │
│     │ Type  │ Type  │ Int64 │ Int64 │ Int64         │ Int64 │ Int64 │
├─────┼───────┼───────┼───────┼───────┼───────────────┼───────┼───────┤
│ 1   │ Int8  │ Int8  │ 100   │ 240   │ 240           │ 0     │ 0     │
│ 2   │ Int8  │ Int16 │ 100   │ 440   │ 340           │ 100   │ 23    │
│ 3   │ Int8  │ Int32 │ 100   │ 840   │ 540           │ 300   │ 36    │
│ 4   │ Int8  │ Int64 │ 100   │ 1640  │ 940           │ 700   │ 43    │
│ 5   │ Int16 │ Int8  │ 100   │ 440   │ 340           │ 100   │ 23    │
│ 6   │ Int16 │ Int16 │ 100   │ 440   │ 440           │ 0     │ 0     │
│ 7   │ Int16 │ Int32 │ 100   │ 840   │ 640           │ 200   │ 24    │
│ 8   │ Int16 │ Int64 │ 100   │ 1640  │ 1040          │ 600   │ 37    │
│ 9   │ Int32 │ Int8  │ 100   │ 840   │ 540           │ 300   │ 36    │
│ 10  │ Int32 │ Int16 │ 100   │ 840   │ 640           │ 200   │ 24    │
│ 11  │ Int32 │ Int32 │ 100   │ 840   │ 840           │ 0     │ 0     │
│ 12  │ Int32 │ Int64 │ 100   │ 1640  │ 1240          │ 400   │ 24    │
│ 13  │ Int64 │ Int8  │ 100   │ 1640  │ 940           │ 700   │ 43    │
│ 14  │ Int64 │ Int16 │ 100   │ 1640  │ 1040          │ 600   │ 37    │
│ 15  │ Int64 │ Int32 │ 100   │ 1640  │ 1240          │ 400   │ 24    │
│ 16  │ Int64 │ Int64 │ 100   │ 1640  │ 1640          │ 0     │ 0     │
=#
