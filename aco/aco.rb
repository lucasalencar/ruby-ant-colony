require_relative "ant"
require_relative "ant_enviroment"

class ACO
  attr_reader :alpha, :beta, :rho, :q, :solution, :max_rho, :min_rho

  DEBUG = false
  SHOW_PROGRESS = false

  def initialize(enviroment, start_vertex, max_iterations, num_ants,
    alpha = 1, beta = 1, q = 1, rho = 0.5, dynamic_rho = true, min_rho = 0.3, max_rho = 0.7)
    @enviroment = enviroment
    @start_vertex = start_vertex
    @max_iterations = max_iterations
    @num_ants = num_ants
    @alpha = alpha
    @beta = beta
    @q = q

    # Dynamic Rho
    @dynamic_rho = dynamic_rho
    @initial_rho = rho
    @rho = rho
    @rho_iterations = 0

    @min_rho = min_rho
    @max_rho = max_rho
  end

  def dynamic_rho?
    @dynamic_rho
  end

  def optimization_value(solution)
    @enviroment.total_weight(solution)
  end

  def generate_ants(target_state)
    ants = [nil] * @num_ants
    ants.map do
      Ant.new(@start_vertex, target_state)
    end
  end

  def best_ant(ants)
    ants.min_by { |ant| optimization_value(ant.path) }
  end

  def better_solution?(path_a, path_b)
    optimization_value(path_a) < optimization_value(path_b)
  end

  # Shortest path solution: [A B C D E A]
  def self.test_enviroment
    g = AntEnviroment.new(('A'..'E').to_a)
    g.add_edges('A', [{v: 'B', w: 2}, {v: 'D', w: 12}, {v: 'E', w: 5}])
    g.add_edges('B', [{v: 'A', w: 2}, {v: 'C', w: 4}, {v: 'D', w: 8}])
    g.add_edges('C', [{v: 'B', w: 4}, {v: 'D', w: 3}, {v: 'E', w: 3}])
    g.add_edges('D', [{v: 'B', w: 8}, {v: 'C', w: 3}, {v: 'A', w: 12}, {v: 'E', w: 10}])
    g.add_edges('E', [{v: 'A', w: 5}, {v: 'C', w: 3}, {v: 'D', w: 10}])
    g
  end

  def run(target_state)
    @enviroment.reset_pheromones
    @max_iterations.times do |iteration|
      puts "\n~> Iteration: #{iteration + 1}." if SHOW_PROGRESS
      construct_ant_solution(target_state)
      puts if SHOW_PROGRESS
      update_pheromones
      store_solution unless @ants.empty?
    end
  end

  private

  # Generate ants and makes ants contruct solutions
  def construct_ant_solution(target_state)
    @ants = generate_ants(target_state)
    puts "Constructing solution with #{@ants.size} ants." if DEBUG
    @ants.each do |ant|
      ant.construct_solution(@enviroment, @alpha, @beta)
      if SHOW_PROGRESS
        print '.'; $stdout.flush
      end
    end
    @ants.delete_if { |ant| not ant.alive? }
  end

  # Update pheromones on the enviroment
  # based on the paths found by ants
  def update_pheromones
    puts "Updating pheromones with #{@ants.size} ants." if DEBUG
    @enviroment.evaporate(@rho)
    @ants.each do |ant|
      @enviroment.update_pheromones(ant.path, optimization_value(ant.path), @q)
    end
  end

  # if solution found is better than global, becomes global
  def store_solution
    best_solution = best_ant(@ants).path
    if @solution.nil? or better_solution?(best_solution, @solution)
      puts "Best solution so far: #{best_solution.inspect}" if SHOW_PROGRESS
      puts "Optimization value: #{optimization_value(best_solution)}" if SHOW_PROGRESS
      @solution = best_solution
      increase_rho if dynamic_rho?
    else
      decrease_rho if dynamic_rho?
    end
  end

  # Decreases evaporation rate depending on iterations without improvements
  def decrease_rho
    if @rho >= @min_rho and @rho < @max_rho
      @rho_iterations += 1 if @rho_iterations < 10
      update_rho
    end
  end

  def increase_rho
    if @rho > @min_rho and @rho <= @max_rho
      @rho_iterations -= 1 if @rho_iterations > -10
      update_rho
    end
  end

  def update_rho
    @rho = @initial_rho + (@rho_iterations / 10.0)
    @rho = @rho.round(1)
    puts "Updated evaporation rate to #{@rho}" if DEBUG
  end

  # Reset rho value
  def reset_rho
    @rho_iterations = 0
    @rho = @initial_rho
  end
end
