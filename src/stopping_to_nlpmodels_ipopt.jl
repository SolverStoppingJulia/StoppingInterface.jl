import NLPModelsIpopt: ipopt

"""
ipopt(nlp) DOESN'T CHECK THE WRONG KWARGS, AND RETURN AN ERROR.

ipopt(::NLPStopping)

"""
function NLPModelsIpopt.ipopt(stp :: NLPStopping; kwargs...)

 #xk = solveIpopt(stop.pb, stop.current_state.x)
 nlp = stp.pb
 stats = ipopt(nlp, print_level     = 0,
                    tol             = stp.meta.rtol,
                    x0              = stp.current_state.x,
                    max_iter        = stp.meta.max_iter,
                    max_cpu_time    = stp.meta.max_time,
                    dual_inf_tol    = stp.meta.atol,
                    constr_viol_tol = stp.meta.atol,
                    compl_inf_tol   = stp.meta.atol,
                    kwargs...)

 #Update the meta boolean with the output message
 if stats.status == :first_order stp.meta.suboptimal      = true end
 if stats.status == :acceptable  stp.meta.suboptimal      = true end
 if stats.status == :infeasible  stp.meta.infeasible      = true end
 if stats.status == :small_step  stp.meta.stalled         = true end
 if stats.status == :max_iter    stp.meta.iteration_limit = true end
 if stats.status == :max_time    stp.meta.tired           = true end

 stp.meta.nb_of_stop = stats.iter
 #stats.elapsed_time

 x = stats.solution

 #Not mandatory, but in case some entries of the State are used to stop
 #fill_in!(stp, x) #too slow

 stop!(stp)

 return stp
end
