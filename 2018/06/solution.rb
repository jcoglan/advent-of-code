require 'set'

input_path = File.expand_path('../input.txt', __FILE__)
points = File.read(input_path).lines.map { |s| s.scan(/\d+/).map(&:to_i) }

max_x  = points.map(&:first).max
max_y  = points.map(&:last).max
grid   = Array.new(max_y + 10) { Array.new(max_x + 10) }
counts = Hash.new { |h, k| h[k] = 0 }
region = 0

grid.each_with_index do |row, y|
  row.each_with_index do |cell, x|
    distances = points.map.with_index do |(px, py), i|
      [i, (x - px).abs + (y - py).abs]
    end

    total = distances.reduce(0) { |s, (_, d)| s + d }
    region += 1 if total < 10_000

    distances.sort_by!(&:last)
    next if distances[0].last == distances[1].last

    n = distances[0][0]
    grid[y][x] = n
    counts[n] += 1
  end
end

edge = Set.new(grid.first + grid.last) +
       grid.flat_map { |row| [row.first, row.last] }

biggest = counts.sort_by(&:last)
                .reverse
                .reject { |n, _| edge.member?(n) }
                .first

p biggest
p region
