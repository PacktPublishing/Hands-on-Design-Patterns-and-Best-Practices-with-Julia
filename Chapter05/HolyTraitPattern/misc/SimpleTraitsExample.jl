using SimpleTraits

# define asset types
include("../src/asset_types.jl")

@traitdef IsLiquid{T}
@traitimpl IsLiquid{Cash}
@traitimpl IsLiquid{Investment}

@traitfn marketprice(x::::IsLiquid) = 
    error("Please implement pricing function for ", typeof(x))

@traitfn marketprice(x::::(!IsLiquid)) = 
    error("Price for illiquid asset $x is not available.")

marketprice(Stock("AAPL", "Apple"))
marketprice(Residence("Los Angeles"))

marketprice(x::Stock) = 123
marketprice(Stock("AAPL", "Apple"))