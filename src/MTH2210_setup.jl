"""
Installation des packages nécessaires pour l'affichage de graphique et la
génération d'un rapport sous format pdf ou HTML.
"""
function MTH2210_setup()
    Pkg.add("Plots")
    Pkg.add("ORCA")
    Pkg.add("Weave")
end
