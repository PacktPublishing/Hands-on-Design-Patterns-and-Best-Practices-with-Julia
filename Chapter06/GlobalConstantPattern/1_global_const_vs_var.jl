# Performance of global constant vs. global variable
#
# Concept:
# Global variables hurts performance because compiler cannot generate
# efficient code.  Make it constant helps the compiler tremendously.

using BenchmarkTools

# using global variable
variable = 10
function add_using_global_variable(x)
    return x + variable
end

@btime add_using_global_variable(10);
#=
julia> @btime add_using_global_variable(10);
  25.572 ns (0 allocations: 0 bytes)
=#

function add_using_function_arg(x, y)
    return x + y
end

@btime add_using_function_arg(10, 10)

#=
julia> @btime add_using_function_arg(10, 10)
  0.030 ns (0 allocations: 0 bytes)
=#

#=
julia> @code_llvm add_using_function_arg(10, 10)

;  @ REPL[158]:6 within `add_using_function_arg'
define i64 @julia_add_using_function_arg_15028(i64, i64) {
top:
; ┌ @ int.jl:53 within `+'
   %2 = add i64 %1, %0
; └
  ret i64 %2
}

julia> @code_llvm add_using_global_variable(10)

;  @ REPL[156]:2 within `add_using_global_variable'
define nonnull %jl_value_t addrspace(10)* @julia_add_using_global_variable_14990(i64) {
top:
  %1 = alloca %jl_value_t addrspace(10)*, i32 3
  %gcframe = alloca %jl_value_t addrspace(10)*, i32 4
  %2 = bitcast %jl_value_t addrspace(10)** %gcframe to i8*
  call void @llvm.memset.p0i8.i32(i8* %2, i8 0, i32 32, i32 0, i1 false)
  %3 = call %jl_value_t*** inttoptr (i64 4493620896 to %jl_value_t*** ()*)() #2
  %4 = getelementptr %jl_value_t addrspace(10)*, %jl_value_t addrspace(10)** %gcframe, i32 0
  %5 = bitcast %jl_value_t addrspace(10)** %4 to i64*
  store i64 4, i64* %5
  %6 = getelementptr %jl_value_t**, %jl_value_t*** %3, i32 0
  %7 = load %jl_value_t**, %jl_value_t*** %6
  %8 = getelementptr %jl_value_t addrspace(10)*, %jl_value_t addrspace(10)** %gcframe, i32 1
  %9 = bitcast %jl_value_t addrspace(10)** %8 to %jl_value_t***
  store %jl_value_t** %7, %jl_value_t*** %9
  %10 = bitcast %jl_value_t*** %6 to %jl_value_t addrspace(10)***
  store %jl_value_t addrspace(10)** %gcframe, %jl_value_t addrspace(10)*** %10
  %11 = load %jl_value_t addrspace(10)*, %jl_value_t addrspace(10)** inttoptr (i64 4757987176 to %jl_value_t addrspace(10)**), align 8
  %12 = getelementptr %jl_value_t addrspace(10)*, %jl_value_t addrspace(10)** %gcframe, i32 2
  store %jl_value_t addrspace(10)* %11, %jl_value_t addrspace(10)** %12
  %13 = call %jl_value_t addrspace(10)* @jl_box_int64(i64 signext %0)
  %14 = getelementptr %jl_value_t addrspace(10)*, %jl_value_t addrspace(10)** %gcframe, i32 3
  store %jl_value_t addrspace(10)* %13, %jl_value_t addrspace(10)** %14
  %15 = getelementptr %jl_value_t addrspace(10)*, %jl_value_t addrspace(10)** %1, i32 0
  store %jl_value_t addrspace(10)* addrspacecast (%jl_value_t* inttoptr (i64 4582122192 to %jl_value_t*) to %jl_value_t addrspace(10)*), %jl_value_t addrspace(10)** %15
  %16 = getelementptr %jl_value_t addrspace(10)*, %jl_value_t addrspace(10)** %1, i32 1
  store %jl_value_t addrspace(10)* %13, %jl_value_t addrspace(10)** %16
  %17 = getelementptr %jl_value_t addrspace(10)*, %jl_value_t addrspace(10)** %1, i32 2
  store %jl_value_t addrspace(10)* %11, %jl_value_t addrspace(10)** %17
  %18 = call nonnull %jl_value_t addrspace(10)* @jl_apply_generic(%jl_value_t addrspace(10)** %1, i32 3)
  %19 = getelementptr %jl_value_t addrspace(10)*, %jl_value_t addrspace(10)** %gcframe, i32 1
  %20 = load %jl_value_t addrspace(10)*, %jl_value_t addrspace(10)** %19
  %21 = getelementptr %jl_value_t**, %jl_value_t*** %3, i32 0
  %22 = bitcast %jl_value_t*** %21 to %jl_value_t addrspace(10)**
  store %jl_value_t addrspace(10)* %20, %jl_value_t addrspace(10)** %22
  ret %jl_value_t addrspace(10)* %18
}
=#

# ------------------------------------------------------------------

function add_using_global_variable_typed(x)
    return x + variable::Int
end

#=
julia> @btime add_using_global_variable_typed(10)
  5.213 ns (0 allocations: 0 bytes)
=#

#= what if the variable got assigned to a value with different type?
julia> variable = 10.0
10.0

julia> add_using_global_variable_typed(10)
ERROR: TypeError: in typeassert, expected Int64, got Float64
=#


# ------------------------------------------------------------------

const constant = 10
function add_using_global_constant(x)
    return constant + x
end

@btime add_using_global_constant(10);
#=
julia> @btime add_using_global_constant(10);
  0.030 ns (0 allocations: 0 bytes)
=#

#=
julia> @code_llvm add_using_global_constant(10)

;  @ REPL[166]:2 within `add_using_global_constant'
define i64 @julia_add_using_global_constant_15035(i64) {
top:
; ┌ @ int.jl:53 within `+'
   %1 = add i64 %0, 10
; └
  ret i64 %1
}
=#

# ----------------------------------------------------------------------
# what if variable is annotated with type?
# ----------------------------------------------------------------------
variable::Int = 10

#=
julia> variable::Int = 10
ERROR: syntax: type declarations on global variables are not yet supported
=#
