# Mortgage.jl
module Mortgage

function payment(amount, rate, years)
    monthly_rate = rate / 12.0
    factor = (1 + monthly_rate) ^ (years * 12.0)
    return amount * (monthly_rate * factor / (factor - 1))
end 

end # module
