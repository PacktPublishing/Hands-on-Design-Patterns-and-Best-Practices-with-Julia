# LSystem

This package implements a domain-specific language for [L-System](https://en.wikipedia.org/wiki/L-system).

## Installation

```
] add https://github.com/tk3369/LSystem.jl
```

## Sample Usage

Create an algae model as follows:

```
algae_model = @lsys begin
    axiom : A
    rule  : A → AB
    rule  : B → A
end
```

Start a new state by creating a `LState` object from the mode.
Then, generate the next sequence using  `next` function.

```
algae_state = LState(algae_model)
println(algae_state)
println(algae_state |> next)
println(algae_state |> next |> next)
println(algae_state |> next |> next |> next)
```