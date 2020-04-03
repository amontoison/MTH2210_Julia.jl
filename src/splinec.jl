"""
Interpolation par les splines cubiques


# Syntaxe
```julia
Sx = splinec(xi , yi , x , type_f , val_f)
```

# Entrée
    1.  xi          -   (Array{Float,1}) Abscisses des points d'interpolation
    2.  yi          -   (Array{Float,1}) Ordonnées des points d'interpolation
    3.  x           -   (Array{Float,1}) Points où la spline cubique est évaluée
    4.  type_f      -   (Array{Integer,1}) Vecteur des types de conditions frontières
                        imposées en x_0 et x_n. Les choix possibles sont:
                            [1,1] -> Spline naturelle
                            [2,2] -> Spline avec courbure prescrite
                            [3,3] -> Spline avec courbure constane
                            [4,4] -> Spline avec pente prescrite
                            [i,j] -> Spline avec condition i imposée en x0 et
                                     condition j imposée en xn

    5.  val_f       -   (Array{Float,1}) Vecteur des valeurs des conditions frontières
                        imposées en x_0 et x_n. Les choix possibles sont:
                            - Si type_S[1] = 1 ou 3, alors val_S[1] = NaN
                            - Si type_S[1] = 2 ou 4, alors val_S[1] = a, où a
                              représente resp. la courbure ou la pente en x0
                            - Si type_S[2] = 1 ou 3, alors val_S[2] = NaN
                            - Si type_S[2] = 2 ou 4, alors val_S[2] = b, où b
                              représente resp. la courbure ou la pente en xn
# Sortie
    1.  Sx          -   (Array{Float,1}) Valeur de la spline cubique aux points x

# Exemples d'appel
```julia
Sx = splinec([1,2,4,5] , [1,9,2,11] , LinRange(1,5,200) , [1,1] , [NaN,NaN])
Sx = splinec([1,2,4,5] , [1,9,2,11] , LinRange(1,5,200) , [2,2] , [5,-6])
Sx = splinec([1,2,4,5] , [1,9,2,11] , LinRange(1,5,200) , [3,3] , [NaN,NaN])
Sx = splinec([1,2,4,5] , [1,9,2,11] , LinRange(1,5,200) , [4,4] , [-30,-10])
Sx = splinec([1,2,4,5] , [1,9,2,11] , LinRange(1,5,200) , [3,4] , [NaN,-10])
```
"""
function splinec(xi::AbstractVector{<:Real}, yi::AbstractVector{<:Real}, x::AbstractVector{<:Real}, type_f::AbstractVector{<:Real} , val_f::AbstractVector{<:Real})

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
    diag_center =   vcat(0 , 2 .* ones(Float64,N-2) , 0)

    M = spdiagm(-1 => diag_below, 0 => diag_center , 1 => diag_above)

    # Calcul du terme de droite
    B           	=   NaN .* ones(Float64,N)
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
    Sx  		=   NaN .* ones(Float64,length(x))
	x_inter 	=	trues(length(x))

	for t=1:N-1
		x_inter		.=	(x .>= xi[t]) .& (x .<= xi[t+1])
		Sx[x_inter] =	poly_spline(view(xi,t:t+1),view(yi,t:t+1),view(Spp,t:t+1),h[t],x[x_inter])
	end


    return Sx

end


"""
Calcul de la table des différences divisées

# Syntaxe
```julia
table_df = divided_difference(xi , yi )
```

# Entrée
    1.  xi         	-   (Array{Float,1}) Abscisses des points d'interpolation
    2.  yi        	-   (Array{Float,1}) Ordonnées des points d'interpolation

# Sortie
    1.  table_df 	-   (Array{Float,2}) Table des différences divisées: la 1ère
                        colonne contient les premières différences divisées, la
                        2ème colonne (jusqu'à la ligne end-1) contient les deuxièmes
                        différences divisées,...

# Exemples d'appel
```julia
xi = [2 , 0 , 5 , 3]
yi = [1 , -1 , 10 , -4]

table = divided_difference(xi,yi)
diff_div1 = table[:,1]
diff_div2 = table[1:end-1,2]
diff_div3 = table[1:end-2,3]
```
"""
function divided_difference(xi::AbstractVector{<:Real} , yi::AbstractVector{<:Real})

    nb          =   length(xi)
    div_f       =   NaN .* ones(Float64,nb-1,nb-1)

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
