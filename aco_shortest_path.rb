require_relative "aco"

class ACOShortestPath < ACO
  # Strength of pheromone on decision probability (between 0 and 1)
  Alpha = 1
  # Strength of heuristic on decision probability (between 0 and 1)
  Beta = 1
  # Rate of pheromone evaporation (between 0 and 1)
  Rho = 0.5
  # Rate of pheromone increase
  Q = 1.0

  def initialize(start_vertex, max_iterations = 5, num_ants = 15)
    super(
      ACO.test_enviroment,
      start_vertex,
      max_iterations,
      num_ants,
      alpha: Alpha, beta: Beta, rho: Rho, q: Q
    )
  end

  def best_ant(ants)
    ants.min_by { |ant| @enviroment.total_weight(ant.path) }
  end

  def better_solution?(path_a, path_b)
    @enviroment.total_weight(path_a) < @enviroment.total_weight(path_b)
  end
end

a = ACOShortestPath.new('A')
a.run
