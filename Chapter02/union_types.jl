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

"A `Stock` is identified by a trading `symbol` for a company `name`."
struct Stock <: Equity
    symbol::String
    name::String
end

abstract type Art end

"A `Painting` is identified by the artist and title."
struct Painting <: Art
    artist::String
    title::String
end

"""
A `Holding` represents something we have with certain quantity.
For example, 100 shares of Apple Inc. stocks, or 1 painting.
"""
struct Holding
    thing::Union{Stock, Painting}
    quantity::Int
end

# how does it work?
"""
julia> aapl = Stock("AAPL", "Apple, Inc.")
Stock("AAPL", "Apple, Inc.")

julia> monalisa = Painting("Leonardo da Vinci", "Monalisa")
Painting("Leonardo da Vinci", "Monalisa")

julia> h1 = Holding(aapl, 100)
Holding(Stock("AAPL", "Apple, Inc."), 100)

julia> h2 = Holding(monalisa, 1)
Holding(Painting("Leonardo da Vinci", "Monalisa"), 1)

julia> my_holdings = [h1, h2]
2-element Array{Holding,1}:
 Holding(Stock("AAPL", "Apple, Inc."), 100)           
 Holding(Painting("Leonardo da Vinci", "Monalisa"), 1)
"""

const ValuableThing = Union{Stock, Painting}

struct Holding
    thing::ValuableThing
    quantity::Int
end

"""
julia> h3 = Holding(Painting("Vincent Van Gogh", "Starry Night"), 1)
Holding(Painting("Vincent Van Gogh", "Starry Night"), 1)
"""