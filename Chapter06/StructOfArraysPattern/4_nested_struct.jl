# What do we do if the struct has a nested structure?

using BenchmarkTools, CSV, Statistics
using StructArrays

struct Fare
    fare_amount::Float64
    extra::Float64
    mta_tax::Float64
    tip_amount::Float64
    tolls_amount::Float64
    improvement_surcharge::Float64
    total_amount::Float64
end

struct TripPayment
    vendor_id::Int
    tpep_pickup_datetime::String
    tpep_dropoff_datetime::String
    passenger_count::Int
    trip_distance::Float64
    fare::Fare
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
                                 Fare(row.fare_amount,
                                      row.extra,
                                      row.mta_tax,
                                      row.tip_amount,
                                      row.tolls_amount,
                                      row.improvement_surcharge,
                                      row.total_amount))
    end
    return records
end

records = read_trip_payment_file("yellow_tripdata_2018-12_100k.csv");
#=
julia> records = read_trip_payment_file("yellow_tripdata_2018-12_100k.csv");

julia> records[1]
TripPayment(1, "2018-12-01 00:28:22", "2018-12-01 00:44:07", 2, 2.5, Fare(12.0, 0.5, 0.5, 3.95, 0.0, 0.3, 17.25))
=#

# Doesn't work if we play the same trick as before
#=
julia> sa = StructArray(records);

julia> sa.fare.fare_amount
ERROR: type Array has no field fare_amount
=#

# How?
#=
julia> sa = StructArray(records, unwrap = t -> t <: Fare);

julia> sa.fare.fare_amount
100000-element Array{Float64,1}:
 12.0
 13.0
  2.5
 12.5
 45.0
 50.5
=#

# It has good performance as expected
#=
julia> @btime mean(sa.fare.fare_amount)
  27.198 μs (1 allocation: 16 bytes)
=#

