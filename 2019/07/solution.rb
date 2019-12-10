require_relative '../02/intcode'

input_path = File.expand_path('../input.txt', __FILE__)
program    = File.read(input_path)

powers = (0..4).to_a.permutation.map do |perm|
  perm.reduce(0) do |power, phase|
    machine = Intcode.new(program, inputs: [phase, power])
    machine.run
    machine.outputs.last
  end
end

p powers.max

powers = (5..9).to_a.permutation.map do |perm|
  output = Queue.new

  machines = perm.map do |phase|
    machine = Intcode.new(program, inputs: Queue.new, outputs: output)
    machine.inputs << phase
    output = machine.inputs
    machine
  end

  machines.first.outputs = machines.last.inputs
  machines.last.inputs << 0

  machines.map { |m| Thread.new { m.run } }.each(&:join)

  machines.first.outputs.shift
end

p powers.max
