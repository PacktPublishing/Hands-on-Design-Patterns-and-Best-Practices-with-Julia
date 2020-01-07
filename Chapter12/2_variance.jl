abstract type Vertebrate end
abstract type Mammal <: Vertebrate end
abstract type Reptile <: Vertebrate end

struct Cat <: Mammal 
    name
end

struct Dog <: Mammal
    name
end

struct Crocodile <: Reptile 
    name
end

Base.show(io::IO, cat::Cat) = print(io, "Cat ", cat.name)
Base.show(io::IO, dog::Dog) = print(io, "Dog ", dog.name)
Base.show(io::IO, croc::Crocodile) = print(io, "Crocodile ", croc.name)

# adopt new pet
function adopt(m::Mammal)
    println(m, " is now adopted.")
    return m
end

# quick test about Liskov substitution principle

adopt(Cat("Felix"));
adopt(Dog("Clifford"));
#=
julia> adopt(Cat("Felix"))
"Cat Felix is now adopted."

julia> adopt(Dog("Clifford"))
"Dog Clifford is now adopted."
=#

adopt(Crocodile("Solomon"));
#=
julia> adopt(Crocodile("Solomon"))
ERROR: MethodError: no method matching adopt(::Crocodile)
Closest candidates are:
  adopt(::Mammal) at REPL[9]:2
=#

# Covariant?  Does Cat <: Mammal imply Array{Cat} <: Array{Mammal}?
adopt(ms::Array{Mammal,1}) = "adopted " * string(ms)

adopt([Cat("Felix"), Cat("Garfield")])
#=
julia> adopt([Cat("Felix"), Cat("Garfield")])
ERROR: MethodError: no method matching adopt(::Array{Cat,1})
Closest candidates are:
  adopt(::Array{Mammal,1}) at REPL[48]:1
  adopt(::Mammal) at REPL[33]:3
=#

adopt(Mammal[Cat("Felix"), Cat("Garfield")])
#=
julia> adopt(Mammal[Cat("Felix"), Cat("Garfield")])
"adopted Mammal[Cat Felix, Cat Garfield]"
=#


# The answer is no.  
# But this this works because an Array{Mammal} was passed.
adopt([Cat("Felix"), Dog("Clifford")])
#=
julia> adopt([Cat("Felix"), Dog("Clifford")])
"accepted Mammal[Cat Felix, Dog Clifford]"
=#

# That's because Array{Mammal} is an array of pointers since
# Mammal isn't concrete.  

# What we should have done?

# homongeneous array of objects with the same concrete type
function adopt(ms::Array{T,1}) where {T <: Mammal}
    return "accepted same kind:" * string(ms)
end
#=
julia> methods(adopt)
# 3 methods for generic function "adopt":
[1] adopt(ms::Array{Mammal,1}) in Main at REPL[22]:1
[2] adopt(m::Mammal) in Main at REPL[16]:2
[3] adopt(ms::Array{T,1}) where T<:Mammal in Main at REPL[26]:1
=#

adopt([Cat("Felix"), Cat("Garfield")])
adopt([Dog("Clifford"), Dog("Astro")])
adopt([Cat("Felix"), Dog("Clifford")])

#=
julia> adopt([Cat("Felix"), Cat("Garfield")])
"accepted Cat[Cat Felix, Cat Garfield]"

julia> adopt([Dog ("Clifford"), Dog ("Astro")])
"accepted Dog [Dog  Clifford, Dog  Astro]"

julia> adopt([Cat("Felix"), Dog ("Clifford")])
"accepted Mammal[Cat Felix, Dog  Clifford]"
=#

# This is great because the functional behavior of adoption 
# may depend on the kind of pet being adopted.

# ------------------------------------------------------
# Method arguments

friend(m::Mammal, f::Mammal) = "$m and $f become friends."

Tuple{Cat,Cat} <: Tuple{Mammal,Mammal}
Tuple{Cat,Dog} <: Tuple{Mammal,Mammal}
Tuple{Dog,Cat} <: Tuple{Mammal,Mammal}
Tuple{Dog,Dog} <: Tuple{Mammal,Mammal}
#=
julia> Tuple{Cat,Cat} <: Tuple{Mammal,Mammal}
true

