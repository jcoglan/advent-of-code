require_relative '../02/intcode'

input_path = File.expand_path('../input.txt', __FILE__)
program    = File.read(input_path).split(',').map(&:to_i)

settings = (0..4).to_a.permutation.map do |perm|
  perm.reduce(0) do |power, phase|
    machine = Intcode.new(program.clone)
    machine.inputs = [phase, power]
    machine.run
    machine.outputs.last
  end
end

p settings.max_by(&:last)

settings = (5..9).to_a.permutation.map do |perm|
  machines = perm.map do |phase|
    machine = Intcode.new(program.clone)
    machine.inputs = Queue.new
    machine.inputs << phase
    machine
  end

  machines.each_with_index do |machine, i|
    out = machines[i + 1] || machines.first
    machine.outputs = out.inputs
  end

  machines.first.inputs << 0

  threads = machines.map { |m| Thread.new { m.run } }
  threads.each(&:join)

  [perm, machines.last.outputs.shift]
end

p settings.max_by(&:last)
