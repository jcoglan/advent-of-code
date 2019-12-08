require 'set'

class Orbits
  def initialize
    @edges  = {}
    @depths = {}
  end

  def add(orbiter, target)
    @edges[orbiter] = target
  end

  def total
    @edges.keys.map { |k| depth(k) }.reduce(0, :+)
  end

  def transfers(source, target)
    queue = [@edges[source], @edges[target]]
    flags = Hash.new { |h, k| h[k] = Set.new }

    flags[queue[0]].add(:left)
    flags[queue[1]].add(:right)

    until queue.empty?
      id = queue.shift
      flag = flags[id]

      if parent = @edges[id]
        queue.push(parent)
        flags[parent] |= flag
      end
    end

    flags.count { |_, f| f.size == 1 }
  end

  private

  def depth(k)
    @depths[k] ||= @edges.has_key?(k) ? depth(@edges[k]) + 1 : 0
  end
end

input_path = File.expand_path('../input.txt', __FILE__)
orbits = Orbits.new

File.read(input_path).each_line do |line|
  target, orbiter = line.strip.split(')')
  orbits.add(orbiter, target)
end

p orbits.total
p orbits.transfers('YOU', 'SAN')
