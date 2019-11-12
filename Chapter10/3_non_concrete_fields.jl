# 1st version. No type annotations!
struct Point
    x
    y
end

# this is syntactically same as Point
struct Point2
    x::Any
    y::Any
end

# this uses concrete type
struct Point3
    x::UInt8
    y::UInt8
end

#=
julia> Point3(0x01, 0x01) |> sizeof
2

julia> Point(0x01, 0x01) |> sizeof
16

julia> Point(Int128(1), Int128(1)) |> sizeof
16
=#

# this one use concrete type as well
struct Point4
    x::Int128
    y::Int128
end

#=
julia> Point4(Int128(1), Int128(1)) |> sizeof
32
=#

#--- parametric type version

# restart REPL and define this
struct Point{T <: Real}
    x::T
    y::T
end

p = Point(0x01, 0x01)
sizeof(p)
p = Point(Int128(1), Int128(1))
sizeof(p)
#=
julia> p = Point(0x01, 0x01)
Point{UInt8}(0x01, 0x01)

julia> sizeof(p)
2

julia> p = Point(Int128(1), Int128(1))
Point{Int128}(1, 1)

julia> sizeof(p)
32
=#

#--- performance test

struct PointAny
    x::Any
    y::Any
end

using Statistics: mean

function center(points::AbstractVector{T}) where T
    return T(
        mean(p.x for p in points), 
        mean(p.y for p in points))
end

make_points(T::Type, n) = [T(rand(), rand()) for _ in 1:n]

using BenchmarkTools

points = make_points(PointAny, 100_000);
@btime center($points)

#=
julia> points = make_points(PointAny, 100_000);

julia> @btime center($points)
  5.384 ms (200007 allocations: 3.05 MiB)
PointAny(0.5008816012742725, 0.4987658522813566)
=#

points = make_points(Point, 100_000);
@btime center($points)

#=
julia> @btime center($points)
  207.027 μs (2 allocations: 32 bytes)
Point4{Float64}(0.5001556466497694, 0.4990206734988199)
=#