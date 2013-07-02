require "pry"

class Ant
  attr_reader :path

  def initialize(start_state)
    @path = [start_state]
  end

  def current_state
    @path.last
  end

  def available_edges
    edges = @current_enviroment.vertex(current_state).edges.values.map do |edge|
      edge unless @path.include?(edge.destination)
    end
    edges.compact
  end

  def target_state
    'E'
  end

  def move(state)
    @path << state
  end

  def construct_solution(enviroment, alpha, beta)
    @current_enviroment = enviroment
    while current_state != target_state
      probs = available_edges_probabilities(alpha, beta)
      move(choose_next_move(probs))
      # p @path
    end
  end

  def available_edges_probabilities(alpha, beta)
    available_edges.map do |edge|
      neighbor_factor(edge, alpha, beta)
    end
  end

  def neighbor_factor(edge, alpha, beta)
    edge.factor(alpha, beta) / available_edges.inject(0) { |sum, e| sum + e.factor(alpha, beta) }
  end

  def choose_next_move(probs)
    choice = rand
    limit = 0
    probs.each_with_index do |prob, index|
      # Increasing limit with nexto probability
      limit += prob
      # Testing if value is < then limit
      return available_edges[index].destination if choice < limit
    end
  end
end