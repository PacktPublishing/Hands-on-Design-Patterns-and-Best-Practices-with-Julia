# Parsing expressions
#=
julia> Meta.parse("x + y")
:(x + y)
=#

# Expr type
#=
julia> Meta.parse("x + y") |> typeof
Expr
=#

# Expr object dump
#=
julia> Meta.parse("x + y") |> dump
Expr
  head: Symbol call
  args: Array{Any}((3,))
    1: Symbol +
    2: Symbol x
    3: Symbol y
=#

# -----------------------------------------------------------------------------

# Single variable
#=
julia> Meta.parse("x") |> dump
Symbol x
=#

# Function calls with keyword arguments
#=
julia> Meta.parse("""open("/tmp/test.txt", read = true, write = true)""") |> dump
Expr
  head: Symbol call
  args: Array{Any}((4,))
    1: Symbol open
    2: String "/tmp/test.txt"
    3: Expr
      head: Symbol kw
      args: Array{Any}((2,))
        1: Symbol read
        2: Bool true
    4: Expr
      head: Symbol kw
      args: Array{Any}((2,))
        1: Symbol write
        2: Bool true
=#

# Nested functions
#=
julia> Meta.parse("cos(sin(x+1))") |> dump
Expr
  head: Symbol call
  args: Array{Any}((2,))
    1: Symbol cos
    2: Expr
      head: Symbol call
      args: Array{Any}((2,))
        1: Symbol sin
        2: Expr
          head: Symbol call
          args: Array{Any}((3,))
            1: Symbol +
            2: Symbol x
            3: Int64 1
=#

# -----------------------------------------------------------------------------

# constructing Expr manually
#=
julia> Expr(:call, :+, :x, :y)
:(x + y)
=#

# nested one
#=
julia> Expr(:call, :sin, Expr(:call, :+, :x, :y))
:(sin(x + y))
=#

# using :() syntax
#=
julia> ex = :(x + y)
:(x + y)

julia> dump(ex)
Expr
  head: Symbol call
  args: Array{Any}((3,))
    1: Symbol +
    2: Symbol x
    3: Symbol y
=#

# quoted block
#=
julia> :(begin
       x = 1
       y = 2
       end)
quote
    #= REPL[24]:2 =#
    x = 1
    #= REPL[24]:3 =#
    y = 2
end
=#

# using quote block directly
#=
julia> quote
           x = 1
           y = 2
       end
quote
    #= REPL[25]:2 =#
    x = 1
    #= REPL[25]:3 =#
    y = 2
end
=#

# -----------------------------------------------------------------------------
# more complex expression

# Variable Assignment
#=
julia> :(x = 1 + 1) |> dump
Expr
  head: Symbol =
  args: Array{Any}((2,))
    1: Symbol x
    2: Expr
      head: Symbol call
      args: Array{Any}((3,))
        1: Symbol +
        2: Int64 1
        3: Int64 1
=#

# Code Block
#=
julia> :(begin
           println("hello")
           println("world")
       end) |> dump
Expr
  head: Symbol block
  args: Array{Any}((4,))
    1: LineNumberNode
      line: Int64 2
      file: Symbol REPL[10]
    2: Expr
      head: Symbol call
      args: Array{Any}((2,))
        1: Symbol println
        2: String "hello"
    3: LineNumberNode
      line: Int64 3
      file: Symbol REPL[10]
    4: Expr
      head: Symbol call
      args: Array{Any}((2,))
        1: Symbol println
        2: String "world"
=#

# Conditional
#=
julia> :(if 2 > 1
           "good"
       else
           "bad"
       end) |> dump
