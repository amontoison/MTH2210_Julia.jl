module MTH2210_Julia

using LinearAlgebra
using Statistics
using Printf

include("bissec.jl")
include("secante.jl")
include("newton1D.jl")

export bissec , secante , newton1D

include("euler.jl")
include("eulermod.jl")
include("ptmilieu.jl")
include("rk4.jl")

export euler , eulermod , ptmilieu , rk4

end
