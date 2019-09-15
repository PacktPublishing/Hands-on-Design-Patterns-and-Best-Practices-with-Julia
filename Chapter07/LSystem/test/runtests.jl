using LSystem
using Test
using Lazy

@testset "LSystem.jl" begin

# Algae

algae_model = @lsys begin
    axiom : A
    rule  : A → AB
    rule  : B → A
end

@test (@> algae_model LState next(0) result) == "A"
@test (@> algae_model LState next(1) result) == "AB"
@test (@> algae_model LState next(2) result) == "ABA"
@test (@> algae_model LState next(3) result) == "ABAAB"

end
