module StoppingInterface

using LinearAlgebra, Stopping

using SolverTools
include("stopping_to_jso_stats.jl")
export status_stopping_to_stats, stopping_to_stats

using NLPModelsIpopt
include("stopping_to_nlpmodels_ipopt.jl")
export ipopt

using NLPModelsKnitro
include("stopping_to_nlpmodels_knitro.jl")
export knitro

end # module
