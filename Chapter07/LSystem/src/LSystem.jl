module LSystem

export @lsys
export LModel, add_rule!
export LState, next, result

using MacroTools

# L-System model definition

"""
A L-system model is represented by an axiom called `axiom`
and a set of rewriting `rules`.
"""
struct LModel
    axiom
    rules
end

"Create a L-system model."
LModel(axiom) = LModel([axiom], Dict())

"Add rule to a model."
function add_rule!(model::LModel, left::T, right::T) where {T <: AbstractString}
    model.rules[left] = split(right, "")
    return nothing
end

"Display model nicely."
function Base.show(io::IO, model::LModel)
    println(io, "LModel:")
    println(io, "  Axiom: ", join(model.axiom))
    for k in sort(collect(keys(model.rules)))
        println(io, "  Rule:  ", k, " → ", join(model.rules[k]))
    end
end

# Tracking state of the system

"""
A L-system state contains a reference to the `model`, the 
current iteration, and the result.
"""
struct LState
    model
    current_iteration
    result
end

"Create a L-system state from a `model`."
LState(model::LModel) = LState(model, 1, model.axiom)

"Advance to the next state and returns a new LState object."
function next(state::LState)
    new_result = []
    for el in state.result
        # Look up `el` from the rules dictionary and append to `new_result`.
        # Just default to the element itself when it is not found
        next_elements = get(state.model.rules, el, el)
        append!(new_result, next_elements)
    end
    return LState(state.model, state.current_iteration + 1, new_result)
end

"Repeated next call"
next(state::LState, n) = n > 0 ? next(next(state), n-1) : state

"Compact the result suitable for display"
result(state::LState) = join(state.result)

Base.show(io::IO, s::LState) = 
    print(io, "LState(", s.current_iteration, "): ", result(s))


# DSL implementation

"""
The @lsys macro is used to construct a L-System model object [LModel](@ref).
The domain specific language requires a single axiom and a set of rewriting rules.
For example:

```
model = @lsys begin
    axiom : A
    rule  : A → AB
    rule  : B → A
end
```
"""
macro lsys(ex)
    ex = MacroTools.postwalk(walk, ex)
    push!(ex.args, :( model ))
    return ex
end

# Walk the AST tree and match expressions.
function walk(ex)
    
    match_axiom = @capture(ex, axiom : sym_)
    if match_axiom
        sym_str = String(sym)
        return :( model = LModel($sym_str) )
    end
    
    match_rule = @capture(ex, rule : original_ → replacement_)
    if match_rule
        original_str = String(original)
        replacement_str = String(replacement)
        return :(
            add_rule!(model, $original_str, $replacement_str)
        )
    end

    return ex
end

end # module
