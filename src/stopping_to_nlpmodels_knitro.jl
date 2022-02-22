#Check https://github.com/JuliaSmoothOptimizers/NLPModelsKnitro.jl/blob/master/src/NLPModelsKnitro.jl
#=
*General options*
algorithm: Indicates which algorithm to use to solve the problem
blasoption: Specifies the BLAS/LAPACK function library to use for basic vector 
            and matrix computations
cg_maxit: Determines the maximum allowable number of inner conjugate gradient 
          (CG) iterations
cg_pmem: Specifies number of nonzero elements per hessian column when computing 
         preconditioner
cg_precond: Specifies whether or not to apply preconditioning during 
            CG iterations in barrier algorithms
cg_stoptol: Relative stopping tolerance for CG subproblems
convex: Identify convex models and apply specializations often beneficial for convex models
delta: Specifies the initial trust region radius scaling factor
eval_fcga: Specifies that gradients are provided together with functions in one callback
honorbnds: Indicates whether or not to enforce satisfaction of simple variable bounds
initpenalty: Initial penalty value used in Knitro merit function
linesearch_maxtrials: Indicates the maximum allowable number of trial points during the linesearch
linesearch: Indicates which linesearch strategy to use for the Interior/Direct or SQP algorithm
linsolver_ooc: Indicates whether to use Intel MKL PARDISO out-of-core solve of linear systems
linsolver: Indicates which linear solver to use to solve linear systems arising in Knitro algorithms
linsolver_maxitref
linsolver_pivottol
objrange: Specifies the extreme limits of the objective function for purposes of determining unboundedness
          Default value: 1.0e20
presolve: Determine whether or not to use the Knitro presolver
presolve_initpt: Controls whether Knitro presolver can shift user-supplied initial point
restarts: Specifies whether to enable automatic restarts
restarts_maxit: Maximum number of iterations before restarting when restarts are enabled
scale: Specifies whether to perform problem scaling
soc: Specifies whether or not to try second order corrections (SOC)
strat_warm_start: Specifies whether or not to invoke a warm-start strategy

*Derivatives options*
bfgs_scaling: Specifies the initial scaling for the BFGS or L-BFGS Hessian approximation
derivcheck: Determine whether or not to perform a derivative check on the model
gradopt: Specifies how to compute the gradients of the objective and constraint functions
hessian_no_f: Determines whether or not to allow Knitro to request Hessian 
              evaluations without the objective component included.
hessopt: Specifies how to compute the (approximate) Hessian of the Lagrangian
         1 (exact) User provides a routine for computing the exact Hessian. (Default)
         4 (product_findiff) Knitro computes Hessian-vector products using finite-differences.
         5 (product) User provides a routine to compute the Hessian-vector products.
         6 (lbfgs) Knitro computes a limited-memory quasi-Newton BFGS Hessian 
                   (its size is determined by the option lmsize).
lmsize: Specifies the number of limited memory pairs stored when approximating the Hessian

*Termination options*
feastol: Specifies the final relative stopping tolerance for the feasibility error.
         Default value: 1.0e-6
feastol_abs: Specifies the final absolute stopping tolerance for the feasibility error.
             Default value: 1.0e-3
fstopval: Used to implement a custom stopping condition based on the objective function value
ftol: The optimization process will terminate if feasible and the relative change 
      in the objective function is less than ftol
      Default value: 1.0e-15
ftol_iters: The optimization process will terminate if the relative change in 
            the objective function is less than ftol for ftol_iters consecutive 
            feasible iterations. Default value: 5

maxfevals: Specifies the maximum number of function evaluations before termination.
           Default value: -1 (unlimited)
maxit: Specifies the maximum number of iterations before termination
       0 is default value, let Knitro set it (10000 for LP/NLP)
maxtime_cpu: Specifies, in seconds, the maximum allowable CPU time before termination. 
             Default value: 1.0e8
maxtime_real: Specifies, in seconds, the maximum allowable real time before termination. 
              Default value: 1.0e8
opttol: Specifies the final relative stopping tolerance for the KKT (optimality) error
        Default value: 1.0e-6
opttol_abs: Specifies the final absolute stopping tolerance for the KKT (optimality) error
            Default value: 1.0e-3
xtol: The optimization process will terminate if the relative change of the 
      solution point estimate is less than xtol. Default value: 1.0e-12
xtol_iters: Number of consecutive iterations where change of the solution point 
            estimate is less than xtol before Knitro stops.
            Default is 1

