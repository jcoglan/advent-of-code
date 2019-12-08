require_relative '../02/intcode'

input_path = File.expand_path('../input.txt', __FILE__)
memory     = File.read(input_path).split(',').map(&:to_i)

machine = Intcode.new(memory.clone)
machine.inputs << 1
machine.run

p machine.outputs.last

machine = Intcode.new(memory.clone)
machine.inputs << 5
machine.run

p machine.outputs.last
