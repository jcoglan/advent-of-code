class Water
  WALL = /#|~/

  def initialize(grid, sources)
    @grid    = grid
    @sources = sources
  end

  def run
    @filled = {}

    until @sources.empty?
      @sources = @sources.flat_map { |source| pour(source) }
    end
  end

  def count(type)
    @grid.reduce(0) { |s, row| s + row.count { |c| c == type } }
  end

  private

  def pour(source)
    return [] if @filled[source]

    x, y = source
    mark(x, y, '|')

    x, y = fall(x, y)

    loop do
      y -= 1
      open_l, l, open_r, r = fill(x, y)

      type = (open_l or open_r) ? '|' : '~'
      (l..r).each { |xx| mark(xx, y, type) }

      next unless open_l or open_r

      @filled[source] = true
      sources = []

      sources << [l, y] if open_l and l < x
      sources << [r, y] if open_r and r > x

      return sources
    end
  end

  def fall(x, y)
    until y == @grid.size or @grid[y][x] =~ WALL
      mark(x, y, '|')
      y += 1
    end
    [x, y]
  end

  def fill(x, y)
    l, open_l = spread(x, y, -1)
    r, open_r = spread(x, y,  1)

    [open_l, l, open_r, r]
  end

  def spread(x, y, d)
    p = x
    return [p, true] if y + 1 == @grid.size

    while @grid[y + 1][p] =~ WALL and @grid[y][p + d] !~ WALL
      p += d
    end
    [p, @grid[y + 1][p] !~ WALL]
  end

  def mark(x, y, type)
    @grid[y][x] = type
  end
end
