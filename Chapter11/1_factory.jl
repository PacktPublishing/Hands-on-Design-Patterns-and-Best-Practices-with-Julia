# --- Factory ---
#=
OOP:
Define an interface for creating an object, but let the classes that implement the 
interface decide which class to instantiate. The Factory method lets a class defer 
instantiation to subclasses.

Why? A pattern to decouple the client from hardcoding to the concrete implementation
of something.

In Java, there is a NumberFormat class that supports formatting 
numbers for various locales.  In order to get the implementation of a 
specific locale, you can call the following method:

    public static NumberFormat getIntegerInstance()
    public static NumberFormat getNumberInstance()

The instance returned respect the interface specified by NumberFormat.
Once the instance is available, it can be used for formatting/parsing numbers.

From client's perspective, it does not couple with the underlying
implementation - which could have been an IntegerNumberFormat and a
FloatNumberFormat class.
=#

struct IntegerNumberFormat end
struct FloatNumberFormat end

# constructor (the "factory")
# choose implementation using regular dispatch mechanism
numberformat(::Type{T}) where {T <: Integer} = IntegerNumberFormat()
numberformat(::Type{T}, args...) where {T <: AbstractFloat} = FloatNumberFormat(args...)

# sample formatters 
# (concrete implementation for the interface with "format" function)
using Printf
format(nf::IntegerNumberFormat, x) = @sprintf("%d", x)
format(nf::FloatNumberFormat, x) = @sprintf("%.2f", x)

# client usage
# (no direct coupling with the concrete types)
nf = numberformat(Int)
format(nf, 1234)   # output: 1234

nf = numberformat(Float64)
format(nf, 1234)   # output: 1234.00

# --- AbstractFactory ---
#=
OOP:
It is a factory of factories.
Given families of products e.g. mac vs windows GUI builders
client logic should not care about the concrete implementation
uses abstract factory to get a factory capable of making a 
particular family of products

How? see diagram.
- GUIFactory interface defines factory methods for creating a family of products
- MacOSFactory and WindowsFactory implement the GUIFactory interface
- Button interface is implemented for both MacOS and Windows
- Label interface is implemented for both MacOS and Windows
- MacOSFactory can build MacOSButton and MacOSLabel
- WindowsOSFactory can build WindowsButton and WindowsLabel 
=#

# How do we do achieve the same in Julia?

abstract type OS end
struct MacOS <: OS end
struct Windows <: OS end

# Interface implemented as abstract types
abstract type Button end
Base.show(io::IO, x::Button) = print(io, "'$(x.text)' button painted on screen")

abstract type Label end
Base.show(io::IO, x::Label) = print(io, "'$(x.text)' label painted on screen")

# Buttons
struct MacOSButton <: Button
    text::String
end

struct WindowsButton <: Button
    text::String
end

# Labels
struct MacOSLabel <: Label
    text::String
end

struct WindowsLabel <: Label
    text::String
end

# Generic implementation using traits
current_os() = MacOS()  # should get from system
make_button(text::String) = make_button(current_os(), text)
make_label(text::String) = make_label(current_os(), text)

# MacOS implementation
make_button(::MacOS, text::String) = MacOSButton(text)
make_label(::MacOS, text::String) = MacOSLabel(text)

# Windows implementation
make_button(::Windows, text::String) = WindowsButton(text)
make_label(::Windows, text::String) = WindowsLabel(text)

# Client perspective
make_button("click me")
#=
julia> make_button("click me")
'click me' button painted on screen
=#

#= 
A real life example is Plots.jl.
It supports multiple plotting backends, but would want to reuse
as much backend-neutral logic as possible. It effectively uses
traits pattern to dispatch to the proper implementation.

```
function plot(args...; kw...)
    # this creates a new plot with args/kw and sets it to be the current plot
    plotattributes = KW(kw)
    preprocessArgs!(plotattributes)

    # create an empty Plot then process
    plt = Plot()
    # plt.user_attr = plotattributes
    _plot!(plt, plotattributes, args)
end
```
=#
