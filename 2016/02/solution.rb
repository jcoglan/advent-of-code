_ = nil

GRID = [
  [_,  _,  1,  _,  _],
  [_,  2,  3,  4,  _],
  [5,  6,  7,  8,  9],
  [_, :A, :B, :C,  _],
  [_,  _, :D,  _,  _]
]

Position = Struct.new(:x, :y) do
  def up
    y == 0 ? self : Position.new(x, y - 1)
  end

  def right
    x == 4 ? self : Position.new(x + 1, y)
  end

  def down
    y == 4 ? self : Position.new(x, y + 1)
  end

  def left
    x == 0 ? self : Position.new(x - 1, y)
  end

  def value
    GRID[y][x]
  end
end

MOVES = {'U' => :up, 'R' => :right, 'D' => :down, 'L' => :left}

input_path = File.expand_path('../input.txt', __FILE__)
lines = File.read(input_path).strip.lines

position = Position.new(0, 2)

lines.each do |line|
  line.each_char do |char|
    move = MOVES[char]
    next unless move

    next_pos = position.__send__(move)

    position = next_pos if next_pos.value
  end
  p [position, position.value]
end
