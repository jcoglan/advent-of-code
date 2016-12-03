DIRECTIONS = [
  [0,1], [1,0], [0,-1], [-1,0]  
]

Position = Struct.new(:x, :y) do
  def distance
    x + y
  end
end

input_path = File.expand_path('../input.txt', __FILE__)
moves = File.read(input_path).strip.split(/\s*,\s*/)

direction = 0
position  = Position.new(0, 0)
visited   = Hash.new { |h,k| h[k] = 0 }

visited[position] = 1

moves.each do |move|
  turn, distance = move.scan(/(L|R)(\d+)/).flatten

  direction += (turn == 'L' ? -1 : 1)
  direction %= DIRECTIONS.size

  distance.to_i.times do
    position.x += DIRECTIONS[direction][0]
    position.y += DIRECTIONS[direction][1]

    visited[position] += 1
    p position.distance if visited[position] == 2
  end
end

p position.distance
