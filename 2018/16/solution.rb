require 'json'

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

samples = Hash.new { |h, k| h[k] = [] }
before  = inst = nil
program = []

input_path = File.expand_path('../input.txt', __FILE__)

File.read(input_path).each_line do |line|
  case line
  when /Before: (.*)/
    before = JSON.parse($1)
  when /(\d+) (\d+) (\d+) (\d+)/
    inst = [$1, $2, $3, $4].map(&:to_i)
    program << inst unless before
  when /After: (.*)/
    after = JSON.parse($1)
    sample = []
    instructions.each do |name, fn|
      reg = before.clone
      fn.call(inst, reg)
      sample << name if reg == after
    end
    samples[inst.first] << sample
    before = nil
  end
end

count = samples.reduce(0) do |sum, (_, names)|
  sum + names.count { |n| n.size >= 3 }
end

p count

samples.each { |code, names| samples[code] = names.reduce(:&) }
codes = {}

until samples.empty?
  code, names = samples.find { |_, names| names.size == 1 }

  codes[code] = names.first

  samples.delete(code)
  samples.each_value { |names| names.delete(codes[code]) }
end

reg = [0, 0, 0, 0]

program.each do |inst|
  instructions[codes[inst.first]].call(inst, reg)
end

p reg
