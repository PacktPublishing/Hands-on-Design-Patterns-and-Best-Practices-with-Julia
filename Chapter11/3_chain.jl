# A framework for implementing CoR
mutable struct Request
    data
end

@enum Status Continue Handled

function apply(req::Request, stack::AbstractVector{Function})
    for f in stack
        status = f(req)
        status == Handled && return nothing
    end
end

# Example

function add_interest_handler(req::Request) 
    req.data *= 1.05   # 5% interest
    println("Your new balance is $(req.data)")
    return Continue
end

function final_handler(req::Request)
    println("finalized request")
    return Handled
end

function send_gift_handler(req::Request)
    req.data > 100_000 && println("Thank you for your business")
    return Continue
end

stack = [
    add_interest_handler, 
    send_gift_handler,
    final_handler
]

amount = 100_000
apply(Request(amount), stack)

amount = 1000
apply(Request(amount), stack)

#=
julia> amount = 100_000
100000

julia> apply(Request(amount), stack)
Your new balance is 105000.0
Thank you for your business
finalized request, ok to exit

julia> amount = 1000
1000

julia> apply(Request(amount), stack)
Your new balance is 1050.0
finalized request, ok to exit
=#