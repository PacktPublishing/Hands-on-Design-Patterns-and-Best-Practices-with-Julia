# Testing from REPL

using LSystem

function generate(model::LModel, n::Integer)
    state = LState(model)
    println(state)
    for i in 1:n
        state = next(state)
        println(state)
    end
end

algae_model = @lsys begin
    axiom : A
    rule  : A → AB
    rule  : B → A
end

generate(algae_model, 4)
