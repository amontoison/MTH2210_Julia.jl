push!(LOAD_PATH,"C:\\Users\\Antonin\\Documents\\Antonin\\Maitrise\\MTH2210_codes\\New_codes\\MTH2210_Julia\\src")

using Documenter, DocumenterLaTeX, MTH2210_Julia

makedocs(
    sitename = "MTH2210 Julia",
    modules = [MTH2210_Julia],
    format = Documenter.HTML(prettyurls = false),
    #format = LaTeX(),
    pages = Any[
            "Accueil" => "accueil.md",
            "Mise en place" => "mise_en_place.md",
            "Julia vs MatLab" => "julia_vs_matlab.md",
            "Génération d'un rapport" => "generate_pdf.md",
            "Interpolation" => "interpolation.md",
            "Problèmes non-linéaires" => "prob_non_lin.md",
            "Équations différentielles ordinaires" => "edo.md",
            "Index des fonctions" => "fct_index.md"
                ]
    )
