require_relative './intcode'

input_path = File.expand_path('../input.txt', __FILE__)
program    = File.read(input_path)

def run(program, noun, verb)
  machine = Intcode.new(program)
  machine.memory[1..2] = [noun, verb]
  machine.run
  machine.memory[0]
end

p run(program, 12, 2)

pairs = (0..99).flat_map { |n| (0..99).map { |v| [n, v] } }

noun, verb = pairs.find do |noun, verb|
  run(program, noun, verb) == 19690720
end

p 100 * noun + verb
