require_relative './machine'

input_path = File.expand_path('../input.txt', __FILE__)
machine = Machine.new(input_path)

p machine.run
