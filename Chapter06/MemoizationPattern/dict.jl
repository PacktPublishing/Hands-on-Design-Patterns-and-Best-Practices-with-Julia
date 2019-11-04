function test_dict_key_change()

    # create a Dict with a single entry keyed by `x`
    d = Dict()
    x = []
    d[x] = 1

    # push a number to the `x` array and test if the key is still found in `d`
    found = Bool[]
    for i in 1:100
        push!(x, i)
        push!(found, haskey(d, x))
    end

    println(sum(found), " out of 100 tests are found")
end
