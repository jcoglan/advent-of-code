class Intcode
  def initialize(memory)
    @memory = memory
    @ip = 0
  end

  def run
    loop do
      case @memory[@ip]
      when 1
        write(@ip + 3, read(@ip + 1) + read(@ip + 2))
        @ip += 4
      when 2
        write(@ip + 3, read(@ip + 1) * read(@ip + 2))
        @ip += 4
      when 99 then break
      end
    end
  end

  private

  def read(address)
    @memory[@memory[address]]
  end

  def write(address, value)
    @memory[@memory[address]] = value
  end
end
