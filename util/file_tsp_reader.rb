require_relative "graph"

class FileTspReader
  def self.read(file_path)
    content = File.read(File.expand_path(file_path))
    coord_section = false; coord_lines = []; dimension = nil
    content.each_line do |line|
      break if line.include?('EOF')
      dimension = line.match(/DIMENSION: (\d+)/)[1].to_i if line.include?('DIMENSION')
      coord_lines << line.strip.squeeze if coord_section
      coord_section = true if line.include?('NODE_COORD_SECTION')
    end
    return coord_lines, dimension
  end

  def self.build_graph(coord_lines, dimension)
    g = Graph.new
    coord_lines.each do |coord_a|
      _, ida, xa, ya = *coord_a.match(/(\d+) (\d+) (\d+)/)
      g.add_vertex(ida) unless g.has_vertex?(ida)
      coord_lines.each do |coord_b|
        _, idb, xb, yb = *coord_b.match(/(\d+) (\d+) (\d+)/)
        g.add_vertex(idb) unless g.has_vertex?(idb)
        g.add_edge(ida, idb, FileTspReader.calculate_weight(xa, ya, xb, yb))
      end
      puts "#{coord_a} => #{ida}"
    end
    g
  end

  private

  def self.calculate_weight(xa, ya, xb, yb)
    xd = xa.to_f - xb.to_f; yd = ya.to_f - yb.to_f
    Math.sqrt(xd*xd + yd*yd)
  end
end

coord_lines, dimension = FileTspReader.read('./benchmarks/tsplib/a280.tsp')
graph = FileTspReader.build_graph(coord_lines, dimension)
p graph
