# A motivating example
module Football
    # My own array-like type
    struct Scores <: AbstractVector{Float64}
        values::Vector{Float64}
    end

    # implement AbstractArray interface
    Base.size(s::Scores) = (length(s.values),)
    Base.getindex(s::Scores, i::Int) = s.values[i]
end

#--- Type 1: Redefining an existing function from a different package 
#            to different logic!

# Let's crash it immediately by typing this into the REPL!
Base.:(+)(x::Int, y::Int) = "hello world"

#=
julia> Base.:(+)(x::Int, y::Int) = "hello world"

┌ Error: Error in the keymap
│   exception =
│    MethodError: no method matching Int64(::String)
│    Closest candidates are:
│      Int64(::Union{Bool, Int32, Int64, UInt32, UInt64, UInt8, Int128, Int16, Int8, UInt128, UInt16}) at boot.jl:710
│      Int64(::Ptr) at boot.jl:720
│      Int64(::Float32) at float.jl:700
│      ...
=#

#--- Type 2: Extending an existing function from a different package with types that you don't own

# In JavaScript, we can add strings to numbers! e.g. "1" + 2 = "12"
module MyModule
    import Base.+
    (+)(s::AbstractString, n::Number) = "$s$n"
end

using .MyModule
"1" + 2
#=
julia> module MyModule
           import Base.+
           (+)(s::AbstractString, n::Number) = "$s$n"
       end
Main.MyModule

julia> using .MyModule

julia> "1" + 2
"12"
=#

# Another package author thought it would be cool to handle strings
# in math operations
module AnotherModule
    import Base: +, -, *, /
    (+)(s::AbstractString, n::T) where T <: Number = parse(T, s) + n
    (-)(s::AbstractString, n::T) where T <: Number = parse(T, s) - n
    (*)(s::AbstractString, n::T) where T <: Number = parse(T, s) * n
    (/)(s::AbstractString, n::T) where T <: Number = parse(T, s) / n
end

using .AnotherModule
"1" + 2
#=
julia> module AnotherModule
           import Base: +, -, *, /
           (+)(s::AbstractString, n::T) where T <: Number = parse(T, s) + n
           (-)(s::AbstractString, n::T) where T <: Number = parse(T, s) - n
           (*)(s::AbstractString, n::T) where T <: Number = parse(T, s) * n
           (/)(s::AbstractString, n::T) where T <: Number = parse(T, s) / n
       end
Main.AnotherModule

julia> using .AnotherModule

julia> "1" + 2
3

julia> "2" * 3
6

julia> "1" + 2.3
3.3
=#

# Avoiding Type 2 piracy - create your own type!

module MyModule
    export @str_str
    import Base: +, show

    struct MyString
        value::AbstractString
    end    

    macro str_str(s::AbstractString) 
        MyString(s)
    end

    show(io::IO, s::MyString) = print(io, s.value)
    (+)(s::MyString, n::Number) = MyString(s.value * string(n))
    (+)(n::Number, s::MyString) = MyString(string(n) * s.value)
    (+)(s::MyString, t::MyString) = MyString(s.value * t.value)
end

using .MyModule
str"I am " + 25 + str" years old!"


#--- Type 3: Extending an existing function from a different package 
#            for your own type but has a different meaning
# aka "puns"
# A Party just contains a title and guest names
struct Party
    title::String
    guests::Vector{String}
end

# constructor
Party(title) = Party(title, String[])

# idea: extending from Base to get around with name conflict issue
Base.join(name::String, party::Party) = push!(party.guests, name)

party = Party("Halloween 2019")
join("Tom", party)
join("Kevin", party)
#=
julia> join("Tom", party)
1-element Array{String,1}:
 "Tom"

julia> join("Kevin", party)
2-element Array{String,1}:
 "Tom"  
 "Kevin"
=#

# what about this bad code?  
# it has bad results without warning due to duck typing.
join(["Bob", "Jeff"], party)
#=
julia> join(["Bob", "Jeff"], party)
"BobParty(\"Halloween 2019\", [\"Tom\", \"Kevin\"])Jeff"
=#

