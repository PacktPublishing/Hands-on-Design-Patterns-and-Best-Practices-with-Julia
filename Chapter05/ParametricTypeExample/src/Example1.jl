module Example1

export Asset, Investment, Equity, Cash, 
    Stock, StockOption, Trade

using Dates: Date

# Abstract type hierarchy for personal assets
abstract type Asset end
abstract type Investment <: Asset end
abstract type Equity <: Investment end
abstract type Cash <: Asset end

# ===== Equity Instruments Types ===== 

struct Stock <: Equity
    symbol::String
    name::String
end

# Types of stock options
@enum CallPut Call Put

struct StockOption <: Equity
    symbol::String
    type::CallPut
    strike::Float64
    expiration::Date
end

# ===== Trading Types =====

abstract type Trade end

# Types (direction) of the trade
@enum BuySell Buy Sell

struct StockTrade <: Trade
    type::BuySell
    stock::Stock
    quantity::Int
    price::Float64
end

struct StockOptionTrade <: Trade
    type::BuySell
    option::StockOption
    quantity::Int
    price::Float64
end

# ===== Trading functions =====

# Regardless of the instrument being traded, the direction of 
# trade (long or short) determines the sign of the payment amount.
sign(t::StockTrade) = t.type == Buy ? 1 : -1
sign(t::StockOptionTrade) = t.type == Buy ? 1 : -1

# market value of a trade is simply quantity times price
payment(t::StockTrade) = sign(t) * t.quantity * t.price
payment(t::StockOptionTrade) = sign(t) * t.quantity * t.price

function test()
    stock = Stock("AAPL", "Apple, Inc.")
    trade = StockTrade(Buy, stock, 100, 200.00) 
    amount = payment(trade)
    @info "Stock Trade" stock trade amount

    option = StockOption("AAPL", Sell, 215.00, Date(2019, 6, 30))
    trade = StockOptionTrade(Sell, option, 1, 3.2)
    amount = payment(trade)
    @info "Option Trade" option trade amount
end

end