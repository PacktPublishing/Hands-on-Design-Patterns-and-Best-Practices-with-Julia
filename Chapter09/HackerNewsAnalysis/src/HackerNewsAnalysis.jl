module HackerNewsAnalysis

export fetch_top_stories, fetch_story, fetch_story_details, take, logx
export Story

export average_score
export average_score2
export average_score3

using HTTP
using JSON3
using Statistics
using Dates
using Formatting

# Container for a story. Underlying data is a Dict from parsing JSON.
struct Story
    by::String
    descendants::Union{Nothing,Int}
    score::Int
    time::Int
    id::Int
    title::String
    kids::Union{Nothing,Vector{Int}}
    url::Union{Nothing,String}
end

# Construct a Story from a Dict (or Dict-compatible) object
function Story(obj)
    value = (x) -> get(obj, x, nothing)
    return Story(
        obj[:by], 
        value(:descendants), 
        obj[:score], 
        obj[:time],
        obj[:id], 
        obj[:title], 
        value(:kids), 
        value(:url))
end

# Find top 500 stories from HackerNews.  Returns an array of story id's.
function fetch_top_stories()
    url = "https://hacker-news.firebaseio.com/v0/topstories.json"
    response = HTTP.request("GET", url)
    return JSON3.read(response.body)
end

# Get a specific story item
function fetch_story(id)
    url = "https://hacker-news.firebaseio.com/v0/item/$(id).json"
    response = HTTP.request("GET", url)
    return Story(JSON3.read(response.body))
end

# average score of recent discussions
function average_score(n = 10)
    story_ids = fetch_top_stories()
    println(now(), " Found ", length(story_ids), " stories")

    top_stories = [fetch_story(id) for id in story_ids[1:min(n,end)]]
    println(now(), " Fetched ", n, " story details")

    avg_top_scores = mean(s.score for s in top_stories)
    println(now(), " Average score = ", avg_top_scores)

    return avg_top_scores
end

# code is pretty busy
# refactoring to smaller functions and make them pipe-friendly (i.e. single argument)

take(n::Int) = xs -> xs[1:min(n,end)]

fetch_story_details(ids::Vector{Int}) = fetch_story.(ids)

calculate_average_score(stories::Vector{Story}) = mean(s.score for s in stories)

# without logging
average_score2(n = 10) = 
    fetch_top_stories() |> 
    take(n) |> 
    fetch_story_details |> 
    calculate_average_score

# pipe friendly logging facility 
logx(fmt::AbstractString, f::Function = identity) = x -> begin
    let y = f(x)
        print(now(), " ")
        printfmtln(fmt, y)
    end
    return x
end

# functional pipe including logging
average_score3(n = 10) = 
    fetch_top_stories()                         |> 
    logx("Number of top stories = {}", length)  |>
    take(n)                                     |> 
    logx("Limited number of stories = $n")      |>
    fetch_story_details                         |> 
    logx("Fetched story details")               |>
    calculate_average_score                     |> 
    logx("Average score = {}")

# conditional logic
check_hotness(n = 10) =
    average_score3(n) |> hotness |> celebrate

hotness(score) = score > 100 ? Val(:high) : Val(:low)
celebrate(v::Val{:high}) = logx("Woohoo! Lots of hot topics!")(v)
celebrate(v::Val{:low}) = logx("It's just a normal day...")(v)

end # module
