"""
Résolution d'une équation non-linéaire de forme ``f(r)=0`` avec la méthode
de la bissection.

# Syntaxe
```julia
(approx , err_abs) = bissec(fct , x0 , x1 , nb_it_max , tol_rel)
```

# Entrée
    1.  fct         -   Fonction f
    2.  x0          -   (Float) Première approximation initiale
	3.  x1          -   (Float) Deuxième approximation initiale
	4.  nb_it_max   -   (Integer) Nombre maximum d'itérations
	5.  tol_rel     -   (Float) Tolérance sur l'approximation de l'erreur relative

# Sortie
    1.  approx      -   (Array{Float,1}) Vecteur de taille nb_iter contenant les itérations
    2.  err_abs     -   (Array{Float,1}) Vecteur de dimension nb_iter contenant les erreurs absolues

# Exemples d'appel
```julia
function my_fct_nl(x)
    f = x^2 - 10
    return f
end
(approx , err_abs) = bissec(my_fct_nl , 3 , 3.5 , 200 , 1e-9)
```
```julia
(approx , err_abs) = bissec((x) -> x^2 - 10 , 3 , 3.5 , 200 , 1e-9)
```
"""
function bissec(fct::Function , x0::T , x1::T , nb_it_max::Integer, tol_rel::T) where {T<:AbstractFloat}

     try
         fct(x0)
     catch y
         error(string("Problème avec la fonction ",fct,".\n",y))
     end

     if ~isa(fct(x0),T)
         error(string("La fonction ",fct," ne retourne pas un scalaire de type ",T))
     end

	 if fct(x0) * fct(x1) > 0
		 println("La condition f(x0)*f(x1)<0 n'est pas respectée.\nArrêt de l''algorithme")
		 approx = [x0,x1]
		 err_abs = Inf*ones(T,2)
		 return (approx,err_abs)
	 elseif fct(x0) == 0
		 approx = [x0]
		 err_abs = [0.]
		 return (approx,err_abs)
	 elseif fct(x1) == 0
		 approx = [x1]
		 err_abs = [0.]
		 return (approx,err_abs)
	 end

     # Initialisation des vecteurs
     app        = 	NaN .* ones(T,nb_it_max)
     err_rel	=	Inf .* ones(T,nb_it_max)
	 arret		=	false
     nb_it      =   1
	 x_gauche	=  	NaN
	 x_droite	=  	NaN
	 x_milieu 	=	NaN
	 f_gauche	=	NaN
	 f_droite	=	NaN
	 f_milieu	=	NaN
	 t = 1

     for outer t=1:nb_it_max-1

		 if t==1
			 x_gauche	=	minimum([x0,x1])
			 x_droite	=	maximum([x0,x1])
		 else
			 if f_gauche*f_milieu < 0
				 x_droite	=	x_milieu
			 elseif f_droite*f_milieu < 0
				 x_gauche	=	x_milieu
			 else
				 println("Problème avec la fonction f.\nArrêt de l''algorithme\n")
				 break
			 end
		 end

		 x_milieu	=	(x_gauche + x_droite)/2
		 app[t]		=	x_milieu
		 nb_it = t

		 if t==1
			 if fct(app[t]) == 0
				 arret	=	true
				 break
			 end
		 else
			 err_rel[t-1]	=	abs(app[t]-app[t-1])/(abs(app[t]) + eps())
			 if (err_rel[t-1] <= tol_rel) || (fct(app[t]) == 0)
				 arret	=	true
				 break
			 end
		 end

		 f_gauche	=	fct(x_gauche)
		 f_droite	=	fct(x_droite)
		 f_milieu	=	fct(x_milieu)
	 end

	 nb_it = t
     approx  = app[1:nb_it]
     err_abs = Inf .* ones(T,nb_it)

     if arret
         err_abs = abs.(approx[end] .- approx)
     else
         println("La méthode de la bissection n'a pas convergée")
     end

     return approx , err_abs
end

@inline bissec(fct::Function , x0::Real , x1::Real , nb_it_max::Integer , tol_rel::Real) = bissec(fct , Float64(x0) ,	Float64(x1) , nb_it_max , Float64(tol_rel))
