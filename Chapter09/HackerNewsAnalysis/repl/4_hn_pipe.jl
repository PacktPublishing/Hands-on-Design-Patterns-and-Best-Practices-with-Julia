using HackerNewsAnalysis

"John" |> logx("Hello, {}")
[1,2,3] |> logx("Array size is {}", length)
#=
julia> "John" |> logx("Hello, {}")
2019-12-01T12:49:36.947 Hello, John
"John"

julia> [1,2,3] |> logx("Array size is {}", length)
2019-12-01T12:49:40.099 Array size is 3
3-element Array{Int64,1}:
 1
 2
 3
=#

