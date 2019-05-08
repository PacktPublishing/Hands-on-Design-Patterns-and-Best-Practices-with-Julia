# Parametric type examples

# regular arrays are parametric types
v = Float64[1, 2, 3, 4, 5]

# julia> v = Float64[1, 2, 3, 4, 5]
# 5-element Array{Float64,1}:
#  1.0
#  2.0
#  3.0
#  4.0
#  5.0

# see the type 
typeof(v)

# julia> typeof(v)
# Array{Float64,1}

struct NamedVector{T} 
    data::Vector{T}
    name::String

    NamedVector(a::AbstractVector{T}, name::String) where {T} = new{T}(a, name)
end
data(nv::NamedVector) = nv.data
name(nv::NamedVector) = nv.name

# create my named Vector
nv = NamedVector(v, "FiveThings")

# julia> nv = NamedVector(v, "FiveThings")
# NamedVector{Float64}([1.0, 2.0, 3.0, 4.0, 5.0], "FiveThings")

data(nv)
name(nv)

# -------------- multiple parameters of same type ------------------

# Exponent table
struct ExpTable{T <: Real} 
    source::Vector{T}      # source data: x
    exponents::Vector{T}   # exponents data: exp(x)
    ExpTable(v::Vector{T}) where {T} = new{T}(v, exp.(v))
end

Base.length(et::ExpTable) = length(et.source)
Base.getindex(et::ExpTable, i) = Pair(et.source[i], et.exponents[i]) 

et = ExpTable(rand(3))
et[1]

# -------------- multiple parameters of different types ---------------

struct PrecisionDiff{T <: Real, S <: Real}
    source::Vector{T}
    converted::Vector{S}
    PrecisionDiff(v::Vector{T}, S) where {T} = new{T,S}(v, convert.(S, v))
end

Base.length(pd::PrecisionDiff) = length(pd.source)
Base.getindex(pd::PrecisionDiff, i) = (
    orig = pd.source[i], 
    converted = pd.converted[i], 
    diff = pd.converted[i] - pd.source[i])

pd = PrecisionDiff(rand(3), Float16)
pd[1]
pd[2]