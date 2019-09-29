#=
julia> match(r"\.com$", "google.com") |> typeof
RegexMatch

julia> match(r"\.com$", "w3.org") |> typeof
Nothing
=#