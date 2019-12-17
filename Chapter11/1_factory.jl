# Factory method - create objects that conforms to certain interface

# Sample interface

"""
 format(::Formatter, x::T) where {T <: Number}

Format a number `x` using the specified formatter.
Returns a string.
"""
function format end

# Example

module FactoryExample

abstract type Formatter end
struct IntegerFormatter <: Formatter end
struct FloatFormatter <: Formatter end

# constructor (the "factory")
# choose implementation using regular dispatch mechanism
formatter(::Type{T}) where {T <: Integer} = IntegerFormatter()
formatter(::Type{T}) where {T <: AbstractFloat} = FloatFormatter()
formatter(::Type{T}) where T = error("No formatter defined for type $T")

# sample formatters 
# (concrete implementation for the interface with "format" function)
using Printf
format(nf::IntegerFormatter, x) = @sprintf("%d", x)
format(nf::FloatFormatter, x) = @sprintf("%.2f", x)

# client usage
# (no direct coupling with the concrete types)
function test()
    nf = formatter(Int)
    println(format(nf, 1234))
    nf = formatter(Float64)
    println(format(nf, 1234))
end

end # module

using .FactoryExample
FactoryExample.test()
