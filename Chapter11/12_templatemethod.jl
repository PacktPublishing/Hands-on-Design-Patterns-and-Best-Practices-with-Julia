#=
Template Method allows an algorithm to be built from different parts
where subclasses can provide implementations without changing the
structure of the algorithm.
=#

# Julia's first class functions can be used for that purpose.
module MLPipeline

using GLM, DataFrames, LinearAlgebra

"""
Run machine learning pipeline
"""
function run(data::DataFrame, response::Symbol, predictors::Vector{Symbol})
    train, test = split_data(data, 0.7)
    model = fit(train, response, predictors)
    validate(test, model, response)
end

"""
Split data randomly and return a tuple of data frames for training and testing
respectively.  Specify `keep` as a number between 0 and 1.0 for the percentage
of records kept for testing. 
"""
split_data(df::DataFrame, keep::Float64) = let b = rand(size(df,1)) .< keep
    (df[b, :], df[.!b, :])
end

"""
Return a model that can be used for predicting the `response` variable
from the `predictors` variables.  
"""
function fit(df::DataFrame, response::Symbol, predictors::Vector{Symbol})
    formula = Term(response) ~ +(Term.(predictors)...)
    return lm(formula, df)
end

"""
Predict response variable using the model and validate accuracy of model.
"""
function validate(df, model, response)
    yhat = predict(model, df)
    y = df[:, response]
    return (result = [y yhat], rmse = rmse(yhat .- y))
end

"Root mean square error."
rmse(ys) = norm(ys) / sqrt(length(ys))

"""
Run machine learning pipeline (template version w/ keyword args)
"""
function run2(data::DataFrame, response::Symbol, predictors::Vector{Symbol};
            fit = fit, split_data = split_data, validate = validate)
    train, test = split_data(data, 0.7)
    model = fit(train, response, predictors)
    validate(test, model, response)
end

end #module

using RDatasets, GLM
using .MLPipeline

# Using original template
boston = dataset("MASS", "Boston");
result, rmse = MLPipeline.run(boston, :MedV, [:Rm, :Tax, :Crim]);
println(rmse)

# Custom fitting function
function fit_glm(df::DataFrame, response::Symbol, predictors::Vector{Symbol})
    formula = Term(response) ~ +(Term.(predictors)...)
    return glm(formula, df, Normal(), IdentityLink())
end

result, rmse = MLPipeline.run2(
    boston, :MedV, [:Rm, :Tax, :Crim],
    fit = fit_glm);

println(rmse)
