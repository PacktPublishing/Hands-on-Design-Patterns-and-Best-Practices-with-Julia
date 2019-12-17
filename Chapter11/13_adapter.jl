# Adapter pattern makes incompatible interfaces work with each other.  

# In Julia, this can be done by implementing creating subtype from an abstract type
# or implement a wrapper interface.

module LinkedList

export Node, list, prev, next, value

mutable struct Node{T}
    prev::Union{Node,Nothing}
    next::Union{Node,Nothing}
    value::T
end

list(x) = Node(nothing, nothing, x)

# accessors
prev(n::Node) = n.prev
next(n::Node) = n.next
value(n::Node) = n.value

"Insert new elements at current position."
function Base.insert!(n::Node{T}, x::T) where T 
    new_node = Node(n, n.next, x)
    if n.next !== nothing
        n.next.prev = new_node
    end
    n.next = new_node
    return n
end

function Base.show(io::IO, n::Node) 
    print(io, "Node: $(n.value)")
    n.next !== nothing && (println(), show(n.next))
end

function test()
end

end #module

using .LinkedList
LL = list(1);
insert!(LL, 2);
insert!(next(LL), 3);
LL

#=
julia> AdapterExample.test()
-- constructing a new list with one element --
Node: 1
-- inserting new node --
Node: 1
Node: 2
=#

# -------------------------------------------------------

# Add indexing function as expected by AbstractArray
# Use Composition.

module AdapterExample

export MyArray

using ..LinkedList

struct MyArray{T} <: AbstractArray{T,1}
    data::Node{T}
end

function Base.getindex(n::MyArray, idx::Int)
    n = n.data
    for i in 1:(idx-1)
        next_node = next(n)
        next_node === nothing && 
            throw(BoundsError(n.data, idx))
        n = next_node
    end
    return value(n)
end

# Size is required
function Base.size(ar::MyArray) 
    n = ar.data
    count = 0
    while next(n) !== nothing
        n = next(n)
        count += 1
    end
    return (1 + count, 1)
end

function test()
    println("--- create list ---")
    mylist = list(1)
    insert!(mylist, 2)
    insert!(next(mylist), 3)
    println(mylist)

    println("--- create array from list and indexing elements ---")
end

end #

using .AdapterExample

ar = MyArray(LL)
ar[1]
ar[2]
ar[end]

#=
julia> ar = MyArray(LL)
3×1 MyArray{Int64}:
 1
 2
 3

julia> ar[1]
1

julia> ar[2]
2

julia> ar[end]
3
=#
