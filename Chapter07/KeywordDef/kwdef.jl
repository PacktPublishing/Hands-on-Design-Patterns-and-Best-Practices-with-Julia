# Regular struct
struct TextStyle
    font_family
    font_size
    font_weight
    foreground_color
    background_color
    alignment
    rotation
end

# how do we construct an object?
style = TextStyle("Arial", 11, "Bold", "black", "white", "left", 0)

# a new constructor using keyword args
function TextStyle(;
    font_family,
    font_size,
    font_weight = "Normal",
    foreground_color = "black",
    background_color = "white", 
    alignment = "left",
    rotation = 0)
return TextStyle(
    font_family,
    font_size,
    font_weight,
    foreground_color,
    background_color,
    alignment,
    rotation)
end

# easier usage
style = TextStyle(
    alignment = "left",
    font_family = "Arial",
    font_weight = "Bold",
    font_size = 11)

# using Base.@kwdef macro
Base.@kwdef struct TextStyle
    font_family
    font_size
    font_weight = "Normal"
    foreground_color = "black"
    background_color= "white"
    alignment = "center"
    rotation = 0
end

# Two constructors are available
#=
julia> methods(TextStyle)
# 2 methods for generic function "(::Type)":
[1] TextStyle(; font_family, font_size, font_weight, foreground_color, background_color, alignment, rotation) in Main at util.jl:728
[2] TextStyle(font_family, font_size, font_weight, foreground_color, background_color, alignment, rotation) in Main at REPL[1]:2
=#

# sample usage
#=
julia> style = TextStyle(
           alignment = "left",
           font_family = "Arial",
           font_weight = "Bold",
           font_size = 11)
TextStyle("Arial", 11, "Bold", "black", "white", "left", 0)
=#