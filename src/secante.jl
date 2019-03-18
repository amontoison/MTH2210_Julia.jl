"""
Résolution d'une équation non-linéaire de forme ``f(x)=0`` avec la méthode
de la sécante:

``x_{n+1} = x_n - \\frac{f(x_n)\\left(x_{n}-x_{n-1}\\right)}{f(x_n)-f(x_{n-1})}``

# Syntaxe
```julia
(approx , err_abs) = secante(fct , x0 , x1 , nb_it_max , tol_rel)
```

# Entrée
    1.  fct         -   Fonction f
    2.  x0          -   (Float) Première approximation initiale
	2.  x1          -   (Float) Deuxième approximation initiale
	4.  nb_it_max   -   (Integer) Nombre maximum d'itérations
    5.  tol_rel     -   (Float) Tolérance sur l'approximation de l'erreur relative

# Sortie
    1.  approx      -   (Array{Float,1}) Vecteur de taille nb_iter contenant les	itérations
    2.  err_abs     -   (Array{Float,1}) Vecteur de dimension nb_iter contenant les erreurs absolues

# Exemples d'appel
```julia
function my_fct_nl(x)
    f = x^2 - 10
    return f
end
(approx , err_abs) = secante(my_fct_nl , 3. , 3.5 , 20 , 1e-9)
```
```julia
(approx , err_abs) = secante((x) -> x^2 - 10 , 3. , 3.5 , 20 , 1e-9)
```
"""
function secante(fct::Function , x0::T , x1::T ,
					nb_it_max::Integer, tol_rel::T) where {T<:AbstractFloat}


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
	 app[2]		= 	x1
     err_rel	=	Inf .* ones(T,nb_it_max)
	 err_rel[1] =	(x1 - x0)/(x1 + eps())
	 arret		=	false
     nb_it      =   1
	 t = 1

     for outer t=2:nb_it_max-1
         app[t+1]	=	app[t] - fct(app[t]) * (app[t] - app[t-1]) / ( fct(app[t]) - fct(app[t-1]) )
         if abs(fct(app[t]) - fct(app[t-1])) == 0
             @printf("L'approximation de la dérivée de f avec les points x=%6.5e et x=%6.5e est exactement 0.\nArrêt de l'algorithme\n",app[t],app[t-1])
             break
         end

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
         println("La méthode de la sécante n'a pas convergée")
     end

     return approx , err_abs
end
