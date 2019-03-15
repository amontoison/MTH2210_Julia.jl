# Julia vs MatLab

Cette page se veut une description sommaire des différences entre les languages
de programmation MatLab et Julia.

Une des différences majeures entre Julia et MatLab est que MatLab représente par
défaut ces données dans dans des matrices contenant des `Float64`, tandis que
Julia type *fortement* ces variables. Par exemple, Julia fait la différence
entre une variable de type `Float64` et un vecteur contenant des `Float64`.

```@repl 1
a = -1.
b = [-1.]
```

Ceci engendre donc des différences dans l'utilisation de certaines fonctions.
Par exemple, si l'on veut calculer les valeurs absolues d'un `Float64` et les
valeurs absolues des éléments d'un vecteur (ou d'une matrice), on obtient les
résultats suivants:

```@repl 1
abs(a)
abs(b)
```

Il sera indiqué à la section [`Opérations sur des vecteurs et des matrices`](@ref creation_vec_mat)
comment effectuer cette opération simple à effectuer sur MatLab.

!!! warning "Avertissement"

    Certaines fonctions mathématiques sont définies sur des matrices carrés, tels
    les fonctions trigonométriques, l'exponentiation et la puissance. Il faut
    donc faire attention à savoir si l'on veut effectuer ces opérations sur la
    matrice ou sur les éléments de la matrice.

## Création de vecteurs et de matrices

La première différence notable avec MatLab est le fait que Julia distingue les
vecteurs des matrices. Les vecteurs sont des `array` de dimension 1, alors que
les matrices sont des `array` dimension 2. En Julia, les vecteurs ne sont alors
ni de type ligne ni colonne. Afin de créer un vecteur sur Julia, on emploie les
crochets `[]` et on sépare les éléments par des virgules ou des point-virgules `;`.

```@repl 2
x = [1,2,3]
y = [1;2;3]
```

Les matrices sont quant à elles créées encore à l'aide de crochets `[]`, mais
les éléments sur une même ligne doivent être séparés pas des espaces et un saut
de ligne s'indique par le point-virgule `;`.

```@repl 2
A = [1 2 3; 4 5 6]
```

!!! note
    La commande suivante créera un `array` de dimension 2 possédant une ligne
    et 3 colonnes au lieu d'un vecteur

    ```@repl 2
    z = [1 2 3]
    ```

## [Opérations sur des vecteurs et des matrices](@id creation_vec_mat)

Julia récupère quelques éléments syntaxiques de MatLab concernant les opérations
sur des vecteurs ou des matrices mais diffère sur quelques points. Comme dans
MatLab, les opérations *élément par élément* s'effectuent à l'aide du point `.`.
Ainsi, les opérations suivantes sont les mêmes que sur MatLab.

```@repl 3
v=[1,2]
B=[1 2 ; 3 4]
C=[5 -6 ; -7 8]

B*C
B.*C

B^2
B.^2

B*v
B.*v
```

La multiplication d'un vecteur ou une matrice par un nombre est définie comme sur
MatLab.

```@repl 3
2.5*v
2.5*B
C/3
```

Les opérations différentes concernent notamment les opérations d'addition/soustraction
et les comparaison logique. L'addition/soustraction d'un nombre et d'un vecteur/matrice
n'est pas définie en Julia, il faut donc utiliser le `.`.

```@repl 3
2 + B
2 .+ B
B - C
B .- C
```

Passer par valeur ou référence

Passer un array de dim 1x1 dans un autre array (float vs array(float))

## fprintf vs println vs @printf

## Plot

semilogy et loglog n'accepte pas les zeros

# Scope des variables

global scope vs parent scope vs local scope


# Fonctions usuelles

norme vecteur vs norme matrice
maximum,minimum
linspace
