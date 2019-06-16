# Motivation

Similar object structures
```
struct IntVector
    array::Vector{Int}
end

struct FloatVector
    array::Vector{Float64}
end
```

Functions are same as well
```
# Functions for IntVector
Base.length(v::IntVector) = length(v.array)
Base.sum(v::IntVector) = sum(v.array)
Base.maximum(v::IntVector) = maximum(v.array)

# Functions for FloatVector
Base.length(v::FloatVector) = length(v.array)
Base.sum(v::FloatVector) = sum(v.array)
Base.maximum(v::FloatVector) = maximum(v.array)
```