# introducing the matchin function
#=
julia> match(r"\.com$", "google.com") |> typeof
RegexMatch

julia> match(r"\.com$", "w3.org") |> typeof
Nothing
=#

# multiple matches scenario

if match(r"\.com$", url) !== nothing
    # do something about .com sites
else if match(r"\.org$", url) !== nothing
    # do something about .org sites
else 
    # do something different
end

# hypothetically, what would we do if `match` uses exception instead?

try 
    match(r"\.com$", url)
    # do something about .com sites
catch ex1
    try
        match(r"\.org$", url)
        # do something about .org sites
    catch ex2 
        # do something different
    end
end
