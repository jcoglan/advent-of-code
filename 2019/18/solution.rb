require 'set'

input_path = File.expand_path('../input.txt', __FILE__)

Start = 0
Path  = 1
Door  = Struct.new(:name)
Key   = Struct.new(:name)

map = {}

File.read(input_path).each_line.with_index do |line, y|
  line.each_char.with_index do |char, x|
    pos = [x, y]

    case char
    when '@' then map[pos] = Start
    when '.' then map[pos] = Path
    when /[A-Z]/ then map[pos] = Door.new(char.to_sym)
    when /[a-z]/ then map[pos] = Key.new(char.upcase.to_sym)
    end
  end
end

def shortest_path(map)
  map.keys
    .select { |pos| map[pos] == Start }
    .map { |start| search_from(map, start) }
    .reduce(:+)
end

def search_from(map, start)
  target  = reachable_keys(map, start)
  states  = [[start, Set.new]]
  visited = Set.new
  counter = 0

  until states.any? { |_, keys| keys == target }
    counter += 1
    states.keep_if { |state| visited.add? state }

    states = states.flat_map do |pos, keys|
      moves = move_from(map, pos)

      moves.delete_if do |pos|
        door = map[pos]
        door.is_a?(Door) and target.member?(door.name) and not keys.member?(door.name)
      end

      moves.map do |pos|
        new_keys = map[pos].is_a?(Key) ? keys + [map[pos].name] : keys
        [pos, new_keys]
      end
    end
  end

  counter
end

def reachable_keys(map, start)
  states  = [start]
  visited = Set.new
  found   = Set.new

  until states.empty?
    pos = states.shift
    next unless visited.add?(pos)
    found.add(map[pos].name) if map[pos].is_a? Key
    states.concat(move_from(map, pos))
  end

  found
end

def move_from(map, pos)
  x, y = pos
  [[x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1]].select { |pos| map.has_key?(pos) }
end

p shortest_path(map)

x, y = map.key(Start)

[[x - 1, y - 1], [x + 1, y - 1], [x - 1, y + 1], [x + 1, y + 1]].each do |pos|
  map[pos] = Start
end

[[x, y - 1], [x - 1, y], [x, y], [x + 1, y], [x, y + 1]].each do |pos|
  map.delete(pos)
end

p shortest_path(map)
