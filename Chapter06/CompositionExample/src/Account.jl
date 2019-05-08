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
    println("Transferring ", amount, " from account ",
        account_number(from), " to account ", account_number(to))
    withdraw!(from, amount)
    deposit!(to, amount)
    return amount
end

# Testing

function test_account()
    acct = Account("1234", 100.00, Date(2019, 1, 1))
    @show acct
    @show deposit!(acct, 25)

    dest = Account("4321", 500.00, Date(2019, 2, 1))
    @show dest
    @show withdraw!(dest, 50.00)

    transfer!(acct, dest, 10.00)
    @show acct
    @show dest
end

