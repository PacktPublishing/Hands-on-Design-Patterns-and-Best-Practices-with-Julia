using HackerNewsAnalysis

top_story_id = first ∘ fetch_top_stories
#=
julia> top_story_id = first ∘ fetch_top_stories
#58 (generic function with 1 method)
=#

top_story_id()
#=
julia> top_story_id()
21676252
=#

top_story = fetch_story ∘ first ∘ fetch_top_stories
top_story()
#=
julia> top_story = fetch_story ∘ first ∘ fetch_top_stories
#58 (generic function with 1 method)

julia> top_story()
Story("kkm", 384, 538, 1575218518, 21676252, "The world needs more search engines", [21677682, 21676507, 21676549, 21676457, 21676352, 21677053, 21676790, 21676616, 21676315, 21676385  …  21676442, 21676505, 21676858, 21676598, 21676736, 21677029, 21676919, 21676853, 21676397, 21676703], "https://www.0x65.dev/blog/2019-12-01/the-world-needs-cliqz-the-world-needs-more-search-engines.html")=#

title(s::Story) = s.title
top_story_title = title ∘ fetch_story ∘ first ∘ fetch_top_stories
top_story_title()
#=
julia> title(s::Story) = s.title
title (generic function with 1 method)

julia> top_story_title = title ∘ fetch_story ∘ first ∘ fetch_top_stories
#58 (generic function with 1 method)

julia> top_story_title()
"The world needs more search engines"
=#
