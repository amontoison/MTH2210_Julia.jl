using MTH2210, LinearAlgebra, UnicodePlots, Statistics, Test

# Script vérifiant les algorithmes d'interpolation
include("analyse_interpolation.jl")

# Script vérifiant les algorithmes de résolution d'équations non-linéaires
include("analyse_conv_nl.jl")

# Script vérifiant les algorithmes de résolution d'équations différentielles partielles
include("analyse_conv_edo.jl")
