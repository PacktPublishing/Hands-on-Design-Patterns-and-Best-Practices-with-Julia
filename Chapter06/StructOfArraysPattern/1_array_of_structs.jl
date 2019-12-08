# Array of structs

using BenchmarkTools, Statistics, CSV

struct TripPayment
    vendor_id::Int
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

# Use CVS.jl to parse the file into a vecot or TripPayment objects
function read_trip_payment_file(file)
    f = CSV.File(file, datarow = 3)
    records = Vector{TripPayment}(undef, length(f))
    for (i, row) in enumerate(f)
        records[i] = TripPayment(row.VendorID,
                                 row.tpep_pickup_datetime, 
                                 row.tpep_dropoff_datetime,
                                 row.passenger_count,
                                 row.trip_distance,
                                 row.fare_amount,
                                 row.extra,
                                 row.mta_tax,
                                 row.tip_amount,
                                 row.tolls_amount,
                                 row.improvement_surcharge,
                                 row.total_amount)
    end
    return records
end

records = read_trip_payment_file("yellow_tripdata_2018-12_100k.csv")

#=
julia> records
100000-element Array{TripPayment,1}:
 TripPayment(1, "2018-12-01 00:28:22", "2018-12-01 00:44:07", 2, 2.5, 12.0, 0.5, 0.5, 3.95, 0.0, 0.3, 17.25)
 TripPayment(1, "2018-12-01 00:52:29", "2018-12-01 01:11:37", 3, 2.3, 13.0, 0.5, 0.5, 2.85, 0.0, 0.3, 17.15)
 TripPayment(2, "2018-12-01 00:12:52", "2018-12-01 00:36:23", 1, 0.0, 2.5, 0.5, 0.5, 0.0, 0.0, 0.3, 3.8)
 ⋮
=#

# find mean of fare_amount field

#=
julia> mean(r.fare_amount for r in records)
11.985990599999994
=#

# how much time does it take?

#=
julia> @btime mean(r.fare_amount for r in $records);
  639.603 μs (1 allocation: 16 bytes)
=#

# what if we have the fare_amount data in an array?
fare_amounts = [r.fare_amount for r in records];

#=
julia> @btime mean(fare_amounts)
  27.090 μs (1 allocation: 16 bytes)
=#

# how much faster?
#=
julia> 640 / 27
23.703703703703702
=#
