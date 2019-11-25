function foo1()
    foo2()
end

function foo2()
    foo3()
end

function foo3()
    throw(ErrorException("bad things happened"))
end

#=
julia> foo1()
ERROR: bad things happened
Stacktrace:
 [1] foo3() at ./REPL[99]:2
 [2] foo2() at ./REPL[96]:2
 [3] foo1() at ./REPL[95]:2
 [4] top-level scope at none:0
=#

function pretty_print_stacktrace(trace)
    for (i,v) in enumerate(trace)
        println(i, " => ", v)
    end
end

# handling error
function foo1()
    try
        foo2()
    catch
        println("handling error gracefully")
        pretty_print_stacktrace(stacktrace())
    end
end

#=
julia> foo1()
handling error gracefully
1 => foo1() at REPL[107]:6
2 => top-level scope at none:0
3 => eval(::Module, ::Any) at boot.jl:328
4 => eval_user_input(::Any, ::REPL.REPLBackend) at REPL.jl:85
5 => macro expansion at REPL.jl:117 [inlined]
6 => (::getfield(REPL, Symbol("##26#27")){REPL.REPLBackend})() at task.jl:259
=#

function foo1()
    try
        foo2()
    catch
        println("handling error gracefully")
        pretty_print_stacktrace(stacktrace(catch_backtrace()))
    end
end

#=
julia> foo1()
handling error gracefully
1 => foo3() at REPL[106]:2
2 => foo2() at REPL[96]:2
3 => foo1() at REPL[109]:3
4 => top-level scope at none:0
5 => eval(::Module, ::Any) at boot.jl:328
6 => eval_user_input(::Any, ::REPL.REPLBackend) at REPL.jl:85
7 => macro expansion at REPL.jl:117 [inlined]
8 => (::getfield(REPL, Symbol("##26#27")){REPL.REPLBackend})() at task.jl:259
=#
