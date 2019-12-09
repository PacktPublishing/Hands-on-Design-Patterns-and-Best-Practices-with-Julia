using Dates

# this function randomly fails
function do_something(name::AbstractString)
    println(now(), " Let's do it")
    if rand() > 0.5
        println(now(), " Good job, $name 👍")
    else
        error(now(), " Too bad 😦")
    end
end

do_something("John")
do_something("John")

#= lucky day
julia> do_something("John")
2019-09-26T21:41:37.617 Let's do it
2019-09-26T21:41:37.617 Good job, John 👍
=#

#= bad day
julia> do_something("John")
2019-09-26T21:41:48.6 Let's do it
ERROR: 2019-09-26T21:41:48.6 Too bad 😦
=#

function do_something_more_robustly(name::AbstractString;
        max_retry_count = 3,
        retry_interval = 2)
    retry_count = 0
    while true
        try
            return do_something(name)
        catch ex
            sleep(retry_interval)
            retry_count += 1
            retry_count > max_retry_count && rethrow(ex)
        end
    end
end

do_something_more_robustly("John")

#= recovering nicely
julia> do_something_more_robustly("John")
2019-09-26T21:52:48.312 Let's do it
2019-09-26T21:52:50.313 Let's do it
2019-09-26T21:52:50.314 Good job, John 👍
=#

#= bad day, but we know how to recover
julia> do_something_more_robustly("John")
2019-09-26T21:52:52.638 Let's do it
2019-09-26T21:52:54.642 Let's do it
2019-09-26T21:52:56.646 Let's do it
2019-09-26T21:52:58.653 Let's do it
ERROR: 2019-09-26T21:52:58.653 Too bad 😦
=#

# easier way
retry(do_something, delays=fill(2.0, 3))("John")

#=
julia> retry(do_something, delays=fill(2.0, 3))("John")
2019-09-28T13:56:55.824 Let's do it
2019-09-28T13:56:57.826 Let's do it
2019-09-28T13:56:59.833 Let's do it
2019-09-28T13:57:01.834 Let's do it
ERROR: 2019-09-28T13:57:01.836 Too bad 😦
=#

# ExponentialBackOff
retry(do_something, delays=ExponentialBackOff(; n = 10))("John")
#=
julia> retry(do_something, delays=ExponentialBackOff(; n = 10))("John")
2019-09-29T00:38:54.428 Let's do it
2019-09-29T00:38:54.48 Let's do it
2019-09-29T00:38:54.762 Let's do it
2019-09-29T00:38:56.202 Let's do it
2019-09-29T00:39:03.773 Let's do it
2019-09-29T00:39:13.775 Let's do it
2019-09-29T00:39:23.779 Let's do it
2019-09-29T00:39:33.791 Let's do it
2019-09-29T00:39:43.797 Let's do it
=#
