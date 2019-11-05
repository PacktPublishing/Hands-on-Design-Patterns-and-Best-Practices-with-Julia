# Parsing expressions
Meta.parse("x + y")
#=
julia> Meta.parse("x + y")
:(x + y)
=#

# Expr type
Meta.parse("x + y") |> typeof
#=
julia> Meta.parse("x + y") |> typeof
Expr
=#

# Expr object dump
Meta.parse("x + y") |> dump
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
Meta.parse("x") |> dump
#=
julia> Meta.parse("x") |> dump
Symbol x
=#

# Function calls with keyword arguments
Meta.parse("""open("/tmp/test.txt", read = true, write = true)""") |> dump
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
Meta.parse("cos(sin(x+1))") |> dump
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
Expr(:call, :+, :x, :y)
#=
julia> Expr(:call, :+, :x, :y)
:(x + y)
=#

# nested one
Expr(:call, :sin, Expr(:call, :+, :x, :y))
#=
julia> Expr(:call, :sin, Expr(:call, :+, :x, :y))
:(sin(x + y))
=#

# using :() syntax
ex = :(x + y)
dump(ex)
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
:( begin
        x = 1
        y = 2
   end )
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
quote
    x = 1
    y = 2
end
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
:(x = 1 + 1) |> dump
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
:(begin
        println("hello")
        println("world")
    end) |> dump
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
:(if 2 > 1
        "good"
    else
        "bad"
    end) |> dump
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
:(for i in 1:5
        println("hello world")
    end) |> dump
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
:(function foo(x; y = 1)
        return x + y
    end) |> dump
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
eval(:(x = 1))
#=
julia> eval(:(x = 1))
1

julia> x
1
=#

# eval from within a function
function foo()
    eval(:(y = 1))
end
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
x = 2
:(sqrt($x))
#=
julia> x = 2
2

julia> :(sqrt($x))
:(sqrt(2))
=#

# splatting interpolation
v = [1, 2, 3]
quote
    max($(v...))
end
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
quote
    max($v...)
end
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
:( x = :hello ) |> dump
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
:( x = hello ) |> dump
#=
julia> :( x = hello ) |> dump
Expr
  head: Symbol =
  args: Array{Any}((2,))
    1: Symbol x
    2: Symbol hello
=#

# variable assignment (using interpolation)
sym = :hello
:( x = $sym)
#=
julia> sym = :hello
:hello

julia> :( x = $sym)
:(x = hello)
=#

# using QuoteNode
sym = QuoteNode(:hello)
:( x = $sym)
#=
julia> sym = QuoteNode(:hello)
:(:hello)

julia> :( x = $sym)
:(x = :hello)
=#

# -----------------------------------------------------------------------------

# interpolation into nested expression
:( :( x = 1 ) ) |> dump
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

:( :( x = $v ) ) |> dump
#=
julia> :( :( x = $v ) ) |> dump
Expr
  head: Symbol quote
  args: Array{Any}((1,))
    1: Expr
      head: Symbol =
      args: Array{Any}((2,))
        1: Symbol x
        2: Expr
          head: Symbol $
          args: Array{Any}((1,))
            1: Symbol v
=#
