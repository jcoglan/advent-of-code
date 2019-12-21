class Planner
  def initialize(image)
    @image = image
    @plan  = []
  end

  def run
    @pos, @dir = @image.find { |_, type| ROBOT.has_key? type }

    loop do
      break unless turn
      walk
    end

    @plan
  end

  private

  def turn
    x, y = @pos

    [1, 3].each do |n|
      dir = (@dir + n) % 4
      dx, dy = ROBOT[dir]

      if @image[[x + dx, y + dy]] == PATH
        @plan << (n == 1 ? 'R' : 'L')
        @dir = dir
        return true
      end
    end

    false
  end

  def walk
    x, y   = @pos
    dx, dy = ROBOT[@dir]
    length = 0

    while @image[[x + dx, y + dy]] == PATH
      x += dx
      y += dy
      length += 1
    end

    @plan << length
    @pos = [x, y]
  end
end
