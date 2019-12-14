require_relative '../02/intcode'

class Painter
  BLACK = 0
  WHITE = 1

  UP    = 0
  RIGHT = 1
  DOWN  = 2
  LEFT  = 3

  def initialize(program, start)
    @machine = Intcode.new(program, inputs: self, outputs: self)
    @stack   = []
    @pos     = [0, 0]
    @dir     = UP

    @state = Hash.new { BLACK }
    @state[@pos] = start
  end

  def run
    @machine.run
  end

  def shift
    @state[@pos]
  end

  def push(value)
    @stack.push(value)
    return unless @stack.size == 2

    @state[@pos] = @stack.shift

    case @stack.shift
    when 0 then @dir -= 1
    when 1 then @dir += 1
    end

    @dir %= 4
    x, y = @pos

    case @dir
    when UP    then @pos = [x, y - 1]
    when DOWN  then @pos = [x, y + 1]
    when LEFT  then @pos = [x - 1, y]
    when RIGHT then @pos = [x + 1, y]
    end
  end

  def count_painted
    @state.size
  end

  def display
    xs, ys = @state.keys.map(&:first), @state.keys.map(&:last)

    (ys.min .. ys.max).each do |y|
      (xs.min .. xs.max).each do |x|
        case @state[[x, y]]
        when BLACK then print '.'
        when WHITE then print '#'
        end
      end
      puts
    end
  end
end

input_path = File.expand_path('../input.txt', __FILE__)
program    = File.read(input_path)

machine = Painter.new(program, Painter::BLACK)
machine.run
p machine.count_painted

machine = Painter.new(program, Painter::WHITE)
machine.run
machine.display
