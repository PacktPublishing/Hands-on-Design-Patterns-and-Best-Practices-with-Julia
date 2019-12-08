# What if we turn all fields into independent arrays?

struct TripPaymentColumnarData
    vendor_id::Vector{Int}
    tpep_pickup_datetime::Vector{String}
    tpep_dropoff_datetime::Vector{String}
    passenger_count::Vector{Int}
    trip_distance::Vector{Float64}
    fare_amount::Vector{Float64}
    extra::Vector{Float64}
    mta_tax::Vector{Float64}
    tip_amount::Vector{Float64}
    tolls_amount::Vector{Float64}
    improvement_surcharge::Vector{Float64}
    total_amount::Vector{Float64}
end

# Reformat data
columar_records = TripPaymentColumnarData(
    [r.vendor_id for r in records],
    [r.tpep_pickup_datetime for r in records],
    [r.tpep_dropoff_datetime for r in records],
    [r.passenger_count for r in records],
    [r.trip_distance for r in records],
    [r.fare_amount for r in records],
    [r.extra for r in records],
    [r.mta_tax for r in records],
    [r.tip_amount for r in records],
    [r.tolls_amount for r in records],
    [r.improvement_surcharge for r in records],
    [r.total_amount for r in records]
);

@btime mean(columar_records.fare_amount);
#=
julia> @btime mean(columar_records.fare_amount);
  27.170 μs (1 allocation: 16 bytes)
=#
