# Test functions

function trait_test_cash()
    cash = Money("USD", 100.00)
    @show tradable(cash)
    @show marketprice(cash)
    return true
end

function trait_test_stock()
    aapl = Stock("AAPL", "Apple, Inc.")
    @show tradable(aapl)
    @show marketprice(aapl)
    return true
end

function trait_test_residence()
    try 
        home = Residence("Los Angeles")
        @show tradable(home)    # returns false
        @show marketprice(home) # exception is raised
    catch ex
        println(ex)
    end
    return true
end

function trait_test_bond()
    try
        bill = TreasuryBill("123456789")
        @show tradable(bill)
        @show marketprice(bill) # exception is raised
    catch ex
        println(ex)
    end
    return true
end

#= REPL
julia> trait_test_cash();
tradable(cash) = true
marketprice(cash) = 100.0

julia> trait_test_stock();
tradable(aapl) = true
marketprice(aapl) = 235

julia> trait_test_residence();
tradable(home) = false
ErrorException("Price for illiquid asset Residence(\"Los Angeles\") is not available.")

julia> trait_test_bond();
tradable(bill) = true
ErrorException("Please implement pricing function for TreasuryBill")
=#

function trait_test_book()
    book = Book("Romeo and Juliet")
    @show tradable(book)
    @show marketprice(book)
    return true
end

#= REPL
julia> trait_test_book();
tradable(book) = true
marketprice(book) = 10.0
=#