# Résolution de problèmes non-linéaires

Cette section est dédiée à la résolution de problèmes non-linéaires. Deux types de problèmes non-linéaires sont étudiés, le premier est le problème de recherche de racines ``r \in \mathbb{R}^n`` de ``F:\mathbb{R}^n \to \mathbb{R}^n``:

`` F(r) = 0``.

Les algorithmes disponibles pour trouver les racines d'une fonction ``F`` sont:
1. Bissection pour ``n=1`` : [`bissec`](@ref),
2. Sécante pour ``n=1`` : [`secante`](@ref),
3. Newton avec dérivée pour ``n=1`` : [`newton1D`](@ref),
4. Newton avec dérivée pour ``n\geq 1`` : [`newtonNDder`](@ref),
5. Newton sans dérivée pour ``n\geq 1`` : [`newtonND`](@ref).

Le deuxième type de problème à résoudre est le problème de recherche d'un point fixe ``z \in \mathbb{R}^n`` d'une fonction ``G:\mathbb{R}^n \to \mathbb{R}^n``:

``G(z) = z``.

L'algorithme disponible pour trouver les points-fixes d'une fonction ``g`` est:
1. Point-fixe pour ``n=1`` : [`ptfixes`](@ref)


# Exemple de résolution d'une équation non-linéaire
