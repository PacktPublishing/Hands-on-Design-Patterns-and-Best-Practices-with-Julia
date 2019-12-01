using HackerNewsAnalysis

fetch_top_stories()
#=
julia> fetch_top_stories()
484-element JSON3.Array{Int64,Base.CodeUnits{UInt8,JSON3.VectorString{Array{UInt8,1}}},Array{UInt64,1}}:
 21676252
 21676933
 21677389
 21674752
 21675456
 21676027
        ⋮
=#

fetch_top_stories() |> first
#=
julia> fetch_top_stories() |> first
21676252
=#

first(fetch_top_stories())
#=
julia> first(fetch_top_stories())
21676252
=#

fetch_top_stories() |> first |> fetch_story
#=
Story("kkm", 384, 538, 1575218518, 21676252, "The world needs more search engines", [21677682, 21676507, 21676549, 21676457, 21676352, 21677053, 21676790, 21676616, 21676315, 21676385  …  21676442, 21676505, 21676858, 21676598, 21676736, 21677029, 21676919, 21676853, 21676397, 21676703], "https://www.0x65.dev/blog/2019-12-01/the-world-needs-cliqz-the-world-needs-more-search-engines.html")
=#