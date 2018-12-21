require_relative '../19/machine'

input_path = File.expand_path('../input.txt', __FILE__)
machine = Machine.new(input_path)

p machine.run(9107763)
p machine.run(7877093)
