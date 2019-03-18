"""
Résolution d'EDOs de type `` \\frac{dY}{dt}(t) = F(t,Y(t))`` avec les
conditions initiales ``Y(t_0) = Y_0`` à l'aide de la méthode de Runge-Kutta
d'ordre 4 jusqu'au temps ``t_f`` avec pas constant ``h``:

``k_1 = h F(t_n,Y_n)
\\\\ k_2 = h F(t_n + \\frac{h}{2}, Y_n + \\frac{k_1}{2})
\\\\ k_3 = h F(t_n + \\frac{h}{2}, Y_n + \\frac{k_2}{2})
\\\\ k_4 = h F(t_n + h, Y_n + k_3)
\\\\ Y_{n+1} = Y_n + \\frac{1}{6} \\left(k_1 + 2k_2 +2k_3 +k_4\\right)``

# Syntaxe
```julia
(t,Y) = rk4(fct , tspan , Y0 , nbpas)
```

# Entrée
    1.  fct     -   Fonction décrivant le système de N EDOs
    2.  tspan   -   (Array{Float,1}) Vecteur contenant le temps initial et final (tspan=[t0,tf])
    3.  Y0      -   (Array{Float,1}) Vecteur contenant les N conditions initiales
    4.  nbpas   -   (Integer) Nombre de pas de temps

# Sortie
    1.  temps   -   (Array{Float,1}) Vecteur contenant les pas de temps
    2.  Y       -   (Array{Float,2}) Matrice de dimension (nbpas+1) x N contenant les approximations

# Exemples d'appel
```julia
function my_edo(t,z)
    f = zeros(length(z))
    f[1] = z[2]
    f[2] = -z[1]
    return f
end
(t,y)   =   rk4(my_edo , [0.;10.] , [1.;0.] , 1000)
```
```julia
(t,y)   =   rk4((t,y) -> cos(t) , [0.;2.] , [1.] , 1000)
```
```julia
(t,y)   =   rk4((t,y) -> [y[2];-y[1]] , [0.;10.] , [1.;0.] , 1000)
```
"""
function rk4(fct::Function, tspan::AbstractArray{T,1},
            Y0::AbstractArray{T,1} , nbpas::Integer) where {T<:AbstractFloat}


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
     k1      =   zeros(T,N)
     k2      =   zeros(T,N)
     k3      =   zeros(T,N)
     k4      =   zeros(T,N)

     for t=1:nbpas
         k1 .= h .* fct(temps[t], view(Y,:,t))
         k2 .= h .* fct(temps[t] + h/2 , view(Y,:,t) .+ k1 ./ 2)
         k3 .= h .* fct(temps[t] + h/2 , view(Y,:,t) .+ k2 ./ 2)
         k4 .= h .* fct(temps[t] + h , view(Y,:,t) .+ k3)

         Y[:,t+1] .= view(Y,:,t) .+ (1/6) .* (k1 .+ 2 .* k2 .+ 2 .* k3 .+ k4)
     end

     return  temps , transpose(Y)

end
