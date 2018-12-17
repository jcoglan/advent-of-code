require_relative './water'

dims = {
  'x' => [1_000_000, -1],
  'y' => [1_000_000, -1]
}
rows = []

input_path = File.expand_path('../input.txt', __FILE__)

PATTERN = /(.)=(\d+), (.)=(\d+)\.\.(\d+)/

File.read(input_path).each_line do |line|
  m = PATTERN.match(line)

  x, y    = m[1], m[3]
  a, b, c = [m[2], m[4], m[5]].map(&:to_i)

  dims[x][0] = [dims[x][0], a].min
  dims[x][1] = [dims[x][1], a].max

  dims[y][0] = [dims[y][0], b].min
  dims[y][1] = [dims[y][1], c].max

  rows << [x, a, y, b, c]
end

x_min, x_max = dims['x']
y_min, y_max = dims['y']

grid = (y_min..y_max).map { Array.new(4 + x_max - x_min, '.') }

rows.each do |x, a, y, b, c|
  (b..c).each do |d|
    m, n = (x == 'x') ? [a, d] : [d, a]
    grid[n - y_min][2 + m - x_min] = '#'
  end
end

source = [500 + 2 - x_min, 0]
water  = Water.new(grid, [source])

water.run
grid.each { |row| puts row.join('') }

moving  = water.count('|')
resting = water.count('~')

p [moving + resting, resting]
