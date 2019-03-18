# Résolution de problèmes non-linéaires

Cette section est dédiée à la résolution de problèmes non-linéaires. Deux types
 de problèmes non-linéaires sont étudiés, le premier est le problème de
 recherche de racines ``r \in \mathbb{R}^n`` de
 ``F:\mathbb{R}^n \to \mathbb{R}^n``:

`` F(r) = 0``.

Les algorithmes disponibles pour trouver les racines d'une fonction ``F`` sont:
1. Bissection pour ``n=1`` : [`bissec`](@ref),
2. Sécante pour ``n=1`` : [`secante`](@ref),
3. Newton avec dérivée pour ``n=1`` : [`newton1D`](@ref),
4. Newton avec dérivée pour ``n\geq 1`` : [`newtonNDder`](@ref),
5. Newton sans dérivée pour ``n\geq 1`` : [`newtonND`](@ref).

Le deuxième type de problème à résoudre est le problème de recherche d'un point
fixe ``z \in \mathbb{R}^n`` d'une fonction ``G:\mathbb{R}^n \to \mathbb{R}^n``:

``G(z) = z``.

L'algorithme disponible pour trouver les points-fixes d'une fonction ``g`` est:
1. Point-fixe pour ``n=1`` : [`ptfixes`](@ref)


## Exemple de résolution d'une équation non-linéaire

On cherche à calculer une approximation de ``\sqrt{10}`` en calculant la racine
positive de ``f(x) = x^2 - 10``. On définit tout d'abord la fonction ``f``:

```@example 1
function my_fct_nl(x)
    f = x^2 - 10
    return f
end
function my_dfct_nl(x)
    df = 2*x
    return df
end
nothing # hide
```  

On appelle ensuite les fonctions [`bissec`](@ref), [`secante`](@ref) et
[`newton1D`](@ref) afin de résoudre ce problème. On choisit ``x_0=2.5`` et
``x_1=4`` de sorte que ``f(x_0)f(x_1)<0`` et une tolérance sur l'erreur relative
de ``tol=10^{-9}``.

```@example 1
using MTH2210_Julia
using Plots
using Printf

x0 = 2.5
x1 = 4.
tol = 1e-9
(approx_bis , err_bis) = bissec(my_fct_nl , x0 , x1 , 100 , tol)
(approx_sec , err_sec) = secante(my_fct_nl , x0 , x1 , 50 , tol)
(approx_new , err_new) = newton1D(my_fct_nl , my_dfct_nl , x0 , 20 , tol)
nothing # hide
```
La méthode des points-fixes peut aussi être employée pour approximer
``\sqrt{10}``. On considère la fonction ``g(x) = -\frac{x^2}{10} + x+ 1`` dont
un point-fixe est ``\sqrt{10}``

```@example 1
function g(x)
    g = -x^2/10 + x + 1
    return g
end
(approx_fixe , err_fixe) = ptfixes(g , x0 , 50 , 1e-9)
nothing # hide
```

On peut ensuite afficher l'évolution des erreurs selon l'itération.

!!! warning "Avertissement"
    Il est important de sélectionner les éléments non-nuls des vecteurs
    `err_bis`, `err_sec`, `err_new` et `err_fixe` afin de pouvoir les afficher
    avec un axe logarithmique (`yscale=:log10`). Pour ce faire, on peut
    utiliser l'indexation logique `err_bis[err_bis.>0]`.

```@example 1
plot(1:length(err_bis[err_bis.>0]),err_bis[err_bis.>0],label="Bissection")
plot!(1:length(err_sec[err_sec.>0]),err_sec[err_sec.>0],label="Sécante")
plot!(1:length(err_new[err_new.>0]),err_new[err_new.>0],label="Newton")
plot!(1:length(err_fixe[err_fixe.>0]),err_fixe[err_fixe.>0],label="Pt-fixe",
      xlabel="nb itérations",ylabel="Erreur absolue",yscale=:log10)
plot!([],[],label="",size=(400,300)); savefig("nl-plot.png"); nothing # hide
```

![Erreurs pour les algorithmes de résolution d'équation non-linéaire](nl-plot.png)

Les tableaux des ratios des erreurs peuvent aussi être produits pour les
méthodes des points-fixes, de la sécante et de Newton:

```@example 1
ratio_fixe_1 = err_fixe[2:end] ./ err_fixe[1:end-1]
ratio_fixe_a = err_fixe[2:end] ./ err_fixe[1:end-1] .^ ((1+sqrt(5))/2)
ratio_fixe_2 = err_fixe[2:end] ./ err_fixe[1:end-1] .^ 2

ratio_sec_1 = err_sec[2:end] ./ err_sec[1:end-1]
ratio_sec_a = err_sec[2:end] ./ err_sec[1:end-1] .^ ((1+sqrt(5))/2)
ratio_sec_2 = err_sec[2:end] ./ err_sec[1:end-1] .^ 2

ratio_new_1 = err_new[2:end] ./ err_new[1:end-1]
ratio_new_a = err_new[2:end] ./ err_new[1:end-1] .^ ((1+sqrt(5))/2)
ratio_new_2 = err_new[2:end] ./ err_new[1:end-1] .^ 2

@printf("Ratio des erreurs pour points-fixes\n")
@printf("e_{n+1}/e_{n}           e_{n+1}/e_{n}^a         e_{n+1}/e_{n}^2\n")
for t=1:length(ratio_fixe_1)
    @printf("%16.15e   %16.15e   %16.15e\n", ratio_fixe_1[t] , ratio_fixe_a[t] , ratio_fixe_2[t])
end
@printf("\n\nRatio des erreurs pour la sécante\n")
@printf("e_{n+1}/e_{n}           e_{n+1}/e_{n}^a         e_{n+1}/e_{n}^2\n")
for t=1:length(ratio_sec_1)
    @printf("%16.15e   %16.15e   %16.15e\n", ratio_sec_1[t] , ratio_sec_a[t] , ratio_sec_2[t])
end
@printf("\n\nRatio des erreurs pour Newton\n")
@printf("e_{n+1}/e_{n}           e_{n+1}/e_{n}^a         e_{n+1}/e_{n}^2\n")
for t=1:length(ratio_new_1)
    @printf("%16.15e   %16.15e   %16.15e\n" , ratio_new_1[t] , ratio_new_a[t] , ratio_new_2[t])
end
```

On constate, tel qu'attendu, que la méthode de la sécante converge au nombre
d'or ``\frac{1+ \sqrt{5}}{2}``, que la méthode de Newton converge à l'ordre 2
et que la méthode des points-fixes converge à l'ordre 1 et à un taux de
convergence de ``-\frac{2\sqrt{10}}{10}+1``.
