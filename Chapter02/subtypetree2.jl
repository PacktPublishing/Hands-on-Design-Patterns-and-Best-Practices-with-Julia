# A more robust version of `subtypetree` that handles cycles in the type hierarchy.
function subtypetree(roottype, level = 1, indent = 4, io = stdout, visited = Set{Type}())
    level == 1 && println(io, roottype)
    for s in subtypes(roottype)
        if s ∉ visited
            println(io, join(fill(" ", level * indent)) * string(s))
            push!(visited, s)
            subtypetree(s, level + 1, indent, io, visited)
        end
    end
    return nothing
end
