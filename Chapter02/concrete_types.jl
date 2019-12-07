# Concrete types

# Abstract types from abstract_types.jl
abstract type Asset end

abstract type Property <: Asset end
abstract type Investment <: Asset end
abstract type Cash <: Asset end

abstract type House <: Property end
abstract type Apartment <: Property end

abstract type FixedIncome <: Investment end
abstract type Equity <: Investment end

# Define immutable/composite types
struct Stock <: Equity
    symbol::String
    name::String
end

# Create an instance
stock = Stock("AAPL", "Apple, Inc.")

#= REPL
julia> stock = Stock("AAPL", "Apple, Inc.")
Stock("AAPL", "Apple, Inc.")
=#

# implementing the contract from abstract type
function describe(s::Stock)
    return s.symbol * "(" * s.name * ")"
end

# It's immutable!
#= REPL
julia> stock.name = "Apple LLC"
ERROR: setfield! immutable struct of type Stock cannot be changed
=#

# Create another type
# Note that types are specified here
struct BasketOfStocks
    stocks::Vector{Stock}
    reason::String
end

many_stocks = [
    Stock("AAPL", "Apple, Inc."),
    Stock("IBM", "IBM")
]

# Create a basket of stocks
basket = BasketOfStocks(many_stocks, "Anniversary gift for my wife")

#= REPL
julia> many_stocks = [
           Stock("AAPL", "Apple, Inc."),
           Stock("IBM", "IBM")
       ]
2-element Array{Stock,1}:
 Stock("AAPL", "Apple, Inc.")
 Stock("IBM", "IBM")         

julia> basket = BasketOfStocks(many_stocks, "Anniversary gift for my wife")
BasketOfStocks(Stock[Stock("AAPL", "Apple, Inc."), Stock("IBM", "IBM")], "Anniversary gift for my wife")

julia> pop!(basket.stocks)
Stock("IBM", "IBM")

julia> basket
BasketOfStocks(Stock[Stock("AAPL", "Apple, Inc.")], "Anniversary gift for my wife")
=#

# ----------------------------------------
# mutable structs

# NOTE: restart REPL so we can define Stock again

mutable struct Stock <: Equity
    symbol::String
    name::String
end

#= REPL
julia> stock = Stock("AAPL", "Apple, Inc.")
StockHolding("AAPL", "Apple, Inc.")

julia> stock.name = "Apple LLC"
Apple LLC

julia> stock
Stock("AAPL", "Apple LLC")
=#
