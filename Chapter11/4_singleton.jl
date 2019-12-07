# XXX: this file requires Julia 1.3 (tested with RC5)

# don't use global variables
# let's use a Ref instead

# object that needs to be initialized as singleton
struct Foo x end

# placeholder for Foo object.  Start with nothing until initialized.
const singleton = Ref{Union{Foo,Nothing}}(nothing)

# initializer
function construct()
    global singleton
    if singleton[] === nothing
        foo = Foo(rand(UInt8))
        println("constructing singleton object $foo")
        singleton[] = foo
    end
    return singleton[]
end

# test
#=
julia> construct()
constructing singleton object Foo(0x4e)
Foo(0x4e)
=#

# testing in multi-threading app.

# restart REPL with multiple threads enabled
#=
$ JULIA_THREADS=4 julia

julia> Threads.nthreads()
4
=#

# Then, define Foo type, singleton object, and construct() 
# function again.

# Test again. Ooops... it's initialized multiple times!
#=
julia> singleton[] = nothing

julia> Threads.@threads for i in 1:8
           construct()
       end
constructing singleton object Foo(0x0c)
constructing singleton object Foo(0x3f)
constructing singleton object Foo(0xc3)
constructing singleton object Foo(0x83)
=#

# how do we ensure a single construction?

# create a ReentrantLock 
singleton_lock = ReentrantLock()

# change construct() function to acquire lock before
# construction, and release it after it's done.
function construct()
    global singleton
    global singleton_lock
    lock(singleton_lock)
    try
        if singleton[] === nothing
            foo = Foo(rand(UInt8))
            println("constructing singleton object $foo")
            singleton[] = foo
        end
    finally
        unlock(singleton_lock)
        return singleton[]
    end
end

# Test again!  Yay, it's good!
#=
julia> singleton[] = nothing

julia> Threads.@threads for i in 1:8
           construct()
       end
constructing singleton object Foo(0x40)
=#
