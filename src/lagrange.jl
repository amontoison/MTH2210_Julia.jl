"""
Résolution dun système non-linéaire de forme ``F(r)=0`` avec la méthode
de Newton:

``\\Delta x = J_F^{-1}(x_n) F(x_n)
\\\\ x_{n+1} = x_n + \\Delta x ``

# Syntaxe
```julia
Lx = lagrange(xi , yi , x)
```

# Entrée
    1.  xi         	-   Abscisses des points d'interpolation
    2.  yi        	-   Ordonnées des points d'interpolation
    3.  x          	-   Points où le polynôme d'interpolation est évalué

# Sortie
    1.  Lx     	 	-   Valeur du polynôme aux points x

# Exemples d'appel
```julia
function my_sys_nl(x)
	F = zeros(eltype(x),length(x))
	F[1] = x[1]^2 + x[2]^2 - 1
	F[2] = -x[1]^2 + x[2]
	return F
end
function my_sys_nl_jac(x)
	jac = zeros(eltype(x),length(x),length(x))
	jac[1,1] = 2*x[1]
	jac[1,2] = 2*x[2]
	jac[2,1] = -2*x[1]
	jac[2,2] = 1
	return jac
end
(approx , err_abs) = newtonNDder(my_sys_nl , my_sys_nl_jac , [1.,1.] , 20 , 1e-9)
```
"""
function lagrange(xi::AbstractArray{T,1} , yi::AbstractArray{T,1} ,
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
    Lx  =   Array{T,1}(undef,length(x))
    for t=1:length(x)
        test = (x[t] .== xi)
        if any(test)
            temp = yi[test]
            Lx[t] = temp[1]
        else
            vec_diff = x[t] .- xi
            ratio    = w ./ vec_diff
            Lx[t]    = sum(ratio .* yi) / sum(ratio)
        end
    end

    return Lx
end
