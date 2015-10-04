require_relative "../aco/aco"

class ACOTsp < ACO
  def initialize(enviroment, start_vertex, max_iterations = 20, num_ants = 100,
    alpha = 1, beta = 1, q = 1, rho = 0.5, dynamic_rho = true, min_rho = 0.3, max_rho = 0.7)
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
