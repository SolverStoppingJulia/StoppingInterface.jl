var documenterSearchIndex = {"docs":
[{"location":"reference/#Reference","page":"Reference","title":"Reference","text":"","category":"section"},{"location":"reference/","page":"Reference","title":"Reference","text":"​","category":"page"},{"location":"reference/#Contents","page":"Reference","title":"Contents","text":"","category":"section"},{"location":"reference/","page":"Reference","title":"Reference","text":"​","category":"page"},{"location":"reference/","page":"Reference","title":"Reference","text":"Pages = [\"reference.md\"]","category":"page"},{"location":"reference/","page":"Reference","title":"Reference","text":"​","category":"page"},{"location":"reference/#Index","page":"Reference","title":"Index","text":"","category":"section"},{"location":"reference/","page":"Reference","title":"Reference","text":"​","category":"page"},{"location":"reference/","page":"Reference","title":"Reference","text":"Pages = [\"reference.md\"]","category":"page"},{"location":"reference/","page":"Reference","title":"Reference","text":"​","category":"page"},{"location":"reference/","page":"Reference","title":"Reference","text":"Modules = [StoppingInterface]","category":"page"},{"location":"reference/#JSOSolvers.R2-Tuple{Stopping.NLPStopping}","page":"Reference","title":"JSOSolvers.R2","text":"`R2(stp::NLPStopping; subsolver_verbose::Int = 0, kwargs...)`\n\nStopping-version of the R2 function from JSOSolvers.jl. This function calls fill_in! (doesn't update hessian) and stop! after R2 call, if the problem is a success (:first_order or :acceptable) and fill_in_on_success is true or if it failed and fill_in_on_failure is true. The keyword arguments are passed to the R2 call.\n\n\n\n\n\n","category":"method"},{"location":"reference/#JSOSolvers.lbfgs-Tuple{Stopping.NLPStopping}","page":"Reference","title":"JSOSolvers.lbfgs","text":"`lbfgs(stp::NLPStopping; subsolver_verbose::Int = 0, kwargs...)`\n\nStopping-version of the lbfgs function from JSOSolvers.jl. This function calls fill_in! (doesn't update hessian) and stop! after lbfgs call, if the problem is a success (:first_order or :acceptable) and fill_in_on_success is true or if it failed and fill_in_on_failure is true. The keyword arguments are passed to the lbfgs call.\n\n\n\n\n\n","category":"method"},{"location":"reference/#JSOSolvers.tron-Tuple{Stopping.NLPStopping}","page":"Reference","title":"JSOSolvers.tron","text":"`tron(stp::NLPStopping; subsolver_verbose::Int = 0, kwargs...)`\n\nStopping-version of the tron function from JSOSolvers.jl. This function calls fill_in! (doesn't update hessian) and stop! after tron call, if the problem is a success (:first_order or :acceptable) and fill_in_on_success is true or if it failed and fill_in_on_failure is true. The keyword arguments are passed to the tron call.\n\n\n\n\n\n","category":"method"},{"location":"reference/#JSOSolvers.trunk-Tuple{Stopping.NLPStopping}","page":"Reference","title":"JSOSolvers.trunk","text":"`trunk(stp::NLPStopping; subsolver_verbose::Int = 0, kwargs...)`\n\nStopping-version of the trunk function from JSOSolvers.jl. This function calls fill_in! (doesn't update hessian) and stop! after trunk call, if the problem is a success (:first_order or :acceptable) and fill_in_on_success is true or if it failed and fill_in_on_failure is true. The keyword arguments are passed to the trunk call.\n\n\n\n\n\n","category":"method"},{"location":"reference/#NLPModelsIpopt.ipopt-Tuple{Stopping.NLPStopping}","page":"Reference","title":"NLPModelsIpopt.ipopt","text":"`ipopt(stp::NLPStopping; subsolver_verbose::Int = 0, kwargs...)`\n\nStopping-version of the ipopt function from NLPModelsIpopt.jl. This function calls fill_in! (doesn't update hessian) and stop! after ipopt call, if the problem is a success (:first_order or :acceptable) and fill_in_on_success is true or if it failed and fill_in_on_failure is true.\n\nsubsolver_verbose corresponds to print_level argument in ipopt. Other keyword arguments are passed to the ipopt call. Selection of possible options.\n\n\n\n\n\n","category":"method"},{"location":"reference/#StoppingInterface.status_stopping_to_stats-Tuple{Stopping.AbstractStopping}","page":"Reference","title":"StoppingInterface.status_stopping_to_stats","text":"`status_stopping_to_stats(stp::AbstractStopping)`\n\nReturn the status in GenericExecutionStats from a Stopping.\n\n\n\n\n\n","category":"method"},{"location":"reference/#StoppingInterface.stopping_to_stats-Tuple{Stopping.NLPStopping}","page":"Reference","title":"StoppingInterface.stopping_to_stats","text":"`stopping_to_stats(stp::NLPStopping)`\n\nInitialize a GenericStats from Stopping\n\n\n\n\n\n","category":"method"},{"location":"#StoppingInterface.jl-–-An-interface-between-Stopping-the-rest-of-the-World","page":"Home","title":"StoppingInterface.jl – An interface between Stopping the rest of the World","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"(Image: CI) (Image: codecov) (Image: Stable) (Image: Dev) (Image: release) (Image: DOI)","category":"page"},{"location":"#How-to-Cite","page":"Home","title":"How to Cite","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"If you use StoppingInterface.jl in your work, please cite using the format given in CITATION.bib.","category":"page"},{"location":"#Installation","page":"Home","title":"Installation","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"pkg> add StoppingInterface","category":"page"},{"location":"","page":"Home","title":"Home","text":"You need to first add using Knitro, NLPModelsKnitro before calling the function knitro.","category":"page"},{"location":"#Example","page":"Home","title":"Example","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"using ADNLPModels, Stopping, StoppingInterface\n\n# Rosenbrock\nnlp = ADNLPModel(x -> (x[1] - 1)^2 + 100 * (x[2] - x[1]^2)^2, [-1.2; 1.0])\nstp = NLPStopping(nlp)\nlbfgs(stp) # update and returns `stp`\n\nstp.current_state.x # contains the solution\nstp.current_state.fx # contains the optimal value\nstp.current_state.gx # contains the gradient","category":"page"},{"location":"","page":"Home","title":"Home","text":"We refer to Stopping.jl for more documentation and StoppingTutorials.jl for tutorials.","category":"page"},{"location":"#Bug-reports-and-discussions","page":"Home","title":"Bug reports and discussions","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"If you think you found a bug, feel free to open an issue. Focused suggestions and requests can also be opened as issues. Before opening a pull request, start an issue or a discussion on the topic, please.","category":"page"},{"location":"tutorial/#Tutorial","page":"Tutorial","title":"Tutorial","text":"","category":"section"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"Pages = [\"tutorial.md\"]","category":"page"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"The StoppingInterface package offers a Stopping-compatible buffer of external solvers. The current list includes:","category":"page"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"ipopt via NLPModelsIpopt.jl;\nknitro via NLPModelsKnitro.jl;\nlbfgs, tron and trunk via JSOSolvers.jl.","category":"page"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"We explain below how to design your buffer.","category":"page"},{"location":"tutorial/#StoppingInterface-Tutorial:-use-a-buffer","page":"Tutorial","title":"StoppingInterface Tutorial: use a buffer","text":"","category":"section"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"In the case where one algorithm/solver is not Stopping-compatible, a buffer solver is required to unify the formalism.","category":"page"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"We illustrate this situation here with the Ipopt solver.","category":"page"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"Remark in the buffer function: If the solver stops with success but the stopping condition is not satisfied, one option is to iterate and reduce the various tolerances.","category":"page"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"using Ipopt, ADNLPModels, NLPModelsIpopt, Stopping\nnlp = ADNLPModel(x -> (x[1] - 1)^2 + 100 * (x[2] - x[1]^2)^2, [-1.2; 1.0])","category":"page"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"The traditional way to solve an optimization problem using NLPModelsIpopt.","category":"page"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"stats = ipopt(nlp, print_level = 0)","category":"page"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"Use y0 (general),zL (lower bound), and zU (upper bound) for the initial guess of Lagrange multipliers.","category":"page"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"Using Stopping, the idea is to create a buffer function.","category":"page"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"function solveIpopt(stp :: NLPStopping)\n\n  stats = ipopt(nlp, print_level     = 0,\n                     tol             = stp.meta.rtol,\n                     x0              = stp.current_state.x,\n                     max_iter        = stp.meta.max_iter,\n                     max_cpu_time    = stp.meta.max_time,\n                     dual_inf_tol    = stp.meta.atol,\n                     constr_viol_tol = stp.meta.atol,\n                     compl_inf_tol   = stp.meta.atol)\n\n  # Update the meta boolean with the output message\n  if stats.status == :first_order stp.meta.suboptimal      = true end\n  if stats.status == :acceptable  stp.meta.suboptimal      = true end\n  if stats.status == :infeasible  stp.meta.infeasible      = true end\n  if stats.status == :small_step  stp.meta.stalled         = true end\n  if stats.status == :max_iter    stp.meta.iteration_limit = true end\n  if stats.status == :max_time    stp.meta.tired           = true end\n\n  stp.meta.nb_of_stop = stats.iter\n  x = stats.solution\n\n  # Not mandatory, but in case some entries of the State are used to stop\n  fill_in!(stp, x)\n  stop!(stp)\n\n  return stp\nend","category":"page"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"We now illustrate the use of the buffer function. First, we define a NLPAtX state, a NLPStopping and use unconstrained_check optimality function.","category":"page"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"nlp_at_x = NLPAtX(nlp.meta.x0)\nstop = NLPStopping(nlp, nlp_at_x, optimality_check = unconstrained_check)","category":"page"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"In a first scenario, we solve again the problem with the buffer solver.","category":"page"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"solveIpopt(stop)\nstop.current_state.x, status(stop), stop.meta.nb_of_stop","category":"page"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"In a second scenario, we check the control on the maximum number of iterations.","category":"page"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"nbiter = stop.meta.nb_of_stop\nreinit!(stop, rstate = true, x = nlp.meta.x0) #rstate is set as true to allow reinit! modifying the State\nstop.meta.max_iter = max(nbiter - 4, 1)\n\nsolveIpopt(stop)\n# Final status is :IterationLimit\nstop.current_state.x, status(stop)","category":"page"}]
}
