require 'set'
require_relative '../22/dijkstra'

class Map
  def self.parse(regex)
    map = new
    regex.each_char { |char| map.parse(char) }
    map
  end

  attr_reader :doors

  def initialize
    @states = [ [0, 0] ]
    @stack  = []
    @outs   = []
    @doors  = Hash.new { |h, k| h[k] = Set.new }
  end

  def parse(char)
    case char
      when 'N' then walk( 0, -1)
      when 'E' then walk( 1,  0)
      when 'S' then walk( 0,  1)
      when 'W' then walk(-1,  0)
      when '(' then push
      when '|' then switch
      when ')' then pop
    end
  end

  def next_nodes(node)
    @doors[node].map { |n| [n, 1] }
  end

  private

  def walk(dx, dy)
    @states.each { |state| walk_state(state, dx, dy) }
  end

  def walk_state(state, dx, dy)
    x, y = state
    state[0] += dx
    state[1] += dy
    connect([x, y], state)
  end

  def connect(a, b)
    @doors[a.clone] << b.clone
    @doors[b.clone] << a.clone
  end

  def push
    @stack << @states.map(&:clone)
    @outs << []
  end

  def switch
    @outs.last.concat(@states.map(&:clone))
    @states = @stack.last.map(&:clone)
  end

  def pop
    @outs.last.concat(@states.map(&:clone))
    @stack.pop
    @states = @outs.pop.uniq
  end
end

input_path = File.expand_path('../input.txt', __FILE__)
map = Map.parse(File.read(input_path))

dijkstra = Dijkstra.new(map, [0, 0])

dists = map.doors.keys.map do |node|
  [node, dijkstra.distance_to(node)]
end

(x, y), d = dists.max_by(&:last)
p d
p dists.count { |_, d| d >= 1000 }

path = Set.new

dijkstra.shortest_path([x, y]) { [] }.each_cons(2) do |(px, py), (nx, ny)|
  path << [px, py, nx, ny]
  path << [nx, ny, px, py]
end

rx = map.doors.keys.map(&:first).minmax
ry = map.doors.keys.map(&:last).minmax

def dim(str)
  "\e[30m#{ str }\e[m"
end

(ry[0]..ry[1]).each_with_index do |y, j|
  unless j == 0
    (rx[0]..rx[1]).each_with_index do |x, i|
      print '   ' unless i == 0
      line = map.doors[[x, y-1]].include?([x, y]) ? '|' : ' '
      line = dim(line) unless path.include?([x, y-1, x, y]) or path.include?([x, y, x, y-1])
      print line
    end
    puts
  end
  (rx[0]..rx[1]).each_with_index do |x, i|
    line = map.doors[[x-1, y]].include?([x, y]) ? '---' : '   '
    line = dim(line) unless path.include?([x-1, y, x, y]) or path.include?([x, y, x-1, y])
    print line unless i == 0
    print [x, y] == [0, 0] ? 'x' : 'o'
  end
  puts
end
