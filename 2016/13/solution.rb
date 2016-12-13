require 'set'

Grid = Struct.new(:favourite_number) do
  OFFSETS = [-1, 0, 1]

  def space?((x, y))
    z = x*x + 3*x + 2*x*y + y + y*y
    z += favourite_number
    z.to_s(2).scan(/1/).size.even?
  end

  def start_at(x, y)
    @frontier = [[x, y]]
    @visited  = Set.new(@frontier)
  end

  def distance_to(a, b)
    steps = 0

    until @frontier.include?([a, b])
      expand_frontier
      steps += 1
    end

    steps
  end

  def locations_reachable_in(steps)
    steps.times { expand_frontier }
    @visited.size
  end

  def expand_frontier
    @frontier = @frontier.flat_map { |c| unvisited_neighbour_spaces c }
  end

  def unvisited_neighbour_spaces(location)
    neighbours(location).select { |c| space? c }
                        .select { |c| @visited.add? c }
  end

  def neighbours((x, y))
    offsets = [[1,0], [0,1], [-1,0], [0,-1]]

    offsets.map { |dx, dy| [x + dx, y + dy] }
           .select { |a, b| a >= 0 && b >= 0 }
  end

  def inspect
    max_x, max_y = [:first, :last].map { |x| @visited.map(&x).max }

    max_y.times.map { |y|
      max_x.times.map { |x|
        @visited.member?([x, y]) ? ' ' : '#'
      }.join('')
    }.join("\n")
  end
end


grid = Grid.new(1364)

grid.start_at(1, 1)
p [:in_50, grid.locations_reachable_in(50)]

grid.start_at(1, 1)
p [:distance, grid.distance_to(31, 39)]

p grid
