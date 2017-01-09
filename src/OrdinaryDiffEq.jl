__precompile__()

module OrdinaryDiffEq

  using DiffEqBase

  import DiffEqBase: solve, solve!, init, step!, build_solution

  using Parameters, GenericSVD, ForwardDiff, InplaceOps, RecursiveArrayTools,
        NLsolve, Juno, Calculus, Roots, DataStructures

  import Base: linspace

  import Base: start, next, done, eltype

  import ForwardDiff.Dual

  import DiffEqBase: resize!,cache_iter,terminate!,get_du,
                     get_dt,get_proposed_dt,modify_proposed_dt!,
                     u_modified!,savevalues!

  #Constants

  const TEST_FLOPS_CUTOFF = 1e10

  include("misc_utils.jl")
  include("algorithms.jl")
  include("alg_utils.jl")
  include("caches.jl")
  include("integrators/unrolled_tableaus.jl")
  include("integrators/type.jl")
  include("integrators/integrator_utils.jl")
  include("integrators/fixed_timestep_integrators.jl")
  include("integrators/explicit_rk_integrator.jl")
  include("integrators/low_order_rk_integrators.jl")
  include("integrators/high_order_rk_integrators.jl")
  include("integrators/verner_rk_integrators.jl")
  include("integrators/feagin_rk_integrators.jl")
  include("integrators/implicit_integrators.jl")
  include("integrators/rosenbrock_integrators.jl")
  include("integrators/threaded_rk_integrators.jl")
  include("integrators/integrator_interface.jl")
  include("integrators/composite_integrator.jl")
  include("iterator_interface.jl")
  include("constants.jl")
  include("callbacks.jl")
  include("composite_solution.jl")
  include("solve.jl")
  include("initdt.jl")
  include("interp_func.jl")
  include("dense.jl")
  include("derivative_wrappers.jl")

  #General Functions
  export solve, solve!, init, step!

  #Callback Necessary
  export ode_addsteps!, ode_interpolant,
        @ode_callback, @ode_event, @ode_change_cachesize, @ode_change_deleteat,
        terminate!, savevalues!, copyat_or_push!, isfsal

  export constructDP5, constructVern6, constructDP8, constructDormandPrince, constructFeagin10,
        constructFeagin12, constructFeagin14

  # Reexport the Alg Types

  export OrdinaryDiffEqAlgorithm, OrdinaryDiffEqAdaptiveAlgorithm, OrdinaryDiffEqCompositeAlgorithm,
        Euler, Midpoint, RK4, ExplicitRK, BS3, BS5, DP5, DP5Threaded, Tsit5,
        DP8, Vern6, Vern7, Vern8, TanYam7, TsitPap8, Vern9, ImplicitEuler,
        Trapezoid, Rosenbrock23, Rosenbrock32, Feagin10, Feagin12, Feagin14,
        CompositeAlgorithm
end # module
