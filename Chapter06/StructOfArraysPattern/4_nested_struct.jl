# What do we do if the struct has a nested structure?

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
    vendor_id::String
    tpep_pickup_datetime::String
    tpep_dropoff_datetime::String
    passenger_count::Int
    trip_distance::Float64
    fare::Fare
end

function parse_tripdata_file(filename)
    records = Vector{TripPayment}()
    open(filename) do f
        readline(f); readline(f); #skip header/blank lines
        while !eof(f)
            line = readline(f) 
            fields = split(line, ",")
            fare = Fare(
                parse(Float64, fields[11]),
                parse(Float64, fields[12]),
                parse(Float64, fields[13]),
                parse(Float64, fields[14]),
                parse(Float64, fields[15]),
                parse(Float64, fields[16]),
                parse(Float64, fields[17])
            )
            record = TripPayment(
                fields[1],
                fields[2],
                fields[3],
                parse(Int, fields[4]),
                parse(Float64, fields[5]),
                fare
            )
            push!(records, record)
        end 
    end
    return records
end

#=
julia> records = parse_tripdata_file("yellow_tripdata_2018-12_100k.csv");

julia> records[1]
TripPayment("1", "2018-12-01 00:28:22", "2018-12-01 00:44:07", 2, 2.5, Fare(12.0, 0.5, 0.5, 3.95, 0.0, 0.3, 17.25))
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

