require_relative "ant"
require_relative "ant_enviroment"

# Shortest path solution: [A B C D E A]

class ACO
  attr_reader :alpha, :beta, :rho, :q, :solution

  def initialize(enviroment, start_vertex, max_iterations, num_ants, alpha: 1, beta: 1, rho: 0.5, q: 1)
    @enviroment = enviroment
    @start_vertex = start_vertex
    @max_iterations = max_iterations
    @num_ants = num_ants
    @alpha = alpha
    @beta = beta
    @rho = rho
    @q = q
  end

  def generate_ants(target_state)
    ants = [nil] * @num_ants
    ants.map do
      Ant.new(@start_vertex, target_state)
    end
  end

  def run(target_state)
    @enviroment.reset_pheromones
    @max_iterations.times do |iteration|
      puts
      puts "~> Iteration: #{iteration}."
      @ants = generate_ants(target_state)
      # Ants find a path using pheromones
      puts "Constructing solution with #{@ants.size} ants."
      @ants.each { |ant| ant.construct_solution(@enviroment, @alpha, @beta); print '.'; $stdout.flush }
      @ants.delete_if { |ant| not ant.alive? }
      puts
      # Update pheromones
      puts "Updating pheromones with #{@ants.size} ants."
      @enviroment.evaporate(@rho)
      @ants.each { |ant| @enviroment.update_pheromones(ant.path, optimization_value(ant.path), @q) }
      # if Local solution better than global, become global solution
      unless @ants.empty?
        best_solution = best_ant(@ants).path
        if @solution.nil? or better_solution?(best_solution, @solution)
          puts "Best solution so far: #{best_solution.inspect}"
          puts "Optimization value: #{optimization_value(best_solution)}"
          @solution = best_solution
        end
      end
    end
  end

  def best_ant(ants)
    ants.min_by { |ant| optimization_value(ant.path) }
  end

  def better_solution?(path_a, path_b)
    optimization_value(path_a) < optimization_value(path_b)
  end

  def optimization_value(solution)
    @enviroment.total_weight(solution)
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
