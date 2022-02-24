import NLPModelsIpopt: ipopt

"""
    `ipopt(stp::NLPStopping; subsolver_verbose::Int = 0, kwargs...)`

Stopping-version of the `ipopt` function from NLPModelsIpopt.jl.
This function calls `fill_in!` (doesn't update hessian) and `stop!` after `ipopt` call,
if the problem is a success (`:first_order` or `:acceptable`) and `fill_in_on_success` is true or if it failed and `fill_in_on_failure` is true.

`subsolver_verbose` corresponds to `print_level` argument in `ipopt`.
Other keyword arguments are passed to the `ipopt` call.
Selection of possible [options](https://coin-or.github.io/Ipopt/OPTIONS.html#OPTIONS_REF).
"""
function NLPModelsIpopt.ipopt(
  stp::NLPStopping;
  subsolver_verbose::Int = 0,
  fill_in_on_success = true,
  fill_in_on_failure = true,
  kwargs...,
)
  stp.meta.start_time = time()
  #xk = solveIpopt(stop.pb, stop.current_state.x)
  nlp = stp.pb
  stats = ipopt(
    nlp;
    print_level = subsolver_verbose,
    tol = stp.meta.rtol,
    x0 = stp.current_state.x,
    max_iter = stp.meta.max_iter,
    max_cpu_time = stp.meta.max_time,
    dual_inf_tol = stp.meta.atol,
    constr_viol_tol = stp.meta.atol,
    compl_inf_tol = stp.meta.atol,
    kwargs...,
  )

  #Update the meta boolean with the output message
  #=
  if stats.status == :first_order stp.meta.suboptimal      = true end
  if stats.status == :acceptable  stp.meta.suboptimal      = true end
  if stats.status == :infeasible  stp.meta.infeasible      = true end
  if stats.status == :small_step  stp.meta.stalled         = true end
  if stats.status == :max_eval    stp.meta.max_eval        = true end
  if stats.status == :max_iter    stp.meta.iteration_limit = true end
  if stats.status == :max_time    stp.meta.tired           = true end
  if stats.status ∈ [:neg_pred, 
                     :not_desc]   stp.meta.fail_sub_pb     = true end
  if stats.status == :unbounded   stp.meta.unbounded       = true end
  if stats.status == :user        stp.meta.stopbyuser      = true end
  if stats.status ∈ [:stalled, 
                     :small_residual,
                     :small_step]   stp.meta.stalled       = true end
  #if stats.status == :exception   stp.meta.exception      = true end #available ≥ 0.2.6
  =#
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
