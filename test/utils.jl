# https://juliaci.github.io/BenchmarkTools.jl/dev/manual/
function stopping_overhead(nlp::AbstractNLPModel, solver::Function)
    stp = NLPStopping(nlp)
    max_ev = if :neval_obj in keys(stp.meta.max_cntrs)
      stp.meta.max_cntrs[:neval_obj]
    else
      typemax(Int)
    end
    fun(nlp) = if solver == ipopt
      ipopt(
        nlp,
        print_level = 0,
        tol = stp.meta.rtol,
        x0 = stp.current_state.x,
        max_iter = stp.meta.max_iter,
        max_cpu_time = stp.meta.max_time,
        dual_inf_tol = stp.meta.atol,
        constr_viol_tol = stp.meta.atol,
        compl_inf_tol = stp.meta.atol,
      )
    else
      solver(
        nlp,
        verbose = 0,
        atol = stp.meta.atol,
        rtol = stp.meta.rtol,
        # max_iter = stp.meta.max_iter,
        max_time = stp.meta.max_time,
        max_eval = max_ev,
      )
    end
    fun(nlp) # for pre-compilation
    let nlp = nlp, stp = stp, solver = solver, fun = fun
        global tnlp = @benchmark $fun($nlp)
        @show tnlp
        global tstp = @benchmark $solver($stp)
        @show tstp
    end
    return tstp, tnlp
  end
  