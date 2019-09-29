using Dates
using HTTP

Base.@kwdef mutable struct Target
    url::String
    finished::Bool = false
    finish_time::Union{DateTime,Nothing} = nothing
end

function index_site!(site::Target)
    response = HTTP.get(site.url)
    site.finished = true
    site.finish_time = now()
    println("Site $(site.url) crawled.  Status=", response.status)
end

#=
julia> site = Target(url = "https://this-site-does-not-exist-haha.com")
Target("https://this-site-does-not-exist-haha.com", false, nothing)

julia> index_site!(site)
ERROR: IOError(Base.IOError("connect: connection refused (ECONNREFUSED)", -61) 
during request(https://this-site-does-not-exist-haha.com))
=#

#= other exceptions
julia> site = Target(url = "https://www.google.com/this-page-does-not-exist")
Target("https://www.google.com/this-page-does-not-exist", false, nothing)

julia> index_site!(site)
ERROR: HTTP.ExceptionRequest.StatusError(404, "GET", "/this-page-does-not-exist", HTTP.Messages.Response:
=#

# HTTP.ExceptionRequest.StatusError 
# HTTP.Parsers.ParseError 
# HTTP.IOExtras.IOError 
# Sockets.DNSError

using Sockets

function try_index_site!(url)
    try
        site = Target(url = url)
        index_site!(site)
    catch ex
        if ex isa HTTP.ExceptionRequest.StatusError
            println("HTTP status error (code = ", ex.status, ")")
        elseif ex isa Sockets.DNSError
            println("DNS problem: ", ex)
        else
            println("Unknown error:", ex)
        end
    end
end

#=
julia> try_index_site!("https://www.google.com/this-page-does-not-exist")
HTTP status error (code = 404)

julia> try_index_site!("https://this-site-does-not-exist-haha.com")
Unknown error:IOError(Base.IOError("connect: connection refused (ECONNREFUSED)", -61) during request(https://this-site-does-not-exist-haha.com))
=#

function try_index_site!(url)
    try
        site = Target(url = url)
        index_site!(site)
    catch ex
        if ex isa HTTP.ExceptionRequest.StatusError
            println("HTTP status error (code = ", ex.status, ")")
        elseif ex isa Sockets.DNSError
            println("DNS problem: ", ex)
        else
            println("Unknown error:", ex)
        end
    end
end
try_index_site!("https://www.google.com/this-page-does-not-exist")

# ==========================

function foo1()
    foo2()
end

function foo2()
    foo3()
end

function foo3()
    throw(ErrorException("bad things happened"))
end

#=
julia> foo1()
ERROR: bad things happened
Stacktrace:
 [1] foo3() at ./REPL[99]:2
 [2] foo2() at ./REPL[96]:2
 [3] foo1() at ./REPL[95]:2
 [4] top-level scope at none:0
=#

function pretty_print_stacktrace(trace)
    for (i,v) in enumerate(trace)
        println(i, " => ", v)
    end
end

# handling error
function foo1()
    try
        foo2()
    catch
        println("hanlding error gracefully")
        pretty_print_stacktrace(stacktrace())
    end
end

#=
julia> foo1()
hanlding error gracefully
1 => foo1() at REPL[107]:6
2 => top-level scope at none:0
3 => eval(::Module, ::Any) at boot.jl:328
4 => eval_user_input(::Any, ::REPL.REPLBackend) at REPL.jl:85
5 => macro expansion at REPL.jl:117 [inlined]
6 => (::getfield(REPL, Symbol("##26#27")){REPL.REPLBackend})() at task.jl:259
=#

function foo1()
    try
        foo2()
    catch
        pretty_print_stacktrace(stacktrace(catch_backtrace()))
    end
end

#=
julia> foo1()
1 => foo3() at REPL[106]:2
2 => foo2() at REPL[96]:2
3 => foo1() at REPL[109]:3
4 => top-level scope at none:0
5 => eval(::Module, ::Any) at boot.jl:328
6 => eval_user_input(::Any, ::REPL.REPLBackend) at REPL.jl:85
7 => macro expansion at REPL.jl:117 [inlined]
8 => (::getfield(REPL, Symbol("##26#27")){REPL.REPLBackend})() at task.jl:259
=#
