require_relative "ant"
require_relative "ant_enviroment"

require "pry"

# Shortest path solution: [A B C D E A]

class ACO
  # Strength of pheromone on decision probability (between 0 and 1)
  Alpha = 1
  # Strength of heuristic on decision probability (between 0 and 1)
  Beta = 1
  # Rate of pheromone evaporation (between 0 and 1)
  Rho = 0.5
  # Rate of pheromone increase
  Q = 1.0

  def initialize(start_vertex, max_iterations = 10, num_ants = 5)
    @max_iterations = max_iterations
    @num_ants = num_ants
    @start_vertex = start_vertex
    @enviroment = ACO.test_enviroment
  end

  def generate_ants
    ants = [nil] * @num_ants
    ants.map do
      Ant.new(@start_vertex)
    end
  end

  def run
    @enviroment.reset_pheromones
    @max_iterations.times do
      @ants = generate_ants
      # Ants find a path using pheromones
      @ants.each { |ant| ant.construct_solution(@enviroment, Alpha, Beta) }
      @ants.delete_if { |ant| not ant.alive? }
      # Update pheromones
      @enviroment.evaporate(Rho)
      @ants.each { |ant| @enviroment.update_pheromones(ant.path, Q) }
      # if Local solution better than global, become global solution
      best_solution = best_ant(@ants).path
      if @solution.nil? or better_solution?(best_solution, @solution)
        @solution = best_solution
      end
    end
    p @enviroment
    puts "Solution: #{@solution.inspect}"
  end

  def best_ant(ants)
    ants.min_by { |ant| @enviroment.total_weight(ant.path) }
  end

  def better_solution?(path_a, path_b)
    @enviroment.total_weight(path_a) < @enviroment.total_weight(path_b)
  end

  def self.test_enviroment
    g = AntEnviroment.new(('A'..'E').to_a)
    g.add_edges('A', [{v: 'B', w: 2}, {v: 'D', w: 12}, {v: 'E', w: 5}])
    g.add_edges('B', [{v: 'A', w: 2}, {v: 'C', w: 4}, {v: 'D', w: 8}])
    g.add_edges('C', [{v: 'B', w: 4}, {v: 'D', w: 3}, {v: 'E', w: 3}])
    g.add_edges('D', [{v: 'B', w: 8}, {v: 'C', w: 3}, {v: 'A', w: 12}, {v: 'E', w: 10}])
    g.add_edges('E', [{v: 'A', w: 5}, {v: 'C', w: 3}, {v: 'D', w: 10}])
    g
  end
end

a = ACO.new('A')
a.run