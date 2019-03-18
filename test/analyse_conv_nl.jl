"""
Script vérifiant les algorithmes de résolution d'équations non-linéaires
"""

using Plots
using Statistics
push!(LOAD_PATH,"C:\\Users\\Antonin\\Documents\\Antonin\\Maitrise\\MTH2210_codes\\New_codes\\MTH2210_Julia\\src")
using MTH2210_Julia

alpha	=	(1+sqrt(5))/2

# Vérification des ordre de convergence pour bissect, secante, newton1D
# Premier problème
fct1(x)		= 	x^2 - 2
d_fct1(x)	=	2*x

x0	=	0.5
x1	=	3.

(approx_bis1 , err_bis1) = bissec(fct1 , x0 , x1 , 200 , 1e-12)
(approx_sec1 , err_sec1) = secante(fct1 , x0 , x1 , 200 , 1e-12)
(approx_new1 , err_new1) = newton1D(fct1 , d_fct1, x1 , 200 , 1e-12)

err_ex_bis1		=	abs.(approx_bis1 .- sqrt(2))
err_ex_sec1		=	abs.(approx_sec1 .- sqrt(2))
err_ex_new1		=	abs.(approx_new1 .- sqrt(2))


# Calcul des ratios

ratio1_sec_fct1			=	err_ex_sec1[2:end]./err_ex_sec1[1:end-1]
ratio_alpha_sec_fct1	=	err_ex_sec1[2:end]./err_ex_sec1[1:end-1].^alpha
ratio2_sec_fct1			=	err_ex_sec1[2:end]./err_ex_sec1[1:end-1].^2

ratio1_new_fct1			=	err_ex_new1[2:end]./err_ex_new1[1:end-1]
ratio_alpha_new_fct1	=	err_ex_new1[2:end]./err_ex_new1[1:end-1].^alpha
ratio2_new_fct1			=	err_ex_new1[2:end]./err_ex_new1[1:end-1].^2

plot(err_ex_bis1[err_ex_bis1 .> 0],label="Bissection")
plot!(err_ex_sec1[err_ex_sec1 .> 0],label="Sécante")
plot!(err_ex_new1[err_ex_new1 .> 0],label="Newton",yscale=:log10)

# Vérification des ordre de convergence pour bissect, secante, newton1D
# Deuxième problème

fct2(x)		=	exp(x) - x^3
d_fct2(x)	=	exp(x) - 3*x^2

x0	=	0.5
x1	=	3.


(approx_bis2 , err_bis2) = bissec(fct2 , x0 , x1 , 200 , 1e-12)
(approx_sec2 , err_sec2) = secante(fct2 , x0 , x1 , 200 , 1e-12)
(approx_new2 , err_new2) = newton1D(fct2 , d_fct2, x1 , 200 , 1e-12)

# Calcul des ratios

ratio1_sec_fct2			=	err_sec2[2:end]./err_sec2[1:end-1]
ratio_alpha_sec_fct2	=	err_sec2[2:end]./err_sec2[1:end-1].^alpha
ratio2_sec_fct2			=	err_sec2[2:end]./err_sec2[1:end-1].^2

ratio1_new_fct2			=	err_new2[2:end]./err_new2[1:end-1]
ratio_alpha_new_fct2	=	err_new2[2:end]./err_new2[1:end-1].^alpha
ratio2_new_fct2			=	err_new2[2:end]./err_new2[1:end-1].^2


plot(err_bis2[err_bis2 .> 0],label="Bissection")
plot!(err_sec2[err_sec2 .> 0],label="Sécante")
plot!(err_new2[err_new2 .> 0],label="Newton",yscale=:log10)


# Vérification de Newton pour racines multiples

fct3(x)		=	x*sin(x)^2
d_fct3(x)	=	sin(x)^2 + 2*x*sin(x)*cos(x)

(approx_new3 , err_new3) = newton1D(fct3 , d_fct3, 1. , 200 , 1e-12)
(approx_new4 , err_new4) = newton1D(fct3 , d_fct3, 3. , 200 , 1e-12)

err_ex_new3		=	abs.(approx_new3 .- 0)
err_ex_new4		=	abs.(approx_new4 .- pi)

ratio1_new_fct3		=	err_ex_new3[2:end]./err_ex_new3[1:end-1] # Racine de multiplicité 3
ratio1_new_fct4		=	err_ex_new4[2:end]./err_ex_new4[1:end-1] # Racine de multiplicité 2


# Vérification de la méthode des points-fixes pour ordre 1

fct4(x)	=	-x^2/10 + x + 1
taux	=	-2*sqrt(10)/10 + 1

(approx_ptf5 , err_ptf5) = ptfixes(fct4 , 1. , 200 , 1e-12)

err_ex_ptf5		=	abs.(approx_ptf5 .- sqrt(10))

ratio1_ptf5		=	err_ex_ptf5[2:end]./err_ex_ptf5[1:end-1]


# Vérification de la méthode des points-fixes pour ordre 2

fct5(x)	=	-x^2/6 + x + 9/6
taux2	=	-1/6

(approx_ptf6 , err_ptf6) = ptfixes(fct5 , 1. , 200 , 1e-12)

err_ex_ptf6		=	abs.(approx_ptf6 .- 3)

ratio1_ptf6		=	err_ex_ptf6[2:end]./err_ex_ptf6[1:end-1]
ratio2_ptf6		=	err_ex_ptf6[2:end]./err_ex_ptf6[1:end-1].^2



# Vérification des fonctions newton_ND_avec_der et newton_ND_sans_der

fct6(x)	=	[5*sin(0.1*x[1]*x[2]) - x[3] ,
			 x[1]^2 + x[2]^2 + x[3]^2 - 9 ,
			 x[1] - x[2] - x[3] - 1]

jac_fct6(x)	=	[5*0.1*x[2]*cos(0.1*x[1]*x[2])  5*0.1*x[1]*cos(0.1*x[1]*x[2])  -1 ;
				 2*x[1]  2*x[2]  2*x[3] ;
				 1  -1  -1]

x0 = [1. ; 1. ; 1.]

(approx_sans_6 , err_sans_6) = newtonND(fct6 , x0 , 100 , 1e-12)
(approx_avec_6 , err_avec_6) = newtonNDder(fct6 , jac_fct6 , x0 , 100 , 1e-12)

ratio1_sans_6		=	err_sans_6[2:end]./err_sans_6[1:end-1]
ratio_alpha_sans_6	=	err_sans_6[2:end]./err_sans_6[1:end-1].^alpha
ratio2_sans_6		=	err_sans_6[2:end]./err_sans_6[1:end-1].^2

ratio1_avec_6		=	err_avec_6[2:end]./err_avec_6[1:end-1]
ratio_alpha_avec_6	=	err_avec_6[2:end]./err_avec_6[1:end-1].^alpha
ratio2_avec_6		=	err_avec_6[2:end]./err_avec_6[1:end-1].^2
