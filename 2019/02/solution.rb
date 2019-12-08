require_relative './intcode'

input_path = File.expand_path('../input.txt', __FILE__)
memory     = File.read(input_path).split(',').map(&:to_i)

def run(memory, noun, verb)
  memory[1] = noun
  memory[2] = verb
  Intcode.new(memory).run
  memory[0]
end

p run(memory.clone, 12, 2)

pairs = (0..99).flat_map { |n| (0..99).map { |v| [n, v] } }

noun, verb = pairs.find do |noun, verb|
  run(memory.clone, noun, verb) == 19690720
end

p 100 * noun + verb
