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
    'D'
  end

  def move(state)
    @path << state
  end

  def construct_solution(enviroment, alpha, beta)
    @current_enviroment = enviroment
    while current_state != target_state
      move(choose_next_move(alpha, beta))
    end
  end

  def choose_next_move(alpha, beta)
    edges = available_edges
    probs = available_edges.map do |edge|
      neighbor_factor(edge, alpha, beta)
    end
    begin
      max = probs.index(probs.max)
      next_move = edges[max].destination
      probs[max] = -1
    end while @path.include?(next_move)
    next_move
  end

  def neighbor_factor(edge, alpha, beta)
    edge.factor(alpha, beta) / available_edges.inject(0) { |sum, e| sum + e.factor(alpha, beta) }
  end
end