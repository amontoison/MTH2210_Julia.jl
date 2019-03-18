"""
Interpolation de Lagrange

# Syntaxe
```julia
Lx = lagrange(xi , yi , x)
```

# Entrée
    1.  xi          -   (Array{Float,1}) Abscisses des points d'interpolation
    2.  yi          -   (Array{Float,1}) Ordonnées des points d'interpolation
    3.  x           -   (Array{Float,1}) Points où le polynôme d'interpolation est évalué

# Sortie
    1.  Lx          -   (Array{Float,1}) Valeur du polynôme aux points x

# Exemples d'appel
```julia
Lx = lagrange([-1.,0.,1.] , [1.,0.,1.] , LinRange(-1,1,200))
```
"""
function lagrange(xi::AbstractArray{T,1}, yi::AbstractArray{T,1},
    x::AbstractArray{T,1}) where {T<:AbstractFloat}

    N = length(xi)

    if length(yi) != N
            error("Les vecteurs xi et yi doivent avoir la meme taille")
    elseif xi == x
            println("Le polynôme d''interpolation est évalué exactement au points d''interpolation")
    end

    # Calcul des poids barycentriques
    w   =   Array{T,1}(undef,N)
    ind =   1:1:N

    for t=1:N
        w[t] = 1 ./ prod(xi[ind .!= t] .- xi[t])
    end

    # Calcul de l'interpolant aux points x
    test        =   Array{Bool,1}(undef,length(xi))
    Lx          =   Array{T,1}(undef,length(x))
    vec_diff    =   Array{T,1}(undef,length(xi))
    ratio       =   Array{T,1}(undef,length(xi))

    for t=1:length(x)
        test .= (x[t] .== xi)
        if any(test)
            Lx[t] = yi[test][1]
        else
            vec_diff .= x[t] .- xi
            ratio    .= w ./ vec_diff
            Lx[t]    = sum(ratio .* yi) / sum(ratio)
        end
    end

    return Lx
end
