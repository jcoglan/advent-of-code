Bot = Struct.new(:x, :y, :z, :r) do
  def distance(other)
    dx = x - other.x
    dy = y - other.y
    dz = z - other.z

    dx.abs + dy.abs + dz.abs
  end
end

input_file = File.expand_path('../input.txt', __FILE__)
PATTERN = /^pos=<(.*),(.*),(.*)>, r=(.*)$/

bots = File.read(input_file).lines.map do |line|
  match = PATTERN.match(line)
  x, y, z, r = match[1..4].map(&:to_i)
  Bot.new(x, y, z, r)
end

best = bots.max_by(&:r)
near = bots.select { |b| b.distance(best) <= best.r }
p best
p near.size
