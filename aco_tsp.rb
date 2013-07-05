require_relative "aco/aco"
require_relative "aco/ant"
require_relative "aco/ant_enviroment"
require_relative "util/file_tsp_reader"

class ACOTsp < ACO
  # Strength of pheromone on decision probability (between 0 and 1)
  Alpha = 1
  # Strength of heuristic on decision probability (between 0 and 1)
  Beta = 1
  # Rate of pheromone evaporation (between 0 and 1)
  Rho = 0.5
  # Activates dynamic rho
  Dynamic_rho = true
  # Limits rho value
  Min_rho = 0.3
  Max_rho = 0.7
  # Rate of pheromone increase
  Q = 1.0

  def initialize(enviroment, start_vertex, max_iterations = 20, num_ants = 100)
    super(
      enviroment,
      start_vertex,
      max_iterations,
      num_ants,
      alpha: Alpha, beta: Beta, q: Q,
      rho: Rho, dynamic_rho: Dynamic_rho,
      max_rho: Max_rho, min_rho: Min_rho
    )
  end

  def run
    super(@start_vertex)
  end
end

class Ant
  def reached_end?
    has_all_vertices = @current_enviroment.vertices.keys.all? do |vertex|
      @path.include?(vertex)
    end
    has_all_vertices and @current_enviroment.has_edge?(@path.first, @path.last)
  end
end

puts "Reading file"
enviroment = FileTspReader.example('./benchmarks/tsplib/att48.tsp', AntEnviroment)
a = ACOTsp.new(enviroment, '1')
puts "Running algorithm"
a.run
puts
puts "Solution: #{a.solution}"
puts "Solution size: #{a.solution.size}"
puts "Solution optimum value: #{enviroment.total_weight(a.solution)}"