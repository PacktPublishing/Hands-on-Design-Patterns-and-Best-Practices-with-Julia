module Example2

export Asset, Investment, Equity, Cash, 
    Stock, StockOption, Trade, SingleTrade

using Dates: Date

# Abstract type hierarchy for personal assets
abstract type Asset end
abstract type Investment <: Asset end
abstract type Equity <: Investment end
abstract type Cash <: Asset end

# ===== Equity Instruments Types ===== 

# Define concrete types 
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
@enum LongShort Long Short

struct SingleTrade{T <: Investment} <: Trade
    type::LongShort
    instrument::T
    quantity::Int
    price::Float64
end

# ===== Trading functions =====

# Regardless of the instrument being traded, the direction of 
# trade (long or short) determines the sign of the payment amount.
sign(t::SingleTrade) = t.type == Long ? 1 : -1

# market value of a trade is simply quantity times price
payment(t::SingleTrade) = sign(t) * t.quantity * t.price

# stock options are special
# by convention, each option contract refers to 100 underlying shares of the stock
payment(t::SingleTrade{StockOption}) = sign(t) * 100 * t.quantity * t.price

function test()
    stock = Stock("AAPL", "Apple, Inc.")
    trade = SingleTrade{Stock}(Long, stock, 100, 200.00) 
    amount = payment(trade)
    @info "Stock Trade" stock trade amount

    option = StockOption("AAPL", Put, 215.00, Date(2019, 6, 30))
    trade = SingleTrade{StockOption}(Short, option, 1, 3.2)
    amount = payment(trade)
    @info "Option Trade" option trade amount
end

end # module