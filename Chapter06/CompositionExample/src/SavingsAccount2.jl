# SavingsAccount2 is same as SavingsAccount but uses Lazy's @forward macro

using Lazy: @forward

# We will use Composition pattern to gain existing Account functionality.
struct SavingsAccount2
    acct::Account
    interest_rate::Float64
    
    SavingsAccount2(account_number, balance, date_opened, interest_rate) = new(
        Account(account_number, balance, date_opened),
        interest_rate
    )
end

# Forward assessors and functions
@forward SavingsAccount2.acct account_number, balance, date_opened
@forward SavingsAccount2.acct deposit!, withdraw!

# The @forward macro only works with first argument
transfer!(from::SavingsAccount2, to::SavingsAccount2, amount::Real) = transfer!(
    from.acct, to.acct, amount)

# new accessor
interest_rate(sa::SavingsAccount2) = sa.interest_rate

# new behavior
function accrue_daily_interest!(sa::SavingsAccount2) 
    interest = balance(sa.acct) * interest_rate(sa) / 365
    deposit!(sa.acct, interest)
end

# Test
function test_savings_account2()
    acct = SavingsAccount2("5678", 3000.00, Date(2019, 3, 1), 0.03)
    acct2 = SavingsAccount2("6000", 1000.00, Date(2019, 3, 1), 0.03)
    @show acct acct2
    @show deposit!(acct, 200)
    @show withdraw!(acct, 100)
    @show transfer!(acct, acct2, 500)
    @show accrue_daily_interest!(acct)
    @show accrue_daily_interest!(acct)
    @show accrue_daily_interest!(acct)
end