# A framework for implementing CoR
#
# A chain of functions are executed but we allow early
# exit when a function decides that the request is 
# completely handled e.g. A CoR implementation of
# HTTP handlers may skip the rest of the handlers when
# an error is detected early in the chain.

module ChainOfResponsibilityExample

mutable struct DepositRequest
    id::Int
    amount::Float64
end

@enum Status CONTINUE HANDLED

"""
Apply handlers.  Stop the chain when a handler
return `HANDLED`.
"""
function apply(req::DepositRequest, handlers::AbstractVector{Function})
    for f in handlers
        status = f(req)
        status == HANDLED && return nothing
    end
end

# Example usage

function update_account_handler(req::DepositRequest) 
    println("Deposited $(req.amount) to account $(req.id)")
    return CONTINUE
end

function send_gift_handler(req::DepositRequest)
    req.amount > 100_000 && 
        println("=> Thank you for your business")
    return CONTINUE
end

function notify_customer(req::DepositRequest)
    println("deposit is finished")
    return HANDLED
end

handlers = [
    update_account_handler, 
    send_gift_handler,
    notify_customer
]

function test()
    println("Test: customer depositing a lot of money")
    amount = 300_000
    apply(DepositRequest(1, amount), handlers)

    println("\nTest: regular customer")
    amount = 1000
    apply(DepositRequest(2, amount), handlers)
end

end #module

using .ChainOfResponsibilityExample
ChainOfResponsibilityExample.test()

#=
julia> amount = 100_000
100000

julia> apply(DepositRequest(amount), handlers)
Your new balance is 105000.0
Thank you for your business
finalized request, ok to exit

julia> amount = 1000
1000

julia> apply(DepositRequest(amount), handlers)
Your new balance is 1050.0
finalized request, ok to exit
=#
