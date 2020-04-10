# Définition des paramètres pour l'analyse de convergence
nb_eval = 15
nb_pas_init = 100
nb_pas = [nb_pas_init * 2^i for i=0:nb_eval-1]

# Définition du problème avec sa solution exacte
tspan = [0.0 , 5.0]
h     = (tspan[2] - tspan[1]) ./ nb_pas
x0    = [1.0 , 0.0]

function fct(t, z)
    dim = length(z)
    f = zeros(dim)
    f[1] = z[2]
    f[2] = -10 * z[1]
    return f
end

sol_exacte(t) = [cos(t*sqrt(10)), -sqrt(10)*sin(t*sqrt(10))]

# Initialisation des vecteurs contenant les erreurs
err_euler_exp = zeros(nb_eval);
err_euler_mod = zeros(nb_eval);
err_pt_milieu = zeros(nb_eval);
err_rk4       = zeros(nb_eval);

# Calcul des erreurs en norme infinie
for t=1:nb_eval
    (temps,y_euler_exp) = euler(fct,tspan,x0,nb_pas[t])
    (temps,y_euler_mod) = eulermod(fct,tspan,x0,nb_pas[t])
    (temps,y_pt_milieu) = ptmilieu(fct,tspan,x0,nb_pas[t])
    (temps,y_rk4)       = rk4(fct,tspan,x0,nb_pas[t])

    sol_exacte_mat = zeros(nb_pas[t]+1, length(x0))
    for tt=1:length(temps)
        sol_exacte_mat[tt,:] = sol_exacte(temps[tt])
    end
    err_euler_exp[t] = norm(y_euler_exp - sol_exacte_mat, Inf)
    err_euler_mod[t] = norm(y_euler_mod - sol_exacte_mat, Inf)
    err_pt_milieu[t] = norm(y_pt_milieu - sol_exacte_mat, Inf)
    err_rk4[t]       = norm(y_rk4       - sol_exacte_mat, Inf)
end

# Calcul de l'ordre
ordre_euler_exp = log.(2 ,err_euler_exp[1:end-1] ./ err_euler_exp[2:end])
ordre_euler_mod = log.(2, err_euler_mod[1:end-1] ./ err_euler_mod[2:end])
ordre_pt_milieu = log.(2, err_pt_milieu[1:end-1] ./ err_pt_milieu[2:end])
ordre_rk4       = log.(2, err_rk4[1:end-1] ./ err_rk4[2:end])

println("Ordre d'Euler explicite : ", mean(ordre_euler_exp))
println("Ordre d'Euler modifié : ", mean(ordre_euler_mod))
println("Ordre de point milieu : ", mean(ordre_pt_milieu))
println("Ordre de Runge-Kutta 4 : ", mean(ordre_rk4))

# Affichage des grapiques de convergence
println(lineplot(log.(10, h), log.(10, err_pt_milieu), name="point milieu", color = :red   , xlabel="log₁₀(h)", ylabel="log₁₀(‖err‖∞)", title="graphique de convergence"))
println()
println(lineplot(log.(10, h), log.(10, err_euler_mod), name="euler mod"   , color = :blue  , xlabel="log₁₀(h)", ylabel="log₁₀(‖err‖∞)", title="graphique de convergence"))
println()
println(lineplot(log.(10, h), log.(10, err_euler_exp), name="euler exp"   , color = :green , xlabel="log₁₀(h)", ylabel="log₁₀(‖err‖∞)", title="graphique de convergence"))
println()
println(lineplot(log.(10, h), log.(10, err_rk4)      , name="rk4"         , color = :yellow, xlabel="log₁₀(h)", ylabel="log₁₀(‖err‖∞)", title="graphique de convergence"))
