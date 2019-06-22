module DelegationPattern

# account
export Account
export account_number, balance, date_opened
export deposit!, withdraw!, transfer!

# savings account
export SavingsAccount, SavingsAccount2
export interest_rate, accrue_daily_interest!

# package dependencies
using Dates: Date
using Lazy: @forward

include("Account.jl")
include("SavingsAccount.jl")
include("SavingsAccount2.jl")

end # module
