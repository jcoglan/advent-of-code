class Machine
  def self.bin_inst(op, type)
    -> ((_, a, b, c), reg) {
      value = (type == :r) ? reg[b] : b
      reg[c] = reg[a].__send__(op, value)
    }
  end

  def self.comp_inst(op, t, s)
    -> ((_, a, b, c), reg) {
      x = (t == :r) ? reg[a] : a
      y = (s == :r) ? reg[b] : b
      reg[c] = x.__send__(op, y) ? 1 : 0
    }
  end

  INSTRUCTIONS = {
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

  def initialize(input_path)
    @ip = nil
    @program = []

    File.read(input_path).each_line do |line|
      if line =~ /#ip (\d)/
        @ip = $1.to_i
      else
        line = line.strip.split(/\s+/)
        line = line.take(1).map(&:to_sym) + line.drop(1).map(&:to_i)
        @program << line
      end
    end
  end

  def run(value = 0)
    reg = Array.new(6, 0)
    reg[0] = value

    while reg[@ip] < @program.size
      execute(reg[@ip], reg)
      reg[@ip] += 1
    end

    reg
  end

  def execute(line, reg)
    inst = @program[line]
    INSTRUCTIONS[inst.first].call(inst, reg)
  end
end
