# Parametric type example

abstract type Asset end
abstract type Investment <: Asset end
abstract type Equity <: Investment end

struct Stock <: Equity
    symbol::String
    name::String
end

mutable struct StockHolding{T <: Real} 
    stock::Stock
    quantity::T
end

# --- REPL ---
"""
julia> stock = Stock("AAPL", "Apple, Inc.");

julia> holding = StockHolding{Int}(stock, 100)
StockHolding{Int64}(Stock("AAPL", "Apple, Inc."), 100)

julia> holding = StockHolding{Float64}(stock, 100)
StockHolding{Float64}(Stock("AAPL", "Apple, Inc."), 100.0)

julia> holding = StockHolding{Rational}(stock, 100 // 3)
StockHolding{Rational}(Stock("AAPL", "Apple, Inc."), 100//3)
"""

mutable struct StockHolding2{T <: Real, P <: AbstractFloat} 
    stock::Stock
    quantity::T
    price::P
    marketvalue::P
end

# --- REPL ---
"""
julia> holding = StockHolding2{Int32,Float64}(stock, 100, 180.00, 18000.00)
StockHolding2{Int32,Float64}(Stock("AAPL", "Apple, Inc."), 100, 180.0, 18000.0)
"""