using DelegationPattern
using Test

@testset "DelegationPattern.jl" begin
    include("funcs.jl")

    # Note: these functions just output test results to console
    @test test_account() == nothing
    @test test_savings_account() == nothing
    @test test_savings_account2() == nothing
end
