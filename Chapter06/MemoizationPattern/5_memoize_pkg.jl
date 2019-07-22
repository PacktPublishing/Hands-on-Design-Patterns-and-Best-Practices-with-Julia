#=
julia> using Memoize

julia> @memoize fib(n) = n < 3 ? 1 : fib(n-1) + fib(n-2)
fib (generic function with 1 method)

julia> @time fib(40)
  0.027960 seconds (64.56 k allocations: 3.378 MiB)
102334155

julia> @time fib(40)
  0.000003 seconds (7 allocations: 208 bytes)
102334155

julia> @time fib(39)
  0.000003 seconds (7 allocations: 208 bytes)
63245986
=#

#= Caching.jl
julia> using Caching, CSV, DataFrames

julia> @cache function read_csv(filename::AbstractString)
           println("Reading file: ", filename)
           @time df = CSV.File(filename) |> DataFrame
           return df
       end
           
read_csv (cache with 0 entries, 0 in memory 0 on disk)

julia> df = read_csv("Film_Permits.csv")
Reading file: Film_Permits.csv
  7.853251 seconds (25.52 M allocations: 1010.414 MiB, 10.49% gc time)

julia> size(df)
(42576, 14)

julia> df_again = read_csv("Film_Permits.csv");

julia> df === df_again
true

julia> propertynames(read_csv)
(:name, :filename, :func, :cache, :offsets, :history, :max_size)

julia> read_csv.cache
Dict{UInt64,Any} with 1 entry:
  0x602537e6ffb4d3f0 => 42576×14 DataFrame. Omitted printing of 11 columns…

julia> read_csv.filename
"/Users/tomkwong/Downloads/_7d1d434983e10ae8_.bin"

shell> ls -la /Users/tomkwong/Downloads/_7d1d434983e10ae8_.bin
ls: /Users/tomkwong/Downloads/_7d1d434983e10ae8_.bin: No such file or directory

julia> @persist! read_csv
read_csv (cache with 1 entry, 1 in memory 1 on disk)

shell> ls -1s /Users/tomkwong/Downloads/_7d1d434983e10ae8_.bin
33760 /Users/tomkwong/Downloads/_7d1d434983e10ae8_.bin

julia> read_csv
read_csv (cache with 1 entry, 1 in memory 1 on disk)

julia> @empty! read_csv
read_csv (cache with 1 entry, 0 in memory 1 on disk)

julia> df = read_csv("Film_Permits.csv");

julia> size(df)
(42576, 14)

julia> read_csv
read_csv (cache with 1 entry, 0 in memory 1 on disk)

julia> @syncache! read_csv "disk"
read_csv (cache with 1 entry, 1 in memory 1 on disk)

=#