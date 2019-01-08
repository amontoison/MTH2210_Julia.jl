#' # MTH2210A-RAPPORT DE LABORATOIRE
#'
#' Nom et Prenoms                       Matricule: 0000000       Groupe:00
#'
#' Nom et Prenoms                       Matricule: 0000000       Groupe:00
#'
#'
#' Date:

using Plots
using Printf
using LinearAlgebra

#' ## Exercice 1 - Quelques opérations simples

#' Vecteur allant de 1 à 23 par bond de 2
a = 1:2:23

#' Fonction équivalente au linspace de MatLab
x = range(-2*pi,stop=2*pi,length=1001)

#' Opérations vectorisées
b = a .^ 2
y = 0.2 .* x .+ 1
y2 = sin.(x)

#' Affichage d'un tableau

begin
@printf("n    a                       b\n");
for t=1:length(a)
    @printf("%2d   %16.15e   %16.15e\n",t,a[t],b[t])
end
end

#' Un commentaire sur l'exercice 1

#' ## Exercice 2 - Affichage d'un graphique

plot(x , y , label="2cos(x)")
plot!(x , y2 , label="sin(x)" , xlabel="x")

#' ## Exercice 3 - Création d'une fonction

fct1 = function(x)
    z = sin(x)^2
    return z
end

#' Appel de la fonction sur un float
resultat = fct1(2.0)

#' Appel de la fonction pour des vecteurs de float
resultat2 = fct1.(x)
