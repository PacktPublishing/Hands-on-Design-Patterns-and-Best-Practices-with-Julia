# double
#=
julia> macro doubled(ex)
           return :( 2 * $(esc(ex)))
       end
=#


# generated function
#=
julia> @generated function doubled(x)
           return :( 2 * x )
       end

julia> doubled(2)
4

julia> x = 3.0
3.0

julia> doubled(x)
6.0
=#

# -----------------------------------------------------------------------------
# generated function arguments

# debug
#=
julia> @generated function doubled(x)
           @show x
           return :( 2 * x )
       end

julia> doubled(2)
x = Int64
4

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

