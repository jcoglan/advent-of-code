require 'set'

def step(cells)
  cells.map.with_index do |row, y|
    row.map.with_index do |cell, x|
      count = yield x, y
      cell_state(cell, count)
    end
  end
end

def cell_state(cell, count)
  if cell == '.' and (count == 1 or count == 2)
    '#'
  elsif cell == '#' and count != 1
    '.'
  else
    cell
  end
end

def neighbors(cells, x, y)
  return [] if cells[y][x] == '?'

  neighbors = [[x, y - 1], [x + 1, y], [x, y + 1], [x - 1, y]]
  x_range   = 0 ... cells.first.size
  y_range   = 0 ... cells.size

  neighbors.keep_if do |x, y|
    x_range.include?(x) and y_range.include?(y)
  end

  neighbors.map { |x, y| cells[y][x] }
end

input_path = File.expand_path('../input.txt', __FILE__)
init_cells = File.read(input_path).lines.map(&:strip).map(&:chars)

cells  = init_cells
states = Set.new

while states.add?(cells)
  cells = step(cells) do |x, y|
    neighbors(cells, x, y).count { |cell| cell == '#' }
  end
end

diversity = cells.flatten
            .map.with_index { |cell, i| cell == '#' ? 2 ** i : 0 }
            .reduce(0, :+)

p diversity

def step_levels(levels)
  empty    = empty_level(levels.first)
  expanded = [empty, empty] + levels + [empty, empty]

  (1 ... expanded.size - 1).map do |i|
    step_layers(*expanded[i - 1 .. i + 1])
  end
end

def empty_level(level)
  level.map { |row| row.map { |c| c == '?' ? '?' : '.' } }
end

#             x
#         0 1 2 3 4
#       0 . . . . .
#       1 . . . . .
#     y 2 . . ? . .
#       3 . . . . .
#       4 . . . . .

def step_layers(outer, current, inner)
  step(current) do |x, y|
    bugs = neighbors(current, x, y)

    bugs << outer[1][2] if y == 0
    bugs << outer[2][3] if x == 4
    bugs << outer[3][2] if y == 4
    bugs << outer[2][1] if x == 0

    case [x, y]
    when [2, 1] then bugs += inner.first
    when [3, 2] then bugs += inner.map(&:last)
    when [2, 3] then bugs += inner.last
    when [1, 2] then bugs += inner.map(&:first)
    end

    bugs.count { |b| b == '#' }
  end
end

init_cells[2][2] = '?'
levels = [init_cells]
200.times { levels = step_levels(levels) }

p levels.flatten.count { |c| c == '#' }
