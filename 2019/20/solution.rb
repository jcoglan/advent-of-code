require 'set'

input_path = File.expand_path('../input.txt', __FILE__)
map = File.read(input_path).lines.map(&:chars)

path   = Set.new
gates  = Hash.new { |h, k| h[k] = [] }
labels = {}

map.each_with_index do |line, y|
  line.each_with_index do |char, x|
    next unless char == '.'

    pos = [x, y]
    path.add(pos)

    nearby = [
      [[x, y - 2], [x, y - 1], [x, y - 3]],
      [[x + 1, y], [x + 2, y], [x + 3, y]],
      [[x, y + 1], [x, y + 2], [x, y + 3]],
      [[x - 2, y], [x - 1, y], [x - 3, y]]
    ]

    nearby.each do |(x1, y1), (x2, y2), (x3, y3)|
      a, b = map[y1][x1], map[y2][x2]
      next unless a =~ /[A-Z]/ and b =~ /[A-Z]/

      if x3 >= 0 and y3 >= 0 and map.fetch(y3, []).fetch(x3, nil) == ' '
        type = :inner
      else
        type = :outer
      end

      name = [a, b].join
      gates[name] << [type, pos]
      labels[pos] = name
    end
  end
end

(_, aa), _ = gates['AA']
(_, zz), _ = gates['ZZ']

def shortest_path(start, target, &gen_state)
  states  = [start]
  visited = Set.new
  counter = 0

  until states.include?(target)
    counter += 1

    states = states.flat_map do |state|
      visited.add?(state) ? gen_state.call(state) : []
    end
  end

  counter
end

p shortest_path(aa, zz) { |state|
  x, y = state

  moves = [[x, y - 1], [x + 1, y], [x, y + 1], [x - 1, y]]
          .select { |pos| path.member? pos }

  if name = labels[state]
    moves.concat(gates[name].map(&:last) - [state])
  end

  moves
}

p shortest_path([aa, 0], [zz, 0]) { |(x, y), layer|
  moves = [[x, y - 1], [x + 1, y], [x, y + 1], [x - 1, y]]
          .select { |pos| path.member? pos }
          .map { |pos| [pos, layer] }

  if name = labels[[x, y]]
    source = gates[name].find { |_, pos| pos == [x, y] }
    is_outer = (source[0] == :outer)

    unless layer == 0 and is_outer
      next_layer = is_outer ? layer - 1 : layer + 1

      jumps = gates[name] - [source]
      moves.concat(jumps.map { |_, pos| [pos, next_layer] })
    end
  end

  moves
}
