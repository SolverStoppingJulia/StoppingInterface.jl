module StoppingInterface

using LinearAlgebra, NLPModels, Requires, SparseArrays, Stopping

using SolverCore
include("stopping_to_jso_stats.jl")
export status_stopping_to_stats, stopping_to_stats

@init begin
  @require JSOSolvers = "10dff2fc-5484-5881-a0e0-c90441020f8a" begin
    include("stopping_to_jsosolvers.jl")
  end

  @require NLPModelsIpopt = "f4238b75-b362-5c4c-b852-0801c9a21d71" begin
    include("stopping_to_nlpmodels_ipopt.jl")
  end

  @require NLPModelsKnitro = "bec4dd0d-7755-52d5-9a02-22f0ffc7efcb" begin
    @require KNITRO = "67920dd8-b58e-52a8-8622-53c4cffbe346" begin
      include("stopping_to_nlpmodels_knitro.jl")
    end
  end
end

function SolverCore.solve!(solver::AbstractOptimizationSolver, stp::NLPStopping; kwargs...)
  stats = GenericExecutionStats(stp.pb)
  solve!(solver, stp, stats; kwargs...)
end

end # module
