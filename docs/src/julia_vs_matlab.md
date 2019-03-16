# Julia vs MatLab

Cette page se veut une description sommaire des différences entre les languages
de programmation MatLab et Julia. Cette page ne se veut pas être une revue
exhaustive ni complète des différences entre ces deux langages, mais un sommaire
permettant à un utilisateur habitué à MatLab de pouvoir être minimalement fonctionnel
sur Julia. Un complément d'informations peut être trouvé sur cette page web de
la documentation de Julia [Noteworthy Differences from other Languages](https://docs.julialang.org/en/v1/manual/noteworthy-differences/).

Une des différences majeures entre Julia et MatLab est que MatLab représente par
défaut ces données dans dans des matrices contenant des `Float64`, tandis que
Julia type *fortement* ces variables. Notamment, Julia distingue les `integer` et
les `float` à l'aide d'un point `.` suivant immédiatemment le nombre. Par exemple,
la commande suivante crée un `integer` (`Int64` sur la majorité des machines):

```@repl 1
a = 3
typeof(a)
```
Alors que la syntaxe suivante crée un `float` (`Float64` sur la majorité des machines)

```@repl 1
b = 3.
typeof(b)
```

Aussi, Julia fait la différence
entre une variable de type `Float64` et un vecteur contenant des `Float64`.

```@repl 1
c = -1.
d = [-1.]
```

Ceci engendre donc des différences dans l'utilisation de certaines fonctions.
Par exemple, si l'on veut calculer les valeurs absolues d'un `Float64` et les
valeurs absolues des éléments d'un vecteur (ou d'une matrice), on obtient les
résultats suivants:

```@repl 1
abs(c)
abs(d)
```

Il sera indiqué à la section [`Opérations sur des vecteurs et des matrices`](@ref creation_vec_mat)
comment effectuer cette opération simple à effectuer sur MatLab.

## Création de vecteurs et de matrices

La première différence notable avec MatLab est le fait que Julia distingue les
vecteurs des matrices. Les vecteurs sont des `array` de dimension 1, alors que
les matrices sont des `array` dimension 2. En Julia, la convention adoptée est
de type *column-major order*, les vecteurs sont de type colonne. Afin de créer
un vecteur sur Julia, on emploie les crochets `[]` et on sépare les éléments par
des virgules ou des point-virgules `;`.

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

Pour les opérateurs logiques, il faut aussi employer le `.` afin de comparer
*éléments par éléments*.

```@repl 3
2 == B
2 .== B
2 .<= B

B<C
B.<C
```

!!! warning "Important"
    Étant donné que le point `.` permet à la fois de définir un `float` et d'effectuer
    les opérations *éléments par éléments*, il faut mettre des espaces entre les
    points afin de pouvoir distinguer la signification de chaque point `.`. La
    commande suivante

    ```repl
    5.+[1,2]
    ```
    Produira le message d'erreur suivant:

    ```repl
    ERROR: syntax: invalid syntax "5.*"; add space(s) to clarify
    ```

    Il faut alors utiliser la syntaxe suivante:

    ```
    5. .+ [1,2]
    ```

Les fonctions mathématiques standards définies sur ``\mathbb{R}`` n'acceptent
pas des vecteurs sous Julia. Il faut donc employer le point `.` immédiatemment
après le nom de la fonction afin d'appliquer la fonction *élément par élément*.

```@repl 3
cos(v)
cos.(v)
mod(B,3)
mod.(B,3)
```

Cette syntaxe s'applique à toute les fonctions écrit sur Julia, que cela soit
les fonctions des librairies standards de Julia ou des fonctions créées par
l'utilisateur.


    !!! warning "Avertissement"

        Certaines fonctions mathématiques sont définies sur des matrices carrés, tels
        les fonctions trigonométriques, l'exponentiation et la puissance. Il faut
        donc faire attention à savoir si l'on veut effectuer ces opérations sur la
        matrice ou sur les éléments de la matrice. L'exemple suivant illustre ces
        différences:

        ```repl
        M=[0 1 ; 2 -1]
        exp(M)
        ```
        produit le résultat suivant:

        ```repl
        2×2 Array{Float64,2}:
        1.8573   0.860982
        1.72196  0.996317
        ```

        alors que la commande suivante:

        ```repl
        exp.(M)
        ```

        effectue l'exponentiation *élément par élément*:

        ```repl
        2×2 Array{Float64,2}:
        1.0      2.71828
        7.38906  0.367879
        ```



## Indexation et *slices* et concaténation de vecteurs et de matrices

On accède aux éléments d'un vecteur ou d'une matrice à l'aide des crochets `[]`
comparativement à MatLab ou l'on accède aux éléments avec les parenthèse `()`.
Le reste de la syntaxe est identique à celle de MatLab, la numérotation commence
à 0 et le dernier élément peut être extrait avec `end`. Les dimensions sont aussi
séparées par des virgules `,`.

```@repl 4
w=[-1,2,3]
E=[1 2 3 ; 4 5 6 ; 7 8 9]

w[2:end]
E[[1,3],1:2]
E[[1,3],[1:2]]
```

La dernière commande engendre une erreur, ce qui permet d'illustrer une subtile
différence entre Julia et MatLab. MatLab interprète la commande `[1:2]` en créant
un vecteur contenant `[1,2]`, alors que Julia crée un *array* d'*array*, ce qui
génère l'erreur.

La concaténation s'effectue selon la même logique que la création d'une matrice,
on emploie l'espace pour concaténer horizontalement et le point-virgule `;` pour concaténer
verticalement  

```@repl 4
[E E]
[E;E]
[w E]
[E ; w']
```

La syntaxe pour modifier un ou des éléments d'un vecteur ou d'une matrice est
la même que sur MatLab. Toutefois, puisque Julia est *fortement typé*, les
commandes suivantes produisent des erreurs étant donné que les types ne concordent pas.

```@repl 4
E[1,1] = [-1]
E[2:3,[1,3]] = -4
```

En comparaison, les commandes suivantes ne produisent pas d'erreurs:

```@repl 4
E[1,1] = -1
E[1:1,1] = [-1]
E[2:3,[1,3]] .= -4
```

## Passer par valeur ou par référence?

Une différence majeure entre MatLab et Julia est le fait que MatLab effectue des
copies de ces variables, alors que 


## Scope des variables

global scope vs parent scope vs local scope

## fprintf vs println vs @printf

## Plot

semilogy et loglog n'accepte pas les zeros


## Fonctions usuelles

norme vecteur vs norme matrice
maximum,minimum
linspace


```@example
a = 1
b = 2
a + b
```
