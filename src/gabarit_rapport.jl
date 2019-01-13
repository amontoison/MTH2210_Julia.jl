#' # MTH2210A-RAPPORT DE LABORATOIRE
#'
#' Nom et Prenoms                       Matricule: 0000000       Groupe:00
#'
#' Nom et Prenoms                       Matricule: 0000000       Groupe:00
#'
#'
#' Date:

using Plots
plotly()
using LinearAlgebra
using Printf
using Statistics
push!(LOAD_PATH,"C:\\Users\\Antonin\\Documents\\Antonin\\Maitrise\\MTH2210_codes\\New_codes\\MTH2210_Julia\\src")
using MTH2210_Julia

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


p1 = plot(x , y , label="2cos(x)")
plot!(p1,x , y2 , label="sin(x)" , xlabel="x")
display(p1)

#' ## Exercice 3 - Création d'une fonction

fct1 = function(x)
    z = sin(x)^2
    return z
end

#' Appel de la fonction sur un float
resultat = fct1(2.0)

#' Appel de la fonction pour des vecteurs de float
resultat2 = fct1.(x)

#' ## Exercice 4 - Résolution EDOs

function my_edo(t,z)
    f = zeros(length(z))
    f[1] = z[2]
    f[2] = -z[1]
    return f
end
(temps,y)   =   euler(my_edo , [0.;10.] , [1.;0.] , 1000)

p2 = plot(temps,y[:,1],label="y(t)")
plot!(p2,temps,10 .* y[:,2],label="y'(t)",xlabel="Temps",title="Solution num. de l'EDO")
display(p2)
