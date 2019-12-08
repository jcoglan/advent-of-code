input_path = File.expand_path('../input.txt', __FILE__)
masses     = File.read(input_path).lines.map(&:to_i)

def fuel(mass)
  (mass / 3.0).floor - 2
end

p masses.reduce(0) { |s, m| s + fuel(m) }

def required_fuel(init)
  Enumerator.produce(fuel(init)) { |mass| fuel(mass) }
end

fuels = masses.flat_map do |mass|
  required_fuel(mass).take_while { |f| f > 0 }
end

p fuels.reduce(0, :+)
