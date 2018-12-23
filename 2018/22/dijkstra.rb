require 'set'

class Dijkstra
  INFINITY = 1_000_000_000

  def initialize(graph, start)
    @graph    = graph
    @start    = start
    @distance = { start => 0 }
    @queue    = Set.new([start])
    @visited  = Set.new
  end

  def distance_to(node)
    walk until @visited.include?(node) or unreachable?
    @distance[node]
  end

  def unreachable?
    @queue.none? { |node| @distance.has_key?(node) }
  end

  def walk
    node = @queue.min_by { |node| @distance.fetch(node, INFINITY) }

    @queue.delete(node)
    @visited.add(node)

    node_dist = @distance.fetch(node)

    @graph.next_nodes(node).each do |neighbor, cost|
      next if @visited.include?(neighbor)

      dist = @distance.fetch(neighbor, INFINITY)
      @distance[neighbor] = [dist, node_dist + cost].min
      @queue.add(neighbor)
    end
  end
end
