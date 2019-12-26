require_relative '../02/intcode'

class Scanner
  attr_reader :results

  def initialize(program)
    @machine = Intcode.new(program, inputs: self, outputs: self)
  end

  def in_beam?(pos)
    @pos = pos
    @machine.clone.run
    @result == 1
  end

  def shift
    @pos.shift
  end

  def push(result)
    @result = result
  end
end

input_path = File.expand_path('../input.txt', __FILE__)
program    = File.read(input_path)
scanner    = Scanner.new(program)

inputs = (0..49).map { |y| (0..49).map { |x| [x, y] } }

results = inputs.map do |row|
  row.map { |pos| scanner.in_beam?(pos) }
end

p results.flatten.count { |r| r == true }
