require_relative '../02/intcode'

input_path = File.expand_path('../input.txt', __FILE__)
program    = File.read(input_path)

machine = Intcode.new(program, inputs: [1])
machine.run
p machine.outputs.last

machine = Intcode.new(program, inputs: [5])
machine.run
p machine.outputs.last
