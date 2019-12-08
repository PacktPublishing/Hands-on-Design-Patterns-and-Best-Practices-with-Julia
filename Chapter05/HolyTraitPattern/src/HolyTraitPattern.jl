module HolyTraitPattern

export Residence, Stock, TreasuryBill, Money, Book
export tradable, marketprice

include("asset_types.jl")
include("traits.jl")
include("literature.jl")

end # module
