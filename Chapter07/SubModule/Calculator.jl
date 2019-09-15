# Calculator.jl
module Calculator

# include sub-modules
include("Mortgage.jl")
using .Mortgage: payment

# functions for the main module
include("funcs.jl")

end # module
