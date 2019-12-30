abstract type Vertebrate end
abstract type Mammal <: Vertebrate end
abstract type Reptile <: Vertebrate end

struct 🐱 <: Mammal 
    name
end

struct 🐶 <: Mammal
    name
end

struct 🐊 <: Reptile 
    name
end

Base.show(io::IO, cat::🐱) = print(io, "🐱 ", cat.name)
Base.show(io::IO, dog::🐶) = print(io, "🐶 ", dog.name)
Base.show(io::IO, croc::🐊) = print(io, "🐊 ", croc.name)

# adopt new pet
function adopt(m::Mammal)
    println(m, " is now adopted.")
    return m
end

# quick test about Liskov substitution principle

adopt(🐱("Felix"));
adopt(🐶("Clifford"));
#=
julia> adopt(🐱("Felix"))
"🐱 Felix is now adopted."

julia> adopt(🐶("Clifford"))
"🐶 Clifford is now adopted."
=#

adopt(🐊("Solomon"));
#=
julia> adopt(🐊("Solomon"))
ERROR: MethodError: no method matching adopt(::🐊)
Closest candidates are:
  adopt(::Mammal) at REPL[9]:2
=#

# Covariant?  Does 🐱 <: Mammal imply Array{🐱} <: Array{Mammal}?
adopt(ms::Array{Mammal,1}) = "adopted " * string(ms)

#=
julia> adopt([🐱("Felix"), 🐱("Garfield")])
ERROR: MethodError: no method matching adopt(::Array{🐱,1})
Closest candidates are:
  adopt(::Array{Mammal,1}) at REPL[48]:1
  adopt(::Mammal) at REPL[33]:3
=#

adopt(Mammal[🐱("Felix"), 🐱("Garfield")])
#=
julia> adopt(Mammal[🐱("Felix"), 🐱("Garfield")])
"adopted Mammal[🐱 Felix, 🐱 Garfield]"
=#


# The answer is no.  
# But this this works because an Array{Mammal} was passed.
adopt([🐱("Felix"), 🐶("Clifford")])
#=
julia> adopt([🐱("Felix"), 🐶("Clifford")])
"accepted Mammal[🐱 Felix, 🐶 Clifford]"
=#

# That's because Array{Mammal} is an array of pointers since
# Mammal isn't concrete.  

# What we should have done?

# homongeneous array of objects with the same concrete type
adopt(ms::Array{T,1}) where {T <: Mammal} = "accepted same kind:" * string(ms)

methods(adopt)
#=
julia> methods(adopt)
# 3 methods for generic function "adopt":
[1] adopt(ms::Array{Mammal,1}) in Main at REPL[22]:1
[2] adopt(m::Mammal) in Main at REPL[16]:2
[3] adopt(ms::Array{T,1}) where T<:Mammal in Main at REPL[26]:1
=#

adopt([🐱("Felix"), 🐱("Garfield")])
adopt([🐶("Clifford"), 🐶("Astro")])
adopt([🐱("Felix"), 🐶("Clifford")])

#=
julia> adopt([🐱("Felix"), 🐱("Garfield")])
"accepted 🐱[🐱 Felix, 🐱 Garfield]"

julia> adopt([🐶 ("Clifford"), 🐶 ("Astro")])
"accepted 🐶 [🐶  Clifford, 🐶  Astro]"

julia> adopt([🐱("Felix"), 🐶 ("Clifford")])
"accepted Mammal[🐱 Felix, 🐶  Clifford]"
=#

# This is great because the functional behavior of adoption 
# may depend on the kind of pet being adopted.

# ------------------------------------------------------
# Method arguments

friend(m::Mammal, f::Mammal) = "$m and $f become friends."

#=
julia> Tuple{🐱,🐱} <: Tuple{Mammal,Mammal}
true

julia> Tuple{🐱,🐶} <: Tuple{Mammal,Mammal}
true

julia> Tuple{🐶,🐱} <: Tuple{Mammal,Mammal}
true

julia> Tuple{🐶,🐶} <: Tuple{Mammal,Mammal}
true
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

female_dogs = [🐶("Pinky"), 🐶("Pinny"), 🐶("Moonie")]
female_cats = [🐱("Minnie"), 🐱("Queenie"), 🐱("Kittie")]

select(::Type{🐶}) = rand(female_dogs)
select(::Type{🐱}) = rand(female_cats)

# Function: Mammal -> Union{🐶,🐱}
match(m::Mammal) = select(typeof(m))

# It's ok to kiss mammals :-)
kiss(m::Mammal) = "$m kissed!"

# Meet a partner
function meet_partner(finder::Function, self::Mammal) 
    partner = finder(self)
    kiss(partner)
end

meet_partner(match, 🐱("Felix"))
#=
julia> meet_partner(match, 🐱("Felix"))
"🐱 Minnie kissed!"
=#

# How about Mammal -> Vertebrate?
neighbor(m::Mammal) = 🐊("Solomon")

meet_partner(neighbor, 🐱("Felix"))
#=
julia> meet_partner(neighbor, 🐱("Felix"))
ERROR: MethodError: no method matching excite(::🐊)
Closest candidates are:
  excite(::Mammal) at REPL[28]:2
=#

# So, function return type needs to be the same or subtype of the
# expected type.  Returning super-type is unsafe.

# What about function arguments?

# Function: 🐱 -> Mammal
buddy(cat::🐱) = rand([🐶("Astro"), 🐶("Goofy"), 🐱("Lucifer")])

meet_partner(buddy, 🐱("Felix"))
meet_partner(buddy, 🐶("Chef"))
#=
julia> meet_partner(buddy, 🐱("Felix"))
"🐱 Lucifer kissed!"

julia> meet_partner(buddy, 🐶("Chef"))
ERROR: MethodError: no method matching buddy(::🐶)
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

# Create a callable struct that takes Vertebrate and returns 🐱
kissy_match(v::Vertebrate) = 🐱("Kissy")
best_cat_matcher = TypedFunction1{Vertebrate,🐱}(kissy_match)

# Now we can pass this typed matcher
meet_partner(best_cat_matcher, 🐶("Goofy"))

# Can we make a mistsake?  Let's try a 🐱 -> 🐱.
cat_cat_match(cat::🐱) = 🐱("Brownie")
brownie_matcher = TypedFunction1{🐱,🐱}(cat_cat_match)

meet_partner(brownie_matcher, 🐶("Goofy"))
#=
julia> meet_partner(brownie_matcher, 🐶("Goofy"))
ERROR: MethodError: no method matching meet_partner(::TypedFunction1{🐱,🐱}, ::🐶)
=#

# Cool, so we're completely type-safe with function arguments.

# Perhaps the syntax can be improved with metaprogramming? e.g.
# @tf F = Mammal ▶ Mammal function meet_partner(finder::F, self::Mammal)
#     partner = finder(self)
#     excite(partner)
# end
