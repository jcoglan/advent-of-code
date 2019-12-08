input_path = File.expand_path('../input.txt', __FILE__)
image_data = File.read(input_path).chars.map(&:to_i)

w = 25
h = 6
layers = image_data.each_slice(w * h).to_a

least_0 = layers.min_by { |l| l.count { |c| c == 0 } }
n_1 = least_0.count { |c| c == 1 }
n_2 = least_0.count { |c| c == 2 }

p n_1 * n_2

composite = (0...h).map do |y|
  (0...w).map do |x|
    layers.reduce(2) do |col, layer|
      val = layer[w * y + x]
      col == 2 ? val : col
    end
  end
end

composite.each do |row|
  puts row.map { |x| x == 1 ? '#' : ' ' }.join('')
end