julia> Tuple{Cat,Dog} <: Tuple{Mammal,Mammal}
true

julia> Tuple{Dog,Cat} <: Tuple{Mammal,Mammal}
true

julia> Tuple{Dog,Dog} <: Tuple{Mammal,Mammal}
true
=#

Tuple{Cat,Crocodile} <: Tuple{Mammal,Mammal}
#=
julia> Tuple{Cat,Crocodile} <: Tuple{Mammal,Mammal}
false
=#

# ------------------------------------------------------
# Function type

#=
julia> all(
all(x::Tuple{Bool,Bool,Bool}) in Base at tuple.jl:390
all(x::Tuple{Bool,Bool}) in Base at tuple.jl:389
all(x::Tuple{Bool}) in Base at tuple.jl:388
all(x::Tuple{}) in Base at tuple.jl:387
all(B::BitArray) in Base at bitarray.jl:1627
all(a::AbstractArray; dims) in Base at reducedim.jl:664
all(f::Function, a::AbstractArray; dims) in Base at reducedim.jl:665
all(itr) in Base at reduce.jl:642
all(f, itr) in Base at reduce.jl:724
=#

all(isodd, [1, 2, 3, 4, 5])
#=
julia> all(isodd, [1, 2, 3, 4, 5])
false
=#

typeof(isodd) <: Function
#=
julia> typeof(isodd) <: Function
true
=#

typeof(isodd)
typeof(isodd) |> supertype
isabstracttype(Function)
#=
julia> typeof(isodd)
typeof(isodd)

julia> typeof(isodd) |> supertype
Function

julia> isabstracttype(Function)
true
=#

typeof(println) <: Function
all(println, [1, 2, 3, 4, 5])
#=
julia> typeof(println) <: Function
true

julia> all(println, [1, 2, 3, 4, 5])
1
ERROR: TypeError: non-boolean (Nothing) used in boolean context
=#

# specific function types
const SignFunctions = Union{typeof(isodd),typeof(iseven)};
myall(f::SignFunctions, a::AbstractArray) = all(f, a);
myall(isodd, [1, 3, 5])
myall(iseven, [2, 4, 6])
myall(println, [2, 4, 6])
#=
julia> const SignFunctions = Union{typeof(isodd),typeof(iseven)};

julia> myall(f::SignFunctions, a::AbstractArray) = all(f, a);

julia> myall(isodd, [1, 3, 5])
true

julia> myall(iseven, [2, 4, 6])
true

julia> myall(println, [2, 4, 6])
ERROR: MethodError: no method matching myall(::typeof(println), ::Array{Int64,1})
=#

# ------------------------------------------------------
# Function subtyping

female_dogs = [Dog("Pinky"), Dog("Pinny"), Dog("Moonie")]
female_cats = [Cat("Minnie"), Cat("Queenie"), Cat("Kittie")]

select(::Type{Dog}) = rand(female_dogs)
select(::Type{Cat}) = rand(female_cats)

# Function: Mammal -> Union{Dog,Cat}
match(m::Mammal) = select(typeof(m))

match(Dog("Astro"))
match(Cat("Garfield"))
#=
julia> match(Dog("Astro"))
Dog Moonie

julia> match(Cat("Garfield"))
Cat Kittie
=#

# It's ok to kiss mammals :-)
kiss(m::Mammal) = "$m kissed!"

# Meet a partner
function meet_partner(finder::Function, self::Mammal) 
    partner = finder(self)
    kiss(partner)
end

meet_partner(match, Cat("Felix"))
#=
julia> meet_partner(match, Cat("Felix"))
"Cat Kittie kissed!"
=#

# How about Mammal -> Vertebrate?
neighbor(m::Mammal) = Crocodile("Solomon")

meet_partner(neighbor, Cat("Felix"))
#=
julia> meet_partner(neighbor, Cat("Felix"))
ERROR: MethodError: no method matching excite(::Crocodile)
Closest candidates are:
  excite(::Mammal) at REPL[28]:2
=#

# So, function return type needs to be the same or subtype of the
# expected type.  Returning super-type is unsafe.

# What about function arguments?

# Function: Cat -> Mammal
buddy(cat::Cat) = rand([Dog("Astro"), Dog("Goofy"), Cat("Lucifer")])

meet_partner(buddy, Cat("Felix"))
meet_partner(buddy, Dog("Chef"))
#=
julia> meet_partner(buddy, Cat("Felix"))
"Cat Lucifer kissed!"

julia> meet_partner(buddy, Dog("Chef"))
ERROR: MethodError: no method matching buddy(::Dog)
=#

# "Be liberal in what you accept and conservative in what you produce."

# ----------------------------------------------------------------
# Revisting Base.all function.

# Wrap a function in a parametric type that captures the argument types and return type
struct PredicateFunction{T,S}
    f::Function
end

# Call the underlying function
(pred::PredicateFunction{T,S})(x::T; kwargs...) where {T,S} = 
    pred.f(x; kwargs...)

# quick experiment
PredicateFunction{Number,Bool}(iseven)(1)
PredicateFunction{Number,Bool}(iseven)(2)
#=
julia> PredicateFunction{Number,Bool}(iseven)(1)
false

julia> PredicateFunction{Number,Bool}(iseven)(2)
true
=#

# our safe version of `all`
function safe_all(pred::PredicateFunction{T,S}, a::AbstractArray) where 
        {T <: Any, S <: Bool}
    all(pred, a)
end

#=
julia> safe_all(PredicateFunction{Number,Bool}(iseven), [1,2,3])
false

julia> safe_all(PredicateFunction{Number,Bool}(iseven), [2,4,6])
true
=#

# ----------------------------------------------------------------
# OPTIONAL.  Animal kingdom example continues.

# Technically, what does `meet_partner` need?

# The signature doesn't tell us much.
methods(meet_partner)
#=
julia> methods(meet_partner)
# 1 method for generic function "meet_partner":
[1] meet_partner(finder::Function, self::Mammal) in Main at REPL[29]:3
=#

# But, we know that needs a function of this type: Mammal -> Mammal
# Given that arguments are contravariant and return type is convariant,
# We can infer that any function with the following type would work:
# T -> S where {T >: Mammal, S <: Mammal}

# Until Julia supports typed functions, we can work around by 
# formulating as such.

# One argument with type T, having return type S.
struct TypedFunction1{T,S}
    f::Function
end

(tf::TypedFunction1{T,S})(x::T; kwargs...) where {T,S} = 
    tf.f(x; kwargs...)

# Let's redefine `meet_partner` to require that.
function meet_partner(finder::TypedFunction1{T,S}, self::Mammal) where 
        {T >: Mammal, S <: Mammal}
    partner = finder(self)
    kiss(partner)
end

# Create a callable struct that takes Vertebrate and returns Cat
kissy_match(v::Vertebrate) = Cat("Kissy")
best_cat_matcher = TypedFunction1{Vertebrate,Cat}(kissy_match)

# Now we can pass this typed matcher
meet_partner(best_cat_matcher, Dog("Goofy"))

# Can we make a mistsake?  Let's try a Cat -> Cat.
cat_cat_match(cat::Cat) = Cat("Brownie")
brownie_matcher = TypedFunction1{Cat,Cat}(cat_cat_match)

meet_partner(brownie_matcher, Dog("Goofy"))
#=
julia> meet_partner(brownie_matcher, Dog("Goofy"))
ERROR: MethodError: no method matching meet_partner(::TypedFunction1{Cat,Cat}, ::Dog)
=#

# Cool, so we're completely type-safe with function arguments.

# Perhaps the syntax can be improved with metaprogramming? e.g.
# @tf F = Mammal ▶ Mammal function meet_partner(finder::F, self::Mammal)
#     partner = finder(self)
#     excite(partner)
# end
