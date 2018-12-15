class Dijkstra
  Node = Struct.new(:x, :y, :distance, :visited, :next)

  class NodeSet
    def initialize
      @nodes = Hash.new { |h, k| h[k] = {} }
    end

    def <<(node)
      @nodes[node.x][node.y] = node
    end

    def get(x, y)
      @nodes[x][y]
    end

    def each
      @nodes.values.each { |h| h.each_value { |node| yield node } }
    end
  end

  INFINITY = 1_000_000

  def initialize(map, start)
    start = Node.new(start.x, start.y, 0, false)

    @nodes = NodeSet.new
    @nodes << start

    map.all_spaces.each do |space|
      @nodes << Node.new(space.x, space.y, INFINITY, false)
    end
    @nodes.each { |node| node.next = next_to(node) }

    @queue = [start]
  end

  def shortest_path(target)
    target = @nodes.get(target.x, target.y)
    visit until target.visited or unreachable?

    path_to(target) if target.visited
  end

  private

  def unreachable?
    @queue.all? { |node| node.distance == INFINITY }
  end

  def visit
    node, idx = @queue.map.with_index.min_by { |n, i| n.distance }

    @queue.delete_at(idx)
    node.visited = true

    node.next.each do |other|
      next if other.visited

      other.distance = [node.distance + 1, other.distance].min
      @queue << other unless @queue.include?(other)
    end
  end

  def path_to(node)
    path = []

    until node.distance == 0
      path << node
      node = node.next.min_by { |n| [n.distance, n.y, n.x] }
    end
    path.reverse
  end

  def next_to(node)
    moves = [
      [node.x, node.y - 1], [node.x - 1, node.y],
      [node.x + 1, node.y], [node.x, node.y + 1]
    ]

    moves.map { |x, y| @nodes.get(x, y) }.compact
  end
end
