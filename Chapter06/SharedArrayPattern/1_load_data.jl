# ------------------------------------------------------------
# Motivation

# Project requirements
# - 22G raw data + runtime overhead
# - as many cpu's as possible
#
# Consider:
# - AWS c5.4xlarge with 16 vCPU, 32 GB RAM

# Valuation matrix:  dims = (100000, 10000, 3)
#     for 100K securities
#          10K monte carlo states
#            3 return attributes
#
# Total memory footprint (GiB)
#     julia> 100_000 * 10_000 * 3 * 8 / 1024 / 1024 / 1024
#     22.351741790771484

# ----------------------------------------------------------------
# Generate test data
# ----------------------------------------------------------------
function locate_file(index)
    id = index - 1
    dir = string(id % 100)
    joinpath(dir, "sec$(id).dat")
end

function make_data_directories(folder)
    for i in 0:99 
        mkpath(joinpath(folder, string(i)))
    end
end

function generate_test_data(nfiles)
    for i in 1:nfiles
        A = rand(10000, 3)
        file = locate_file(i)
        open(file, "w") do io
            write(io, A)
        end
    end
end

# put test data in a separate directory
folder = joinpath(ENV["HOME"], "julia_book_ch06_data")
make_data_directories(folder)
cd(folder)
generate_test_data(100_000)

# data directory
#=
$ ls
0   13  18  22  27  31  36  40  45  5   54  59  63  68  72  77  81  86  90  95
1   14  19  23  28  32  37  41  46  50  55  6   64  69  73  78  82  87  91  96
10  15  2   24  29  33  38  42  47  51  56  60  65  7   74  79  83  88  92  97
11  16  20  25  3   34  39  43  48  52  57  61  66  70  75  8   84  89  93  98
12  17  21  26  30  35  4   44  49  53  58  62  67  71  76  80  85  9   94  99

$ ls -l 0 | tail -6
-rw-rw-r-- 1 ec2-user ec2-user 240000 Jul  9 07:05 sec99400.dat
-rw-rw-r-- 1 ec2-user ec2-user 240000 Jul  9 07:05 sec99500.dat
-rw-rw-r-- 1 ec2-user ec2-user 240000 Jul  9 07:05 sec99600.dat
-rw-rw-r-- 1 ec2-user ec2-user 240000 Jul  9 07:05 sec99700.dat
-rw-rw-r-- 1 ec2-user ec2-user 240000 Jul  9 07:05 sec99800.dat
-rw-rw-r-- 1 ec2-user ec2-user 240000 Jul  9 07:05 sec99900.dat
=#

# ----------------------------------------------------------------
# Fast read into memory
# ----------------------------------------------------------------

# From unix command line, use the `-p` option to start child processes.
#     $ julia -p 16

using Distributed
using SharedArrays

# Read a single data file into a segment of the shared array `dest`
# The segment size is specified as in `dims`. 
@everywhere function read_val_file!(index, dest)
    filename = locate_file(index)
    (nstates, nattrs) = size(dest)[1:2]
    open(filename) do io
        nbytes = nstates * nattrs * 8
        buffer = read(io, nbytes)
        A = reinterpret(Float64, buffer)
        dest[:, :, index] = A
    end
end

# obtain path to data file
@everywhere function locate_file(index)
    id = index - 1
    dir = string(id % 100)
    joinpath(dir, "sec$(id).dat")
end

# main program
function load_data!(nfiles, dest)
    @sync @distributed for i in 1:nfiles
        read_val_file!(i, dest)
    end
end

# main program
@everywhere cd(joinpath(ENV["HOME"], "julia_book_ch06_data"))
nfiles  = 100_000;
nstates = 10_000;
nattr   = 3;
valuation = SharedArray{Float64}(nstates, nattr, nfiles);

@time load_data!(nfiles, valuation);

# It took about 3 minutes to load data 100,000 files
#=
julia> @time load_data!(nfiles, valuation);
180.975685 seconds (1.49 M allocations: 76.647 MiB, 0.01% gc time)
=#

