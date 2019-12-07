# Iterator

# https://github.com/tk3369/CircularList.jl/blob/master/src/CircularList.jl

"""
Doubly linked list implementation
"""
mutable struct Node{T} 
    data::Union{T, Nothing} 
    prev::Union{Node{T}, Nothing}
    next::Union{Node{T}, Nothing}
end

"""
List is used to hold a pre-allocated vector of nodes.
"""
mutable struct List{T} 
    nodes::Vector{Node{T}}      # preallocated array of nodes
    current::Node{T}            # current "head" or the circular list
    length::Int                 # number of active elements
    last::Int                   # last index of the nodes array
    capacity::Int               # size of the nodes array
end

"Iteration protocol implementation."
function iterate(CL::List, (el, i) = (CL.current, 1))
    i > CL.length && return nothing
    return (el.data, (el.next, i + 1))
end

# try it out!
using CircularList

cl = circularlist(["John", "Peter", "Kevin"])
foreach(println, cl)
