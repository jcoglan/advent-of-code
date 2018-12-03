require 'set'

input_path = File.expand_path('../input.txt', __FILE__)

PATTERN = /^#(\d+) @ (\d+),(\d+): (\d+)x(\d+)$/

claims = File.read(input_path).lines.map do |line|
  PATTERN.match(line).captures.map(&:to_i)
end

size   = 1000
fabric = Array.new(size) { Array.new(size) { [] } }
ids    = Set.new

claims.each do |id, left, top, width, height|
  ids.add(id)

  width.times do |x|
    height.times do |y|
      cell = fabric[top + y][left + x]
      cell << id
      ids -= cell if cell.size > 1
    end
  end
end

p fabric.reduce(0) { |s, row| s + row.count { |n| n.size > 1 } }
p ids
