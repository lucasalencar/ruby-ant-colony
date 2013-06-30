class Graph
  def initialize(vertices = [], directed = false)
    @vertices = Hash.new
    add_vertices(vertices)
    @directed = directed
  end

  def add_vertex(id)
    @vertices.store(id, Vertex.new(id))
  end

  def add_edge(start, destination, weight)
    @vertices[start].add(Edge.new(start, destination, weight))
    unless @directed
      @vertices[destination].add(Edge.new(destination, start, weight))
    end
  end

  def add_edges(commom_start, destinations, weights)
    destinations.each_with_index do |destination, index|
      add_edge(commom_start, destination, weights[index])
    end
  end

  def add_vertices(ids)
    ids.each { |id| add_vertex(id) }
  end

  def inspect
    output = ""
    @vertices.each_value do |vertex|
      output << vertex.inspect
      output << "\n"
    end
    output.chomp
  end
end

class Vertex
  attr_reader :id
  attr_accessor :edges

  def initialize(id, edges = [])
    @id = id
    edges.each do |edge|
      raise "Wrong Edge Declaration: vertex #{id} on edge #{edge}" unless edge.is_valid?(@id)
    end
    @edges = edges
  end

  def add(edge)
    if edge.kind_of?(Edge)
      @edges << edge unless @edges.include?(edge)
    else
      raise "Object is not kind of Edge."
    end
  end

  def inspect
    edges = ""
    @edges.each do |edge|
      edges << edge.inspect
      edges << ',' unless edge == @edges.last
    end
    "{#{id} => [#{edges}]}"
  end
end

class Edge
  attr_reader :start, :destination, :weight

  def initialize(start, destination, weight = 0)
    @start = start
    @destination = destination
    @weight = weight
  end

  def ==(edge)
    @start == edge.start and @destination == edge.destination and @weight == edge.weight
  end

  def is_valid?(id)
    start == id or destination == id
  end

  def inspect
    "#{destination}"
  end
end
