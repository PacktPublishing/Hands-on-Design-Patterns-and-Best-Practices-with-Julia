"""
`SavingsAccount` is a kind of `Account` that generates interest daily.
We will use Delegation pattern to gain existing `Account` functionality.
"""
struct SavingsAccount
    acct::Account
    interest_rate::Float64
    
    SavingsAccount(account_number, balance, date_opened, interest_rate) = new(
        Account(account_number, balance, date_opened),
        interest_rate
    )
end

# Forward accessors
account_number(sa::SavingsAccount) = account_number(sa.acct)
balance(sa::SavingsAccount) = balance(sa.acct)
date_opened(sa::SavingsAccount) = date_opened(sa.acct)

deposit!(sa::SavingsAccount, amount::Real) = deposit!(sa.acct, amount)
withdraw!(sa::SavingsAccount, amount::Real) = withdraw!(sa.acct, amount)
transfer!(sa1::SavingsAccount, sa2::SavingsAccount, amount::Real) = transfer!(
    sa1.acct, sa2.acct, amount)

# new accessor
interest_rate(sa::SavingsAccount) = sa.interest_rate

# new behavior
function accrue_daily_interest!(sa::SavingsAccount) 
    interest = balance(sa.acct) * interest_rate(sa) / 365
    deposit!(sa.acct, interest)
end
