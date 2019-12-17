module SingletonExample

export AppKey

# AppKey contains an app id and encryption key
struct AppKey
    appid::String
    value::UInt128
end

# placeholder for AppKey object.  Start with nothing until initialized.
const appkey = Ref{Union{AppKey,Nothing}}(nothing)

# initializer
function construct()
    global appkey
    if appkey[] === nothing
        ak = AppKey("myapp", rand(UInt128))
        println("constructing $ak")
        appkey[] = ak
    end
    return nothing
end

function test()
    construct()
end

function test_multithreading()
    println("Number of threads: ", Threads.nthreads())
    global appkey[] = nothing
    Threads.@threads for i in 1:8
        construct()
    end
end

end #module

using .SingletonExample
SingletonExample.test()
SingletonExample.test_multithreading()

# test
#=
julia> SingletonExample.test()
constructing AppKey("myapp", 0x2b20f8bf74d7175ec25ad70669faa434)

julia> SingletonExample.test_multithreading()
Number of threads: 4
constructing AppKey("myapp", 0xaa0c9aa1746439568ec7f2ff99edb107)
constructing AppKey("myapp", 0xb9078c91ce3e764322d4d5c980b011d0)
constructing AppKey("myapp", 0x23c3507affbd65cab8c9fb25d5c3db29)
constructing AppKey("myapp", 0x3e3f51b5fecc028c1007b8e182fa2d74)
=#

# How do we ensure a single construction???

module SingletonExample2

export AppKey

# object that needs to be initialized as appkey
struct AppKey
    appid::String
    value::UInt128
end

# placeholder for AppKey object.  Start with nothing until initialized.
const appkey = Ref{Union{AppKey,Nothing}}(nothing)

# create a ReentrantLock 
const appkey_lock = Ref{ReentrantLock}(ReentrantLock())

# change construct() function to acquire lock before
# construction, and release it after it's done.
function construct()
    global appkey
    global appkey_lock
    lock(appkey_lock[])
    try
        if appkey[] === nothing
            ak = AppKey("myapp", rand(UInt128))
            println("constructing $ak")
            appkey[] = ak
        end
    finally
        unlock(appkey_lock[])
        return appkey[]
    end
end

function test_multithreading()
    println("Number of threads: ", Threads.nthreads())
    global appkey[] = nothing
    Threads.@threads for i in 1:8
        construct()
    end
end

end #module

using .SingletonExample2
SingletonExample2.test_multithreading()

#=
julia> F.test_multithreading()
Number of threads: 4
constructing appkey object Main.F.AppKey(0xb8)
skipped construction.
skipped construction.
skipped construction.
skipped construction.
skipped construction.
skipped construction.
skipped construction.
=#

