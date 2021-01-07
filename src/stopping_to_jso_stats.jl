using SolverTools

"""
Return the status in GenericStats from a Stopping.
"""
function status_stopping_to_stats(stp :: AbstractStopping)
 stp_status = status(stp)
 convert = Dict([(:Optimal, :first_order),
                 (:SubProblemFailure, :unknown),
                 (:SubOptimal, :acceptable),
                 (:Unbounded, :unbounded),
                 (:UnboundedPb, :unbounded),
                 (:Stalled, :stalled),
                 (:IterationLimit, :max_iter),
                 (:Tired, :max_time), #disapear from Stopping.jl#v0.2.5
                 (:TimeLimit, :max_time),
                 (:ResourcesExhausted, :max_eval), #disapear from Stopping.jl#v0.2.5
                 (:EvaluationLimit, :max_eval),
                 (:ResourcesOfMainProblemExhausted, :max_eval),
                 (:Infeasible, :infeasible),
                 (:DomainError, :exception),
                 (:Unknown, :unknown)
                 ])
 return convert[stp_status]
end

"""
Initialize a GenericStats from Stopping
"""
function stopping_to_stats(stp :: NLPStopping)
    return GenericExecutionStats(status_stopping_to_stats(stp), 
                                 stp.pb,
                                 solution     = stp.current_state.x,
                                 objective    = stp.current_state.fx,
                                 primal_feas  = norm(stp.current_state.cx, Inf),
                                 dual_feas    = norm(stp.current_state.res, Inf),
                                 multipliers  = stp.current_state.lambda,
                                 iter         = stp.meta.nb_of_stop,
                                 elapsed_time = stp.current_state.current_time - stp.meta.start_time)
end
