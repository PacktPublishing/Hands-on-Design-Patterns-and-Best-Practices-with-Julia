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

module AbstractFactoryExample

abstract type OS end
struct MacOS <: OS end
struct Windows <: OS end

# Interface implemented as abstract types
abstract type Button end
Base.show(io::IO, x::Button) = 
    print(io, "'$(x.text)' button")

abstract type Label end
Base.show(io::IO, x::Label) = 
    print(io, "'$(x.text)' label")

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

function test()
    make_button("click me")
end

end #module

using .AbstractFactoryExample
AbstractFactoryExample.test()
#=
julia> make_button("click me")
'click me' button painted on screen
=#
