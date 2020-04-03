"""
Résolution d'une équation non-linéaire de forme ``g(x)=x`` avec la méthode
des points-fixes:

``x_{n+1} = g(x_n)``

# Syntaxe
```julia
(approx , err_abs) = ptfixes(fct , x0 , nb_it_max , tol_rel)
```

# Entrée
    1.  fct         -   Fonction g
    2.  x0          -   (Float) Approximation initiale
	4.  nb_it_max   -   (Integer) Nombre maximum d'itérations
    5.  tol_rel     -   (Float) Tolérance sur l'approximation de l'erreur relative

# Sortie
    1.  approx      -   (Array{Float,1}) Vecteur de taille nb_iter contenant les itérations
    2.  err_abs     -   (Array{Float,1}) Vecteur de dimension nb_iter contenant les erreurs absolues

# Exemples d'appel
```julia
function my_fct_nl(x)
    g = -x^2/10 + x + 1
    return g
end
(approx , err_abs) = ptfixes(my_fct_nl , 3 , 25 , 1e-9)
```
```julia
(approx , err_abs) = ptfixes( (x) -> -x^2/10 + x + 1 , 3 , 25 , 1e-9)
```
"""
function ptfixes(fct::Function , x0::T , nb_it_max::Integer, tol_rel::T) where {T<:AbstractFloat}


     try
         fct(x0)
     catch y
         error(string("Problème avec la fonction ",fct,".\n",y))
     end

     if ~isa(fct(x0),T)
         error(string("La fonction ",fct," ne retourne pas un scalaire de type ",T))
     end

     # Initialisation des vecteurs
     app        = 	NaN .* ones(T,nb_it_max)
     app[1]	    =	x0
     err_rel	=	Inf .* ones(T,nb_it_max)
	 arret		=	false
     nb_it      =   1
	 t = 1

     for outer t=1:nb_it_max-1
         app[t+1]	=	fct(app[t])
         err_rel[t]	=	abs(app[t+1]-app[t])/(abs(app[t+1]) + eps())

         if (err_rel[t] <= tol_rel) || (fct(app[t+1]) == 0)
             arret	=	true
		     break
         end
     end

     nb_it   = t+1
     approx  = app[1:nb_it]
     err_abs = Inf .* ones(T,nb_it)

     if arret
         err_abs = abs.(approx[end] .- approx)
     else
         println("La méthode des points fixes n'a pas convergée")
     end

     return approx , err_abs
end

@inline ptfixes(fct::Function, x0::Real, nb_it_max::Integer, tol_rel::Real) = ptfixes(fct, Float64(x0), nb_it_max, Float64(tol_rel))
