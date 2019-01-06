# Mise en place de Julia

Le langage de programmation Julia peut être téléchargée sur le site web
[Download Julia](https://julialang.org/downloads/). La version v1 ou une
version plus récente doit être téléchargée.

## Installation des packages nécessaires au cours

Certains packages de Julia doivent être téléchargées afin de pouvoir afficher
des graphiques, employer les fonctions du cours ou publier un rapport sous
format pdf. Le script [MTH2210\_setup.jl](../../src/MTH2210_setup.jl) doit être téléchargé et
exécuté à l'aide de la commande suivante:

```julia
include("MTH2210_setup.jl")
```

Les packages suivants seront installés grâce à ce script:

- Affichage de graphique : [Plots](http://docs.juliaplots.org/latest/)
- Génération d'un rapport : [Weave](http://weavejl.mpastell.com/stable/)
- Fonctions du cours : MTH2210_Julia
