# Mise en place de Julia

Les étapes permettant d'installer [Julia](https://julialang.org/) ainsi que les
programmes nécessaires afin d'obtenir une interface de type *IDE* avec
l'éditeur [Atom](https://atom.io/).

## Installation de Julia

Le langage de programmation Julia peut être téléchargée sur le site web
[Download Julia](https://julialang.org/downloads/). La version v1 ou une
version plus récente doit être téléchargée.

## Installation d'Atom et des autres packages

L'éditeur de texte [Atom](https://atom.io/) doit être téléchargé. Il faut
ensuite télécharger le package [Juno](http://junolab.org/) sur Atom. Pour ce
faire, une fois Atom ouvert, il faut aller dans `Setting` via le menu `File` ou
avec la commande `Ctrl+,`. Une fois dans `Setting`, sélectionnez l'onglet
`Install` et suivez les étapes suivantes:

1. Installez le package `uber-juno`
2. Ouvrez les `Settings` du package `uber-juno` et assurez vous que l'option *Disable - Don't run installation when Atom boots* est déselectionné.
3. Redémarrez l'éditeur Atom. Atom devrait alors installer de nouveaux packages.
4. Redémarrez une dernière fois l'éditeur Atom.

Une nouvelle barre d'outils devrait apparaître sur l'interface d'Atom. Si cette
barre n'est pas visible, vous pouvez la faire apparaître/disparaître avec la
commande `Ctrl+Alt+T`. De plus, sous le menu Packages d'Atom, une entrée Julia
devrait maintenant être présente. Si vous rencontrez des problèmes, assurez vous
que les packages suivants d'Atom sont installés:

- latex-completion
- indent-detective
- ink
- julia-client
- language-julia
- tool-bar

!!! warning "Avertissement"

    Vous devez vous assurer que les packages d'Atom soit capable de trouver
    l'éxécutable de Julia. Pour ce faire, vérifiez en cliquant sur le menu Package,
    puis Julia puis Settings si le champ *Julia Path* est vide. Si c'est le cas,
    indiquez l'emplacement de l'éxécutable de Julia, habituellement `C:\Users\VotreNom\AppData\Local\Julia-version\bin\julia.exe`.


## Installation du package MTH2210_Julia

Afin d'installer le package `MTH2210_Julia`, vous devez éxécuter la commande
suivante dans la console de Julia.

```julia
Pkg.add(PackageSpec(url="https://github.com/AntoninPaquette/MTH2210_Julia.jl.git", rev="master"))
```

Les packages suivants doivent aussi être installés:

- Affichage de graphique : [Plots](http://docs.juliaplots.org/latest/),
- Génération d'un rapport : [Weave](http://weavejl.mpastell.com/stable/).

Pour ce faire, vous devez appeler la fonction MTH2210_setup

```julia
MTH2210_setup()
```
