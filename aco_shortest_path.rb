require_relative "aco/aco"
require_relative "aco/ant"
require_relative "aco/ant_enviroment"
require_relative "util/file_tsp_reader"

class ACOShortestPath < ACO
  # Strength of pheromone on decision probability (between 0 and 1)
  Alpha = 1
  # Strength of heuristic on decision probability (between 0 and 1)
  Beta = 1
  # Rate of pheromone evaporation (between 0 and 1)
  Rho = 0.5
  # Rate of pheromone increase
  Q = 1.0

  def initialize(enviroment, start_vertex, max_iterations = 5, num_ants = 15)
    super(
      enviroment,
      start_vertex,
      max_iterations,
      num_ants,
      alpha: Alpha, beta: Beta, rho: Rho, q: Q
    )
  end
end

a = ACOShortestPath.new('A')
a.run('E')
puts "Solution: #{a.solution}"