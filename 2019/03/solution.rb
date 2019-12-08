input_path = File.expand_path('../input.txt', __FILE__)

wires = File.read(input_path).lines.map do |line|
  pos   = [0, 0]
  steps = 0
  wire  = { pos.clone => steps }

  line.split(',').each do |code|
    dir, len = /(.)(\d+)/.match(code)[1..2]

    len.to_i.times do
      case dir
      when 'U' then pos[1] += 1
      when 'R' then pos[0] += 1
      when 'D' then pos[1] -= 1
      when 'L' then pos[0] -= 1
      end
      steps += 1
      wire[pos.clone] ||= steps
    end
  end

  wire
end

crossings = wires.map(&:keys).reduce(:&) - [[0, 0]]
x, y = crossings.min_by { |x, y| x.abs + y.abs }

p x.abs + y.abs

distances = crossings.map do |point|
  dist = wires.map { |wire| wire[point] }.reduce(0, :+)
  [point, dist]
end

p distances.min_by(&:last)
