input_path = File.expand_path('../input.txt', __FILE__)
lines = File.read(input_path).strip.lines

rows, cols = 6, 50

screen = (1..rows).map { [false] * cols }

lines.each do |line|
  case line

  when /rect (\d+)x(\d+)/
    a, b = $1.to_i, $2.to_i
    b.times do |y|
      a.times { |x| screen[y][x] = true }
    end

  when /rotate row y=(\d+) by (\d+)/
    y, n = $1.to_i, $2.to_i
    screen[y].rotate!(-n)

  when /rotate column x=(\d+) by (\d)+/
    x, n = $1.to_i, $2.to_i
    screen = screen.transpose
    screen[x].rotate!(-n)
    screen = screen.transpose

  end
end

p screen.inject(0) { |s, row| s + row.count { |x| x } }

screen.each do |row|
  puts row.map { |cell| cell ? '#' : '.' }.join('')
end
