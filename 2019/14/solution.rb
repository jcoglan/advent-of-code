def parse(chem)
  chem.scan(/(\d+)\s+([A-Z]+)/).map { |q, n| [n, q.to_i] }
end

input_path = File.expand_path('../input.txt', __FILE__)
rules = {}

File.read(input_path).lines.each do |line|
  ins, out = line.strip.split(/\s*=>\s*/)
  type, amount = parse(out).first

  rules[type] = [amount, parse(ins)]
end

def ore(rules, fuel)
  state = { 'FUEL' => fuel }

  until state.select { |k, v| v > 0 }.map(&:first) == ['ORE']
    inputs = state.flat_map do |chem, needed|
      next [[chem, needed]] unless rules.has_key?(chem)

      amount, inputs = rules[chem]
      f = (needed.to_f / amount).ceil

      inputs.map { |type, amt| [type, f * amt] } +
          [[chem, needed - f * amount]]
    end

    state = inputs.each_with_object({}) do |(type, amount), s|
      s[type] = s.fetch(type, 0) + amount
    end

    state.delete_if { |k, v| v == 0 }
  end

  state['ORE']
end

one_fuel = ore(rules, 1)
p one_fuel

limit = 1_000_000_000_000
estimate = limit / one_fuel
low = (0.5 * estimate).floor
high = (1.5 * estimate).ceil

while low + 1 < high
  mid = (low + high) / 2
  o = ore(rules, mid)

  if o < limit
    low = mid
  else
    high = mid
  end
end

p low
