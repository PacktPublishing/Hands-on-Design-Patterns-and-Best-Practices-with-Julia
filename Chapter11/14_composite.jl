#=
Compose objects into tree structures to represent part-whole hierarchies. 
Composite lets clients treat individual objects and compositions of objects uniformly.
=#

# portfolio management example - fund of funds

module CompositeExample

# export Portfolio, Holding, sample_portfolio, market_value

struct Holding
    symbol::String
    qty::Int
    price::Float64
end

Base.show(io::IO, h::Holding) = 
    print(io, h.symbol, " ", h.qty, " shares @ \$", h.price)

struct Portfolio
    symbol::String
    name::String
    stocks::Vector{Holding}
    subportfolios::Vector{Portfolio}
end

Base.show(io::IO, p::Portfolio) = myshow(io, p)

function myshow(io::IO, p::Portfolio, level = 0)
    println("  " ^ level, p.name, " (", p.symbol, ")")
    if length(p.stocks) > 0
        println(io, "  ", "  " ^ level, "Holdings:")
        foreach(h -> println(io, "  " ^ level, "    ", h), p.stocks)
    end
    if length(p.subportfolios) > 0
        foreach(subpf -> myshow(io, subpf, level + 1), p.subportfolios)
    end
end

Portfolio(symbol::String, name::String, Holdings::Vector{Holding}) = 
    Portfolio(symbol, name, Holdings, Portfolio[])

Portfolio(symbol::String, name::String, subportfolios::Vector{Portfolio}) = 
    Portfolio(symbol, name, Holding[], subportfolios)

function sample_portfolio()
    large_cap = Portfolio("TOMKA", "Large Cap Portfolio", [
        Holding("AAPL", 100, 275.15), 
        Holding("IBM", 200, 134.21), 
        Holding("GOOG", 300, 1348.83)])

    small_cap = Portfolio("TOMKB", "Small Cap Portfolio", [
        Holding("ATO", 100, 107.05), 
        Holding("BURL", 200, 225.09), 
        Holding("ZBRA", 300, 257.80)])
    
    p1 = Portfolio("TOMKF", "Fund of Funds Sleeve", [large_cap, small_cap])
    p2 = Portfolio("TOMKG", "Special Fund Sleeve", [Holding("C", 200, 76.39)])
    return Portfolio("TOMZ", "Master Fund", [p1, p2])
end

# Contractual functions

# Every investment should have a market value regarless of whether 
# it is a portfolio or stock.

market_value(s::Holding) = s.qty * s.price

market_value(p::Portfolio) = 
    mapreduce(market_value, +, p.stocks, init = 0.0) +
    mapreduce(market_value, +, p.subportfolios, init = 0.0)
    # length(p.stocks) > 0 ? sum(market_value.(p.stocks)) : 0.0 + 
    # length(p.subportfolios) > 0 ? sum(market_value.(p.subportfolios)) : 0.0

# Every investment should have a trade symbols regarless of whether 
# it is a portfolio or stock.

trade_symbol(s::Holding) = s.symbol
trade_symbol(p::Portfolio) = p.symbol

# ---- Testing ----
function test()
    portfolio = CompositeExample.sample_portfolio()
    mv = market_value(portfolio)
    println(portfolio)
    println("market value = ", mv)
end

end # module

using .CompositeExample
CompositeExample.test()

#= REPL
julia> using .CompositeExample

julia> CompositeExample.test()
Master Fund (TOMZ)
  Fund of Funds Sleeve (TOMKF)
    Large Cap Portfolio (TOMKA)
      Holdings:
        AAPL 100 shares @ $275.15
        IBM 200 shares @ $134.21
        GOOG 300 shares @ $1348.83
    Small Cap Portfolio (TOMKB)
      Holdings:
        ATO 100 shares @ $107.05
        BURL 200 shares @ $225.09
        ZBRA 300 shares @ $257.8
  Special Fund Sleeve (TOMKG)
    Holdings:
      C 200 shares @ $76.39

market value = 607347.0
=#

