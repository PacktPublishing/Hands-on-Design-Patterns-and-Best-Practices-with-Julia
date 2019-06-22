# --------------------------------------------------------------------------------
# Literature is a separate type hierarchy that's unrelated to Asset.
# We can still use the LiquidityStyle trait here.
# --------------------------------------------------------------------------------

abstract type Literature end

struct Book <: Literature
    name
end

# assign trait
LiquidityStyle(::Type{Book}) = IsLiquid()

# sample pricing function
marketprice(b::Book) = 10.0
