# Vehicle interface and FighterJet implementation

using Vehicle, FighterJets

fj = FighterJet(false, 0, (0,0))
go!(fj, :mars)

# julia> fj = FighterJet(false, 0, (0,0))
# FighterJet(false, 0.0, (0.0, 0.0))

# julia> go!(fj, :mars)
# Powered on: FighterJet(true, 0.0, (0.0, 0.0))
# Changed direction to 0.52: FighterJet(true, 0.52, (0.0, 0.0))
# Moved (867.82,496.88): FighterJet(true, 0.52, (867.82, 496.88))
# Powered off: FighterJet(false, 0.52, (867.82, 496.88))