# REPL experiments

#= --- how to use HTTP ---

julia> using HTTP

julia> url = "https://hacker-news.firebaseio.com/v0/topstories.json";

julia> response = HTTP.request("GET", url);

julia> typeof(response)
HTTP.Messages.Response

julia> response.body 
4501-element Array{UInt8,1}:
 0x5b
 0x32
 0x31
 0x33
    ⋮

julia> String(response.body)
"[21373800,21373487,21371642,21373931,21372613,21373852,21373756,21373976,21369866,
21366349,21370605,21372784,21370025,21373301,21373086,21373930,21369210,21371658,21
372822,21371187,21369377,21370508,21370525,..."


=#

#= --- putting it altogether ---

julia> using HTTP, JSON3

julia> url = "https://hacker-news.firebaseio.com/v0/topstories.json";

julia> response = HTTP.request("GET", url);

julia> JSON3.read(String(response.body))
500-element JSON3.Array{Int64,Base.CodeUnits{UInt8,String},Array{UInt64,1}}:
 21373800
 21373976
 21373487
        ⋮
=#

#= --- getting a story ---

julia> HackerNewsAnalysis.fetch_story(21373800)
Fetching story from https://hacker-news.firebaseio.com/v0/item/21373800.json
HackerNewsAnalysis.Story("f2f", 15, 83, 1572229812, 21373800, "Unix: A History and a Memoir, by Brian Kernighan", [21374103, 21374126, 21374147, 21374091, 21373962, 21374024, 21374056, 21373940, 21373977, 21373932, 21373882], "https://www.cs.princeton.edu/~bwk/")

=#

#= --- average_score() ---
julia> average_score()
Finding top stories from https://hacker-news.firebaseio.com/v0/topstories.json
2019-10-27T21:33:27.766 Found 500 stories
Fetching story from https://hacker-news.firebaseio.com/v0/item/21373800.json
Fetching story from https://hacker-news.firebaseio.com/v0/item/21373976.json
Fetching story from https://hacker-news.firebaseio.com/v0/item/21373487.json
Fetching story from https://hacker-news.firebaseio.com/v0/item/21374198.json
Fetching story from https://hacker-news.firebaseio.com/v0/item/21371642.json
Fetching story from https://hacker-news.firebaseio.com/v0/item/21373852.json
Fetching story from https://hacker-news.firebaseio.com/v0/item/21372613.json
Fetching story from https://hacker-news.firebaseio.com/v0/item/21373756.json
Fetching story from https://hacker-news.firebaseio.com/v0/item/21369866.json
Fetching story from https://hacker-news.firebaseio.com/v0/item/21373930.json
2019-10-27T21:33:28.989 Fetched 10 story details
2019-10-27T21:33:28.992 Average score = 87.6
87.6

=#

