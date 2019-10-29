fetch_top_stories()
#=
julia> fetch_top_stories()
500-element JSON3.Array{Int64,Base.CodeUnits{UInt8,String},Array{UInt64,1}}:
 21376744
 21377517
 21378319
 21377598
 21377769
        ⋮
=#

fetch_top_stories() |> first
#=
julia> fetch_top_stories() |> first
21376744
=#

first(fetch_top_stories())
#=
julia> first(fetch_top_stories())
21376744
=#

fetch_top_stories() |> first |> fetch_story
#=
julia> fetch_top_stories() |> first |> fetch_story
HackerNewsAnalysis.Story("chriskrycho", 188, 395, 1572269234, 21376744, "Apple Developer Documentation Is Missing", [21377358, 21377951, 21377000, 21377003, 21377301, 21377771, 21377870, 21376918, 21377533, 21377614  …  21377164, 21377687, 21377041, 21377356, 21377089, 21377406, 21376962, 21377298, 21377348, 21377088], "https://v4.chriskrycho.com/2019/apple-your-developer-documentation-is-garbage.html")
=#