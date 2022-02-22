# Tutorial

```@contents
Pages = ["tutorial.md"]
```

The `StoppingInterface` package offers a Stopping-compatible buffer of external solvers.
The current list includes:
- `ipopt` via [NLPModelsIpopt.jl](https://github.com/JuliaSmoothOptimizers/NLPModelsIpopt.jl);
- `knitro` via [NLPModelsKnitro.jl](https://github.com/JuliaSmoothOptimizers/NLPModelsKnitro.jl);
- `lbfgs`, `tron` and `trunk` via [JSOSolvers.jl](https://github.com/JuliaSmoothOptimizers/NLPModelsIpopt.jl).

We explain below how to design your buffer.

## StoppingInterface Tutorial: use a buffer

In the case where one algorithm/solver is not Stopping-compatible,
a buffer solver is required to unify the formalism.

We illustrate this situation here with the Ipopt solver.

**Remark in the buffer function:** If the solver stops with success
but the stopping condition is not satisfied, one option is to iterate
and reduce the various tolerances.

```@example 1
using Ipopt, ADNLPModels, NLPModelsIpopt, Stopping
nlp = ADNLPModel(x -> (x[1] - 1)^2 + 100 * (x[2] - x[1]^2)^2, [-1.2; 1.0])
```

The traditional way to solve an optimization problem using [NLPModelsIpopt](https://github.com/JuliaSmoothOptimizers/NLPModelsIpopt.jl).
```@example 1
stats = ipopt(nlp, print_level = 0)
```
Use `y0` (general),`zL` (lower bound), and `zU` (upper bound) for the initial guess of Lagrange multipliers.

Using Stopping, the idea is to create a buffer function.
```@example 1
function solveIpopt(stp :: NLPStopping)

  stats = ipopt(nlp, print_level     = 0,
                     tol             = stp.meta.rtol,
                     x0              = stp.current_state.x,
                     max_iter        = stp.meta.max_iter,
                     max_cpu_time    = stp.meta.max_time,
                     dual_inf_tol    = stp.meta.atol,
                     constr_viol_tol = stp.meta.atol,
                     compl_inf_tol   = stp.meta.atol)

  # Update the meta boolean with the output message
  if stats.status == :first_order stp.meta.suboptimal      = true end
  if stats.status == :acceptable  stp.meta.suboptimal      = true end
  if stats.status == :infeasible  stp.meta.infeasible      = true end
  if stats.status == :small_step  stp.meta.stalled         = true end
  if stats.status == :max_iter    stp.meta.iteration_limit = true end
  if stats.status == :max_time    stp.meta.tired           = true end

  stp.meta.nb_of_stop = stats.iter
  x = stats.solution

  # Not mandatory, but in case some entries of the State are used to stop
  fill_in!(stp, x)
  stop!(stp)

  return stp
end
```

We now illustrate the use of the buffer function. First, we define a `NLPAtX` state, a `NLPStopping` and use `unconstrained_check` optimality function.
```@example 1
nlp_at_x = NLPAtX(nlp.meta.x0)
stop = NLPStopping(nlp, nlp_at_x, optimality_check = unconstrained_check)
```

In a first scenario, we solve again the problem with the buffer solver.
```@example 1
solveIpopt(stop)
stop.current_state.x, status(stop), stop.meta.nb_of_stop
```

In a second scenario, we check the control on the maximum number of iterations.
```@example 1
reinit!(stop, rstate = true, x = nlp.meta.x0) #rstate is set as true to allow reinit! modifying the State
stop.meta.max_iter = max(nbiter-4,1)

solveIpopt(stop)
# Final status is :IterationLimit
stop.current_state.x, status(stop)
```
