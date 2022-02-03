using LinearAlgebra, Test
#JSO packages
using ADNLPModels, NLPModels, NLPModelsIpopt
# , NLPModelsKnitro
#This package
using Stopping, StoppingInterface
using BenchmarkTools

include("utils.jl")

for solver in (ipopt, lbfgs, trunk, tron)
  @testset "Compute overhead of using Stopping with $(string(solver))" begin
    T = Float64
    n = 100
    function f(x)
      n = length(x)
      return 100 * sum((x[i + 1] - x[i]^2)^2 for i = 1:(n - 1)) + sum((x[i] - 1)^2 for i = 1:(n - 1))
    end
    x0 = T.([i / (n + 1) for i = 1:n])
    nlp = ADNLPModel(f, x0, name = "genrose")
    tstp, tnlp = stopping_overhead(nlp, solver)
    median_overhead = (median(tstp).time - median(tnlp).time) # result in nanoseconds
    @show median_overhead / 1e9 # in seconds
    @test median_overhead < 0.05 * median(tnlp).time
  end
end

@testset "Rosenbrock with ∑x = 1" begin
  nlp = ADNLPModel(
    x -> (x[1] - 1.0)^2 + 100 * (x[2] - x[1]^2)^2,
    [-1.2; 1.0],
    x -> [sum(x) - 1],
    [0.0],
    [0.0],
  )
  sol = [-1.612771347383541; 2.612771347383541]
  stp = NLPStopping(nlp)
  @test status_stopping_to_stats(stp) == :unknown
  fill_in!(stp, sol)
  @test stop!(stp)
  status_stopping_to_stats(stp) == :first_order
  reinit!(stp, rstate = true, x = zeros(2))
  stp.meta.nb_of_stop = stp.meta.max_iter + 1
  fill_in!(stp, stp.current_state.x)
  @test stop!(stp)
  @test status_stopping_to_stats(stp) == :max_iter

  # reinit!(stp)
  # stp = knitro(stp)
  # @show status(stp), stp.current_state.x
  reinit!(stp)
  stp = ipopt(stp)
  @test status(stp) == :Optimal
end

for solver in (:lbfgs, :tron, :trunk, :ipopt)
  @testset "Rosenbrock with $solver" begin
    nlp = ADNLPModel(x -> (x[1] - 1.0)^2 + 100 * (x[2] - x[1]^2)^2, [-1.2; 1.0])
    sol = ones(2)
    stp = NLPStopping(nlp)
    @test status_stopping_to_stats(stp) == :unknown
    fill_in!(stp, sol)
    @test stop!(stp)
    status_stopping_to_stats(stp) == :first_order
    reinit!(stp, rstate = true, x = zeros(2))
    stp.meta.nb_of_stop = stp.meta.max_iter + 1
    fill_in!(stp, stp.current_state.x)
    @test stop!(stp)
    @test status_stopping_to_stats(stp) == :max_iter

    # reinit!(stp)
    # stp = knitro(stp)
    # @show status(stp), stp.current_state.x
    reinit!(stp)
    stp = eval(solver)(stp)
    @test status(stp) == :Optimal
  end
end

@testset "GSE status to meta" begin
  nlp = ADNLPModel(
    x -> (x[1] - 1.0)^2 + 100 * (x[2] - x[1]^2)^2,
    [-1.2; 1.0],
    x -> [sum(x) - 1],
    [0.0],
    [0.0],
  )
  stp = NLPStopping(nlp)
  StoppingInterface.stats_status_to_meta!(stp, :first_order)
  @test stp.meta.optimal
  reinit!(stp)
  StoppingInterface.stats_status_to_meta!(stp, :acceptable)
  @test stp.meta.suboptimal
  reinit!(stp)
  StoppingInterface.stats_status_to_meta!(stp, :infeasible)
  @test stp.meta.infeasible
  reinit!(stp)
  StoppingInterface.stats_status_to_meta!(stp, :small_step)
  @test stp.meta.stalled
  reinit!(stp)
  StoppingInterface.stats_status_to_meta!(stp, :max_eval)
  @test stp.meta.resources
  reinit!(stp)
  StoppingInterface.stats_status_to_meta!(stp, :max_iter)
  @test stp.meta.iteration_limit
  reinit!(stp)
  StoppingInterface.stats_status_to_meta!(stp, :max_time)
  @test stp.meta.tired
  reinit!(stp)
  StoppingInterface.stats_status_to_meta!(stp, :neg_pred)
  @test stp.meta.fail_sub_pb
  reinit!(stp)
  StoppingInterface.stats_status_to_meta!(stp, :not_desc)
  @test stp.meta.fail_sub_pb
  reinit!(stp)
  StoppingInterface.stats_status_to_meta!(stp, :unbounded)
  @test stp.meta.unbounded
  reinit!(stp)
  StoppingInterface.stats_status_to_meta!(stp, :user)
  @test stp.meta.stopbyuser
  reinit!(stp)
  StoppingInterface.stats_status_to_meta!(stp, :stalled)
  @test stp.meta.stalled
  reinit!(stp)
  StoppingInterface.stats_status_to_meta!(stp, :small_residual)
  @test stp.meta.stalled
  reinit!(stp)
  StoppingInterface.stats_status_to_meta!(stp, :small_step)
  @test stp.meta.stalled
end
