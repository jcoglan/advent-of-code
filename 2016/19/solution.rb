class Game
  attr_reader :elves

  def initialize(count)
    @elves = count.times.map(&:succ)
    @index = 0
  end

  def play!
    turn until @elves.size == 1
  end

  def turn
    @index = 0 if @index >= @elves.size

    elf     = @elves[@index]
    size    = @elves.size
    steal_n = (@index + size/2) % size
    steal   = @elves[steal_n]

    # p [@index, elf, steal]

    @elves.delete_at(steal_n)
    @index += 1 if steal_n > @index
  end
end

def calculate_left(n)
  2 * (n - 2 ** Math.log(n, 2).floor) + 1
end

def calculate_cross(n)
  k = (n == 1) ?  0 : 3 ** Math.log(n - 1, 3).floor
  (n > 2 * k) ? (2 * n - 3 * k) : (n - k)
end

p calculate_left(3005290)
p calculate_cross(3005290)

__END__

(1..60).each do |n|
  game = Game.new(n)
  game.play!
  p [n, game.elves, calculate_cross(n)]
end

__END__

      1           1           1         1
    4   2
      3         4   2         2



      1   2           1   2
                                      1   2           2
    6       3       6       3
                                      6   3         6   3
      5   4             5
