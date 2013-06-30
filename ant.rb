class Ant
  attr_reader :path

  def initialize(start_position)
    @path = [start_position]
  end

  def move(vertex_id)
    @path << vertex_id
  end
end