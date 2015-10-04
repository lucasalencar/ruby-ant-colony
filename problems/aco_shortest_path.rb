require_relative "../aco/aco"

class ACOShortestPath < ACO
  def initialize(enviroment, start_vertex, max_iterations = 5, num_ants = 15,
    alpha: 1, beta: 1, q: 1, rho: 0.5, dynamic_rho: true, min_rho: 0.3, max_rho: 0.7)
    super(
      enviroment,
      start_vertex,
      max_iterations,
      num_ants,
      alpha, beta, q,
      rho, dynamic_rho,
      max_rho, min_rho
    )
  end

  def optimization_value(solution)
    solution.size
  end
end
