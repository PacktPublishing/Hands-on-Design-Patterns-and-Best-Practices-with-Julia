# funcs.jl - common calculation functions

export interest, rate, mortgage

function interest(amount, rate)
    return amount * (1 + rate)
end

function rate(amount, interest)
    return interest / amount
end

# uses payment function from Mortgage.jl
function mortgage(home_price, down_payment, rate, years)
    return payment(home_price - down_payment, rate, years)
end
