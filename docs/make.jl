using Documenter
using MTH2210

makedocs(
    modules = [MTH2210],
    sitename = "MTH2210.jl",
    authors = "Antonin Paquette and Alexis Montoison",
    format = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true"),
    pages = [
            "Accueil" => "index.md",
            "Mise en place" => "mise_en_place.md",
            "Julia vs MatLab" => "julia_vs_matlab.md",
            "Génération d'un rapport" => "generate_pdf.md",
            "Interpolation" => "interpolation.md",
            "Problèmes non-linéaires" => "prob_non_lin.md",
            "Équations différentielles ordinaires" => "edo.md",
            "Index des fonctions" => "fct_index.md"
            ]
    )

deploydocs(repo = "github.com/amontoison/MTH2210.jl.git")
