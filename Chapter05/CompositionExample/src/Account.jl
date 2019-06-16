export Account

using Dates: Date

# Object Definition
mutable struct Account
    account_number::String
    balance::Float64
    date_opened::Date
end

# Accessors
account_number(a::Account) = a.account_number
balance(a::Account) = a.balance
date_opened(a::Account) = a.date_opened

# Functions

function deposit!(a::Account, amount::Real)
    a.balance += amount
    return a.balance
end

function withdraw!(a::Account, amount::Real)
    a.balance -= amount
    return a.balance
end

function transfer!(from::Account, to::Account, amount::Real)
    # println("Transferring ", amount, " from account ",
    #     account_number(from), " to account ", account_number(to))
    withdraw!(from, amount)
    deposit!(to, amount)
    return amount
end

