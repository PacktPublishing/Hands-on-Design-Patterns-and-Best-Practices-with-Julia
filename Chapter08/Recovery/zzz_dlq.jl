# dead letter queue

using Dates: now

# ============
# Set up a bad web site that it sometimes throws 500 internal server error
using HTTP
using Sockets

function web_handler(http)
    if rand() > 0.5
        HTTP.setstatus(http, 200)
        startwrite(http)
        write(http, "OK")
    else
        HTTP.setstatus(http, 500)
        startwrite(http)
        write(http, "<h1>Internal Server Errror</h1>")
    end
end

port = 1234
server = Sockets.listen(port)
http_server_task = @async HTTP.listen(web_handler; server=server)

# ============
# Error handling process

server_error_queue = Channel(128)
admin_message_shutdown = "ADMIN:SHUTDOWN"

function process_error(channel)
    while true
        msg = take!(channel)
        msg == admin_message_shutdown && break
        println(now(), " handling error: ", msg)
    end
    println(now(), " Error handling has exited.")
end

function shutdown_error_handler(channel)
    put!(channel, admin_message_shutdown)
    sleep(0.5)  # throttle REPL
    return nothing
end

# kick off error handling process
error_handling_task = @async process_error(server_error_queue)

# ============

#=
julia> http_server_task.state
:runnable

julia> error_handling_task.state
:runnable
=#

# ============
# Test.  

for i in 1:4
    try
        HTTP.get("http://localhost:1234", retry = false)
        println(now(), "Request $i was successful")
    catch
        put!(server_error_queue, "Request $i unable to reach site")
    end
end

# Closing server will stop HTTP.listen.
close(server)

