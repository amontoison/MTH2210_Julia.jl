module MTH2210_Julia

using LinearAlgebra
using Statistics
using Printf

include("newton1D.jl")

export newton1D

include("euler.jl")
include("eulermod.jl")
include("ptmilieu.jl")
include("rk4.jl")

export euler,eulermod,ptmilieu,rk4

end
