# ----------------------------------------------------------------
# Alternative: multh-threading
# ----------------------------------------------------------------

#=
$ export JULIA_NUM_THREADS=16
=#

function process_multithreaded(nfiles, nstates, nattr)
    result = zeros(nstates, nattr, nfiles)
    Threads.@threads for i in 1:nfiles
        read_val_file!(i, result)
    end
    return result
end

#=
julia> @time result = process_multithreaded(nfiles, nstates, nattr);
190.520584 seconds (2.95 M allocations: 44.268 GiB, 0.44% gc time)
=#
