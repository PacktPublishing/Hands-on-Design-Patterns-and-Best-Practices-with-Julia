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

# Define immutable type
struct Stock <: Equity
    symbol::String
    name::String
end

Stock("AAPL", "Apple, Inc.")  # US NASDAQ 

#= REPL
julia> Stock("AAPL", "Apple, Inc.")  # US NASDAQ
Stock("AAPL", "Apple, Inc.")
=#

# Create an instance
s = Stock("AAPL", "Apple, Inc.")

# It's immutable!
#= REPL
julia> s.symbol = "foo"
ERROR: setfield! immutable struct of type Stock cannot be changed
Stacktrace:
 [1] setproperty!(::Stock, ::Symbol, ::String) at ./sysimg.jl:19
 [2] top-level scope at none:0
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
bs = BasketOfStocks(many_stocks, "Anniversary gift for my wife")

#= REPL
julia> bs = BasketOfStocks(many_stocks, "Anniversary gift for my wife")
BasketOfStocks(Stock[Stock("AAPL", "Apple, Inc."), Stock("IBM", "IBM")], "Anniversary gift for my wife")

julia> pop!(bs.stocks)
Stock("IBM", "IBM")

julia> bs
BasketOfStocks(Stock[Stock("AAPL", "Apple, Inc.")], "Anniversary gift for my wife")
=#

# ----------------------------------------
# mutable structs

mutable struct StockHolding
    stock::Stock
    quantity::Int
end

holding = StockHolding(Stock("AAPL", "Apple, Inc."), 100)
holding.quantity += 200
holding

#= REPL
julia> mutable struct StockHolding
           stock::Stock
           quantity::Int
       end

julia> holding = StockHolding(Stock("AAPL", "Apple, Inc."), 100)
StockHolding(Stock("AAPL", "Apple, Inc."), 100)

julia> holding.quantity += 200
300

julia> holding
StockHolding(Stock("AAPL", "Apple, Inc."), 300)
=#