"""
`SavingsAccount2` is same as `SavingsAccount` but uses Lazy's `@forward` macro.
We will use Delegation pattern to gain existing `Account` functionality.
"""
struct SavingsAccount2
    acct::Account
    interest_rate::Float64
    
    SavingsAccount2(account_number, balance, date_opened, interest_rate) = new(
        Account(account_number, balance, date_opened),
        interest_rate
    )
end

# Forward accessors and functions
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

