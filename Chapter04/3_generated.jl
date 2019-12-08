# double a number, the macro way!
#=
macro doubled(ex)
    return :( 2 * $(esc(ex)))
end
=#

# This code does not work.  Don't try it.
#=
macro doubled(ex)
    if typeof(ex) isa AbstractFloat
        return :( double_super_duper($(esc(ex))) )
    else
        return :( 2 * $(esc(ex)))
    end
end
=#

# generated function
@generated function doubled(x)
    return :( 2 * x )
end
doubled(2)
#=
julia> @generated function doubled(x)
           return :( 2 * x )
       end

julia> doubled(2)
4
=#

# -----------------------------------------------------------------------------
# generated function arguments

# debug
@generated function doubled(x)
    @show x
    return :( 2 * x )
end
doubled(2)
doubled(2)
#=
julia> @generated function doubled(x)
           @show x
           return :( 2 * x )
       end

julia> doubled(2)
x = Int64
4
=#

doubled(3.0)
#=
julia> doubled(3.0)
x = Float64
6.0
=#

# using type info
#=
julia> @generated function doubled(x)
           if x <: AbstractFloat
               return :( double_super_duper(x) )
           else
               return :( 2 * x )
           end
       end
=#

