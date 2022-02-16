module StoppingInterface

using LinearAlgebra, Stopping

using SolverCore
include("stopping_to_jso_stats.jl")
export status_stopping_to_stats, stopping_to_stats

using JSOSolvers
include("stopping_to_jsosolvers.jl")
export lbfgs, tron, trunk

using NLPModelsIpopt
include("stopping_to_nlpmodels_ipopt.jl")
export ipopt

using Requires
is_knitro_installed = false
include("stopping_to_nlpmodels_knitro.jl")

end # module