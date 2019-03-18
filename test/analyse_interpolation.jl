"""
Script vérifiant les algorithmes d'interpolation
"""

using Plots
#using Test
push!(LOAD_PATH,"C:\\Users\\Antonin\\Documents\\Antonin\\Maitrise\\MTH2210_codes\\New_codes\\MTH2210_Julia\\src")
using MTH2210_Julia
using LinearAlgebra
using Statistics

# Vérification de la fonction lagrange pour polynôme 1

fct1(x)	=	(x-1) * (x+2.5) * (x-pi) * (x+11)^2

xi		=	[-10,-2,4,pi,-exp(1),0]
yi		=	fct1.(xi)
xfin	=	LinRange(minimum(xi),maximum(xi),1000)

y_inter		=	lagrange(xi,yi,xfin)
y_exacte	=	fct1.(xfin)

err_rel1	=	norm(y_exacte - y_inter)/norm(y_exacte)
#@test err_rel1 < 1e-12


# Vérification de la fonction lagrange pour polynôme 2

fct2(x)	= 	(x-2)^2 * (x+5)^3 * (x-exp(1))^4

xi		=	LinRange(-2,2,10)
yi		=	fct2.(xi)
xfin	=	LinRange(minimum(xi),maximum(xi),1000)

y_inter		=	lagrange(xi,yi,xfin)
y_exacte	=	fct2.(xfin)

err_rel2	=	norm(y_exacte - y_inter)/norm(y_exacte)
@test err_rel2 < 1e-12

# Vérification avec un fonction quelconque

fct3(x)	=	exp(x)

degre	=	3
nb_pts	=	degre + 1
nb_loop		=	10

x_interet	=	1 .+ [1/2^nb_loop]
erreur 		=	zeros(nb_loop)

for t=1:nb_loop
	xi	=	1 .+ LinRange(-1/2^(t-1),1/2^(t-1),nb_pts)
	yi	=	fct3.(xi)

	y_inter		=	lagrange(xi,yi,x_interet)
	erreur[t]	=	norm(fct3.(x_interet) - y_inter);
end

ordre	=	log.(erreur[1:end-1]./erreur[2:end]) ./ log(2)
#@test abs(mean(ordre) - (degre+1)) < 0.1

# Vérification de la fonction splinec

fct4(x)		=	-4*x^3 + pi*x^2 + 11*x - exp(1)
d_fct4(x)	=	-12*x^2 + 2*pi*x + 11
d2_fct4(x)	=	-24*x .+ 2*pi

a		=	-5
b		=	4
nb_pts	=	3

xi	=	LinRange(a,b,nb_pts)
yi	=	fct4.(xi)
x	=	LinRange(a,b,1000)
y_exacte	=	fct4.(x)

Sx1 = splinec( xi , yi , x , [2,2] , [d2_fct4(a),d2_fct4(b)])
err_rel_spline1	=	norm(y_exacte - Sx1)/norm(y_exacte)
