# Object is mutable. Can we ensure the content never changes?

# modify the getproperty for :contents field by returning a copy.
function Base.getproperty(fc::FileContent, s::Symbol)
    if s in (:path,)
        return getfield(fc, s)
    elseif s === :contents
        !getfield(fc, :loaded) && load_contents!(fc)
        return copy(getfield(fc, :contents))
    else
        error("Unsupported property: $s")
    end
end

#=
julia> fc.contents
359-element Array{UInt8,1}:
 0x23
 0x23
 0x0a

julia> fc.contents[1] = 0x00
0x00

julia> fc.contents
359-element Array{UInt8,1}:
 0x23
 0x23
 0x0a

 =#