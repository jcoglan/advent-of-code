state = nil
rules = {}

input_path = File.expand_path('../input.txt', __FILE__)

File.read(input_path).each_line do |line|
  case line
  when /initial state: ([#.]+)/
    state = $1.chars.map.with_index.to_a
  when /([#.]+) => ([#.])/
    rules[$1.chars] = $2
  end
end

seen   = {}
states = []
period = 0
motion = 0

loop do
  key  = state.map(&:first).join('')
  g, p = seen[key]

  if g
    period = states.size - g
    motion = state.first.last - p
    break
  end

  seen[key] = [states.size, state.first.last]
  states << state

  min, max  = state.map(&:last).values_at(0, -1)
  new_state = (min - 2 .. max + 2).map { |i| ['.', i] }

  new_state.map!.with_index do |(_, n), i|
    cs = (i - 2 .. i + 2).map { |n| n < 2 ? '.' : state[n - 2]&.first || '.' }
    [rules[cs], n]
  end

  new_state.pop until new_state.last.first == '#'
  new_state.shift until new_state.first.first == '#'

  state = new_state
end

n = 50_000_000_000
d = ((n - states.size) / period) + 1
s = states[n - d]

cells = s.select { |c, _| c == '#' }
total = cells.map(&:last).map { |n| n + d * motion }.reduce(0, :+)

p total
