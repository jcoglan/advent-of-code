UP    = 0
RIGHT = 1
DOWN  = 2
LEFT  = 3
PATH  = 5

ROBOT = {
  UP    => [ 0, -1],
  RIGHT => [+1,  0],
  DOWN  => [ 0, +1],
  LEFT  => [-1,  0],
}

class Camera
  def initialize(program)
    @machine = Intcode.new(program, outputs: self)
  end

  def run(image)
    @image = image
    @x, @y = 0, 0
    @machine.run
  end

  def push(value)
    if value == 10
      @x, @y = 0, @y + 1
      return
    end

    case value.chr
    when '#' then @image[[@x, @y]] = PATH
    when '^' then @image[[@x, @y]] = UP
    when '>' then @image[[@x, @y]] = RIGHT
    when 'v' then @image[[@x, @y]] = DOWN
    when '<' then @image[[@x, @y]] = LEFT
    end

    @x += 1
  end
end
