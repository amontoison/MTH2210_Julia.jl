#' # MTH2210A-RAPPORT DE LABORATOIRE
#'
#' Nom et Prenoms                       Matricule: 0000000       Groupe:00
#'
#' Nom et Prenoms                       Matricule: 0000000       Groupe:00
#'
#'
#' Date:

using Plots
gr()
using LinearAlgebra
using Printf
using Statistics
using MTH2210_Julia

#' ## Exercice 1 - Quelques opérations simples

function question1()

# Vecteur allant de 1 à 23 par bond de 2
a = 1:2:23
b = a .^ 2

@printf("n    a                       b\n");
for t=1:length(a)
    @printf("%2d   %16.15e   %16.15e\n",t,a[t],b[t])
end

return

end

question1()



# Un commentaire sur l'exercice 1

#' ## Exercice 2 - Affichage d'un graphique

function question2()

x = range(-2*pi,stop=2*pi,length=1001)
y = 0.2 .* x .+ 1
y2 = sin.(x)

p1 = plot(x , y , label="2cos(x)")
plot!(p1,x , y2 , label="sin(x)" , xlabel="x")
display(p1)

end

question2()

#' ## Exercice 3 - Création d'une fonction

function question3()

fct1 = function(x)
    z = sin(x)^2
    return z
end

# Appel de la fonction sur un float
resultat = fct1(2.0)

# Appel de la fonction pour des vecteurs de float
x = range(-2*pi,stop=2*pi,length=1001)
resultat2 = fct1.(x)

end

question3()

#' ## Exercice 4 - Résolution EDOs

function question4()

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

end

question4()
