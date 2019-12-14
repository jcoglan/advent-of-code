require 'rational'
require 'set'

Point = Struct.new(:x, :y) do
  def -(other)
    dx, dy = other.x - x, other.y - y
    return 0 if dx == 0 and dy == 0

    if dy == 0
      dx / dx.abs
    else
      [dy / dy.abs, Rational(dx, dy)]
    end
  end
end

input_path = File.expand_path('../input.txt', __FILE__)

points = File.read(input_path).lines.flat_map.with_index do |line, y|
  line.chars.flat_map.with_index do |char, x|
    char == '#' ? [Point.new(x, y)] : []
  end
end

scores = points.map do |base|
  diffs = Set.new(points.map { |p| p - base }) - [0]
  [base, diffs.size]
end

base, count = scores.max_by(&:last)
p count
