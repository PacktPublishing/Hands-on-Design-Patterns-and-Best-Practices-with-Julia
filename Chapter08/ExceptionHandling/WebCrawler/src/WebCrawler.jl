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
            try_index_site!(s)
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

    function try_index_site!(site::Target)
        try
            index_site!(site)
        catch ex
            println("Unable to index site: $site")
            if ex isa HTTP.ExceptionRequest.StatusError
                println("HTTP status error (code = ", ex.status, ")")
            elseif ex isa Sockets.DNSError
                println("DNS problem: ", ex)
            else
                println("Unknown error:", ex)
            end
        end
    end

    global function reset_crawler!()
        empty!(sites)
    end

end # let

end # module
