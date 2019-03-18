"""
Résolution dun système non-linéaire de forme ``F(r)=0`` avec la méthode
de Newton:

``\\Delta x = J_F^{-1}(x_n) F(x_n)
\\\\ x_{n+1} = x_n + \\Delta x ``

# Syntaxe
```julia
(approx , err_abs) = newtonNDder(fct , jac , x0 , nb_it_max , tol_rel)
```

# Entrée
    1.  fct         -   Fonction F
    2.  dfct        -   Matrice jacobienne de la fonction F
    3.  x0          -   (Array{Float,1}) Vecteur des approximations initiales
    4.  nb_it_max   -   (Integer) Nombre maximum d'itérations
    5.  tol_rel     -   (Float) Tolérance sur l'approximation de l'erreur relative

# Sortie
    1.  approx      -   (Array{Float,2}) Matrice de taille (nb_iter x N) contenant les itérations
    2.  err_abs     -   (Array{Float,1}) Vecteur de dimension nb_iter contenant les erreurs absolues

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
function newtonNDder(fct::Function , jac::Function, x0::AbstractArray{T,1} ,
				nb_it_max::Integer, tol_rel::T) where {T<:AbstractFloat}


    try
	    fct(x0)
	catch y
        error(string("Problème avec la fonction ",fct,".\n",y))
    end

    try
        jac(x0)
    catch y
        error(string("Problème avec la fonction ",jac,".\n",y))
    end

	N = length(x0)

	if ~isa(fct(x0),Vector{T}) || ~(length(fct(x0)) == N)
		error(string("La fonction ",fct," ne retourne pas un vecteur de type ",
	  	 			T, " ou de dimension ",N))
	elseif ~isa(jac(x0),Array{T}) || ~(size(jac(x0)) == (N,N))
		error(string("La fonction ",jac," ne retourne pas une matrice de dimension ",
		    			N, "x", N, " de type ",T))
	elseif ~check_jac(fct,jac,x0,T)
		println("Il semble y avoir une erreur avec la dérivée")
    end

	# Initialisation des vecteurs
	app        	= 	NaN .* ones(T,N,nb_it_max)
	app[:,1]	=	x0
	err_rel		=	Inf .* ones(T,nb_it_max)
	arret		=	false
	nb_it      	=   1
	t 			= 	1
	mat_jac 	=	zeros(T,N,N)
	deltax 		=	zeros(T,N)

	for outer t=1:nb_it_max-1
		mat_jac 	.= 	jac(view(app,:,t))
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

function check_jac(f,jac,x0,T)

	taille	=	length(x0)
 	if minimum(x0) == 0
 		h_init	=	1e-6
 	else
 		h_init	=	1e-3 * minimum(x0)
 	end

 	h		=	h_init ./ (2 .^ (0:4))
 	erreur	=	NaN * ones(T,length(h))
	vec_zero 	=	zeros(T,length(x0))
	mat_zero 	=	zeros(T,taille,taille)
	app 		=	Array{T,2}(undef,taille,taille)
	delta_h		=	Array{T,1}(undef,taille)

 	for t=1:length(h)
 		app		.=	mat_zero
 		for d=1:taille
 			delta_h		.=	vec_zero
 			delta_h[d]	=	h[t]
 			app[:,d]	.=	(f(x0+delta_h) .- f(x0-delta_h)) ./ (2*h[t])
 		end
 		erreur[t]	=	norm(abs.(jac(x0) .- app));
 	end

 	ordre	=	log.(erreur[2:end] ./ erreur[1:end-1]) ./
 				log.(h[2:end]      ./ h[1:end-1]);

 	test	=	(mean( abs.(2 .- ordre) ) <= 0.25) || (mean(erreur ./
					(norm(jac(x0)) + eps())) <=1e-9);

	return test

end
