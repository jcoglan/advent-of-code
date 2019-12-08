class Intcode
  attr_accessor :inputs, :outputs

  def initialize(memory)
    @memory  = memory
    @inputs  = []
    @outputs = []
    @ip      = 0
  end

  def run
    loop do
      case opcode
      when 1
        write(3, read(1) + read(2))
        @ip += 4
      when 2
        write(3, read(1) * read(2))
        @ip += 4
      when 3
        write(1, @inputs.shift)
        @ip += 2
      when 4
        @outputs.push(read(1))
        @ip += 2
      when 5
        @ip = (read(1) == 0) ? @ip + 3 : read(2)
      when 6
        @ip = (read(1) == 0) ? read(2) : @ip + 3
      when 7
        write(3, read(1) < read(2) ? 1 : 0)
        @ip += 4
      when 8
        write(3, read(1) == read(2) ? 1 : 0)
        @ip += 4
      when 99 then break
      end
    end
  end

  private

  def opcode
    @memory[@ip] % 100
  end

  def mode(offset)
    f = 10 ** (offset + 1)
    (@memory[@ip] / f) % 10
  end

  def read(offset)
    case mode(offset)
    when 0 then @memory[@memory[@ip + offset]]
    when 1 then @memory[@ip + offset]
    end
  end

  def write(offset, value)
    @memory[@memory[@ip + offset]] = value
  end
end
