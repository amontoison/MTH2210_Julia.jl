module MTH2210_Julia

using LinearAlgebra
using Printf
using SparseArrays
using Statistics

include("lagrange.jl")
include("splinec.jl")

export lagrange , splinec , divided_difference

include("bissec.jl")
include("secante.jl")
include("newton1D.jl")
include("newtonNDder.jl")
include("newtonND.jl")
include("ptfixes.jl")

export bissec , secante , newton1D , newtonNDder , newtonND , ptfixes

include("euler.jl")
include("eulermod.jl")
include("ptmilieu.jl")
include("rk4.jl")

export euler , eulermod , ptmilieu , rk4

end
