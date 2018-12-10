class Points
  P = Struct.new(:px, :py, :vx, :vy)

  def initialize(points)
    @points = points
  end

  def at(t)
    @points.map { |p| [p.px + t * p.vx, p.py + t * p.vy] }
  end
end

class Optimiser
  def initialize(points)
    @points = points
  end

  def run
    t, v = 0, nil

    loop do
      new_v = variance(t)
      return t - 1 if v and new_v > v

      v = new_v
      t += 1
    end
  end

  def variance(t)
    ps = @points.at(t)
    xs = ps.map(&:first)
    ys = ps.map(&:last)

    c = [mean(xs), mean(ys)]

    ds = ps.map { |x, y| (x - c[0]) ** 2 + (y - c[1]) ** 2 }
    mean(ds)
  end

  def mean(xs)
    xs.reduce(0.0, :+) / xs.size
  end
end

def draw(ps)
  xs, ys = ps.map(&:first), ps.map(&:last)
  x_min, x_max = xs.minmax
  y_min, y_max = ys.minmax

  (y_min..y_max).each do |y|
    (x_min..x_max).each do |x|
      c = ps.include?([x, y]) ? '#' : ' '
      print c
    end
    print "\n"
  end
end

input_path = File.expand_path('../input.txt', __FILE__)

PATTERN = /position=<\s*(-?\d+),\s*(-?\d+)> velocity=<\s*(-?\d+),\s*(-?\d+)>/

points = File.read(input_path).lines.map do |line|
  match = PATTERN.match(line)
  Points::P.new(*match[1..4].map(&:to_i))
end

points = Points.new(points)
opt    = Optimiser.new(points)
time   = opt.run

draw(points.at(time))
p time
