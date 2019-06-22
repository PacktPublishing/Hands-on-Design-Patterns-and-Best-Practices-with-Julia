using HolyTraitPattern
using Test

@testset "HolyTraitPattern.jl" begin
    include("funcs.jl")
    @test trait_test_cash() 
    @test trait_test_stock()
    @test trait_test_residence()
    @test trait_test_bond()
    @test trait_test_book()
end
