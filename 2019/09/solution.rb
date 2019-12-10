require_relative '../02/intcode'

input_path = File.expand_path('../input.txt', __FILE__)
program    = File.read(input_path).split(',').map(&:to_i)

machine = Intcode.new(program.clone)
machine.inputs << 1
machine.run
p machine.outputs

machine = Intcode.new(program.clone)
machine.inputs << 2
machine.run
p machine.outputs
