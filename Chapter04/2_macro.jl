# Simple macro
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
:(for #7#i = 1:2
      #= REPL[84]:4 =#
      (Main.println)("hello world")
  end)
=#

# what happens?
#=
julia> macro identity(ex)
           dump(ex)
           return ex
       end

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

julia> @code_lowered foo()
CodeInfo(
1 ─ %1 = 1 + 2 + 3
└── return %1
)
=#

# -----------------------------------------------------------------------------
# manipulating expressions

# example 1
#=
julia> macro squared(ex)
           return :($(ex) * $(ex))
       end
@squared (macro with 1 method)

julia> @squared 3
9
=#

# does not quite work properly
#=
julia> function foo()
           x = 2
           return @squared x
       end

julia> foo()
ERROR: UndefVarError: x not defined
=#

# why?
#=
julia> @code_lowered foo()
CodeInfo(
1 ─ x = 2
│ %2 = Main.x * Main.x
└── return %2
)
=#

# let's fix it
#=
julia> macro squared(ex)
           return :($(esc(ex)) * $(esc(ex)))
       end

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
#=
julia> macro ntimes(n, ex)
           quote
               times = $(esc(n))
               for i in 1:times
                   $(esc(ex))
               end
           end
       end

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

julia> @code_lowered foo()
CodeInfo(
1 ─ times@_2 = 0
│ times@_3 = 3
│ %3 = 1:times@_3
│ #temp# = (Base.iterate)(%3)
│ %5 = #temp# === nothing
│ %6 = (Base.not_int)(%5)
└── goto #4 if not %6
2 ┄ %8 = #temp#
│ i = (Core.getfield)(%8, 1)
│ %10 = (Core.getfield)(%8, 2)
│ (Main.println)("hello world")
│ #temp# = (Base.iterate)(%3, %10)
│ %13 = #temp# === nothing
│ %14 = (Base.not_int)(%13)
└── goto #4 if not %14
3 ─ goto #2
4 ┄ %17 = (Main.println)("times = ", times@_2)
└── return %17
)
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

julia> macro ndf_str(s)
           nstr, spec = split(s, ":")
           n = parse(Int, nstr) # number of rows
           types = split(spec, ",") # column type specifications

           num_columns = length(types)

           mappings = Dict(
                "f64"=>Float64, "f32"=>Float32,
                "i64"=>Int64, "i32"=>Int32, "i16"=>Int16, "i8"=>Int8)

           column_types = [mappings[t] for t in types]
           column_names = [Symbol("x$i") for i in 1:num_columns]

           DataFrame([column_names[i] => rand(column_types[i], n)
                for i in 1:num_columns]...)
       end

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
