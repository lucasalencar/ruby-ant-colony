require_relative "../util/graph"

class AntEnviroment < Graph
  # Reset all edges pheromones to 0
  def reset_pheromones
    @vertices.each_value do |v|
      v.edges.each_value { |e| e.pheromone = 0.000001 }
    end
  end

  # Evaporates pheromones on every edge
  def evaporate(rho)
    @vertices.each_value do |vertex|
      vertex.edges.each_value { |edge| edge.pheromone *= 1 - rho }
    end
  end

  def update_pheromones(path, optimization_value, q)
    pheromone_update = q / optimization_value
    edges = edges_from_path(path)
    edges.each do |e|
      update_pheromone(e.start, e.destination, pheromone_update)
    end
  end

  def update_pheromone(start, destination, pheromone_update)
    @vertices[start].edges[destination].pheromone += pheromone_update
    @vertices[destination].edges[start].pheromone += pheromone_update unless @directed
  end

  def edges_from_path(input_path)
    path = input_path.reverse.clone
    edges = Array.new; start = path.pop
    until path.empty?
      destination = path.pop
      edges << @vertices[start].edges[destination]
      start = destination
    end
    edges
  end

  def total_weight(path)
    edges = edges_from_path(path)
    edges.inject(0) { |sum, edge| sum + edge.weight }
  end
end

class Edge
  attr_accessor :pheromone

  def factor(alpha, beta)
    (pheromone ** alpha) * ((1.0 / weight) ** beta)
  end

  def inspect
    "(#{destination}, #{weight}, #{pheromone})"
  end
end
