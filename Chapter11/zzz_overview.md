# Creational (5, done)

Factory and AbstractFactory: factory.jl

Singleton - singleton.jl

Prototype - use copy function.  Discuss the case of shallow vs deep copy.  

Builder - builder.jl

# Behavioral (11)

Chain of Responsibility: chain.jl.  Similar functions in mux/http package.

Command: holy traits

Interpreter: using macro to represent DSL

Iterator: 6_iterator.jl.  Julia already has a well-established interface.

Mediator: OK to implement the same in Julia.

Memento: 8_memento.jl blog post use case.

Observer: 9_observer.jl account changes.

State: 10_state.jl TCPConnection.  Use multiple dispatch.

Strategy: 2_strategy.jl

Template Method: 11_templatemethod.jl - ML pipeline

Visitor: "It should be possible to define a new operation for (some) classes of an object structure without changing the classes."  It is already supported by default and used regularly via multiple dispatch.

# Structural (7)

Adapter - 12_adapter.jl.  Linked list being used as an array.

Bridge - use interface/traits

Composite - 13_composite.jl  portfolio/stock composites

Decorator - use composition/delegation.  

Facade - provide a user-friendly facade package that delegate work to subsystems (dependent packages).  Plots and StatPlots are good examples.

Flyweight - sharing of objects to support large number of fine-grained objects e.g. InternedStrings package.

Proxy - control access

# Notes

Decorator vs. Proxy 
- https://javadevcentral.com/proxy-pattern-vs-decorator-pattern
- https://stackoverflow.com/questions/18618779/differences-between-proxy-and-decorator-pattern


