"""
    `R2(stp::NLPStopping; subsolver_verbose::Int = 0, kwargs...)`

Stopping-version of the R2 function from JSOSolvers.jl.
This function calls `fill_in!` (doesn't update hessian) and `stop!` after R2 call,
if the problem is a success (`:first_order` or `:acceptable`) and `fill_in_on_success` is true or if it failed and `fill_in_on_failure` is true.
The keyword arguments are passed to the R2 call.
"""
JSOSolvers.R2(stp::NLPStopping; kwargs...) = solve!(JSOSolvers.R2Solver(stp.pb), stp; kwargs...)

"""
    `lbfgs(stp::NLPStopping; subsolver_verbose::Int = 0, kwargs...)`

Stopping-version of the lbfgs function from JSOSolvers.jl.
This function calls `fill_in!` (doesn't update hessian) and `stop!` after lbfgs call,
if the problem is a success (`:first_order` or `:acceptable`) and `fill_in_on_success` is true or if it failed and `fill_in_on_failure` is true.
The keyword arguments are passed to the lbfgs call.
"""
JSOSolvers.lbfgs(stp::NLPStopping; kwargs...) =
  solve!(JSOSolvers.LBFGSSolver(stp.pb), stp; kwargs...)

"""
    `tron(stp::NLPStopping; subsolver_verbose::Int = 0, kwargs...)`

Stopping-version of the tron function from JSOSolvers.jl.
This function calls `fill_in!` (doesn't update hessian) and `stop!` after tron call,
if the problem is a success (`:first_order` or `:acceptable`) and `fill_in_on_success` is true or if it failed and `fill_in_on_failure` is true.
The keyword arguments are passed to the tron call.
"""
JSOSolvers.tron(stp::NLPStopping; kwargs...) = solve!(JSOSolvers.TronSolver(stp.pb), stp; kwargs...)

"""
    `trunk(stp::NLPStopping; subsolver_verbose::Int = 0, kwargs...)`

Stopping-version of the trunk function from JSOSolvers.jl.
This function calls `fill_in!` (doesn't update hessian) and `stop!` after trunk call,
if the problem is a success (`:first_order` or `:acceptable`) and `fill_in_on_success` is true or if it failed and `fill_in_on_failure` is true.
The keyword arguments are passed to the trunk call.
"""
JSOSolvers.trunk(stp::NLPStopping; kwargs...) =
  solve!(JSOSolvers.TrunkSolver(stp.pb), stp; kwargs...)

function SolverCore.solve!(
  solver::Union{
    JSOSolvers.R2Solver,
    JSOSolvers.LBFGSSolver,
    JSOSolvers.TronSolver,
    JSOSolvers.TrunkSolver,
  },
  stp::NLPStopping,
  stats::GenericExecutionStats;
  subsolver_verbose::Int = 0,
  fill_in_on_success = true,
  fill_in_on_failure = true,
  kwargs...,
)
  max_ev = if :neval_obj in keys(stp.meta.max_cntrs)
    stp.meta.max_cntrs[:neval_obj]
  else
    typemax(Int)
  end

  stp.meta.start_time = time()

  nlp = stp.pb
  T = eltype(nlp.meta.x0)
  stats = solve!(
    solver,
    nlp,
    stats;
    verbose = subsolver_verbose,
    atol = T(stp.meta.atol),
    rtol = T(stp.meta.rtol),
    x = stp.current_state.x,
    # max_iter = stp.meta.max_iter,
    max_time = stp.meta.max_time,
    max_eval = max_ev,
    kwargs...,
  )

  stp = stats_status_to_meta!(stp, stats)

  if status(stp) == :Unknown
    @warn "Error in StoppingInterface statuses: return status is $(stats.status)"
    @show stats.solver_specific
  end

  stp.meta.nb_of_stop = stats.iter
  Stopping._update_time!(stp.current_state, time()) # stats.elapsed_time

  success = stats.status ∈ [:first_order, :acceptable]
  if (success && fill_in_on_success) || (!success && fill_in_on_failure)
    x = stats.solution
    # Not mandatory, but in case some entries of the State are used to stop
    fill_in!(stp, x, Hx = stp.current_state.Hx)

    stop!(stp)
  end

  return stp
end
