# Demo test functions
using Dates: Date

# Account (child object)
function test_account()
    acct = Account("1234", 100.00, Date(2019, 1, 1))
    @show acct
    @show deposit!(acct, 25)
    println("-------------------------------------")

    dest = Account("4321", 500.00, Date(2019, 2, 1))
    @show dest
    @show withdraw!(dest, 50.00)
    println("-------------------------------------")

    @show transfer!(acct, dest, 10.00)
    @show acct
    @show dest
    return nothing
end

# SavingsAccount (parent object - manual forwarding)
function test_savings_account()
    acct = SavingsAccount("1234", 3000.00, Date(2019, 3, 1), 0.03)
    acct2 = SavingsAccount("5678", 1000.00, Date(2018, 3, 1), 0.03)
    test_savings_account_logic(acct, acct2)
end

# SavingsAccount2 (parent object - using @forward)
function test_savings_account2()
    acct = SavingsAccount2("1234", 3000.00, Date(2019, 3, 1), 0.03)
    acct2 = SavingsAccount2("5678", 1000.00, Date(2018, 3, 1), 0.03)
    test_savings_account_logic(acct, acct2)
end

# common test logic
function test_savings_account_logic(acct, acct2)
    @show acct acct2
    @show deposit!(acct, 200)
    @show withdraw!(acct2, 30)
    println("-------------------------------------")
    @show acct acct2
    @show transfer!(acct, acct2, 500)
    @show acct acct2
    println("-------------------------------------")
    @show accrue_daily_interest!(acct)
    @show accrue_daily_interest!(acct)
    return nothing
end

# Check how @forward expands code
function check_forward_macro()
    @macroexpand(@forward SavingsAccount.acct balance,deposit!)
end