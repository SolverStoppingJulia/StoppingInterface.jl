import JSOSolvers: lbfgs, trunk, tron
for fun in (:lbfgs, :trunk, :tron)
  premeth = Meta.parse("JSOSolvers." * string(fun))
  @eval begin
    function $premeth(stp::NLPStopping; subsolver_verbose::Int = 0, kwargs...)
      max_ev = if :neval_obj in keys(stp.meta.max_cntrs)
        stp.meta.max_cntrs[:neval_obj]
      else
        typemax(Int)
      end

      nlp = stp.pb
      T = eltype(nlp.meta.x0)
      stats = $fun(
        nlp,
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
      #stats.elapsed_time

      x = stats.solution

      #Not mandatory, but in case some entries of the State are used to stop
      fill_in!(stp, x) #too slow

      stop!(stp)

      return stp
    end
  end
end
