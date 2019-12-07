# Union type example

using Dates: Date

# abstract types from previous section
abstract type Asset end

abstract type Property <: Asset end
abstract type Investment <: Asset end
abstract type Cash <: Asset end

abstract type House <: Property end
abstract type Apartment <: Property end

abstract type FixedIncome <: Investment end
abstract type Equity <: Investment end

# concrete types

struct Stock <: Equity
    symbol::String
    name::String
end

# new hierarchy

abstract type Art end

struct Painting <: Art
    artist::String
    title::String
end

# union type

struct BasketOfThings
    things::Vector{Union{Painting,Stock}}
    reason::String
end

#= REPL
julia> stock = Stock("AAPL", "Apple, Inc.",)
Stock("AAPL", "Apple, Inc.")

julia> monalisa = Painting("Leonardo da Vinci", "Monalisa")
Painting("Leonardo da Vinci", "Monalisa")

julia> things = Union{Painting,Stock}[stock, monalisa]
2-element Array{Union{Painting, Stock},1}:
 Stock("AAPL", "Apple, Inc.")             
 Painting("Leonardo da Vinci", "Monalisa")

julia> present = BasketOfThings(things, "Anniversary gift for my wife")
BasketOfThings(Union{Painting, Stock}[Stock("AAPL", "Apple, Inc."), Painting("Leonardo da Vinci", "Monalisa")], "Anniversary gift for my wife")
=#

# easier to read :-)

const Thing = Union{Painting,Stock}

struct BasketOfThings
    thing::Vector{Thing}
    reason::String
end
