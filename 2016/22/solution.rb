Node = Struct.new(:size, :used, :avail)

input_path = File.expand_path('../input.txt', __FILE__)
lines = File.read(input_path).strip.lines

nodes = {}

lines[2..-1].each do |line|
  n = line.scan(/\d+/).map(&:to_i)
  nodes[[n[0], n[1]]] = Node.new(n[2], n[3], n[4])
end

not_empty = nodes.values.select { |n| n.used > 0 }

pairs = not_empty.flat_map do |a|
  bs = nodes.values.select { |b| b != a && b.avail >= a.used }
  bs.map { |b| [a, b] }
end

p pairs.size

high_x = nodes.keys.map(&:first).max


