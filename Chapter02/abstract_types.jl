# Abstract type hierarchy
abstract type Asset end

abstract type Property <: Asset end
abstract type Investment <: Asset end
abstract type Cash <: Asset end

abstract type House <: Property end
abstract type Apartment <: Property end

abstract type FixedIncome <: Investment end
abstract type Equity <: Investment end

# simple functions on abstract types
describe(a::Asset) = "Something valuable"
describe(e::Investment) = "Financial investment"
describe(e::Property) = "Physical property"

# function that just raise an error
"""
    location(p::Property) 

Returns the location of the property as a tuple of (latitude, longitude).
"""
location(p::Property) = error("Location is not defined in the concrete type")

# an empty function
"""
    location(p::Property) 

Returns the location of the property as a tuple of (latitude, longitude).
"""
function location(p::Property) end

# Returns true if there's enough cash to buy the equity
enough_cash_to_buy(a::Asset, c::Cash) = value(c) > value(e)