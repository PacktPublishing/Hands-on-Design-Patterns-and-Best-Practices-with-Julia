# introducing the matchin function

match(r"\.com$", "google.com") |> typeof
match(r"\.com$", "w3.org") |> typeof
#=
julia> match(r"\.com$", "google.com") |> typeof
RegexMatch

julia> match(r"\.com$", "w3.org") |> typeof
Nothing
=#

# multiple matches scenario
url = "http://google.com"
if match(r"\.com$", url) !== nothing
    # do something about .com sites
else if match(r"\.org$", url) !== nothing
    # do something about .org sites
else 
    # do something different
end

# hypothetically, what would we do if `match` uses exception instead?
url = "http://google.com"
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
