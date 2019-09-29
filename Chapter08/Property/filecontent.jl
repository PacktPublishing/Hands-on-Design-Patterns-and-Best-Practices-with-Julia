# ------------------------------------------------------------------------
# Protecting access via property interface

mutable struct FileContent
    path
    loaded
    contents
end

function FileContent(path) 
    ss = lstat(path)
    return FileContent(path, false, zeros(UInt8, ss.size))
end

function load_contents!(fc::FileContent)
    open(fc.path) do io
        readbytes!(io, getfield(fc, :contents)) # not f.contents
        fc.loaded = true
    end
    nothing
end

# quick test

#= 
julia> fc = FileContent("/etc/hosts")
FileContent("/etc/hosts", false, UInt8[0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  …  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])

julia> fc.loaded
false

julia> load_contents!(fc)

julia> fc.loaded
true

julia> fc.contents
359-element Array{UInt8,1}:
 0x23
 0x23
 0x0a
=#

# how does the compiler work with the dot notation?

# reference
#=
julia> Meta.lower(Main, :( fc.path ))
:($(Expr(:thunk, CodeInfo(
    @ none within `top-level scope'
1 ─ %1 = Base.getproperty(fc, :path)
└──      return %1
))))
=#

# assignment
#=
julia> Meta.lower(Main, :( fc.path = "/etc/hosts"))
:($(Expr(:thunk, CodeInfo(
    @ none within `top-level scope'
1 ─     Base.setproperty!(fc, :path, "/etc/hosts")
└──     return "/etc/hosts"
))))
=#

# take a look at Julia's source code :-)
#=
julia> @edit fc.path
=#

# got this:
#=
getproperty(Core.@nospecialize(x), f::Symbol) = getfield(x, f)
setproperty!(x, f::Symbol, v) = setfield!(x, f, convert(fieldtype(typeof(x), f), v))
=#

# extend Base.getproperty to redefine the meaning of dot notation
function Base.getproperty(fc::FileContent, s::Symbol)
    direct_passthrough_fields = (:path, )
    if s in direct_passthrough_fields
        return getfield(fc, s)
    end
    if s === :contents
        !getfield(fc, :loaded) && load_contents!(fc)
        return getfield(fc, :contents)
    end
    error("Unsupported property: $s")
end

# lazy load
function load_contents!(fc::FileContent)
    open(getfield(fc, :path)) do io
        readbytes!(io, getfield(fc, :contents)) # not f.contents
        setfield!(fc, :loaded, true)
    end
    nothing
end

fc = FileContent("/etc/hosts")

# test
#=
julia> fc = FileContent("/etc/hosts")
FileContent("/etc/hosts", false, UInt8[0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  …  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])

julia> fc.path
"/etc/hosts"

julia> fc.contents
359-element Array{UInt8,1}:
 0x23
 0x23
 0x0a
    ⋮

julia> fc.loaded
ERROR: Unsupported property: loaded
=#

function Base.setproperty!(fc::FileContent, s::Symbol, value)
    if s === :path
        ss = lstat(value)
        setfield!(fc, :path, value)
        setfield!(fc, :loaded, false)
        setfield!(fc, :contents, zeros(UInt8, ss.size))
        println("Object re-initialized for $value (size $(ss.size))")
        return nothing
    end
    error("Property $s cannot be changed.")
end

#=
julia> fc.path = "/etc/profile"
Object re-initialized for /etc/profile (size 189)
"/etc/profile"

julia> fc.contents = []
ERROR: Property contents cannot be changed.
=#

# before propertynames
#=
julia> fc.
contents loaded    path
=#

# expose property names to tools like the REPL
function Base.propertynames(fc::FileContent)
    return (:path, :contents)
end

#= 
julia> fc.
contents path
=#
