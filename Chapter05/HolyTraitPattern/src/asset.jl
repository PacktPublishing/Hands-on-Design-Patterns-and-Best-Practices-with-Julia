# Abstract type hierarchy for personal assets
abstract type Asset end

abstract type Property <: Asset end
abstract type Investment <: Asset end
abstract type Cash <: Asset end

abstract type House <: Property end
abstract type Apartment <: Property end

abstract type Bond <: Investment end
abstract type Equity <: Investment end

# Define concrete classes 
struct Residence <: House
    location
end

struct Stock <: Equity
    symbol
    name
end

struct TreasuryBill <: Bond
    cusip
end

struct Money <: Cash
    currency
    amount
end

# --------------------------------------------------------------------------------
# Liquidity traits
# --------------------------------------------------------------------------------

abstract type LiquidityStyle end
struct IsLiquid <: LiquidityStyle end
struct IsIlliquid <: LiquidityStyle end

# Default behavior is illiquid
LiquidityStyle(::Type{<:Asset}) = IsIlliquid()

# Cash is always liquid
LiquidityStyle(::Type{<:Cash}) = IsLiquid()

# Any subtype of Investment is liquid
LiquidityStyle(::Type{<:Investment}) = IsLiquid()

# --- Trait behavior ---

# The thing is tradable if it is liquid
tradable(x::T) where {T} = tradable(LiquidityStyle(T), x)
tradable(::IsLiquid, x) = true
tradable(::IsIlliquid, x) = false

# The thing has a market price if it is liquid
marketprice(x::T) where {T} = marketprice(LiquidityStyle(T), x)
marketprice(::IsLiquid, x) = error("Please implement pricing function for ", typeof(x))
marketprice(::IsIlliquid, x) = error("Price for illiquid asset $x is not available.")

# Sample pricing functions for Money and Stock
marketprice(x::Money) = x.amount
marketprice(x::Stock) = rand(4000:5000)


