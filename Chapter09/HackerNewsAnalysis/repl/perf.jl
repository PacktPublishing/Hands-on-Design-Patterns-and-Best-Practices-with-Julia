# Broadcasting over pipes

add1(x) = x + 1
mul2(x) = x * 2
add1mul2v(xs) = xs |> add1v |> mul2v

add1v(x) = x .+ 1
mul2v(x) = x .* 2
add1mul2(xs) = xs .|> add1 .|> mul2

xs = collect(1:10000);
@btime add1mul2v($xs);
@btime add1mul2($xs);

#=
julia> @btime add1mul2v($xs);
  16.128 μs (4 allocations: 156.41 KiB)

julia> @btime add1mul2($xs);
  8.417 μs (2 allocations: 78.20 KiB)
=#