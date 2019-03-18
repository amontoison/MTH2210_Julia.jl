"""
Installation des packages nécessaires pour l'affichage de graphiques et la
génération d'un rapport sous format pdf ou HTML.
"""
function MTH2210_setup()
    Pkg.add("Plots")
    Pkg.add("PlotlyJS")
    Pkg.add("ORCA")
    Pkg.add("Weave")
end
