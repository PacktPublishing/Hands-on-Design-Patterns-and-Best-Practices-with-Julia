module HolyTraitPattern

export Residence, Stock, TreasuryBill, Money, Book
export tradable, marketprice

include("asset.jl")
include("literature.jl")

end # module
