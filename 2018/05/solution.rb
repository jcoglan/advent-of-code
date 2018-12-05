input_path = File.expand_path('../input.txt', __FILE__)
polymer    = File.read(input_path)

def react_1(polymer)
  chars   = polymer.chars
  changed = false
  i       = 0

  while i < chars.size - 1
    x, y = chars[i], chars[i + 1]

    if x != y and x.downcase == y.downcase
      changed = true
      chars.slice!(i, 2)
    else
      i += 1
    end
  end

  [changed, chars.join("")]
end

def react(polymer)
  loop do
    changed, polymer = react_1(polymer)
    break unless changed
  end
  polymer
end

p react(polymer).size

results = {}

('a'..'z').each do |unit|
  poly = polymer.gsub(/#{unit}/i, '')
  results[unit] = react(poly).size
end

p results.min_by(&:last)
