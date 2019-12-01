# REPL experiments

#= --- how to use HTTP ---

julia> using HTTP

julia> url = "https://hacker-news.firebaseio.com/v0/topstories.json";

julia> response = HTTP.request("GET", url);

julia> typeof(response)
HTTP.Messages.Response

julia> response.body
4357-element Array{UInt8,1}:
 0x5b
 0x32
 0x31
 0x36
 0x37
 0x36
    ⋮

julia> String(response.body)
"[21676252,21676933,21677389,21674752,21675456,21676027,21671304,
21676606,21674599,21675498,21676923,21674729,21669787,21669530,21676543,
21675894,21676384,21677533,21677556,21674610,21667223,21675030,
21675228,21675280,21671799,..."
=#

#= --- putting it altogether ---

julia> using HTTP, JSON3

julia> url = "https://hacker-news.firebaseio.com/v0/topstories.json";

julia> response = HTTP.request("GET", url);

julia> JSON3.read(String(response.body))
484-element JSON3.Array{Int64,Base.CodeUnits{UInt8,String},Array{UInt64,1}}:
 21676252
 21676933
 21677389
 21674752
 21675456
 21676027
        ⋮
=#

#= --- getting a story ---

julia> fetch_story(21676252)
Story("kkm", 383, 535, 1575218518, 21676252, 
"The world needs more search engines", 
[21676507, 21676549, 21676457, 21676352, 21677053, 21676790, 21676616, 
21676315, 21676385, 21677210  …  21676442, 21676505, 21676858, 21676598, 
21676736, 21677029, 21676919, 21676853, 21676397, 21676703], 
"https://www.0x65.dev/blog/2019-12-01/the-world-needs-cliqz-the-world-needs-more-search-engines.html")
=#

#= --- average score ---
julia> average_score()
2019-12-01T12:44:05.653 Found 484 stories
2019-12-01T12:44:06.453 Fetched 10 story details
2019-12-01T12:44:06.453 Average score = 131.3
131.3
=#

