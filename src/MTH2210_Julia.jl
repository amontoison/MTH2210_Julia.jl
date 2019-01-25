module MTH2210_Julia

using LinearAlgebra
using Pkg
using Printf
using SparseArrays
using Statistics

include("MTH2210_setup.jl")

export MTH2210_setup

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
