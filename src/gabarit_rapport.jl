#' # MTH2210A-RAPPORT DE LABORATOIRE
#'
#' Nom et Prenoms                       Matricule: 0000000       Groupe:00
#'
#' Nom et Prenoms                       Matricule: 0000000       Groupe:00
#'
#'
#' Date:

using Plots
using LinearAlgebra
using Printf
using Statistics
push!(LOAD_PATH,"C:\\Users\\Antonin\\Documents\\Antonin\\Maitrise\\MTH2210_codes\\New_codes\\MTH2210_Julia\\src")
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

x = LinRange(-2*pi,2*pi,1001)
y = 0.2 .* x .+ 1
y2 = sin.(x)

plot(x , y , label="2cos(x)")
plot!(x , y2 , label="sin(x)" , xlabel="x")

end

question2()

#' ## Exercice 3 - Création d'une fonction

function question3()

fct1(x) = sin(x)^2

# Appel de la fonction sur un float
resultat = fct1(2.0)

# Appel de la fonction pour des vecteurs de float
x = LinRange(-2*pi,2*pi,1001)
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

plot(temps,y[:,1],label="y(t)")
plot!(temps,10 .* y[:,2],label="y'(t)",xlabel="Temps",title="Solution num. de l'EDO")

end

question4()
