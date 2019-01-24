"""
Résolution dun système non-linéaire de forme ``F(r)=0`` avec la méthode
de Newton en approximant la jacobienne:

``\\Delta x = \\tilde{J}_F^{-1}(x_n) F(x_n)
\\\\ x_{n+1} = x_n + \\Delta x ``

# Syntaxe
```julia
(approx , err_abs) = newtonND(fct , x0 , nb_it_max , tol_rel)
```

# Entrée
    1.  fct         -   Fonction F
    2.  x0          -   Approximation initiale
    3.  nb_it_max   -   Nombre maximum d'itérations
    4.  tol_rel     -   Tolérance sur l'approximation de l'erreur relative

# Sortie
    1.  approx      -   Matrice de taille (nb_iter x N) contenant les itérations
    2.  err_abs     -   Vecteur de dimension nb_iter contenant les erreurs absolues

# Exemples d'appel
```julia
function my_sys_nl(x)
	F = zeros(eltype(x),length(x))
	F[1] = x[1]^2 + x[2]^2 - 1
	F[2] = -x[1]^2 + x[2]
	return F
end
(approx , err_abs) = newtonND(my_sys_nl , [1.,1.] , 20 , 1e-9)
```
"""
function newtonND(fct::Function , x0::AbstractArray{T,1} , nb_it_max::Integer,
						tol_rel::T) where {T<:AbstractFloat}


    try
	    fct(x0)
	catch y
        error(string("Problème avec la fonction ",fct,".\n",y))
    end

	N = length(x0)

	if ~isa(fct(x0),Vector{T}) || ~(length(fct(x0)) == N)
		error(string("La fonction ",fct," ne retourne pas un vecteur de type ",
	  	 			T, " ou de dimension ",N))
    end

	# Initialisation des vecteurs
	app        	= 	NaN .* ones(T,N,nb_it_max)
	app[:,1]	=	x0
	err_rel		=	Inf .* ones(T,nb_it_max)
	arret		=	false
	nb_it      	=   1
	t 			= 	1
	mat_jac 	=	zeros(T,N,N)
	deltax 	=	zeros(T,N)

	@time for outer t=1:nb_it_max-1
		@time mat_jac 	.= 	app_jac(fct,view(app,:,t),T)
		deltax 		.=	mat_jac \ (-fct(view(app,:,t)))
		app[:,t+1]	.=	view(app,:,t) .+ deltax

		if det(mat_jac) == 0
			@printf("Le déterminant de la matrice jacobienne de F à l'itération %d est exactement 0.\nArrêt de l'algorithme\n",t)
			break
		end

		err_rel[t]	=	norm(view(app,:,t+1) .- view(app,:,t))/(norm(view(app,:,t+1)) + eps())

		if (err_rel[t] <= tol_rel) || (norm(fct(view(app,:,t+1))) == 0)
			arret	=   true
			break
		end

	end

	nb_it 	= 	t + 1
	approx 	=   view(app,:,1:nb_it)
	err_abs =   NaN * ones(T,nb_it)

    if arret
        for t=1:nb_it
            err_abs[t] = norm(view(approx,:,t) .- view(approx,:,nb_it))
        end
    else
        println("La méthode de Newton n'a pas convergée")
    end

    return transpose(approx) , err_abs

end

function app_jac(f,x,T)

	taille	=	length(x)
 	if minimum(x) == 0
 		h_init	=	1e-6
 	else
 		h_init	=	1e-3 * minimum(x)
 	end
 	h			=	h_init ./ (2 .^ (0:1))
	vec_zero 	=	zeros(T,length(x))
	mat_zero 	=	zeros(T,taille,taille)
	appj 		=	Array{typeof(C),1}(undef,2)
	appj[:] 	=	[mat_zero , mat_zero]
	app_finale 	=	Array{T,2}(undef,taille,taille)
	delta_h		=	Array{T,1}(undef,taille)
	vec_zero 	=	Array{T,1}(undef,taille)

	@time for t=1:2
 		appj[t]		.=	mat_zero
 		for d=1:taille
 			delta_h		.=	vec_zero
 			delta_h[d]	=	h[t]
 			appj[t][:,d]	.=	(f(x .+ delta_h) .- f(x .- delta_h)) ./ (2*h[t])
 		end
 	end

 	app_finale	.=	(2^2 .* appj[2] .- appj[1]) ./ (2^2-1)

	return app_finale

end
