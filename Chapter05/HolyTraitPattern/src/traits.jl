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
marketprice(x::Stock) = rand(200:250)


