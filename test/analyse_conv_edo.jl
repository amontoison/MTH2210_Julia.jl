"""
Script vérifiant les algorithmes de résolution d'équations différentielles
partielles
"""
using Plots
push!(LOAD_PATH,"C:\\Users\\Antonin\\Documents\\Antonin\\Maitrise\\MTH2210_codes\\New_codes\\MTH2210_Julia\\src")
using MTH2210_Julia
using LinearAlgebra

# Définition des paramètres pour l'analyse de convergence
nb_eval = 15
nb_pas_init = 100
nb_pas = nb_pas_init * 2 .^ (0:(nb_eval - 1))

# Définition du problème avec sa solution exacte
tspan = [0.,5.]
h     = (tspan[2] - tspan[1]) ./ nb_pas
x0 = [1.,0.]
function fct(t,z)
    f = zeros(length(z))
    f[1] = z[2]
    f[2] = -10 * z[1]
    return f
end

sol_exacte(t) = [cos(t*sqrt(10)),-sqrt(10)*sin(t*sqrt(10))]

# Initialisation des matrices
err_euler_exp   =   Array{eltype(x0)}(undef,nb_eval)
err_euler_mod   =   Array{eltype(x0)}(undef,nb_eval)
err_pt_milieu   =   Array{eltype(x0)}(undef,nb_eval)
err_rk4         =   Array{eltype(x0)}(undef,nb_eval)


# Calcul ds erreurs absolues
for t=1:nb_eval
    (temps,y_euler_exp) =   euler(fct,tspan,x0,nb_pas[t])
    (temps,y_euler_mod) =   eulermod(fct,tspan,x0,nb_pas[t])
    (temps,y_pt_milieu) =   ptmilieu(fct,tspan,x0,nb_pas[t])
    (temps,y_rk4)       =   rk4(fct,tspan,x0,nb_pas[t])

    sol_exacte_mat = Array{eltype(x0)}(undef,nb_pas[t]+1,length(x0))
    for tt=1:length(temps)
        sol_exacte_mat[tt,:] = sol_exacte(temps[tt])
    end
    err_euler_exp[t]        =   norm(y_euler_exp - sol_exacte_mat,Inf)
    err_euler_mod[t]        =   norm(y_euler_mod - sol_exacte_mat,Inf)
    err_pt_milieu[t]        =   norm(y_pt_milieu - sol_exacte_mat,Inf)
    err_rk4[t]              =   norm(y_rk4 - sol_exacte_mat,Inf)
end

# Calcul de l'ordre
ordre_euler_exp	  =	log.(err_euler_exp[1:end-1] ./ err_euler_exp[2:end]) ./ log(2)
ordre_euler_mod	  =	log.(err_euler_mod[1:end-1] ./ err_euler_mod[2:end]) ./ log(2)
ordre_pt_milieu	  =	log.(err_pt_milieu[1:end-1] ./ err_pt_milieu[2:end]) ./ log(2)
ordre_rk4	      =	log.(err_rk4[1:end-1] ./ err_rk4[2:end]) ./ log(2)

println("Ordre d'Euler explicite")
println(ordre_euler_exp)
println("Ordre d'Euler modifié")
println(ordre_euler_mod)
println("Ordre de point milieu")
println(ordre_pt_milieu)
println("Ordre de Runge-Kutta d'ordre 4")
println(ordre_rk4)


# Affichage des grapiques de convergence
plot(h,err_euler_exp,label="euler exp")
plot!(h,err_euler_mod,label="euler mod")
plot!(h,err_pt_milieu,label="point milieu")
plot!(h,err_rk4,xscale=:log10,yscale=:log10,label="rk4",xlabel="h",ylabel="erreur abs")
