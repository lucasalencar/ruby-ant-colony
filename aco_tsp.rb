require_relative "aco"

class ACOTsp < ACO
  # Strength of pheromone on decision probability (between 0 and 1)
  Alpha = 1
  # Strength of heuristic on decision probability (between 0 and 1)
  Beta = 1
  # Rate of pheromone evaporation (between 0 and 1)
  Rho = 0.5
  # Rate of pheromone increase
  Q = 1.0

  def initialize(start_vertex, max_iterations = 10, num_ants = 5)
    super(
      ACO.test_enviroment,
      start_vertex,
      max_iterations,
      num_ants,
      alpha: Alpha, beta: Beta, rho: Rho, q: Q
    )
  end
end

a = ACOTsp.new('A')
a.run
