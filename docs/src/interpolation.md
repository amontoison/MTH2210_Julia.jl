# Résolution de problèmes d'interpolation

Cette section est dédiée à la résolution de problèmes d'interpolation. Le
premier type d'interpolation consiste à résoudre le problème suivant:
Connaissant les ``n+1`` points d'interpolation ``(x_0,y_0),(x_1,y_1),\ldots,
(x_n,y_n)``, on cherche le polynôme ``p`` de degré ``n`` tel que ``p(x_0)=y_0,
p(x_1)=y_1,\ldots,p(x_n)=y_n``. L'algorithme disponible pour résoudre ce
problème est:
1. Méthode de Lagrange: [`lagrange`](@ref)

L'algorithme est une version autre que celle du cours et est basé sur
*Barycentric Lagrange Interpolation* (Berrut J. et Trefethen L.N.).

Une autre méthode d'interpolation est la spline cubique et l'algorithme
disponible est:
1. Méthode des splines cubiques: [`splinec`](@ref)

## Exemple d'interpolation avec la méthode de Lagrange

Soit les points d'interpolation ``(-1,2), \ (0,-4), \ (2.5,10), \ (3,5)``. On
veut afficher le polynôme de degré 3 sur l'intervalle ``[-1,3]``. On utilise
la fonction [`lagrange`](@ref) ainsi:

```@example 1
using MTH2210_Julia
using Plots

xi = [-1.,0.,2.5,3.]
yi = [2.,-4.,10.,5.]
xfin = LinRange(minimum(xi),maximum(xi),250)
Lx = lagrange(xi , yi , xfin)

plot(xi,yi,linetype=:scatter,label="Pt inter")
plot!(xfin,Lx,label="P3(x)",xlabel="x",legend=:bottomright)
plot!([],[],label="",size=(400,300)); savefig("lagrange-plot.png"); nothing # hide
```

![Interpolation de Lagrange](lagrange-plot.png)


## Exemple d'interpolation avec la méthode des splines cubiques

On peut aussi employer une spline cubique afin d'interpoler les points
précédents. On impose que ``S'(x_0) = 10`` et ``S''(x_3) = 50``.

```@example 1
Sx = splinec(xi , yi , xfin , [4,2] , [10.,50.])

plot(xi,yi,linetype=:scatter,label="Pt inter")
plot!(xfin,Sx,label="Spline cubique",xlabel="x",legend=:bottomright)
plot!([],[],label="",size=(400,300)); savefig("splinec-plot.png"); nothing # hide
```

![Interpolation avec spline cubique](splinec-plot.png)
