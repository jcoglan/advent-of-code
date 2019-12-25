require 'rational'
require 'set'

Point = Struct.new(:x, :y) do
  def direction(other)
    dx, dy = self - other
    return 0 if dx == 0 and dy == 0

    if dx == 0
      Direction.new(dy / dy.abs, nil)
    else
      Direction.new(dx / dx.abs, Rational(dy, dx))
    end
  end

  def -(other)
    [x - other.x, y - other.y]
  end
end

Direction = Struct.new(:sign, :ratio) do
  def <=>(other)
    if rank == other.rank
      ratio <=> other.ratio
    else
      rank <=> other.rank
    end
  end

  def rank
    case self
      in { sign: -1, ratio: nil      } then 1
      in { sign:  1, ratio: Rational } then 2
      in { sign:  1, ratio: nil      } then 3
      in { sign: -1, ratio: Rational } then 4
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
  diffs = Set.new(points.map { |p| p.direction(base) }) - [0]
  [base, diffs.size]
end

base, count = scores.max_by(&:last)
p count

spokes = Hash.new { |h, k| h[k] = [] }

points.each do |p|
  next if p == base
  spokes[p.direction(base)] << p
end

spokes = spokes.sort_by(&:first).map(&:last)
point  = nil

200.times do
  spoke = spokes.shift
  point = spoke.shift
  spokes << spoke unless spoke.empty?
end

p 100 * point.x + point.y
