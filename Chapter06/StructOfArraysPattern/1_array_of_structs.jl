# Array of structs

using BenchmarkTools, Statistics

struct TripPayment
    vendor_id::String
    tpep_pickup_datetime::String
    tpep_dropoff_datetime::String
    passenger_count::Int
    trip_distance::Float64
    fare_amount::Float64
    extra::Float64
    mta_tax::Float64
    tip_amount::Float64
    tolls_amount::Float64
    improvement_surcharge::Float64
    total_amount::Float64
end

function parse_tripdata_file(filename)
    records = Vector{TripPayment}()
    open(filename) do f
        readline(f); readline(f); #skip header/blank lines
        while !eof(f)
            line = readline(f) 
            fields = split(line, ",")
            record = TripPayment(
                fields[1],
                fields[2],
                fields[3],
                parse(Int, fields[4]),
                parse(Float64, fields[5]),
                parse(Float64, fields[11]),
                parse(Float64, fields[12]),
                parse(Float64, fields[13]),
                parse(Float64, fields[14]),
                parse(Float64, fields[15]),
                parse(Float64, fields[16]),
                parse(Float64, fields[17])
            )
            push!(records, record)
        end 
    end
    return records
end

# read data file
records = parse_tripdata_file("yellow_tripdata_2018-12_100k.csv");

#=
julia> length(records)
100000

julia> records[1:5]
5-element Array{TripPayment,1}:
 TripPayment("1", "2018-12-01 00:28:22", "2018-12-01 00:44:07", 2, 2.5, 12.0, 0.5, 0.5, 3.95, 0.0, 0.3, 17.25)
 TripPayment("1", "2018-12-01 00:52:29", "2018-12-01 01:11:37", 3, 2.3, 13.0, 0.5, 0.5, 2.85, 0.0, 0.3, 17.15)
 TripPayment("2", "2018-12-01 00:12:52", "2018-12-01 00:36:23", 1, 0.0, 2.5, 0.5, 0.5, 0.0, 0.0, 0.3, 3.8)
 TripPayment("1", "2018-12-01 00:35:08", "2018-12-01 00:43:11", 1, 3.9, 12.5, 0.5, 0.5, 2.75, 0.0, 0.3, 16.55)
 TripPayment("1", "2018-12-01 00:21:54", "2018-12-01 01:15:13", 1, 12.8, 45.0, 0.5, 0.5, 9.25, 0.0, 0.3, 55.55)
=#

# find mean of fare_amount field

#=
julia> mean(r.fare_amount for r in records)
11.985990599999994
=#

# how much time does it take?

#=
julia> @btime mean(r.fare_amount for r in $records);
  761.912 μs (1 allocation: 16 bytes)
=#

# what if we have the fare_amount data in an array?
fare_amounts = [r.fare_amount for r in records];

#=
julia> @btime mean(fare_amounts)
  27.090 μs (1 allocation: 16 bytes)
=#

# how much faster?
#=
julia> 762 / 27
28.22222222222222
=#
