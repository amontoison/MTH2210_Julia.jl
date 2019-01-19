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

    # Vérification des arguments d'entrées

    if length(yi) != N
        error("Les vecteurs xi et yi doivent avoir la meme taille")
    elseif xi == x
        println("Le polynôme dinterpolation est évalué exactement au points d'interpolation")
    elseif sort(xi)!=xi
        error("Les abscisses ne sont pas arrangées en ordre croissant")
    elseif length(type_f) != 2
        error("Les types de conditions frontières ne sont pas dans un vecteur de dimension 2")
    elseif ~any(type_f[1].==[1,2,3,4]) | ~any(type_f[2].==[1,2,3,4])
        error("Les types de conditions frontières ne sont pas valide (entier de 1 à 4)")
    elseif length(val_f) != 2
        error("Les valeurs des conditions frontières ne sont pas dans un vecteur de dimension 2")
    end

    # Assemblage de la matrice
    h 			= 	diff(xi)
    denom 		= 	h[1:end-1] .+ h[2:end]
    diag_below  =   vcat(h[1:end-1] ./ denom , 0)
    diag_above  =   vcat(0 , h[2:end] ./ denom)
    diag_center =   vcat(0 , 2 .* ones(T,N-2) , 0)

    M = spdiagm(-1 => diag_below, 0 => diag_center , 1 => diag_above)

    # Calcul du terme de droite
    B           		=   Array{T}(undef,N)
    B[2:end-1]  	=   6 .* divided_difference(xi,yi)[1:N-2,2]

    # Imposition des conditions frontières
    if type_f[1] == 1
        M[1,1]  =   1
        B[1]    =   0
    elseif type_f[1] == 2
        M[1,1]  =   1
        B[1]    =   val_f[1]
    elseif type_f[1] == 3
        M[1,1]  =   1
        M[1,2]  =   -1
        B[1]    =   0
    elseif type_f[1] == 4
        M[1,1]  =   2
        M[1,2]  =   1
        B[1]    =   6 / h[1] * ((yi[2] - yi[1]) / h[1] - val_f[1])
    end
    if type_f[2] == 1
        M[N,N]  =   1
        B[N]    =   0
    elseif type_f[2] == 2
        M[N,N]  =   1
        B[N]    =   val_f[2]
    elseif type_f[2] == 3
        M[N,N]      =   1
        M[N,N-1]    =   -1
        B[N]      =   0
    elseif type_f[2] == 4
        M[N,N]  =   2
        M[N,N-1]  =   1
        B[N]    =   6 / h[end] * (val_f[2] - (yi[end] - yi[end-1])/h[end])
    end

    # Résolution du système linéaire
    Spp     =   M\B

    # Calcul de la spline aux points x
    Sx  		=   Array{T}(undef,length(x))
	x_inter 	=	Array{Bool}(undef,length(x))

	for t=1:N-1
		x_inter		.=	(x .>= xi[t]) .& (x .<= xi[t+1])
		Sx[x_inter] =	poly_spline(view(xi,t:t+1),view(yi,t:t+1),view(Spp,t:t+1),h[t],x[x_inter])
	end


    return Sx

end


""">
Table des différences divisées:

"""
function divided_difference(xi::AbstractArray{T,1},
                        yi::AbstractArray{T,1}) where {T<:AbstractFloat}

    nb          =   length(xi)
    div_f       =   NaN*ones(AbstractFloat,nb-1,nb-1)

    div_f[:,1]  .=  diff(yi) ./ diff(xi)

    for t=2:nb-1
        div_f[1:nb-t,t]    .=   diff(view(div_f,1:nb-t+1,t-1)) ./
                                (view(xi,t+1:nb) .- view(xi,1:nb-t))
    end


    return div_f

end

function poly_spline(xi,yi,Spp,h,x)
    Px = -Spp[1]/(6*h) .* (x .- xi[2]).^3 .+ Spp[2]/(6*h) .* (x .- xi[1]).^3 .-
            (yi[1]/h - Spp[1]*h/6) .* (x .- xi[2]) .+ (yi[2]/h - Spp[2]*h/6) .* (x .- xi[1])
    return Px
end

function poly_spline2(xi,yi,Spp,h,x)
    Px = -Spp[1]/(6*h) * (x - xi[2])^3 + Spp[2]/(6*h) * (x - xi[1])^3 -
            (yi[1]/h - Spp[1]*h/6) * (x - xi[2]) + (yi[2]/h - Spp[2]*h/6) * (x - xi[1])
    return Px
end
