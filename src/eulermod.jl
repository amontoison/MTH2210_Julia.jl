"""
Résolution d'EDOs de type `` \\frac{dY}{dt}(t) = F(t,Y(t))`` avec les
conditions initiales ``Y(t_0) = Y_0`` à l'aide de la méthode d'Euler modifié
jusqu'au temps ``t_f`` avec pas constant ``h``:

``\\tilde{Y} = Y_{n} + h F(t_n,Y_n)
\\\\ Y_{n+1} = Y_n + \\frac{h}{2} \\left(F(t_n,Y_n) + F(t_n +h, \\tilde{Y}) \\right)``

# Syntaxe
```julia
(t,Y) = eulermod(fct , tspan , Y0 , nbpas)F(t_n,Y_n) +
```

# Entrée
    1.  fct     -   Fonction décrivant le système de N EDOs
    2.  tspan   -   Vecteur contenant le temps initial et final (tspan=[t0,tf])
    3.  Y0      -   Vecteur contenant les N conditions initiales
    4.  nbpas   -   Entier spécifiant le nombre de pas de temps

# Sortie
    1.  temps   -   Vecteur contenant les pas de temps
    2.  Y       -   Matrice de dimension (nbpas+1) x N contenant les approximations

# Exemples d'appel
```julia
(t,y)   =   eulermod((t,y) -> cos(t) , [0.;2.] , [1.] , 1000)
```
```julia
(t,y)   =   eulermod((t,y) -> [y[2];-y[1]] , [0.;10.] , [1.;0.] , 1000)
```
```julia
function my_edo(t,z)
    f = zeros(length(z))
    f[1] = z[2]
    f[2] = -z[1]
    return f
end
(t,y)   =   eulermod(my_edo , [0.;10.] , [1.;0.] , 1000)
```
"""
function eulermod(fct::Function , tspan::Vector{T},
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
     y_tilde =   zeros(T,N)

     for t=1:nbpas
         y_tilde .= view(Y,:,t) .+ h .* fct(temps[t], view(Y,:,t))
         Y[:,t+1] .= view(Y,:,t) .+ (h ./ 2) .* (fct(temps[t], view(Y,:,t)) .+ fct(temps[t] + h, y_tilde))
     end

     return  temps , transpose(Y)

end