Expr
  head: Symbol if
  args: Array{Any}((3,))
    1: Expr
      head: Symbol call
      args: Array{Any}((3,))
        1: Symbol >
        2: Int64 2
        3: Int64 1
    2: Expr
      head: Symbol block
      args: Array{Any}((2,))
        1: LineNumberNode
          line: Int64 2
          file: Symbol REPL[12]
        2: String "good"
    3: Expr
      head: Symbol block
      args: Array{Any}((2,))
        1: LineNumberNode
          line: Int64 4
          file: Symbol REPL[12]
        2: String "bad"
=#

# Loop
#=
julia> :(for i in 1:5
           println("hello world")
       end) |> dump
Expr
  head: Symbol for
  args: Array{Any}((2,))
    1: Expr
      head: Symbol =
      args: Array{Any}((2,))
        1: Symbol i
        2: Expr
          head: Symbol call
          args: Array{Any}((3,))
            1: Symbol :
            2: Int64 1
            3: Int64 5
    2: Expr
      head: Symbol block
      args: Array{Any}((2,))
        1: LineNumberNode
          line: Int64 2
          file: Symbol REPL[13]
        2: Expr
          head: Symbol call
          args: Array{Any}((2,))
            1: Symbol println
            2: String "hello world"
=#

# Function Definition
#=
julia> :(function foo(x; y = 1)
           return x + y
       end) |> dump
Expr
  head: Symbol function
  args: Array{Any}((2,))
    1: Expr
      head: Symbol call
      args: Array{Any}((3,))
        1: Symbol foo
        2: Expr
          head: Symbol parameters
          args: Array{Any}((1,))
            1: Expr
              head: Symbol kw
              args: Array{Any}((2,))
                1: Symbol y
                2: Int64 1
        3: Symbol x
    2: Expr
      head: Symbol block
      args: Array{Any}((2,))
        1: LineNumberNode
          line: Int64 2
          file: Symbol REPL[23]
        2: Expr
          head: Symbol return
          args: Array{Any}((1,))
            1: Expr
              head: Symbol call
              args: Array{Any}((3,))
                1: Symbol +
                2: Symbol x
                3: Symbol y
=#

# -----------------------------------------------------------------------------

# eval expressions
#=
julia> eval(:(x = 1))
1

julia> x
1
=#

# eval from within a function
#=
julia> function foo()
           eval(:(y = 1))
       end

julia> foo()
1

julia> y
1
=#

# interpolation
#=
julia> x = 2
2

julia> :(sqrt($x))
:(sqrt(2))
=#

# splatting interpolation
#=
julia> v = [1, 2, 3]
3-element Array{Int64,1}:
 1
 2
 3

julia> quote
           max($(v...))
       end
quote
    #= REPL[47]:2 =#
    max(1, 2, 3)
end
=#

# incorrect splatting usage
#=
julia> quote
           max($v...)
       end
quote
    #= REPL[46]:2 =#
    max([1, 2, 3]...)
end
=#

# -----------------------------------------------------------------------------

# what is QuoteNode
#=
julia> :( x = :hello ) |> dump
Expr
  head: Symbol =
  args: Array{Any}((2,))
    1: Symbol x
    2: QuoteNode
      value: Symbol hello
=#

# variable assignment
#=
julia> :( x = hello ) |> dump
Expr
  head: Symbol =
  args: Array{Any}((2,))
    1: Symbol x
    2: Symbol hello
=#

# variable assignment (using interpolation)
#=
julia> sym = :hello
:hello

julia> :( x = $sym)
:(x = hello)
=#

# using QuoteNode
#=
julia> sym = QuoteNode(:hello)
:(:hello)

julia> :( x = $sym)
:(x = :hello)
=#

# -----------------------------------------------------------------------------

# interpolation into nested expression
#=
julia> :( :( x = 1 ) ) |> dump
Expr
  head: Symbol quote
  args: Array{Any}((1,))
    1: Expr
      head: Symbol =
      args: Array{Any}((2,))
        1: Symbol x
        2: Int64 1

julia> :( :( x = $($v) ) )
:($(Expr(:quote, :(x = $(Expr(:$, 2))))))
=#