*Output options*
out_hints: Print diagnostic hints (e.g. on user option settings) after solving
           0 no prints, and 1 prints (default in Knitro)
outlev: Controls the level of output produced by Knitro
        0 (none) Printing of all output is suppressed.
        1 (summary) Print only summary information.
        2 (iter_10) Print basic information every 10 iterations. (default in Knitro)
=#

@init begin
  @require KNITRO = "67920dd8-b58e-52a8-8622-53c4cffbe346" begin
    @require NLPModelsKnitro = "bec4dd0d-7755-52d5-9a02-22f0ffc7efcb" begin
      is_knitro_installed = true
      import NLPModelsKnitro: knitro

      """
          `knitro(stp::NLPStopping; subsolver_verbose::Int = 0, kwargs...)`

      Stopping-version of the `knitro` function from NLPModelsKnitro.jl.
      This function calls `stop!` after `knitro` call.
      Use the `KnitroSolver` structure to fill-in the gradient and objective in the state.

      `subsolver_verbose` corresponds to `print_level` argument in `knitro`.
      Other keyword arguments are passed to the `knitro` call.
      Selection of possible [options](https://www.artelys.com/docs/knitro/3_referenceManual/userOptions.html).

      It requires `using KNITRO, NLPModelsKnitro`.
      """
      function NLPModelsKnitro.knitro(
        stp::NLPStopping;
        convex::Int = -1, #let Knitro deal with it :)
        objrange::Real = stp.meta.unbounded_threshold,
        hessopt::Int = 1,
        feastol::Real = stp.meta.rtol,
        feastol_abs::Real = stp.meta.atol,
        opttol::Real = stp.meta.rtol,
        opttol_abs::Real = stp.meta.atol,
        maxfevals::Int = min(stp.meta.max_cntrs[:neval_sum], typemax(Int32)),
        maxit::Int = 0, #stp.meta.max_iter
        maxtime_real::Real = stp.meta.max_time,
        out_hints::Int = 0,
        subsolver_verbose::Int = 0, #1 to see everything
        algorithm::Int = 0, # *New* 2
        ftol::Real = 1.0e-15, # *New*
        ftol_iters::Int = 5, # *New*
        xtol::Real = stp.meta.atol, # 1.0e-12, # *New*
        xtol_iters::Int = 2, # 3 # *New*
        kwargs...,
      )
        @assert -1 ≤ convex ≤ 1
        @assert 1 ≤ hessopt ≤ 7
        @assert 0 ≤ out_hints ≤ 1
        @assert 0 ≤ subsolver_verbose ≤ 6
        @assert 0 ≤ maxit

        nlp = stp.pb
        #y0 = stp.current_state.lambda #si défini
        #z0 = stp.current_state.mu #si défini 
        solver = NLPModelsKnitro.KnitroSolver(
          nlp,
          x0 = stp.current_state.x,
          objrange = objrange,
          feastol = feastol,
          feastol_abs = feastol_abs,
          opttol = opttol,
          opttol_abs = opttol_abs,
          maxfevals = maxfevals,
          maxit = maxit,
          maxtime_real = maxtime_real,
          out_hints = out_hints,
          algorithm = algorithm,
          ftol = ftol,
          ftol_iters = ftol_iters,
          xtol = xtol,
          xtol_iters = xtol_iters,
          outlev = subsolver_verbose;
          kwargs...,
        )
        stats = NLPModelsKnitro.knitro!(nlp, solver)
        #@show stats.status, stats.solver_specific[:internal_msg]
        #if stats.status ∉ (:unbounded, :exception, :unknown) #∈ (:first_order, :acceptable) 
        stp.current_state.x = stats.solution
        stp.current_state.fx = stats.objective
        stp.current_state.gx = KNITRO.KN_get_objgrad_values(solver.kc)[2]
        #norm(stp.current_state.gx, Inf)#stats.dual_feas #TODO: this is for unconstrained problem!!
        stp.current_state.mu = stats.multipliers_L
        stp.current_state.current_score = max(stats.dual_feas, stats.primal_feas)
        #end
        #Update the meta boolean with the output message
        stp = stats_status_to_meta!(stp, stats)
        #@show status(stp, list = true)
        if status(stp) == :Unknown
          @warn "Error in StoppingInterface statuses: return status is $(stats.status)"
          #print(stats)
        end

        return stp #would be better to return the stats somewhere
      end

      export knitro
    end
  end
end
