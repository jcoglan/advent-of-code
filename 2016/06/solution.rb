input_path = File.expand_path('../input.txt', __FILE__)
lines = File.read(input_path).strip.lines

state = Hash.new do |h, index|
  h[index] = Hash.new { |g, char| g[char] = 0 }
end

lines.each do |line|
  line.strip.chars.each.with_index do |char, i|
    state[i][char] += 1
  end
end

p state.keys.sort.map { |i| state[i].min_by(&:last).first }.join('')
