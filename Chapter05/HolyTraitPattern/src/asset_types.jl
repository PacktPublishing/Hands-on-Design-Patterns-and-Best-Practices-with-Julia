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

