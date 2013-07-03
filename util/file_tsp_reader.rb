class FileTspReader
  def self.read(file_path)
    content = File.read(File.expand_path(file_path))
    coord_section = false; coord_lines = []; dimension = nil
    content.each_line do |line|
      break if line.include?('EOF')
      dimension = FileTspReader.match_dimension(line) if line.include?('DIMENSION')
      coord_lines << line.strip if coord_section
      coord_section = true if line.include?('NODE_COORD_SECTION')
    end
    return coord_lines, dimension
  end

  def self.build_graph(coord_lines, dimension, graph_class)
    g = graph_class.new
    coord_lines.each do |coord_a|
      _, ida, xa, ya = *coord_a.match(/(\d+) \s*(\d+) \s*(\d+)/)
      g.add_vertex(ida) unless g.has_vertex?(ida)
      coord_lines.each do |coord_b|
        _, idb, xb, yb = *coord_b.match(/(\d+) \s*(\d+) \s*(\d+)/)
        g.add_vertex(idb) unless g.has_vertex?(idb)
        g.add_edge(ida, idb, FileTspReader.calculate_weight(xa, ya, xb, yb))
      end
    end
    g
  end

  def self.example(file_path, graph_class)
    coord_lines, dimension = FileTspReader.read(file_path)
    FileTspReader.build_graph(coord_lines, dimension, graph_class)
  end

  def self.tour(file_path)
    content = File.read(File.expand_path(file_path))
    tour_section = false; tour = []; dimension = nil
    content.each_line do |line|
      break if line.include?('EOF') or line.include?('-1')
      dimension = FileTspReader.match_dimension(line) if line.include?('DIMENSION')
      tour << line.strip if tour_section
      tour_section = true if line.include?('TOUR_SECTION')
    end
    return tour, dimension
  end

  private

  def self.match_dimension(line)
    _, dimension = *line.match(/DIMENSION[^0-9]*(\d+)/)
    dimension.to_i
  end

  def self.calculate_weight(xa, ya, xb, yb)
    xd = xa.to_f - xb.to_f; yd = ya.to_f - yb.to_f
    Math.sqrt(xd*xd + yd*yd)
  end
end
