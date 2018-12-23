require_relative './dijkstra'

class Map
  def initialize(n, m, k, d, zeros)
    @n, @m, @k = n, m, k
    @d, @zeros = d, zeros

    @index   = []
    @erosion = []
  end

  def index(x, y)
    @index[y] ||= []
    @index[y][x] ||= get_index(x, y)
  end

  def erosion(x, y)
    @erosion[y] ||= []
    @erosion[y][x] ||= get_erosion(x, y)
  end

  private

  def get_index(x, y)
    return 0 if @zeros.include?([x, y])

    return (x * @n) if y == 0
    return (y * @m) if x == 0

    erosion(x-1, y) * erosion(x, y-1)
  end

  def get_erosion(x, y)
    (index(x, y) + @d) % @k
  end
end

class Graph
  TOOLS = [:T, :C, :N]

  ROCKY  = 0
  WET    = 1
  NARROW = 2

  def initialize(map)
    @map = map
  end

  def next_nodes(state)
    x, y, tool = state
    type = @map.erosion(x, y) % 3

    next_states = TOOLS.select { |t| t != tool and can_use?(t, type) }
                  .map { |t| [[x, y, t], 7] }

    neighbors = [[x, y-1], [x+1, y], [x, y+1], [x-1, y]]

    neighbors.each do |x, y|
      next if x < 0 or y < 0

      ntype = @map.erosion(x, y) % 3
      next_states << [[x, y, tool], 1] if can_use?(tool, ntype)
    end

    next_states
  end

  def can_use?(tool, type)
    return false if tool == :N and type == ROCKY
    return false if tool == :T and type == WET
    return false if tool == :C and type == NARROW

    true
  end
end

d, tx, ty = 10914, 9, 739
map = Map.new(16807, 48271, 20183, d, [[0, 0], [tx, ty]])

risk = (0..ty).map do |y|
  (0..tx).map { |x| map.erosion(x, y) % 3 }
end

total_risk = risk.flatten.reduce(0, :+)
p total_risk

graph    = Graph.new(map)
dijkstra = Dijkstra.new(graph, [0, 0, :T])

p dijkstra.distance_to([tx, ty, :T])
