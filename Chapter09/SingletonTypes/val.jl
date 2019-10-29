# Some GUI is sending a command from the user clicking on a menu
# e.g. "open", "close", "exit", "help"

# Depending on the command, the program does different things.
function process_command(command::String, args...)
    if command == "open"
        # open a file
    elseif command == "close"
        # close current file
    elseif command == "exit"
        # exit program
    elseif command == "help"
        # pops up a help dialog
    else
        error("bug - this should have never happened.")
    end
end

# problem - this function can become very long
# problem - this function must be changed every time a new command is added


struct OpenCommand end

oc1 = OpenCommand()
oc2 = OpenCommand()
oc1 === oc2

# what is Val?
Val(1)
Val(1) |> typeof

#=
julia> Val(1)
Val{1}()

julia> Val(1) |> typeof
Val{1}
=#

#= as defined in Julia, it's nothing but:
struct Val{x}
end
=#

# is it a singleton?
Val(1) === Val(1)
Val(:foo) === Val(:foo)

#=
julia> Val(1) === Val(1)
true

julia> Val(:foo) === Val(:foo)
true
=#

# only bits-type is allowed, otherwise...
#=
julia> Val("julia")
ERROR: TypeError: in Type, in parameter, expected Type, got String
=#

Val(:open)
#=
julia> Val(:open)
Val{:open}()
=#

function process_command(::Val{:open}, filename) 
    println("opening file $filename")
end

function process_command(::Val{:close}, filename) 
    println("closing file $filename")
end

#=
julia> process_command(Val(:open), "julia.pdf")
opening file julia.pdf
=#

# look ma, there's no if-then-else statements!
function process_command(command::String, args...)
    process_command(Val(Symbol(command)), args...)
end

#=
julia> process_command("open", "julia.pdf")
opening file julia.pdf

julia> process_command("close", "julia.pdf")
closing file julia.pdf
=#

# -----------------------------------------------

#=
julia> ntuple(i -> 2i, 10)
(2, 4, 6, 8, 10, 12, 14, 16, 18, 20)

julia> @btime ntuple(i->2i, 10);
  0.032 ns (0 allocations: 0 bytes)

julia> @btime ntuple(i->2i, 11);
  812.209 ns (4 allocations: 336 bytes)
=#

#= singleton type
julia> @btime ntuple(i->2i, Val(10));
  0.032 ns (0 allocations: 0 bytes)

julia> @btime ntuple(i->2i, Val(11));
  0.031 ns (0 allocations: 0 bytes)

julia> @btime ntuple(i->2i, Val(100));
  17.270 ns (0 allocations: 0 bytes)
=#

# An extreme example from Julia Base
# This is a huge if/then/else block of code for performance reason
function ntuple(f::F, n::Integer) where F
    t = n == 0  ? () :
        n == 1  ? (f(1),) :
        n == 2  ? (f(1), f(2)) :
        n == 3  ? (f(1), f(2), f(3)) :
        n == 4  ? (f(1), f(2), f(3), f(4)) :
        n == 5  ? (f(1), f(2), f(3), f(4), f(5)) :
        n == 6  ? (f(1), f(2), f(3), f(4), f(5), f(6)) :
        n == 7  ? (f(1), f(2), f(3), f(4), f(5), f(6), f(7)) :
        n == 8  ? (f(1), f(2), f(3), f(4), f(5), f(6), f(7), f(8)) :
        n == 9  ? (f(1), f(2), f(3), f(4), f(5), f(6), f(7), f(8), f(9)) :
        n == 10 ? (f(1), f(2), f(3), f(4), f(5), f(6), f(7), f(8), f(9), f(10)) :
        _ntuple(f, n)
    return t
end

function _ntuple(f, n)
    @_noinline_meta
    (n >= 0) || throw(ArgumentError(string("tuple length should be ≥ 0, got ", n)))
    ([f(i) for i = 1:n]...,)
end

# Using singleton type dynamic dispatch
# inferrable ntuple (enough for bootstrapping)
ntuple(f, ::Val{0}) = ()
ntuple(f, ::Val{1}) = (@_inline_meta; (f(1),))
ntuple(f, ::Val{2}) = (@_inline_meta; (f(1), f(2)))
ntuple(f, ::Val{3}) = (@_inline_meta; (f(1), f(2), f(3)))

@inline function ntuple(f::F, ::Val{N}) where {F,N}
    N::Int
    (N >= 0) || throw(ArgumentError(string("tuple length should be ≥ 0, got ", N)))
    if @generated
        quote
            @nexprs $N i -> t_i = f(i)
            @ncall $N tuple t
        end
    else
        Tuple(f(i) for i = 1:N)
    end
end

# let's understand what's going on here

using Base.Cartesian
@nexprs 3 i -> t_i = i

# It's the same thing as:
# t_1 = 1
# t_2 = 2
# t_3 = 3

#=
julia> @macroexpand(@nexprs 3 i -> t_i = i)
quote
    t_1 = 1
    t_2 = 2
    t_3 = 3
end
=#

#=
julia> @macroexpand(@ncall 3 tuple t)
:(tuple(t_1, t_2, t_3))
=#

# of course, we cannot hard code the number 3.
# but the macro can only work wth an integer not a variable...
# that's why the implementation wraps it in a @generated block
# and interpolate the value of N into the @ncall and @nexprs calls.

#=
julia> @macroexpand(@ncall N tuple t)
ERROR: LoadError: MethodError: no method matching @ncall(::LineNumberNode, ::Module, ::Symbol, ::Symbol, ::Symbol)
Closest candidates are:
  @ncall(::LineNumberNode, ::Module, ::Int64, ::Any, ::Any...) at cartesian.jl:105
=#

