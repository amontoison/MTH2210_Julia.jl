module MTH2210_Julia

using LinearAlgebra
using SparseArrays
using Statistics
using Printf

include("bissec.jl")
include("secante.jl")
include("newton1D.jl")
include("newtonNDder.jl")
include("newtonND.jl")

export bissec , secante , newton1D , newtonNDder , newtonND

include("euler.jl")
include("eulermod.jl")
include("ptmilieu.jl")
include("rk4.jl")

export euler , eulermod , ptmilieu , rk4

end
