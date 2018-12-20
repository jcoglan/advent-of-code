def bin_inst(op, type)
  -> ((_, a, b, c), reg) {
    value = (type == :r) ? reg[b] : b
    reg[c] = reg[a].__send__(op, value)
  }
end

def comp_inst(op, t, s)
  -> ((_, a, b, c), reg) {
    x = (t == :r) ? reg[a] : a
    y = (s == :r) ? reg[b] : b
    reg[c] = x.__send__(op, y) ? 1 : 0
  }
end

instructions = {
  addr: bin_inst(:+, :r),   addi: bin_inst(:+, :i),
  mulr: bin_inst(:*, :r),   muli: bin_inst(:*, :i),
  banr: bin_inst(:&, :r),   bani: bin_inst(:&, :i),
  borr: bin_inst(:|, :r),   bori: bin_inst(:|, :i),

  setr: -> ((_, a, _, c), reg) { reg[c] = reg[a] },
  seti: -> ((_, a, _, c), reg) { reg[c] = a },

  gtir: comp_inst(:>, :i, :r),
  gtri: comp_inst(:>, :r, :i),
  gtrr: comp_inst(:>, :r, :r),

  eqir: comp_inst(:==, :i, :r),
  eqri: comp_inst(:==, :r, :i),
  eqrr: comp_inst(:==, :r, :r),
}

ip = nil
program = []

input_path = File.expand_path('../input.txt', __FILE__)

File.read(input_path).each_line do |line|
  if line =~ /#ip (\d)/
    ip = $1.to_i
  else
    line = line.strip.split(/\s+/)
    line = line.take(1).map(&:to_sym) + line.drop(1).map(&:to_i)
    program << line
  end
end

reg = Array.new(6, 0)

while reg[ip] < program.size
  inst = program[reg[ip]]
  instructions[inst.first].call(inst, reg)
  reg[ip] += 1
end

p reg
