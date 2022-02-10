using ADNLPModels
using Documenter
using Printf
using StoppingInterface

makedocs(
  modules = [StoppingInterface],
  doctest = true,
  # linkcheck = true,
  strict = true,
  format = Documenter.HTML(
    assets = ["assets/style.css"],
    prettyurls = get(ENV, "CI", nothing) == "true",
  ),
  sitename = "StoppingInterface.jl",
  pages = ["Home" => "index.md", "Tutorial" => "tutorial.md", "Reference" => "reference.md"],
)

deploydocs(repo = "github.com/SolverStoppingJulia/StoppingInterface.jl.git", devbranch = "main")
