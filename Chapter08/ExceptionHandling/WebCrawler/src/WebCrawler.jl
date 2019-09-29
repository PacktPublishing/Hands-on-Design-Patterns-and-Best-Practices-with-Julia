module WebCrawler

export add_site!, crawl_sites!, current_sites, reset_crawler!
export Target

using Dates
using HTTP

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
        response = HTTP.get(site.url)
        site.finished = true
        site.finish_time = now()
        println("Site $(site.url) crawled.")
    end

    global function reset_crawler!()
        empty!(sites)
    end

end # let

end # module
