# How a regular module may be written
module WebCrawler

using Dates

# public interface
export Target
export add_site!, crawl_sites!, current_sites, reset_crawler!

# target sites 
Base.@kwdef mutable struct Target
    url::String
    finished::Bool = false
    finish_time::Union{DateTime,Nothing} = nothing
end

# tracks current set of targets
const sites = Target[]

function add_site!(site::Target)
    push!(sites, site)
end

function crawl_sites!()
    for s in sites
        index_site!(s)
    end
end

function current_sites()
    copy(sites)
end

function index_site!(site::Target)
    site.finished = true
    site.finish_time = now()
    println("Site $(site.url) crawled.")
end

function reset_crawler!()
    empty!(sites)
end

end # module

# test
using Main.WebCrawler
add_site!(Target(url = "http://cnn.com"));
add_site!(Target(url = "http://yahoo.com"));
current_sites()

crawl_sites!()
current_sites()

#=
julia> using Main.WebCrawler

julia> add_site!(Target(url = "http://cnn.com"));

julia> add_site!(Target(url = "http://yahoo.com"));

julia> current_sites()
2-element Array{Target,1}:
 Target("http://cnn.com", false, nothing)  
 Target("http://yahoo.com", false, nothing)

julia> crawl_sites()
Site http://cnn.com crawled.
Site http://yahoo.com crawled.

julia> current_sites()
2-element Array{Target,1}:
 Target("http://cnn.com", true, 2019-09-23T22:17:51.222)  
 Target("http://yahoo.com", true, 2019-09-23T22:17:51.226)

=#


# ---------------------------------------------------------------------------
# Using closure to hide non-public fields/functions

module WebCrawler

using Dates

# public interface
export Target
export add_site!, crawl_sites!, current_sites, reset_crawler!

# target sites 
Base.@kwdef mutable struct Target
    url::String
    finished::Bool = false
    finish_time::Union{DateTime,Nothing} = nothing
end

let sites = Target[]

    global function add_site!(site::Target)
        push!(sites, site)
    end

    global function crawl_sites!()
        for s in sites
            index_site!(s)
        end
    end

    global function current_sites()
        copy(sites)
    end

    function index_site!(site::Target)
        site.finished = true
        site.finish_time = now()
        println("Site $(site.url) crawled.")
    end

    global function reset_crawler!()
        empty!(sites)
    end

end # let

end # module


# test
using Main.WebCrawler
add_site!(Target(url = "http://cnn.com"));
add_site!(Target(url = "http://yahoo.com"));
current_sites()

crawl_sites!()
current_sites()

