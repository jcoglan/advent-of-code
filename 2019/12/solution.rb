require 'set'

def load_moons
  input_path = File.expand_path('../input.txt', __FILE__)

  File.read(input_path).lines.map do |line|
    vars = line.scan(/([a-z]+)\s*=\s*(-?\d+)/)
    [
      Hash[vars.map { |n, v| [n, v.to_i] }],
      Hash[vars.map { |n, _| [n, 0] }]
    ]
  end
end

def update_moons(moons)
  moons.each do |pos, vel|
    moons.each do |p, _|
      pos.each_key do |key|
        if p[key] > pos[key]
          vel[key] += 1
        elsif p[key] < pos[key]
          vel[key] -= 1
        end
      end
    end
  end

  moons.each do |pos, vel|
    pos.each_key { |key| pos[key] += vel[key] }
  end
end

moons = load_moons
1000.times { update_moons(moons) }

energies = moons.flat_map do |pos, vel|
  p, k = [pos, vel].map { |v| v.values.map(&:abs).reduce(0, :+) }
  p * k
end

p energies.reduce(0, :+)

moons   = load_moons
periods = { 'x' => Set.new, 'y' => Set.new, 'z' => Set.new }

loop do
  break if periods.none? do |key, set|
    set.add?(moons.map { |m| m.map { |v| v[key] } })
  end

  update_moons(moons)
end

def lcm(a, b)
  a * b / gcd(a, b)
end

def gcd(a, b)
  a, b = b, a % b until b == 0
  a
end

p periods.values.map(&:size).reduce { |a, b| lcm(a, b) }
