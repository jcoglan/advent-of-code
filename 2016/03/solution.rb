input_path = File.expand_path('../input.txt', __FILE__)
lines = File.read(input_path).strip.lines

Triangle = Struct.new(:a, :b, :c) do
  def possible?
    a + b > c && b + c > a && c + a > b
  end
end

# part 1
triangles = lines.map do |line|
  a, b, c = line.scan(/\d+/).map(&:to_i)
  Triangle.new(a, b, c)
end

# part 2
triangles = lines.each_slice(3).flat_map do |lines|
  ns = lines.map { |l| l.scan(/\d+/).map(&:to_i) }
  ns.transpose.map { |a, b, c| Triangle.new(a, b, c) }
end

p triangles.select(&:possible?).size
p triangles.reject(&:possible?).size
