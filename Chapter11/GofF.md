# Gang of Four design patterns

## References
https://howtodoinjava.com/design-patterns/creational/singleton-design-pattern-in-java/


## Creational

Singleton ==> YES
- Use `const` to define a single instance of a `struct`
- Enforceable?  check.
- Lazy initialization
```
const singleton = Car()
```

Builder ==> YES
- A complex object is built in multiple steps and the builder is the SME
- Chaining example:
```
using Lazy: @>
car = @> make_car() make_wheels(4) paint(:blue)
```

Factory
- Decouple creation of objects from implementation
- Caller doesn't need to know the factory's dependencies
- Eg. FileIO?
- Eg. Optim.jl? choosing whichever solver.

AbstractFactory
- another abstraction on top of Factory

Prototype
- Prepare an object and clone it to create new ones rather than doing it from fresh
- Performance improvement since hard work can be done upfront
- copy!

## Behavioral

Chaining of Responsibility
- HTTP layers
- Lazy @> 
- Flux Chain?

Command
- Java: adding new command classes to handle new commands
- Almost nothing to worry about in Julia since a function just need to be defined

Iterator
- Julia's iterator interface

Mediator
- Allows many objects to communicate with each other via a single mediator object
- Julia Channels?

Memento
- Remember states between changes to allow restoring to a previous state
- Julia?  design immutable objects; define setproperty and other mutating functions

Observer
- easy to implement with a list of callbacks

State
- state machine pattern e.g. if TV is currently on, you can only turn it off.
- DSL?

Strategy
- choosing algo at run time e.g. sort choosing the optimal version based on stats
- open/closed principle - closed for modification but open for extension

Template method
- predfined set of steps
- e.g. ML pipeline: clean, impute, standardize, train, predict

Visitor
- ability to add new behavior to existing class without changing its structure
- e.g. a `visit` function is called by an object to obtain functionality from a visitor object
- not sure how this is done in julia

## Structural

Adapter
- allows two incompatible devices to connect with each other
- thought: create a Base package that encapsulate generic interface

Bridge
- separate interface and implementation from an object 
- so both can evolve without affecting each other

Composite
- over inheritance

Decorator
- add function without affecting existing class
- this is native function in Julia

Facade
- define high level interfaces that makes it easier to use
- Plots.jl?

Flyweight
- sharing of objects to support large number of fine-grained objects
- e.g. java.lang.String are interned

Proxy
- control access e.g. security


# Thoughts

Open/Closed Principle
- by design, Julia programs already satisfies this principle
- why?  Consider Base.length function, you can extend the generic function for your own struct.

