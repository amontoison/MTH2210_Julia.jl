"""
Interpolation par les splines cubiques:


# Syntaxe
```julia
Sx = splinec(xi , yi , x , type_f , val_f)
```

# Entrée
    1.  xi         	-   Abscisses des points d'interpolation
    2.  yi        	-   Ordonnées des points d'interpolation
    3.  x          	-   Points où la spline cubique est évaluée
    4.  type_f      -   Type de conditions frontières imposées en x_0 et x_n
    5.  val_f       -   Valeurs des conditions frontières imposées en x_0 et x_n

# Sortie
    1.  Sx     	 	-   Valeur de la spline cubique aux points x

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
Sx = splinec(my_sys_nl , my_sys_nl_jac , [1.,1.] , 20 , 1e-9)
```
"""
function splinec(xi::AbstractArray{T,1}, yi::AbstractArray{T,1} ,
        x::AbstractArray{T,1} , type_f::AbstractArray{<:Integer,1} ,
                val_f::AbstractArray{T,1}) where {T<:AbstractFloat}

    N = length(xi)

    if length(yi) != N
        error("Les vecteurs xi et yi doivent avoir la meme taille")
    elseif xi == x
        println("Le polynôme dinterpolation est évalué exactement au points d'interpolation")
    elseif sort(xi)!=xi
        error("Les abscisses ne sont pas arrangées en ordre croissant")
    elseif length(type_f) != 2
        error("Les types de conditions frontières ne sont pas dans un vecteur de dimension 2")
    elseif ~any(type_f[1].==[1,2,3,4]) || ~any(type_f[2].==[1,2,3,4])
        error("Les types de conditions frontières ne sont pas valide (entier de 1 à 4)")
    elseif length(val_f) != 2
        error("Les valeurs des conditions frontières ne sont pas dans un vecteur de dimension 2")
    end

    # Assemblage de la matrice
    h = diff(xi)
    denom = h[1:end-1] .+ h[2:end]
    diag_below = h[1:end-1] ./ denom
    diag_above = h[2:end] ./ denom
    diag_center = 2. .* ones(T,N-2)

    M = spdiagm(-1 => diag_below, 0 => diag_center , 1 => diag_above)

    println(M)

    return nothing

end
