class Map
  Cell = Struct.new(:x, :y, :state, :points) do
    def unit?
      state == 'E' or state == 'G'
    end

    def space?
      state == '.'
    end
  end

  def initialize(input)
    @cells = input.lines.map.with_index do |line, y|
      line.strip.chars.map.with_index { |char, x| Cell.new(x, y, char, 200) }
    end
  end

  def to_s
    @cells.map { |row| row.map(&:state).join('') }.join("\n")
  end

  def ended?
    all_units.map(&:state).uniq.size == 1
  end

  def round_units
    all_units.sort_by { |unit| [unit.y, unit.x] }
  end

  def move(unit)
    path = target_path(unit)
    return unit unless path

    target = path.first
    cell = @cells[target.y][target.x]

    cell.state  = unit.state
    cell.points = unit.points

    unit.state  = '.'
    unit.points = 0

    cell
  end

  def attack(unit, power)
    enemies = in_range(unit).select { |c| c.unit? and c.state != unit.state }
    picked  = enemies.min_by { |e| [e.points, e.y, e.x] }

    return unless picked

    picked.points -= power
    return if picked.points > 0

    state = picked.state
    picked.state = '.'
    state
  end

  def all_spaces
    @cells.flat_map { |row| row.select(&:space?) }
  end

  private

  def target_path(unit)
    return nil if in_range(unit).any? { |c| c.unit? and c.state != unit.state }

    targets = all_units.select { |t| t.state != unit.state }
    spaces  = spaces_in_range(targets)
    graph   = Dijkstra.new(self, unit)

    paths = spaces.map do |space|
      path = graph.shortest_path(space)
      [space, path]
    end
    paths.select!(&:last)

    paths.min_by { |s, p| [p.size, s.y, s.x] }&.last
  end

  def all_units
    @cells.flat_map { |row| row.select(&:unit?) }
  end

  def spaces_in_range(units)
    units.flat_map { |unit| in_range(unit) }.select(&:space?)
  end

  def in_range(unit)
    moves = [
      [unit.x, unit.y - 1], [unit.x + 1, unit.y],
      [unit.x, unit.y + 1], [unit.x - 1, unit.y]
    ]

    x_range = 0...@cells[0].size
    y_range = 0...@cells.size

    moves.select! { |x, y| x_range.include?(x) and y_range.include?(y) }
    moves.map { |x, y| @cells[y][x] }
  end
end
