using HackerNewsAnalysis

top_story_id = first ∘ fetch_top_stories
#=
julia> top_story_id = first ∘ fetch_top_stories
#58 (generic function with 1 method)
=#

top_story_id()
#=
julia> top_story_id()
21378471
=#

top_story = fetch_story ∘ first ∘ fetch_top_stories
top_story()
#=
julia> top_story = fetch_story ∘ first ∘ fetch_top_stories
#58 (generic function with 1 method)

julia> top_story()
HackerNewsAnalysis.Story("chriskrycho", 219, 431, 1572269234, 21376744, "Apple Developer Documentation Is Missing", [21377358, 21377951, 21379143, 21377000, 21377003, 21378645, 21377301, 21377771, 21377870, 21376918  …  21377164, 21377089, 21377687, 21377041, 21377356, 21377406, 21376962, 21377298, 21377348, 21377088], "https://v4.chriskrycho.com/2019/apple-your-developer-documentation-is-garbage.html")
=#

title(s::Story) = s.title
top_story_title = title ∘ fetch_story ∘ first ∘ fetch_top_stories
top_story_title()
#=
julia> title(s::Story) = s.title
title (generic function with 1 method)

julia> top_story_title = title ∘ fetch_story ∘ first ∘ fetch_top_stories
#58 (generic function with 1 method)

julia> top_story_title()
"Apple Developer Documentation Is Missing"
=#
