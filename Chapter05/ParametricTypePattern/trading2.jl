# -----------------------------------------------------------------------------
# Parametric type design
# -----------------------------------------------------------------------------

using Dates: Date

# Abstract type hierarchy for personal assets
abstract type Asset end
abstract type Investment <: Asset end
abstract type Equity <: Investment end

# Equity Instruments Types 

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

# Trading Types

abstract type Trade end

# Types (direction) of the trade
@enum LongShort Long Short

struct SingleTrade{T <: Investment} <: Trade
    type::LongShort
    instrument::T
    quantity::Int
    price::Float64
end

#= REPL
julia> option = StockOption("AAPLC", Call, 200, Date(2019, 12, 20))
StockOption("AAPLC", Call::CallPut = 0, 200.0, 2019-12-20)

julia> SingleTrade(Long, stock, 100, 188.0)
SingleTrade{Stock}(Long::LongShort = 0, Stock("AAPL", "Apple Inc"), 100, 188.0)

julia> SingleTrade(Long, option, 100, 3.5)
SingleTrade{StockOption}(Long::LongShort = 0, StockOption("AAPLC", Call::CallPut = 0, 200.0, 2019-12-20), 100, 3.5)
=#

#=
julia> SingleTrade{Stock} <: SingleTrade
true

julia> SingleTrade{StockOption} <: SingleTrade
true
=#

# -----------------------------------------------------------------------------
# Defining parametric methods
# -----------------------------------------------------------------------------

# Return + or - sign for the direction of trade
function sign(t::SingleTrade{T}) where {T} 
    return t.type == Long ? 1 : -1
end

# Calculate payment amount for the trade
function payment(t::SingleTrade{T}) where {T} 
    return sign(t) * t.quantity * t.price
end

#= REPL
julia> SingleTrade(Long, stock, 100, 188.0) |> payment
18800.0

julia> SingleTrade(Long, option, 1, 3.50) |> payment
3.5
=#

# Calculate payment amount for option trades (100 shares per contract)
function payment(t::SingleTrade{StockOption})
    return sign(t) * t.quantity * 100 * t.price
end

#= REPL
julia> SingleTrade(Long, stock, 100, 188.0) |> payment
18800.0

julia> SingleTrade(Long, option, 1, 3.50) |> payment
350.0
=#

# -----------------------------------------------------------------------------
# Using multiple parametric type arguments
# -----------------------------------------------------------------------------

struct PairTrade{T <: Investment, S <: Investment} <: Trade
    leg1::SingleTrade{T}
    leg2::SingleTrade{S}
end

payment(t::PairTrade) = payment(t.leg1) + payment(t.leg2)

#= REPL
julia> stock
Stock("AAPL", "Apple Inc")

julia> option
StockOption("AAPLC", Call::CallPut = 0, 200.0, 2019-12-20)

julia> pt = PairTrade(SingleTrade(Long, stock, 100, 188.0), SingleTrade(Short, option, 1, 3.5));

julia> payment(pt)
18450.0
=#