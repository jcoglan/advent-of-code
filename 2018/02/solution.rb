input_path = File.expand_path('../input.txt', __FILE__)
box_ids    = File.read(input_path).lines.map(&:strip)

counts = Hash.new { |h, k| h[k] = 0 }

box_ids.each do |id|
  key = id.chars.group_by { |c| c }.values.map(&:size).uniq
  key.each { |x| counts[x] += 1 }
end

p counts[2] * counts[3]

index = Hash.new { |h, k| h[k] = [] }

box_ids.each do |id|
  id.size.times do |i|
    copy = id.clone
    copy[i] = '_'
    index[copy] << id
  end
end

index.each do |key, ids|
  puts key if ids.size > 1
end
