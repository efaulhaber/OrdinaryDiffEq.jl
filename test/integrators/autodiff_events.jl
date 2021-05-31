using DiffEqSensitivity
using OrdinaryDiffEq, Calculus, Test
using Zygote

function f(du,u,p,t)
  du[1] = u[2]
  du[2] = -p[1]
end

function condition(u,t,integrator) # Event when event_f(u,t) == 0
  u[1]
end

function affect!(integrator)
  @show integrator.t
  println("bounced.")
  integrator.u[2] = -integrator.p[2]*integrator.u[2]
end

cb = ContinuousCallback(condition, affect!)
p = [9.8, 0.8]
prob = ODEProblem(f,eltype(p).([1.0,0.0]),eltype(p).((0.0,1.0)),copy(p))

solve(prob,Tsit5(),abstol=1e-14,reltol=1e-14,callback=cb,save_everystep=true)[end]

function test_f(p)
  _prob = remake(prob, p=p)
  solve(_prob,Tsit5(),abstol=1e-14,reltol=1e-14,callback=cb,save_everystep=false)[end]
end
findiff = Calculus.finite_difference_jacobian(test_f,p)
findiff

using ForwardDiff
ad = ForwardDiff.jacobian(test_f,p)
ad

@test ad ≈ findiff

function test_f2(p, sensealg=ForwardDiffSensitivity())
  _prob = remake(prob, p=p)
  u = Array(solve(_prob,Tsit5(),sensealg=sensealg,abstol=1e-14,reltol=1e-14,callback=cb,save_everystep=false))
  u[end]
end

@test test_f2(p) == test_f(p)[end]

g1 = Zygote.gradient(θ->test_f2(θ,ForwardDiffSensitivity()), p)
g2 = Zygote.gradient(θ->test_f2(θ,ReverseDiffAdjoint()), p)

@test g1[1] ≈ findiff[2,1:2]
@test g2[1] ≈ findiff[2,1:2]
