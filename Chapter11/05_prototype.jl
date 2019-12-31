module PrototypeExample

mutable struct Account
    id::Int
    balance::Float64
end

struct Customer
    name::String
    savingsAccount::Account
    checkingAccount::Account
end

function sample_customers()
    a1 = Account(1, 100.0)
    a2 = Account(2, 200.0)
    c1 = Customer("John Doe", a1, a2)
    
    a3 = Account(3, 300.0)
    a4 = Account(4, 400.0)
    c2 = Customer("Brandon King", a1, a2)

    return [c1, c2]
end

function test(copy_function::Function)
    println("--- testing ", string(copy_function), " ---")
    customers = sample_customers()
    c = copy_function(customers)
    c[1].checkingAccount.balance += 500
    println("orig: ", customers[1].checkingAccount.balance)
    println("new:  ", c[1].checkingAccount.balance)
end

end #module

using .PrototypeExample
PrototypeExample.test(copy)
PrototypeExample.test(deepcopy)
