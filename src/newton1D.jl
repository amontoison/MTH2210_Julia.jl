"""
Résolution d'une équation non-linéaire de forme ``f(x)=0`` avec la méthode
de Newton:

``x_{n+1} = x_n - \\frac{f(x_n)}{f'(x_n)}``

# Syntaxe
```julia
(approx , err_abs) = Newton1D(fct , dfct , x0 , nb_it_max , tol_rel)
```

# Entrée
    1.  fct         -   Fonction f 
    2.  dfct        -   Dérivée de la fonction f
    3.  x0          -   Approximations initiales
    4.  nb_it_max   -   Nombre maximum d'itérations
    5.  tol_rel	    -	Tolérance sur l'approximation de l'erreur relative

# Sortie
    1.  approx      -   Vecteur colonne de taille nb_iter contenant les	itérations
    2.  err_abs	    -	Vecteur colonne de dimension nb_iter contenant les erreurs absolues

# Exemples d'appel
```julia
(approx , err_abs) = Newton1D((x) -> x^2 - 10 , (x) -> 2*x , 3 , 20 , 1e-9)
```
```julia
function my_edo(t,z)
    f = zeros(length(z))
    f[1] = z[2]
    f[2] = -z[1]
    return f
end
(t,y)   =   euler(my_edo , [0.;10.] , [1.;0.] , 1000)
```
"""
function newton1D(fct::Function , tspan::Vector{T},
                    Y0::Vector{T} , nbpas::Integer) where {T<:AbstractFloat}


     # Vérification des arguments d'entrée
     if length(tspan) != 2
         error("Le vecteur tspan doit contenir 2 composantes, [t0 , tf]")
     elseif nbpas<=0
     error(string("L'argument nbpas=$nbpas n'est pas valide. ",
                          "Cet argument doit être un entier > 0."))
     end

     try
         fct(tspan[1],Y0)
     catch y
         if isa(y,BoundsError)
             error("Le nombre de composantes de Y0 et f ne concorde pas")
         else
             error(y)
         end
     end

     if ~isa(fct(tspan[1],Y0),Array{T,1})
         error("La fonction f ne retourne pas un vecteur de type float")
     elseif (length(Y0) != length(fct(tspan[1],Y0)))
         error("Le nombre de composantes de Y0 et f ne concorde pas")
     end

     N       =   length(Y0)
     Y       =   zeros(T,N,nbpas+1)
     Y[:,1]  .=  Y0
     temps   =   LinRange{T}(tspan[1], tspan[2] , nbpas+1)
     h       =   temps[2] - temps[1]

     for t=1:nbpas
         Y[:,t+1] .= view(Y,:,t) .+ h .* fct(temps[t], view(Y,:,t))
     end

     return  temps , transpose(Y)

end
