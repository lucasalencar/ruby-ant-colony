class Graph
  attr_reader :vertices

  def initialize(vertices = [], directed = false)
    @vertices = Hash.new
    add_vertices(vertices)
    @directed = directed
  end

  def vertex(id)
    @vertices[id]
  end

  def directed?
    @directed
  end

  def add_vertex(id)
    @vertices.store(id, Vertex.new(id))
  end

  def add_edge(start, destination, weight)
    @vertices[start].add(start, destination, weight)
    unless @directed
      @vertices[destination].add(destination, start, weight)
    end
  end

  def add_edges(commom_start, destinations)
    destinations.each do |dest|
      add_edge(commom_start, dest[:v], dest[:w])
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
    @edges = Hash.new
  end

  def add(start, destination, weight)
    edge = Edge.new(start, destination, weight)
    @edges.store(destination, edge) unless @edges.has_value?(edge)
  end

  def inspect
    edges = ""
    @edges.each_value do |edge|
      edges << edge.inspect + ','
    end
    "{#{id} => [#{edges.chop}]}"
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

  def inspect
    "(#{destination}, #{weight})"
  end
end

# g = Graph.new([1, 2, 3, 4, 5])
# g.add_edges(1, [{v: 2, w: 0}, {v: 5, w: 0}])
# g.add_edges(2, [{v: 1, w: 0}, {v: 3, w: 0}, {v: 4, w: 0}, {v: 5, w: 0}])
# g.add_edges(3, [{v: 2, w: 0}, {v: 4, w: 0}])
# g.add_edges(4, [{v: 2, w: 0}, {v: 3, w: 0}, {v: 5, w: 0}])
# g.add_edges(5, [{v: 1, w: 0}, {v: 2, w: 0}, {v: 4, w: 0}])
#
# p g