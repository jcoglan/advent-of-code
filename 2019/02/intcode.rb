class Intcode
  attr_accessor :inputs, :outputs
  attr_reader :memory

  def initialize(program, inputs: [], outputs: [])
    @memory  = program.split(',').map(&:to_i)
    @inputs  = inputs
    @outputs = outputs
    @ip      = 0
    @base    = 0
  end

  def clone
    super.tap do |copy|
      copy.instance_variable_set(:@memory, @memory.clone)
    end
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
        value = read(1)
        @ip += 2
        @outputs.push(value)
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
      when 9
        @base += read(1)
        @ip += 2
      when 99 then break
      end
    end
  end

  private

  def mem(address)
    @memory[address] || 0
  end

  def opcode
    mem(@ip) % 100
  end

  def mode(offset)
    f = 10 ** (offset + 1)
    (mem(@ip) / f) % 10
  end

  def read(offset)
    case mode(offset)
    when 0 then mem(mem(@ip + offset))
    when 1 then mem(@ip + offset)
    when 2 then mem(mem(@ip + offset) + @base)
    end
  end

  def write(offset, value)
    case mode(offset)
    when 0 then @memory[mem(@ip + offset)] = value
    when 1 then @memory[@ip + offset] = value
    when 2 then @memory[mem(@ip + offset) + @base] = value
    end
  end
end
