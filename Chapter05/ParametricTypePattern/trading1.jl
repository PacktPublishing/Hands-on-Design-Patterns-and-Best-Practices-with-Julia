# -----------------------------------------------------------------------------
# Motivation
# -----------------------------------------------------------------------------

using Dates: Date

# Abstract type hierarchy for personal assets
abstract type Asset end
abstract type Investment <: Asset end
abstract type Equity <: Investment end

# Equity Instruments Types 
struct Stock <: Equity
    symbol::String
    name::String
end

# Trading Types
abstract type Trade end

# Types (direction) of the trade
@enum LongShort Long Short

struct StockTrade <: Trade
    type::LongShort
    stock::Stock
    quantity::Int
    price::Float64
end

# ---- support stock options ---

# Types of stock options
@enum CallPut Call Put

struct StockOption <: Equity
    symbol::String
    type::CallPut
    strike::Float64
    expiration::Date
end

struct StockOptionTrade <: Trade
    type::LongShort
    option::StockOption
    quantity::Int
    price::Float64
end

# ===== Trading functions =====

# Regardless of the instrument being traded, the direction of 
# trade (long/buy or short/sell) determines the sign of the 
# payment amount.
sign(t::StockTrade) = t.type == Long ? 1 : -1
sign(t::StockOptionTrade) = t.type == Long ? 1 : -1

# market value of a trade is simply quantity times price
payment(t::StockTrade) = sign(t) * t.quantity * t.price
payment(t::StockOptionTrade) = sign(t) * t.quantity * t.price

# --- test ---
stock = Stock("AAPL", "Apple, Inc.")
trade = StockTrade(Long, stock, 100, 200.00) 
amount = payment(trade)

option = StockOption("AAPL", Call, 215.00, Date(2019, 6, 30))
trade = StockOptionTrade(Long, option, 1, 3.2)
amount = payment(trade)

#= REPL
julia> stock = Stock("AAPL", "Apple, Inc.")
Stock("AAPL", "Apple, Inc.")

julia> trade = StockTrade(Long, stock, 100, 200.00)
StockTrade(Long::LongShort = 0, Stock("AAPL", "Apple, Inc."), 100, 200.0)

julia> amount = payment(trade)
20000.0

julia> option = StockOption("AAPL", Call, 215.00, Date(2019, 6, 30))
StockOption("AAPL", Call::CallPut = 0, 215.0, 2019-06-30)

julia> trade = StockOptionTrade(Long, option, 1, 3.2)
StockOptionTrade(Long::LongShort = 0, StockOption("AAPL", Call::CallPut = 0, 215.0, 2019-06-30), 1, 3.2)

julia> amount = payment(trade)
3.2
=#

