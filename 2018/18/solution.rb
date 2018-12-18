input_path = File.expand_path('../input.txt', __FILE__)

grid = File.read(input_path).lines.map(&:strip).map(&:chars)

neighbors = [
  [-1, -1], [ 0, -1], [ 1, -1],
  [-1,  0],           [ 1,  0],
  [-1,  1], [ 0,  1], [ 1,  1]
]

seen = {}
time = 0

loop do
  break if seen[grid]
  seen[grid] = time
  time += 1

  grid = grid.map.with_index do |row, y|
    row.map.with_index do |cell, x|
      values = neighbors.map do |dx, dy|
        nx, ny = x + dx, y + dy
        if nx.between?(0, row.size - 1) and ny.between?(0, grid.size - 1)
          grid[ny][nx]
        end
      end

      os, ts, ls = ['.', '|', '#'].map { |type| values.count(type) }

      if cell == '.' and ts >= 3
        '|'
      elsif cell == '|' and ls >= 3
        '#'
      elsif cell == '#' and (ls == 0 or ts == 0)
        '.'
      else
        cell
      end
    end
  end
end

period = time - seen[grid]
target = 1_000_000_000
loops  = (target - seen[grid]) / period

grid = seen.key(target - loops * period)

grid.each { |row| puts row.join('') }

ts = grid.reduce(0) { |s, r| s + r.count('|') }
ls = grid.reduce(0) { |s, r| s + r.count('#') }

p [seen[grid], time, ts * ls]
