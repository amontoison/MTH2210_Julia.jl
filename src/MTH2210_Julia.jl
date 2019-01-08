module MTH2210_Julia

include("newton1D.jl")

export newton1D

include("euler.jl")
include("eulermod.jl")
include("ptmilieu.jl")
include("rk4.jl")

export euler,eulermod,ptmilieu,rk4

end
