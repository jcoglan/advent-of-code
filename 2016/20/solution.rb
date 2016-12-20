input_path = File.expand_path('../input.txt', __FILE__)
lines = File.read(input_path).strip.lines

ranges = lines.map { |line| line.scan(/\d+/).map(&:to_i) }.sort_by(&:first)

allowed = []
lowest  = 0

ranges.each do |low, high|
  allowed << (lowest...low) if low > lowest
  lowest = [lowest, high + 1].max
end

p allowed.first.begin
p allowed.inject(0) { |s, r| s + r.size }
