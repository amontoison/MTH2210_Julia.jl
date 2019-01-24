"""
Résolution d'une équation non-linéaire de forme ``f(r)=0`` avec la méthode
de Newton:

``x_{n+1} = x_n - \\frac{f(x_n)}{f'(x_n)}``

# Syntaxe
```julia
(approx , err_abs) = newton1D(fct , dfct , x0 , nb_it_max , tol_rel)
```

# Entrée
    1.  fct         -   Fonction f
    2.  dfct        -   Dérivée de la fonction f
    3.  x0          -   Approximation initiale
    4.  nb_it_max   -   Nombre maximum d'itérations
    5.  tol_rel     -   Tolérance sur l'approximation de l'erreur relative

# Sortie
    1.  approx      -   Vecteur de taille nb_iter contenant les itérations
    2.  err_abs     -   Vecteur de dimension nb_iter contenant les erreurs absolues

# Exemples d'appel
```julia
(approx , err_abs) = newton1D((x) -> x^2 - 10 , (x) -> 2*x , 3. , 20 , 1e-9)
```
```julia
function my_fct_nl(x)
    f = x^2 - 10
    return f
end
function my_dfct_nl(x)
    df = 2*x
    return df
end
(approx , err_abs) = newton1D(my_fct_nl , my_dfct_nl , 3. , 20 , 1e-9)
```
"""
function newton1D(fct::Function , dfct::Function , x0::T ,
				nb_it_max::Integer, tol_rel::T) where {T<:AbstractFloat}


     try
         fct(x0)
     catch y
         error(string("Problème avec la fonction ",fct,".\n",y))
     end

     try
         dfct(x0)
     catch y
         error(string("Problème avec la fonction ",dfct,".\n",y))
     end

     if ~isa(fct(x0),T)
         error(string("La fonction ",fct," ne retourne pas un scalaire de type ",T))
     elseif ~isa(dfct(x0),T)
         error(string("La fonction ",dfct," ne retourne pas un scalaire de type ",T))
     elseif ~check_derivative(fct,dfct,x0,T)
         println("Il semble y avoir une erreur avec la dérivée")
     end

     # Initialisation des vecteurs
     app        = 	NaN .* ones(T,nb_it_max)
     app[1]	    =	x0
     err_rel	=	Inf .* ones(T,nb_it_max)
     arret		=	false
     nb_it      =   1
	 t = 1

     for outer t=1:nb_it_max-1
         app[t+1]	=	app[t] - fct(app[t]) / dfct(app[t])
         if abs(dfct(app[t])) == 0
             @printf("La dérivée de f au point x=%6.5e est exactement 0.\nArrêt de l'algorithme\n",app[t])
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
         println("La méthode de Newton n'a pas convergée")
     end

     return approx , err_abs
end



function check_derivative(f,df,x0,T)

	if x0 == 0
		h_init	=	1e-6
	else
		h_init	=	1e-3 * abs(x0)
	end

	h		=	h_init ./ (2. .^ (0:4))
	erreur	=	ones(T,length(h))

	for t=1:length(h)
		app			=	(f(x0+h[t]) - f(x0-h[t])) / (2*h[t])
		erreur[t]	=	abs(df(x0) - app)
	end

	ordre	=	log.(erreur[2:end] ./ erreur[1:end-1]) ./
				log.(h[2:end]      ./ h[1:end-1]);

	test	=	(mean( abs.(2 .- ordre) ) <= 0.25) || (mean(erreur ./ (abs(df(x0))+eps())) <=1e-9)

    return test
end
