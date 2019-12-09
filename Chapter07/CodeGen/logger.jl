# Logger.jl

using Dates

const INFO     = 1
const WARNING  = 2
const ERROR    = 3

struct Logger
    filename   # log file name
    level      # minimum level acceptable to be logged
    handle     # file handle
end

Logger(filename, level) = Logger(filename, level, open(filename, "w"))

# info logging
function info!(logger::Logger, args...)
    if logger.level <= INFO
        let io = logger.handle
            print(io, trunc(now(), Dates.Second), " [INFO] ")
            for (idx, arg) in enumerate(args)
                idx > 0 && print(io, " ")
                print(io, arg)
            end
            println(io)
            flush(io)
        end
    end
end

# testing
info_logger = Logger("/tmp/info.log", INFO)
info!(info_logger, "hello", 123)

readlines("/tmp/info.log")
#=
julia> readlines("/tmp/info.log")
1-element Array{String,1}:
 "2019-09-07T22:22:46 [INFO]  hello 123"
=#

error_logger = Logger("/tmp/error.log", ERROR)
info!(error_logger, "hello", 123)

readlines("/tmp/error.log")
#=
julia> readlines("/tmp/error.log")
0-element Array{String,1}
=#

# now I'm tempted to just finish the project by duplicating the code 
# and make slight changes.
# => Violation of DRY principle!
function warning!(logger::Logger, args...)
    if logger.level <= WARNING
        let io = logger.handle
            print(io, trunc(now(), Dates.Second), " [WARNING] ")
            for (idx, arg) in enumerate(args)
                idx > 0 && print(io, " ")
                print(io, arg)
            end
            println(io)
            flush(io)
        end
    end
end

# code gen
for level in (:info, :warning, :error)
    lower_level_str = String(level)
    upper_level_str = uppercase(lower_level_str)
    upper_level_sym = Symbol(upper_level_str)

    fn = Symbol(lower_level_str * "!")
    label = " [" * upper_level_str * "] "

    @eval function $fn(logger::Logger, args...)
        if logger.level <= $upper_level_sym
            let io = logger.handle
                print(io, trunc(now(), Dates.Second), $label)
                for (idx, arg) in enumerate(args)
                    idx > 0 && print(io, " ")
                    print(io, arg)
                end
                println(io)
                flush(io)
            end
        end
    end
end

info_logger = Logger("/tmp/info.log", INFO)
info!(info_logger,    "hello", 123)
warning!(info_logger, "hello", 123)
error!(info_logger,   "hello", 123)

warning_logger = Logger("/tmp/warning.log", WARNING)
info!(warning_logger,    "hello", 123)
warning!(warning_logger, "hello", 123)
error!(warning_logger,   "hello", 123)

error_logger = Logger("/tmp/error.log", ERROR)
info!(error_logger,    "hello", 123)
warning!(error_logger, "hello", 123)
error!(error_logger,   "hello", 123)

readlines("/tmp/info.log")
readlines("/tmp/warning.log")
readlines("/tmp/error.log")
#=
julia> readlines("/tmp/info.log")
3-element Array{String,1}:
 "2019-12-08T17:03:28 [INFO]  hello 123"   
 "2019-12-08T17:03:28 [WARNING]  hello 123"
 "2019-12-08T17:03:28 [ERROR]  hello 123"  

julia> readlines("/tmp/warning.log")
2-element Array{String,1}:
 "2019-12-08T17:03:29 [WARNING]  hello 123"
 "2019-12-08T17:03:29 [ERROR]  hello 123"  

julia> readlines("/tmp/error.log")
1-element Array{String,1}:
 "2019-12-08T17:03:30 [ERROR]  hello 123"
=#

# debugging - https://github.com/timholy/CodeTracking.jl

methods(error!)
methods(error!) |> first

using Revise, CodeTracking
methods(error!) |> first |> definition
#=
julia> methods(error!)
# 1 method for generic function "error!":
[1] error!(logger::Logger, args...) in Main at REPL[70]:8

julia> methods(error!) |> first
error!(logger::Logger, args...) in Main at REPL[70]:8

julia> using Revise, CodeTracking

julia> methods(error!) |> first |> definition
:(function error!(logger::Logger, args...)
      #= REPL[24]:8 =#
      if logger.level <= ERROR
          #= REPL[24]:9 =#
          let io = logger.handle
              #= REPL[24]:10 =#
              print(io, trunc(now(), Dates.Second), " [ERROR] ")
              #= REPL[24]:11 =#
              for (idx, arg) = enumerate(args)
                  #= REPL[24]:12 =#
                  idx > 0 && print(io, " ")
                  #= REPL[24]:13 =#
                  print(io, arg)
              end
              #= REPL[24]:15 =#
              println(io)
              #= REPL[24]:16 =#
              flush(io)
          end
      end
  end)
=#

# MacroTools.prewalk

using MacroTools
MacroTools.prewalk(rmlines, definition(first(methods(error!))))
#=
julia> using MacroTools

julia> MacroTools.prewalk(rmlines, definition(first(methods(error!))))
:(function error!(logger::Logger, args...)
      if logger.level <= ERROR
          let io = logger.handle
              print(io, trunc(now(), Dates.Second), " [ERROR] ")
              for (idx, arg) = enumerate(args)
                  idx > 0 && print(io, " ")
                  print(io, arg)
              end
              println(io)
              flush(io)
          end
      end
  end)
=#

# using Lazy and chain with rmlines

using Lazy
@>> methods(error!) first definition MacroTools.prewalk(rmlines)
#= 
using Lazy

julia> @>> methods(error!) first definition MacroTools.prewalk(rmlines)
:(function error!(logger::Logger, args...)
      if logger.level <= ERROR
          let io = logger.handle
              print(io, trunc(now(), Dates.Second), " [ERROR] ")
              for (idx, arg) = enumerate(args)
                  idx > 0 && print(io, " ")
                  print(io, arg)
              end
              println(io)
              flush(io)
          end
      end
  end)
=#

function logme!(level, label, logger::Logger, args...)
    if logger.level <= level
        let io = logger.handle
            print(io, trunc(now(), Dates.Second), label)
            for (idx, arg) in enumerate(args)
                idx > 0 && print(io, " ")
                print(io, arg)
            end
            println(io)
            flush(io)
        end
    end
end

info!(logger::Logger, msg...)    = logme!(INFO,    " [INFO] ",    logger, msg...)
warning!(logger::Logger, msg...) = logme!(WARNING, " [WARNING] ", logger, msg...)
error!(logger::Logger, msg...)   = logme!(ERROR,   " [ERROR] ",   logger, msg...)


#----- using closuure -----
function make_log_func(level, label)
    (logger::Logger, args...) -> begin
        if logger.level <= level
            let io = logger.handle
                print(io, trunc(now(), Dates.Second), " [", label, "] ")
                for (idx, arg) in enumerate(args)
                    idx > 0 && print(io, " ")
                    print(io, arg)
                end
                println(io)
                flush(io)
            end
        end
    end
end

info!    = make_log_func(INFO, "INFO")
warning! = make_log_func(WARNING, "WARNING")
error!   = make_log_func(ERROR, "ERROR")

