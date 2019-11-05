# Simple macro
macro hello()
    return :(
    for i in 1:3
        println("hello world")
    end
    )
end
#=
julia> macro hello()
           return :(
           for i in 1:3
               println("hello world")
           end
           )
       end

julia> @hello()
hello world
hello world
hello world

julia> @hello
hello world
hello world
hello world
=#

# -----------------------------------------------------------------------------
# passing literal argument
macro hello(n)
    return :(
    for i in 1:$n
        println("hello world")
    end
    )
end
#=
julia> macro hello(n)
           return :(
           for i in 1:$n
               println("hello world")
           end
           )
       end
@hello (macro with 2 methods)

julia> @hello(2)
hello world
hello world

julia> @hello 2
hello world
hello world
=#

# -----------------------------------------------------------------------------
# Passing expression arguments
function showme(x)
    @show x
end
#=
julia> a = 1; b = "hello"; c = :hello;

julia> function showme(x)
           @show x
       end

julia> showme(a);
x = 1

julia> showme(b);
x = "hello"

julia> showme(c);
x = :hello
=#

macro showme(x)
    @show x
end
#=
julia> macro showme(x)
           @show x
       end

julia> @showme(a);
x = :a

julia> @showme(b);
x = :b

julia> @showme(c);
x = :c
=#

# -----------------------------------------------------------------------------

# macro expansion
#=
julia> @macroexpand @hello 2
:(for #4#i = 1:2
      #= REPL[3]:4 =#
      Main.println("hello world")
  end)
=#

# what happens?
macro identity(ex)
    dump(ex)
    return ex
end
#=
julia> macro identity(ex)
           dump(ex)
           return ex
       end
=#

function foo()
    return @identity 1 + 2 + 3
end

#=
julia> function foo()
           return @identity 1 + 2 + 3
       end
Expr
  head: Symbol call
  args: Array{Any}((4,))
    1: Symbol +
    2: Int64 1
    3: Int64 2
    4: Int64 3
foo (generic function with 1 method)
=#

@code_lowered foo()
#=
julia> @code_lowered foo()
CodeInfo(
1 ─ %1 = 1 + 2 + 3
└──      return %1
)
=#

# -----------------------------------------------------------------------------
# manipulating expressions

# example 1
macro squared(ex)
    return :($(ex) * $(ex))
end
#=
julia> macro squared(ex)
           return :($(ex) * $(ex))
       end
@squared (macro with 1 method)

julia> @squared 3
9
=#

# does not quite work properly
function foo()
    x = 2
    return @squared x
end
#=
julia> function foo()
           x = 2
           return @squared x
       end

julia> foo()
ERROR: UndefVarError: x not defined
=#

# why?
@code_lowered foo()

#=
julia> @code_lowered foo()
CodeInfo(
1 ─      x = 2
│   %2 = Main.x * Main.x
└──      return %2
)
=#

# let's fix it
macro squared(ex)
    return :($(esc(ex)) * $(esc(ex)))
end
#=
julia> macro squared(ex)
           return :($(esc(ex)) * $(esc(ex)))
       end
=#

function foo()
    x = 2
    return @squared x
end

#=
julia> function foo()
           x = 2
           return @squared x
       end

julia> foo()
4
=#

# example 2
#=
julia> :(sin(x)) |> dump
Expr
  head: Symbol call
  args: Array{Any}((2,))
    1: Symbol sin
    2: Symbol x

julia> :(sin(sin(x))) |> dump
Expr
  head: Symbol call
  args: Array{Any}((2,))
    1: Symbol sin
    2: Expr
      head: Symbol call
      args: Array{Any}((2,))
        1: Symbol sin
        2: Symbol x
=#

macro compose_twice(ex)
    @assert ex.head == :call
    @assert length(ex.args) == 2
    me = copy(ex)
    ex.args[2] = me
    return ex
end
#=
julia> macro compose_twice(ex)
           @assert ex.head == :call
           @assert length(ex.args) == 2
           me = copy(ex)
           ex.args[2] = me
           return ex
       end

julia> @compose_twice(sin(1)) == sin(sin(1))
true
=#

# -----------------------------------------------------------------------------

# macro hygiene
macro ntimes(n, ex)
    quote
        times = $(esc(n))
        for i in 1:times
            $(esc(ex))
        end
    end
end
#=
julia> macro ntimes(n, ex)
           quote
               times = $(esc(n))
               for i in 1:times
                   $(esc(ex))
               end
           end
       end
=#

function foo()
    times = 0
    @ntimes 3 println("hello world")
    println("times = ", times)
end
#=
julia> function foo()
           times = 0
           @ntimes 3 println("hello world")
           println("times = ", times)
       end

julia> foo()
hello world
hello world
hello world
times = 0
=#

# let's expand the macro and see what happens
@macroexpand(@ntimes 3 println("hello world"))

#=
julia> @macroexpand(@ntimes 3 println("hello world"))
quote
    #= REPL[73]:3 =#
    #118#times = 3
    #= REPL[73]:4 =#
    for #119#i = 1:#118#times
        #= REPL[73]:5 =#
        println("hello world")
    end
end
=#

# -----------------------------------------------------------------------------
# non standard string literal

# regex
#=
julia> typeof(r"^hello")
Regex
=#

# our own
#=
julia> DataFrame(x1 = rand(Float64, 100000), x2 = rand(Int16, 100000))
=#

# nmeric data frame non-standard string literal macro
macro ndf_str(s)
    nstr, spec = split(s, ":")
    n = parse(Int, nstr) # number of rows
    types = split(spec, ",") # column type specifications
    
    num_columns = length(types)
    
    mappings = Dict(
    "f64"=>Float64, "f32"=>Float32,
    "i64"=>Int64, "i32"=>Int32, "i16"=>Int16, "i8"=>Int8)
    
    column_types = [mappings[t] for t in types]
    column_names = [Symbol("x$i") for i in 1:num_columns]
    
    return DataFrame([column_names[i] => rand(column_types[i], n)
        for i in 1:num_columns]...) 
end
    
ndf"100000:f64,f32,i16,i8"
#=
julia> ndf"100000:f64,f32,i16,i8"
100000×4 DataFrame
│ Row │ x1       │ x2        │ x3    │ x4   │
│     │ Float64  │ Float32   │ Int16 │ Int8 │
├─────┼──────────┼───────────┼───────┼──────┤
│ 1   │ 0.160496 │ 0.404637  │ 6805  │ 96   │
│ 2   │ 0.994738 │ 0.636778  │ 23910 │ -59  │
│ 3   │ 0.59626  │ 0.520906  │ 11857 │ -71  │
│ 4   │ 0.637577 │ 0.152872  │ -3842 │ 48   │
│ 5   │ 0.396112 │ 0.0520195 │ -2919 │ -111 │
=#
