input_path = File.expand_path('../input.txt', __FILE__)
orig_list  = File.read(input_path).chars.map(&:to_i)

base = [0, 1, 0, -1]
list = orig_list.clone
size = list.size

patterns = (1 .. size).map do |i|
  base.lazy.cycle.flat_map { |x| [x] * i }.drop(1).take(size).to_a
end

100.times do
  list = list.map.with_index do |n, i|
    list.zip(patterns[i]).map { |x, y| x * y }.reduce(:+).abs % 10
  end
end

puts list.take(8).join

offset = orig_list.take(7).join.to_i
list   = (orig_list * 10_000).drop(offset)

100.times do
  new_list = []
  sum = 0

  list.each_with_index.reverse_each do |x, i|
    sum += x
    new_list[i] = sum.abs % 10
  end

  list = new_list
end

puts list.take(8).join
