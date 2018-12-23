require 'set'

class Dijkstra
  INFINITY = 1_000_000_000

  class Node
    attr_reader :name
    attr_accessor :distance, :visited, :next

    def initialize(name, distance)
      @name     = name
      @distance = distance
      @visited  = false
      @next     = nil
    end
  end

  def initialize(graph, start)
    @graph = graph
    @start = Node.new(start, 0)
    @nodes = { start => @start }
    @queue = Set.new([@start])
  end

  def distance_to(node)
    node = get_node(node)
    walk until node.visited or unreachable?
    node.distance
  end

  def shortest_path(node)
    distance_to(node)
    node = get_node(node)
    return nil unless node.visited

    path   = [node]
    starts = next_nodes(@start).map(&:first)

    until starts.include?(node)
      nexts = next_nodes(node).map(&:first)
      node  = nexts.min_by { |n| [n.distance] + yield(n.name) }

      path << node
    end

    path << @start
    path.reverse.map(&:name)
  end

  private

  def get_node(name)
    @nodes[name] ||= Node.new(name, INFINITY)
  end

  def next_nodes(node)
    node.next ||= @graph.next_nodes(node.name).map do |name, cost|
      [get_node(name), cost]
    end
  end

  def unreachable?
    @queue.all? { |node| node.distance == INFINITY }
  end

  def walk
    node = @queue.min_by(&:distance)

    @queue.delete(node)
    node.visited = true

    node_dist = node.distance

    next_nodes(node).each do |neighbor, cost|
      next if neighbor.visited

      neighbor.distance = [neighbor.distance, node_dist + cost].min
      @queue << neighbor
    end
  end
end
