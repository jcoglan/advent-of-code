require_relative '../02/intcode'

class Robot
  def initialize(program, script)
    ascii = script.codepoints
    @machine = Intcode.new(program, inputs: ascii, outputs: self)
  end

  def run
    @machine.run
  end

  def push(value)
    if value < 0xff
      print value.chr
    else
      p [value]
    end
  end
end

input_path = File.expand_path('../input.txt', __FILE__)
program    = File.read(input_path)

# !(A & B & C) & D
Robot.new(program, <<~EOF).run
  AND A T
  OR A T
  AND B T
  AND C T
  NOT T J
  AND D J
  WALK
EOF

# !(A & B & C) & D & (E | H)
Robot.new(program, <<~EOF).run
  AND A T
  OR A T
  AND B T
  AND C T
  NOT T J
  AND D J
  AND E T
  OR E T
  OR H T
  AND T J
  RUN
EOF
