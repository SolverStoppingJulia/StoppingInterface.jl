# StoppingInterface.jl -- An interface between Stopping the rest of the World

![CI](https://github.com/SolverStoppingJulia/StoppingInterface.jl/workflows/CI/badge.svg?branch=main)
[![codecov](https://codecov.io/gh/SolverStoppingJulia/StoppingInterface.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/SolverStoppingJulia/StoppingInterface.jl)
[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://SolverStoppingJulia.github.io/StoppingInterface.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://SolverStoppingJulia.github.io/StoppingInterface.jl/dev/)
[![release](https://img.shields.io/github/v/release/SolverStoppingJulia/StoppingInterface.jl.svg?style=flat-square)](https://github.com/SolverStoppingJulia/StoppingInterface.jl/releases)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.6126665.svg)](https://doi.org/10.5281/zenodo.6126665)

## How to Cite

If you use StoppingInterface.jl in your work, please cite using the format given in [CITATION.bib](https://github.com/SolverStoppingJulia/StoppingInterface.jl/blob/main/CITATION.bib).

## Installation

1. `pkg> add StoppingInterface`

You need to first add `using Knitro, NLPModelsKnitro` before calling the function `knitro`.

## Example

```julia
using ADNLPModels, Stopping, StoppingInterface

# Rosenbrock
nlp = ADNLPModel(x -> (x[1] - 1)^2 + 100 * (x[2] - x[1]^2)^2, [-1.2; 1.0])
stp = NLPStopping(nlp)
lbfgs(stp) # update and returns `stp`

stp.current_state.x # contains the solution
stp.current_state.fx # contains the optimal value
stp.current_state.gx # contains the gradient
```

We refer to [Stopping.jl](https://github.com/vepiteski/Stopping.jl) for more documentation and [StoppingTutorials.jl](https://solverstoppingjulia.github.io/StoppingTutorials.jl/dev/) for tutorials.

# Bug reports and discussions

If you think you found a bug, feel free to open an [issue](https://github.com/SolverStoppingJulia/StoppingInterface.jl/issues).
Focused suggestions and requests can also be opened as issues. Before opening a pull request, start an issue or a discussion on the topic, please.
