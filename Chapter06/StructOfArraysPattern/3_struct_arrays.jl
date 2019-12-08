# Using StructArrays.jl package

using StructArrays

sa = StructArray(records);

# We can index into the records as usual

sa[1:3]
#=
julia> sa[1:3]
3-element StructArray(::Array{String,1}, ::Array{String,1}, ::Array{String,1}, ::Array{Int64,1}, ::Array{Float64,1}, ::Array{Float64,1}, ::Array{Float64,1}, ::Array{Float64,1}, ::Array{Float64,1}, ::Array{Float64,1}, ::Array{Float64,1}, ::Array{Float64,1}) with eltype TripPayment:
 TripPayment("1", "2018-12-01 00:28:22", "2018-12-01 00:44:07", 2, 2.5, 12.0, 0.5, 0.5, 3.95, 0.0, 0.3, 17.25)
 TripPayment("1", "2018-12-01 00:52:29", "2018-12-01 01:11:37", 3, 2.3, 13.0, 0.5, 0.5, 2.85, 0.0, 0.3, 17.15)
 TripPayment("2", "2018-12-01 00:12:52", "2018-12-01 00:36:23", 1, 0.0, 2.5, 0.5, 0.5, 0.0, 0.0, 0.3, 3.8)
=#

# type of an indexed record

sa[1]
typeof(sa[1])
#=
julia> sa[1]
TripPayment(1, "2018-12-01 00:28:22", "2018-12-01 00:44:07", 2, 2.5, 12.0, 0.5, 0.5, 3.95, 0.0, 0.3, 17.25)

julia> typeof(sa[1])
TripPayment
=#

# extracting one field

sa.fare_amount
#=
julia> sa.fare_amount
100000-element Array{Float64,1}:
 12.0
 13.0
  2.5
  ⋮
=#

# How does it perform?

@btime mean(sa.fare_amount);
#=
julia> @btime mean(sa.fare_amount);
  27.175 μs (1 allocation: 16 bytes)
=#

# Note that it makes a copy of the data

Base.summarysize(records) / 1024 / 1024
Base.summarysize(sa) / 1024 / 1024 
#=
julia> Base.summarysize(records) / 1024 / 1024
15.068092346191406

julia> Base.summarysize(sa) / 1024 / 1024 
14.305671691894531
=#

# Observation: Columnar format is more memory-efficient.

records = nothing
GC.gc()
#= remove original
julia> records = nothing

julia> GC.gc()
=#
