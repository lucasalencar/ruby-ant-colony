require_relative "aco/ant_enviroment"
require_relative "running"

begin
  options = {
    max_iterations: 10,
    num_ants: 100,
    alpha: 1, # Strength of pheromone on decision probability (between 0 and 1)
    beta: 1, # Strength of heuristic on decision probability (between 0 and 1)
    q: 1.0, # Rate of pheromone increase
    dynamic_rho: true, # Activates dynamic rho
    rho: 0.5, # Rate of pheromone evaporation (between 0 and 1)
    min_rho: 0.3, # Min limit for rho
    max_rho: 0.7 # Max limit for rho
  }
  enviroment = read_example('./benchmarks/tsplib/att48.tsp')
  a = load_example(enviroment, '1', :tsp, options)
  puts "Running algorithm"
  a.run
rescue Interrupt
  puts "Interrupted!"
end

at_exit do
  unless a.solution.nil?
    puts "\nSolution: #{a.solution}"
    puts "Solution size: #{a.solution.size}"
    puts "Solution optimum value: #{enviroment.total_weight(a.solution)}"
  else
    puts "No solution found."
  end
end