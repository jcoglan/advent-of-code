require_relative '../02/intcode'

input_path = File.expand_path('../input.txt', __FILE__)
program    = File.read(input_path)

machine = Intcode.new(program, inputs: [1])
machine.run
p machine.outputs

machine = Intcode.new(program, inputs: [2])
machine.run
p machine.outputs
