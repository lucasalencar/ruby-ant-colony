require_relative "util/file_tsp_reader"

def problem_class(problem)
  if problem == :shortest_path
    require_relative "problems/aco_shortest_path"
    ACOShortestPath
  elsif problem == :tsp
    require_relative "problems/aco_tsp"
    ACOTsp
  else
    raise "Problem not known."
  end
end

def read_example(example_path)
  puts "Reading file"
  FileTspReader.example(example_path, AntEnviroment)
end

def load_example(enviroment, start, problem, ops = {})
  # ACOTSP.new(enviroment, start_vertex, max_iterations, num_ants, alpha, beta, q, rho, dynamic_rho, min_rho, max_rho)
  problem_class(problem).new(enviroment, start, ops[:max_iterations], ops[:num_ants],
    alpha: ops[:alpha], beta: ops[:beta], q: ops[:q], rho: ops[:rho],
    dynamic_rho: ops[:dynamic_rho], min_rho: ops[:min_rho], max_rho: ops[:max_rho])
end
