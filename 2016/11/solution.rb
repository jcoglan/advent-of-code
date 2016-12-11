require 'forwardable'

Generator = Struct.new(:type) do
  def inspect
    "Gen[#{type}]"
  end
end

Microchip = Struct.new(:type) do
  def inspect
    "Chip[#{type}]"
  end
end

Floor = Struct.new(:items) do
  extend Forwardable
  def_delegators :items, :empty?, :delete, :<<

  def inspect
    items.map(&:inspect) * ', '
  end

  def generators
    items.grep(Generator)
  end

  def microchips
    items.grep(Microchip)
  end

  def pairs_movable_to(floor)
    return [] if floor.unprotected_chips.any?

    generators.map do |gen|
      chip = microchips.find { |chip| chip.type == gen.type }
      chip && [gen, chip]
    end.compact
  end

  def unprotected_chips
    microchips.select { |chip| generators.none? { |gen| gen.type == chip.type } }
  end

  def chips_movable_to(floor)
    microchips.select { |chip| floor.safe_for?(chip) }
  end

  def safe_for?(chip)
    generators.empty? || generators.any? { |g| g.type == chip.type }
  end
end

def print_game(floors, c)
  puts '-' * 72
  floors.map.with_index.reverse_each do |floor, i|
    puts "#{i == c ? '->' : '  '}  #{i+1}  #{floor.inspect}"
  end
  puts '-' * 72
end

floors = [
  Floor.new([Microchip.new(:hydrogen), Microchip.new(:lithium)]),
  Floor.new([Generator.new(:hydrogen)]),
  Floor.new([Generator.new(:lithium)]),
  Floor.new([])
]

c, steps = 0, 0

until floors[0..-2].all?(&:empty?)
  steps += 1
  print_game(floors, c)

  floor      = floors[c]
  upstairs   = floors[c+1]
  downstairs = (c > 0) && floors[c-1]

  up_pairs = floor.pairs_movable_to(upstairs)
  p [:up_pairs, up_pairs]

  up_chips = floor.chips_movable_to(upstairs)
  p [:up_chips, up_chips]

  if up_pairs.any?
    up_pairs.first.each { |item| floor.delete(item) }
    up_pairs.first.each { |item| upstairs << item }
    c += 1

  elsif up_chips.any?
    floor.delete(up_chips.first)
    upstairs << up_chips.first
    c += 1

  else
    break
  end
end

p [:steps, steps]
