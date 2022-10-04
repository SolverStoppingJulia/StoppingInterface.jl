import JSOSolvers: lbfgs, trunk, tron
for (fun, Solver) in ((:R2, :R2Solver), (:lbfgs, :LBFGSSolver), (:tron, TronSolver), (:trunk, :TrunkSolver))
  premeth = Meta.parse("JSOSolvers." * string(fun))
  @eval begin
    @doc """
        `$($fun)(stp::NLPStopping; subsolver_verbose::Int = 0, kwargs...)`

    Stopping-version of the $($fun) function from JSOSolvers.jl.
    This function calls `fill_in!` (doesn't update hessian) and `stop!` after $($fun) call,
    if the problem is a success (`:first_order` or `:acceptable`) and `fill_in_on_success` is true or if it failed and `fill_in_on_failure` is true.
    The keyword arguments are passed to the $($fun) call.
    """
    function $premeth(
      stp::NLPStopping;
      kwargs...,
    )
      nlp = stp.pb
      solver = $Solver(nlp)
      stats = GenericExecutionStats(nlp)
      return solve!(solver, stp, stats; kwargs...)
    end

    function SolverCore.solve!(
      solver::$Solver,
      stp::NLPStopping,
      stats::GenericExecutionStats;
      subsolver_verbose::Int = 0,
      fill_in_on_success = true,
      fill_in_on_failure = true,
      kwargs...,
    ) where {T, V}
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
  end
end
